Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZA1G5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZA1G5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZA1G5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:57:44 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34168 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZA1G5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:57:44 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 22:57:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Greg KH <gregkh@suse.de>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
In-Reply-To: <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
Message-ID: <alpine.DEB.1.10.0901272243130.20262@alien.or.mcafeemobile.com>
References: <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de>
 <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com> <20090128052630.GA9512@suse.de>
 <alpine.DEB.1.10.0901272135400.20262@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Davide Libenzi wrote:

> Or, like Willy said, make (for -stable) the default unlimited, and 
> let sysadmins to put the bounds if they feel the DoS can apply to them.

Whose patch follows ...


- Davide


---
 fs/eventpoll.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-27 22:40:23.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-27 22:52:41.000000000 -0800
@@ -220,9 +220,9 @@
  * Configuration options available inside /proc/sys/fs/epoll/
  */
 /* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
+static int max_user_instances __read_mostly = INT_MAX;
 /* Maximum number of epoll watched descriptors, per user */
-static int max_user_watches __read_mostly;
+static int max_user_watches __read_mostly = INT_MAX;
 
 /*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
@@ -721,8 +721,7 @@
 
 	user = get_current_user();
 	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
+	if (atomic_read(&user->epoll_devs) >= max_user_instances)
 		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
@@ -897,8 +896,7 @@
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
-		     max_user_watches))
+	if (atomic_read(&ep->user->epoll_watches) >= max_user_watches)
 		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
 		return -ENOMEM;
@@ -1416,13 +1414,6 @@
 
 static int __init eventpoll_init(void)
 {
-	struct sysinfo si;
-
-	si_meminfo(&si);
-	max_user_instances = 128;
-	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
-		EP_ITEM_COST;
-
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
 
