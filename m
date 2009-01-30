Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbZA3Avo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbZA3Avo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZA3Av1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:51:27 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47454 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbZA3Av0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:51:26 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 16:51:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] epoll: remove debugging code
Message-ID: <alpine.DEB.1.10.0901291619120.16141@alien.or.mcafeemobile.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch remove debugging code from epoll. There's no need for it to be
included into mainline code.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   78 ++++++++-------------------------------------------------
 1 file changed, 11 insertions(+), 67 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-29 15:59:38.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-29 15:59:44.000000000 -0800
@@ -71,24 +71,6 @@
  * a better scalability.
  */
 
-#define DEBUG_EPOLL 0
-
-#if DEBUG_EPOLL > 0
-#define DPRINTK(x) printk x
-#define DNPRINTK(n, x) do { if ((n) <= DEBUG_EPOLL) printk x; } while (0)
-#else /* #if DEBUG_EPOLL > 0 */
-#define DPRINTK(x) (void) 0
-#define DNPRINTK(n, x) (void) 0
-#endif /* #if DEBUG_EPOLL > 0 */
-
-#define DEBUG_EPI 0
-
-#if DEBUG_EPI != 0
-#define EPI_SLAB_DEBUG (SLAB_DEBUG_FREE | SLAB_RED_ZONE /* | SLAB_POISON */)
-#else /* #if DEBUG_EPI != 0 */
-#define EPI_SLAB_DEBUG 0
-#endif /* #if DEBUG_EPI != 0 */
-
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLONESHOT | EPOLLET)
 
@@ -567,9 +549,6 @@ static int ep_remove(struct eventpoll *e
 
 	atomic_dec(&ep->user->epoll_watches);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
-		     current, ep, file));
-
 	return 0;
 }
 
@@ -625,7 +604,6 @@ static int ep_eventpoll_release(struct i
 	if (ep)
 		ep_free(ep);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
 }
 
@@ -748,8 +726,6 @@ static int ep_alloc(struct eventpoll **p
 
 	*pep = ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
-		     current, ep));
 	return 0;
 
 free_uid:
@@ -783,9 +759,6 @@ static struct epitem *ep_find(struct eve
 		}
 	}
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
-		     current, file, epir));
-
 	return epir;
 }
 
@@ -801,9 +774,6 @@ static int ep_poll_callback(wait_queue_t
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
-
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
@@ -976,9 +946,6 @@ static int ep_insert(struct eventpoll *e
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
-		     current, ep, tfile, fd));
-
 	return 0;
 
 error_unregister:
@@ -1195,41 +1162,30 @@ retry:
  */
 SYSCALL_DEFINE1(epoll_create1, int, flags)
 {
-	int error, fd = -1;
-	struct eventpoll *ep;
+	int error;
+	struct eventpoll *ep = NULL;
 
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
 	if (flags & ~EPOLL_CLOEXEC)
 		return -EINVAL;
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, flags));
-
 	/*
-	 * Create the internal data structure ( "struct eventpoll" ).
+	 * Create the internal data structure ("struct eventpoll").
 	 */
 	error = ep_alloc(&ep);
-	if (error < 0) {
-		fd = error;
-		goto error_return;
-	}
-
+	if (error < 0)
+		return error;
 	/*
 	 * Creates all the items needed to setup an eventpoll file. That is,
 	 * a file structure and a free file descriptor.
 	 */
-	fd = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
-			      flags & O_CLOEXEC);
-	if (fd < 0)
+	error = anon_inode_getfd("[eventpoll]", &eventpoll_fops, ep,
+				 flags & O_CLOEXEC);
+	if (error < 0)
 		ep_free(ep);
 
-error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, fd));
-
-	return fd;
+	return error;
 }
 
 SYSCALL_DEFINE1(epoll_create, int, size)
@@ -1254,9 +1210,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	struct epitem *epi;
 	struct epoll_event epds;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
-		     current, epfd, op, fd, event));
-
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
@@ -1333,8 +1286,6 @@ error_tgt_fput:
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
-		     current, epfd, op, fd, event, error));
 
 	return error;
 }
@@ -1350,9 +1301,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 	struct file *file;
 	struct eventpoll *ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
-		     current, epfd, events, maxevents, timeout));
-
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
 		return -EINVAL;
@@ -1389,8 +1337,6 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, s
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
-		     current, epfd, events, maxevents, timeout, error));
 
 	return error;
 }
@@ -1462,13 +1408,11 @@ static int __init eventpoll_init(void)
 
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
-			0, SLAB_HWCACHE_ALIGN|EPI_SLAB_DEBUG|SLAB_PANIC,
-			NULL);
+			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
 	/* Allocates slab cache used to allocate "struct eppoll_entry" */
 	pwq_cache = kmem_cache_create("eventpoll_pwq",
-			sizeof(struct eppoll_entry), 0,
-			EPI_SLAB_DEBUG|SLAB_PANIC, NULL);
+			sizeof(struct eppoll_entry), 0, SLAB_PANIC, NULL);
 
 	return 0;
 }
