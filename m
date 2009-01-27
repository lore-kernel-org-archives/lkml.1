Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZA0Uzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZA0Uzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZA0UzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:55:03 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:44229 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZA0UzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:55:00 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 12:54:58 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] epoll remove debugging code
Message-ID: <alpine.DEB.1.10.0901271253010.20262@alien.or.mcafeemobile.com>
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
 fs/eventpoll.c |   60 +++------------------------------------------------------
 1 file changed, 4 insertions(+), 56 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-26 23:13:28.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-26 23:13:31.000000000 -0800
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
 
@@ -580,9 +562,6 @@
 
 	atomic_dec(&ep->user->epoll_watches);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
-		     current, ep, file));
-
 	return 0;
 }
 
@@ -634,12 +613,9 @@
 
 static int ep_eventpoll_release(struct inode *inode, struct file *file)
 {
-	struct eventpoll *ep = file->private_data;
-
-	if (ep)
-		ep_free(ep);
+	if (file->private_data)
+		ep_free((struct eventpoll *) file->private_data);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: close() ep=%p\n", current, ep));
 	return 0;
 }
 
@@ -764,8 +740,6 @@
 
 	*pep = ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
-		     current, ep));
 	return 0;
 
 free_uid:
@@ -799,9 +773,6 @@
 		}
 	}
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
-		     current, file, epir));
-
 	return epir;
 }
 
@@ -817,9 +788,6 @@
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: poll_callback(%p) epi=%p ep=%p\n",
-		     current, epi->ffd.file, epi, ep));
-
 	spin_lock_irqsave(&ep->lock, flags);
 
 	/*
@@ -991,9 +959,6 @@
 	if (pwake)
 		ep_poll_safewake(&ep->poll_wait);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_insert(%p, %p, %d)\n",
-		     current, ep, tfile, fd));
-
 	return 0;
 
 error_unregister:
@@ -1213,9 +1178,6 @@
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d)\n",
-		     current, flags));
-
 	error = -EINVAL;
 	if (flags & ~EPOLL_CLOEXEC)
 		goto error_return;
@@ -1239,8 +1201,6 @@
 		atomic_inc(&ep->user->epoll_devs);
 
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
-		     current, flags, error));
 
 	return error;
 }
@@ -1267,9 +1227,6 @@
 	struct epitem *epi;
 	struct epoll_event epds;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p)\n",
-		     current, epfd, op, fd, event));
-
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
 	    copy_from_user(&epds, event, sizeof(struct epoll_event)))
@@ -1346,8 +1303,6 @@
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_ctl(%d, %d, %d, %p) = %d\n",
-		     current, epfd, op, fd, event, error));
 
 	return error;
 }
@@ -1363,9 +1318,6 @@
 	struct file *file;
 	struct eventpoll *ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d)\n",
-		     current, epfd, events, maxevents, timeout));
-
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
 		return -EINVAL;
@@ -1402,8 +1354,6 @@
 error_fput:
 	fput(file);
 error_return:
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_wait(%d, %p, %d, %d) = %d\n",
-		     current, epfd, events, maxevents, timeout, error));
 
 	return error;
 }
@@ -1473,13 +1423,11 @@
 
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

