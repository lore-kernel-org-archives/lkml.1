Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZA2E4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZA2E4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZA2E4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:56:11 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:35210 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZA2E4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:56:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 20:56:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>
Subject: [patch] drop epoll max_user_instances and rely only on
 max_user_watches
Message-ID: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus suggested to put limits where the money is, and max_user_watches 
already does that w/out the need of max_user_instances. That has the 
advantage to mitigate the potential DoS while allowing pretty generous 
default behavior.
Allowing top 4% of low memory (per user) to be allocated in epoll 
watches, we have:

LOMEM    MAX_WATCHES (per user)
512MB    ~178000
1GB      ~356000
2GB      ~712000

A box with 512MB of lomem, will meet some challenge in hitting 180K 
watches, socket buffers math teaches us.
No more max_user_instances limits then.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c        |   22 ++++------------------
 include/linux/sched.h |    1 -
 2 files changed, 4 insertions(+), 19 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-28 20:06:55.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-28 20:08:16.000000000 -0800
@@ -234,8 +234,6 @@
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
-/* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
 /* Maximum number of epoll watched descriptors, per user */
 static int max_user_watches __read_mostly;
 
@@ -261,14 +259,6 @@
 
 ctl_table epoll_table[] = {
 	{
-		.procname	= "max_user_instances",
-		.data		= &max_user_instances,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.extra1		= &zero,
-	},
-	{
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
 		.maxlen		= sizeof(int),
@@ -491,7 +481,6 @@
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
-	atomic_dec(&ep->user->epoll_devs);
 	free_uid(ep->user);
 	kfree(ep);
 }
@@ -581,10 +570,6 @@
 	struct eventpoll *ep;
 
 	user = get_current_user();
-	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
-		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (unlikely(!ep))
@@ -1141,7 +1126,6 @@
 			      flags & O_CLOEXEC);
 	if (fd < 0)
 		ep_free(ep);
-	atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
@@ -1366,8 +1350,10 @@
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 128;
-	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
+	/*
+	 * Allows top 4% of lomem to be allocated for epoll watches (per user).
+	 */
+	max_user_watches = (((si.totalram - si.totalhigh) / 25) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
Index: linux-2.6.mod/include/linux/sched.h
===================================================================
--- linux-2.6.mod.orig/include/linux/sched.h	2009-01-28 20:07:41.000000000 -0800
+++ linux-2.6.mod/include/linux/sched.h	2009-01-28 20:08:16.000000000 -0800
@@ -630,7 +630,6 @@
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_devs;	/* The number of epoll descriptors currently open */
 	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE
