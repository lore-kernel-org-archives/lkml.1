Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZAaCzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZAaCzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZAaCrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:01 -0500
Received: from kroah.org ([198.145.64.141]:54969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755506AbZAaCq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:57 -0500
Date: Fri, 30 Jan 2009 18:40:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Davide Libenzi <davidel@xmailserver.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>
Subject: [patch 24/32] epoll: drop max_user_instances and rely only on
	max_user_watches
Message-ID: <20090131024039.GY12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="epoll-drop-max_user_instances-and-rely-only-on-max_user_watches.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Davide Libenzi <davidel@xmailserver.org>

commit 9df04e1f25effde823a600e755b51475d438f56b upstream.

Linus suggested to put limits where the money is, and max_user_watches
already does that w/out the need of max_user_instances.  That has the
advantage to mitigate the potential DoS while allowing pretty generous
default behavior.

Allowing top 4% of low memory (per user) to be allocated in epoll watches,
we have:

LOMEM    MAX_WATCHES (per user)
512MB    ~178000
1GB      ~356000
2GB      ~712000

A box with 512MB of lomem, will meet some challenge in hitting 180K
watches, socket buffers math teaches us.  No more max_user_instances
limits then.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Bron Gondwana <brong@fastmail.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/eventpoll.c        |   22 ++++------------------
 include/linux/sched.h |    1 -
 2 files changed, 4 insertions(+), 19 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -234,8 +234,6 @@ struct ep_pqueue {
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
-/* Maximum number of epoll devices, per user */
-static int max_user_instances __read_mostly;
 /* Maximum number of epoll watched descriptors, per user */
 static int max_user_watches __read_mostly;
 
@@ -261,14 +259,6 @@ static int zero;
 
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
@@ -491,7 +481,6 @@ static void ep_free(struct eventpoll *ep
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
-	atomic_dec(&ep->user->epoll_devs);
 	free_uid(ep->user);
 	kfree(ep);
 }
@@ -581,10 +570,6 @@ static int ep_alloc(struct eventpoll **p
 	struct eventpoll *ep;
 
 	user = get_current_user();
-	error = -EMFILE;
-	if (unlikely(atomic_read(&user->epoll_devs) >=
-			max_user_instances))
-		goto free_uid;
 	error = -ENOMEM;
 	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
 	if (unlikely(!ep))
@@ -1137,7 +1122,6 @@ SYSCALL_DEFINE1(epoll_create1, int, flag
 			      flags & O_CLOEXEC);
 	if (fd < 0)
 		ep_free(ep);
-	atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
@@ -1362,8 +1346,10 @@ static int __init eventpoll_init(void)
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
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -588,7 +588,6 @@ struct user_struct {
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
 #ifdef CONFIG_EPOLL
-	atomic_t epoll_devs;	/* The number of epoll descriptors currently open */
 	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
 #endif
 #ifdef CONFIG_POSIX_MQUEUE

