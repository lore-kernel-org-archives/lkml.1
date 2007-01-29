Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbXA2Kbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbXA2Kbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXA2Kbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:31:34 -0500
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:61696 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbXA2Kbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:31:32 -0500
X-Greylist: delayed 8650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 05:31:32 EST
To: bastian@waldi.eu.org
Cc: stgt-devel@lists.berlios.de, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       davem@davemloft.net
Subject: Re: ibmvstgt/aio broken with 2.6.20-rc6 powerpc
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20070128185258.GA18860@wavehammer.waldi.eu.org>
References: <20070128185258.GA18860@wavehammer.waldi.eu.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070129170740O.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 29 Jan 2007 17:07:40 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bastian Blank <bastian@waldi.eu.org>
Subject: ibmvstgt/aio broken with 2.6.20-rc6 powerpc
Date: Sun, 28 Jan 2007 19:52:58 +0100

> I'm not really sure if this is a ibmvstgt or a generic aio problem.

You use 2.6.20-rc6 with the aio-epoll-wait patch, right?

I think that this is due to the aio-epoll-wait patch because without
using ibmvstgt target driver, simple aio workload crashes 2.6.20-rc6
with the aio-epoll-wait patch on my POWER box. I cannot recall since
when the patch doesn't work on POWER.

If you are interested in only ibmvstgt target driver, use the
following patch. It uses epoll instead of AIO for event
notification. ibmvstgt target driver (and most of the kernel-space
target drivers) uses mmapped I/O and does not need AIO. The user-space
target drivers (like iSCSI) need the aio-epoll-wait patch though.


Index: usr/tgtd.c
===================================================================
--- usr/tgtd.c	(revision 771)
+++ usr/tgtd.c	(working copy)
@@ -202,9 +202,6 @@
 	int nevent, i, err;
 	struct epoll_event events[1024];
 	struct tgt_event *tev;
-	struct iocb iocbs[1], *iocb;
-	struct io_event aioevents[2048];
-	struct timespec timeout = {1, 0};
 
 	err = io_queue_init(2048, &ctx);
 	if (err) {
@@ -212,13 +209,8 @@
 		return;
 	}
 
-	iocb = iocbs;
-	io_prep_epoll_wait(iocb, ep_fd, events, ARRAY_SIZE(events), -1);
-	err = io_submit(ctx, 1, &iocb);
-
 retry:
-	nevent = io_getevents(ctx, 1, ARRAY_SIZE(aioevents), aioevents, &timeout);
-
+	nevent = epoll_wait(ep_fd, events, ARRAY_SIZE(events), -1);
 	if (nevent < 0) {
 		if (errno != EINTR) {
 			eprintf("%m\n");
@@ -226,18 +218,8 @@
 		}
 	} else if (nevent) {
 		for (i = 0; i < nevent; i++) {
-			if (iocb == aioevents[i].obj) {
-				int j;
-				for (j = 0; j < aioevents[i].res; j++) {
-					tev = (struct tgt_event *) events[j].data.ptr;
-					tev->handler(tev->fd, events[j].events, tev->data);
-				}
-
-				err = io_submit(ctx, 1, &iocb);
-			} else {
-				/* FIXME */
-				target_cmd_io_done(aioevents[i].data, 0);
-			}
+			tev = (struct tgt_event *) events[i].data.ptr;
+			tev->handler(tev->fd, events[i].events, tev->data);
 		}
 	} else
 		schedule();
