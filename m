Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYAHPeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYAHPeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYAHPe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:34:29 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:26707 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbYAHPe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:34:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=R/rqngfI3vtv48ZxKna9QxZOth3FsbbZ3+2HE5AzA6GI9waIaaFooL4Zc78GBZrGXzfHcRUpJv0VIHndC2H70Occ1rnvbosp1JjhzgbNAS0BHNGvn7+aKJc67phL5af+TppHdexoU0sEY23yBLXttQJzjcOm1zaeWqw5qHSRz1k=
Message-ID: <478397F7.1030005@gmail.com>
Date: Tue, 08 Jan 2008 23:34:15 +0800
From: Changli Gao <xiaosuo@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: xiaosuo@gmail.com
Subject: [PATCH] Improve scalability of epoll_ctl
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the epitem rbtree with a dynamic array to get the constant insertion/deletion/modification time of the file descriptors. Reuse the size argument of epoll_create, however the size must be smaller than the max file descriptor number: ether the resource limitation or the compiling time limitation.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 eventpoll.c |  205 ++++++++++++++++++++++++++++--------------------------------
 1 file changed, 99 insertions(+), 106 deletions(-)
--- linux-2.6.23-gentoo-r5/fs/eventpoll.c.orig	2007-12-31 22:07:22.000000000 +0800
+++ linux-2.6.23-gentoo-r5/fs/eventpoll.c	2008-01-06 02:06:35.000000000 +0800
@@ -26,7 +26,6 @@
 #include <linux/hash.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/rbtree.h>
 #include <linux/wait.h>
 #include <linux/eventpoll.h>
 #include <linux/mount.h>
@@ -129,14 +128,7 @@ struct poll_safewake {
 	spinlock_t lock;
 };
 
-/*
- * Each file descriptor added to the eventpoll interface will
- * have an entry of this type linked to the "rbr" RB tree.
- */
 struct epitem {
-	/* RB tree node used to link this structure to the eventpoll RB tree */
-	struct rb_node rbn;
-
 	/* List header used to link this structure to the eventpoll ready list */
 	struct list_head rdllink;
 
@@ -191,8 +183,9 @@ struct eventpoll {
 	/* List of ready file descriptors */
 	struct list_head rdllist;
 
-	/* RB tree root used to store monitored fd structs */
-	struct rb_root rbr;
+	/* Array used to store monitored fd structs */
+	struct epitem **epi_array;
+	int epi_array_size;
 
 	/*
 	 * This is a single linked list that chains all the "struct epitem" that
@@ -240,7 +233,6 @@ static struct kmem_cache *epi_cache __re
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
-
 /* Setup the structure that is used as key for the RB tree */
 static inline void ep_set_ffd(struct epoll_filefd *ffd,
 			      struct file *file, int fd)
@@ -249,33 +241,6 @@ static inline void ep_set_ffd(struct epo
 	ffd->fd = fd;
 }
 
-/* Compare RB tree keys */
-static inline int ep_cmp_ffd(struct epoll_filefd *p1,
-			     struct epoll_filefd *p2)
-{
-	return (p1->file > p2->file ? +1:
-	        (p1->file < p2->file ? -1 : p1->fd - p2->fd));
-}
-
-/* Special initialization for the RB tree node to detect linkage */
-static inline void ep_rb_initnode(struct rb_node *n)
-{
-	rb_set_parent(n, n);
-}
-
-/* Removes a node from the RB tree and marks it for a fast is-linked check */
-static inline void ep_rb_erase(struct rb_node *n, struct rb_root *r)
-{
-	rb_erase(n, r);
-	rb_set_parent(n, n);
-}
-
-/* Fast check to verify that the item is linked to the main RB tree */
-static inline int ep_rb_linked(struct rb_node *n)
-{
-	return rb_parent(n) != n;
-}
-
 /* Tells us if the item is currently linked */
 static inline int ep_is_linked(struct list_head *p)
 {
@@ -388,7 +353,7 @@ static void ep_unregister_pollwait(struc
 }
 
 /*
- * Removes a "struct epitem" from the eventpoll RB tree and deallocates
+ * Removes a "struct epitem" from the eventpoll epi_array and deallocates
  * all the associated resources. Must be called with "mtx" held.
  */
 static int ep_remove(struct eventpoll *ep, struct epitem *epi)
@@ -412,8 +377,9 @@ static int ep_remove(struct eventpoll *e
 		list_del_init(&epi->fllink);
 	spin_unlock(&file->f_ep_lock);
 
-	if (ep_rb_linked(&epi->rbn))
-		ep_rb_erase(&epi->rbn, &ep->rbr);
+	if (epi->ffd.fd < ep->epi_array_size
+			&& ep->epi_array[epi->ffd.fd] == epi)
+		ep->epi_array[epi->ffd.fd] = NULL;
 
 	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
@@ -429,10 +395,18 @@ static int ep_remove(struct eventpoll *e
 	return 0;
 }
 
+static inline void epi_array_free(struct eventpoll *ep)
+{
+	if (ep->epi_array_size < PAGE_SIZE / sizeof(struct epitem*))
+		kfree(ep->epi_array);
+	else
+		vfree(ep->epi_array);
+}
+
 static void ep_free(struct eventpoll *ep)
 {
-	struct rb_node *rbp;
 	struct epitem *epi;
+	int i;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
@@ -451,10 +425,10 @@ static void ep_free(struct eventpoll *ep
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
 	 */
-	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
-		epi = rb_entry(rbp, struct epitem, rbn);
-
-		ep_unregister_pollwait(ep, epi);
+	for (i = 0; i < ep->epi_array_size; i ++) {
+		epi = ep->epi_array[i];
+		if (epi != NULL)
+			ep_unregister_pollwait(ep, epi);
 	}
 
 	/*
@@ -463,13 +437,15 @@ static void ep_free(struct eventpoll *ep
 	 * holding "epmutex" we can be sure that no file cleanup code will hit
 	 * us during this operation. So we can avoid the lock on "ep->lock".
 	 */
-	while ((rbp = rb_first(&ep->rbr)) != 0) {
-		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove(ep, epi);
+	for (i = 0; i < ep->epi_array_size; i ++) {
+		epi = ep->epi_array[i];
+		if (epi != NULL)
+			ep_remove(ep, epi);
 	}
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
+	epi_array_free(ep);
 	kfree(ep);
 }
 
@@ -551,58 +527,53 @@ void eventpoll_release_file(struct file 
 	mutex_unlock(&epmutex);
 }
 
-static int ep_alloc(struct eventpoll **pep)
+static int ep_alloc(struct eventpoll **pep, int size)
 {
 	struct eventpoll *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	int msize = sizeof(struct epitem*) * size;
 
 	if (!ep)
 		return -ENOMEM;
 
+	if (size < PAGE_SIZE / sizeof(struct epitem*)) {
+		ep->epi_array = kmalloc(msize, GFP_KERNEL);
+		ep->epi_array_size = size;
+	} else {
+		msize = PAGE_ALIGN(msize);
+		ep->epi_array = vmalloc(msize);
+		ep->epi_array_size = msize / sizeof(struct epitem*);
+	}
+	if (ep->epi_array == NULL) {
+		kfree(ep);
+		return -ENOMEM;
+	}
+	memset(ep->epi_array, 0, msize);
+
 	spin_lock_init(&ep->lock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	INIT_LIST_HEAD(&ep->rdllist);
-	ep->rbr = RB_ROOT;
 	ep->ovflist = EP_UNACTIVE_PTR;
 
 	*pep = ep;
 
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
-		     current, ep));
+	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc(%d) ep=%p\n",
+		     current, size, ep));
 	return 0;
 }
 
 /*
- * Search the file inside the eventpoll tree. The RB tree operations
+ * Search the file inside the eventpoll tree. The epi_array operations
  * are protected by the "mtx" mutex, and ep_find() must be called with
  * "mtx" held.
  */
 static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 {
-	int kcmp;
-	struct rb_node *rbp;
-	struct epitem *epi, *epir = NULL;
-	struct epoll_filefd ffd;
-
-	ep_set_ffd(&ffd, file, fd);
-	for (rbp = ep->rbr.rb_node; rbp; ) {
-		epi = rb_entry(rbp, struct epitem, rbn);
-		kcmp = ep_cmp_ffd(&ffd, &epi->ffd);
-		if (kcmp > 0)
-			rbp = rbp->rb_right;
-		else if (kcmp < 0)
-			rbp = rbp->rb_left;
-		else {
-			epir = epi;
-			break;
-		}
-	}
-
-	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_find(%p) -> %p\n",
-		     current, file, epir));
-
-	return epir;
+	if (fd < ep->epi_array_size && ep->epi_array[fd] != NULL
+			&& ep->epi_array[fd]->ffd.file == file)
+		return ep->epi_array[fd];
+	return  NULL;
 }
 
 /*
@@ -695,23 +666,45 @@ static void ep_ptable_queue_proc(struct 
 	}
 }
 
-static void ep_rbtree_insert(struct eventpoll *ep, struct epitem *epi)
+static int ep_array_expand(struct eventpoll *ep, int size)
 {
-	int kcmp;
-	struct rb_node **p = &ep->rbr.rb_node, *parent = NULL;
-	struct epitem *epic;
-
-	while (*p) {
-		parent = *p;
-		epic = rb_entry(parent, struct epitem, rbn);
-		kcmp = ep_cmp_ffd(&epi->ffd, &epic->ffd);
-		if (kcmp > 0)
-			p = &parent->rb_right;
-		else
-			p = &parent->rb_left;
+	struct epitem **epi_array_new;
+	int size_old = ep->epi_array_size;
+	int msize = size * sizeof(struct epitem*);
+	int msize_old = (ep->epi_array_size) * sizeof(struct epitem*);
+
+	if (size < PAGE_SIZE / sizeof(struct epitem*)) {
+		epi_array_new = krealloc(ep->epi_array, msize, GFP_KERNEL);
+		if (epi_array_new == NULL)
+			return -ENOMEM;
+		ep->epi_array = epi_array_new;
+		ep->epi_array_size = size;
+	} else {
+		msize = PAGE_ALIGN(msize);
+		epi_array_new = vmalloc(msize);
+		if (epi_array_new == NULL)
+			return -ENOMEM;
+		memcpy(epi_array_new, ep->epi_array, msize_old);
+		epi_array_free(ep);
+		ep->epi_array = epi_array_new;
+		ep->epi_array_size = msize / sizeof(struct epitem*);
 	}
-	rb_link_node(&epi->rbn, parent, p);
-	rb_insert_color(&epi->rbn, &ep->rbr);
+	memset(epi_array_new + size_old, 0, msize - msize_old);
+
+	return 0;
+}
+
+static int ep_array_insert(struct eventpoll *ep, struct epitem *epi)
+{
+	if (unlikely(epi->ffd.fd >= ep->epi_array_size)) {
+		int retval;
+
+		if ((retval = ep_array_expand(ep, epi->ffd.fd + 1)) != 0)
+			return retval;
+	}
+	ep->epi_array[epi->ffd.fd] = epi;
+
+	return 0;
 }
 
 /*
@@ -730,7 +723,6 @@ static int ep_insert(struct eventpoll *e
 		goto error_return;
 
 	/* Item initialization follow here ... */
-	ep_rb_initnode(&epi->rbn);
 	INIT_LIST_HEAD(&epi->rdllink);
 	INIT_LIST_HEAD(&epi->fllink);
 	INIT_LIST_HEAD(&epi->pwqlist);
@@ -758,7 +750,7 @@ static int ep_insert(struct eventpoll *e
 	 * install process. Namely an allocation for a wait queue failed due
 	 * high memory pressure.
 	 */
-	if (epi->nwait < 0)
+	if (epi->nwait < 0 || ((error = ep_array_insert(ep, epi)) != 0))
 		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
@@ -766,12 +758,6 @@ static int ep_insert(struct eventpoll *e
 	list_add_tail(&epi->fllink, &tfile->f_ep_links);
 	spin_unlock(&tfile->f_ep_lock);
 
-	/*
-	 * Add the current item to the RB tree. All RB tree operations are
-	 * protected by "mtx", and ep_insert() is called with "mtx" held.
-	 */
-	ep_rbtree_insert(ep, epi);
-
 	/* We have to drop the new item inside our item list to keep track of it */
 	spin_lock_irqsave(&ep->lock, flags);
 
@@ -1066,10 +1052,7 @@ retry:
 }
 
 /*
- * It opens an eventpoll file descriptor. The "size" parameter is there
- * for historical reasons, when epoll was using an hash instead of an
- * RB tree. With the current implementation, the "size" parameter is ignored
- * (besides sanity checks).
+ * It opens an eventpoll file descriptor.
  */
 asmlinkage long sys_epoll_create(int size)
 {
@@ -1086,7 +1069,17 @@ asmlinkage long sys_epoll_create(int siz
 	 * structure ( "struct eventpoll" ).
 	 */
 	error = -EINVAL;
-	if (size <= 0 || (error = ep_alloc(&ep)) != 0)
+	if (size <= 0) {
+		error = -EINVAL;
+		goto error_return;
+	}
+	if (size > current->signal->rlim[RLIMIT_NOFILE].rlim_cur
+				|| size > NR_OPEN) {
+		error = -ENFILE;
+		goto error_return;
+	}
+
+	if ((error = ep_alloc(&ep, size)) != 0)
 		goto error_return;
 
 	/*
@@ -1167,7 +1160,7 @@ asmlinkage long sys_epoll_ctl(int epfd, 
 	mutex_lock(&ep->mtx);
 
 	/*
-	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
+	 * Try to lookup the file inside our epi_array, Since we grabbed "mtx"
 	 * above, we can be sure to be able to use the item looked up by
 	 * ep_find() till we release the mutex.
 	 */


