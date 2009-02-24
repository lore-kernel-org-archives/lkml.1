Return-Path: <linux-kernel-owner+w=401wt.eu-S1759147AbZBXR2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbZBXR2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbZBXR1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:27:22 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:2194 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759006AbZBXR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:27:21 -0500
Message-ID: <49A42DF7.8080309@cybernetics.com>
Date: Tue, 24 Feb 2009 12:27:19 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] [2.6.29] epoll: remember the event if epoll_wait returns
 -EFAULT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If epoll_wait returns -EFAULT, the event that was being returned when
the fault was encountered will be forgotten.  This is not a big deal
since EFAULT will happen only if a buggy userspace program passes in a
bad address, in which case what happens later usually doesn't matter.
However, it is easy to remember the event for later, and this patch
makes a simple change to do that.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---

This patch is against 2.6.29-rc6; however, it doesn't need to go
into 2.6.29.  Use the -mm version instead if applying after the other
patches in -mm.

--- a/fs/eventpoll.c	2009-02-20 16:34:02.000000000 -0500
+++ b/fs/eventpoll.c	2009-02-20 16:36:25.000000000 -0500
@@ -974,8 +974,6 @@ static int ep_send_events(struct eventpo
 	for (eventcnt = 0; !list_empty(&txlist) && eventcnt < maxevents;) {
 		epi = list_first_entry(&txlist, struct epitem, rdllink);
 
-		list_del_init(&epi->rdllink);
-
 		/*
 		 * Get the ready file event set. We can safely use the file
 		 * because we are holding the "mtx" and this will guarantee
@@ -1000,6 +998,9 @@ static int ep_send_events(struct eventpo
 				epi->event.events &= EP_PRIVATE_BITS;
 			eventcnt++;
 		}
+
+		list_del_init(&epi->rdllink); /* remove from txlist */
+
 		/*
 		 * At this point, noone can insert into ep->rdllist besides
 		 * us. The epoll_ctl() callers are locked out by us holding

