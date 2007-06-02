Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXFBW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXFBW7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbXFBW7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:59:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2713 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762335AbXFBW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:59:09 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Sat, 02 Jun 2007 15:59:05 -0700
Subject: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Core code for the unsequential fdmap implementation. Random allocation,
exact allocation, de-allocation and lookup are all O(1) operations.
The only operation that is O(N) is the strict from-N-up kind of allocation,
but that only used by F_DUPFD and it's definitely not frequently used
(and current code is O(N) too).
Like the "struct fdtable", the unsequential fdmap is RCU friendly too.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/fs/fdmap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/fs/fdmap.c	2007-06-02 15:35:58.000000000 -0700
@@ -0,0 +1,473 @@
+/*
+ *  fs/fdmap.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/fdmap.h>
+
+#define FDMAP_F_BUSYSLOT	(1UL << (BITS_PER_LONG - 1))
+
+#define FDMAP_FD(i)		((i) + 1)
+#define FDMAP_MKUSERFD(i)	((i) - 1)
+
+struct fdmap_defer {
+	spinlock_t lock;
+	struct work_struct wq;
+	struct fd_map *next;
+};
+
+static DEFINE_PER_CPU(struct fdmap_defer, fdmap_defer_list);
+
+static inline void fdmap_init_slothead(struct fd_slot *head)
+{
+	head->prev = head->next = 0;
+}
+
+static inline int fdmap_list_empty(struct fd_slot *head)
+{
+	return head->next == 0;
+}
+
+static void fdmap_insert(struct fd_slot *head, unsigned long inew,
+			 unsigned long iprev, unsigned long inext)
+{
+	struct fd_slot *new, *prev, *next;
+
+	prev = head + iprev;
+	next = head + inext;
+	new = head + inew;
+	prev->next = inew;
+	new->next = inext;
+	/*
+	 * The insert function is used to re-insert the slot inside
+	 * the list of free slots, so basically during fd release time.
+	 * The ->next field is used by fdmap_busy_slot() to test if a
+	 * slot is allocated or not. We need to make sure the ->next
+	 * fields are properly set, before the updates to the ->prev
+	 * fields are visible.
+	 */
+	smp_wmb();
+	next->prev = inew;
+	new->prev = iprev;
+}
+
+static void fdmap_remove(struct fd_slot *head, unsigned long idel)
+{
+	struct fd_slot *del, *prev, *next;
+
+	del = head + idel;
+	prev = head + del->prev;
+	next = head + del->next;
+	prev->next = del->next;
+	next->prev = del->prev;
+}
+
+static inline void fdmap_add_slot(struct fd_slot *slots, unsigned long inew)
+{
+	fdmap_insert(slots, inew, slots[0].prev, 0);
+}
+
+static inline int fdmap_busy_slot(const struct fd_slot *ptr)
+{
+	smp_rmb();
+	return !!(ptr->next & FDMAP_F_BUSYSLOT);
+}
+
+static void *fdmap_alloc_mem(unsigned long size)
+{
+	if (size <= PAGE_SIZE)
+		return kmalloc(size, GFP_KERNEL);
+	else
+		return vmalloc(size);
+}
+
+static void fdmap_free_mem(void *data, unsigned long size)
+{
+	if (size <= PAGE_SIZE)
+		kfree(data);
+	else
+		vfree(data);
+}
+
+/**
+ * fdmap_file_get - Gets the file pointer associated with a file descriptor
+ *
+ * @fmap: [in] Pointer to the file descriptor map
+ * @fd:   [in] File descriptor
+ *
+ * Returns the file pointer associated with the file @fd, or NULL
+ * if no file pointer is still associated with @fd.
+ */
+struct file *fdmap_file_get(struct fd_map *fmap, unsigned int fd)
+{
+	struct fd_slot *ptr;
+
+	ptr = fmap->slots + FDMAP_FD(fd) - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return NULL;
+	return (struct file *) ptr->prev;
+}
+
+/**
+ * fdmap_install - Installs a file pointer onto a previously allocated
+ *                 file descriptor
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] Previously allocated file descriptor
+ * @file:   [in] File pointer
+ *
+ */
+void fdmap_install(struct fd_map *fmap, unsigned int fd, struct file *file)
+{
+	smp_wmb();
+	fmap->slots[FDMAP_FD(fd) - fmap->base].prev = (unsigned long) file;
+}
+
+/**
+ * fdmap_newfd - Allocates a new file descriptor
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] File descriptor allocation hint. If @fd == FDMAP_HINT_ANY,
+ *               then a random free file descriptor is allocated. If @fd is
+ *               FDMAP_HINT_FDUP(FD), then a free file descriptor from FD up,
+ *               is allocated. If @fd is FDMAP_HINT_EXACT(FD), the function
+ *               tries to allocate the file descriptor FD, if available
+ * @flags:  [in] Flags to be associated with the new file descriptor
+ *
+ * Return the newly allocated file descriptor, or a negative number in case
+ * of error.
+ */
+int fdmap_newfd(struct fd_map *fmap, int fd, unsigned long flags)
+{
+	unsigned int i;
+	struct fd_slot *ptr;
+
+	/*
+	 * fd == 0    means alloc any
+	 * fd < 0     means alloc one from (-fd) up
+	 * fd > 0     means alloc exactly (fd - 1), if possible
+	 */
+	if (fd) {
+		if (fd > 0) {
+			fd--;
+			if (unlikely(fd < fmap->base))
+				return -EBADF;
+			if (fd >= fmap->base + fmap->size)
+				return -EMFILE;
+			fd = FDMAP_FD(fd);
+			ptr = fmap->slots + fd - fmap->base;
+			if (fdmap_busy_slot(ptr))
+				return -EBADF;
+		} else {
+			i = FDMAP_FD(-fd);
+			if (unlikely(i <= fmap->base))
+				return -EBADF;
+			i -= fmap->base;
+			ptr = fmap->slots + i;
+			for (; i <= fmap->size; i++, ptr++)
+				if (!fdmap_busy_slot(ptr))
+					break;
+			if (i > fmap->size)
+				return -EMFILE;
+			fd = i;
+		}
+	} else {
+		if (unlikely(fdmap_list_empty(&fmap->slots[0])))
+			return -EMFILE;
+		fd = (int) fmap->slots[0].next;
+		ptr = fmap->slots + fd;
+	}
+	fdmap_remove(&fmap->slots[0], fd);
+	/*
+	 * We need to make sure that at the time ->next is marked as allocated,
+	 * ->prev is properly initialize to NULL. This way the RCU-aware
+	 * fdmap_file_get() can return the "correct" invalid NULL value, instead
+	 * of garbage.
+	 */
+	ptr->prev = 0;
+	smp_wmb();
+	ptr->next = FDMAP_F_BUSYSLOT | flags;
+
+	return fmap->base + FDMAP_MKUSERFD(fd);
+}
+
+/**
+ * fdmap_putfd - Releases a previously allocated file descriptor
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] Previously allocated file descriptor
+ *
+ */
+void fdmap_putfd(struct fd_map *fmap, unsigned int fd)
+{
+	/*
+	 * The smp_wmb() inside fdmap_insert() takes care of making
+	 * the transaction RCU friendly.
+	 */
+	fdmap_add_slot(&fmap->slots[0], FDMAP_FD(fd) - fmap->base);
+}
+
+/**
+ * fdmap_get_fdflags - Retrieves an allocated file descriptor flags
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] Previously allocated file descriptor
+ *
+ * Returns the file descriptor flags, if the descriptor is allocated,
+ * or zero if not.
+ */
+unsigned long fdmap_get_fdflags(struct fd_map *fmap, unsigned int fd)
+{
+	struct fd_slot *ptr;
+
+	ptr = fmap->slots + FDMAP_FD(fd) - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return 0;
+
+	return ptr->next & ~FDMAP_F_BUSYSLOT;
+}
+
+/**
+ * fdmap_set_fdflags - Changes an allocated file descriptor flags. It allows
+ *                     to specify a set of flags to be cleared, together with
+ *                     a set of flags to be set
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] Previously allocated file descriptor
+ * @fclear: [in] Set of flags to be cleared
+ * @fadd:   [in] Set of flags to be set
+ *
+ * Returns the file descriptor flags, if the descriptor is allocated,
+ * or zero if not.
+ */
+int fdmap_set_fdflags(struct fd_map *fmap, unsigned int fd, unsigned long fclear,
+		      unsigned long fadd)
+{
+	struct fd_slot *ptr;
+
+	ptr = fmap->slots + FDMAP_FD(fd) - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return -EBADF;
+	fclear &= ~FDMAP_F_BUSYSLOT;
+	ptr->next = (ptr->next & ~fclear) | fadd;
+
+	return 0;
+}
+
+/**
+ * fdmap_for_each_file - Enumerates all the file pointers inside the allocated
+ *                       file descriptors. Only if the file pointer is not NULL
+ *                       (although the file descriptor may be allocated), the
+ *                       callback function is invoked
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @proc:   [in] Callback to be invoked for every file pointer
+ * @priv:   [in] Private data for the callback (passed in the first parameter)
+ *
+ */
+void fdmap_for_each_file(struct fd_map *fmap, int (*proc)(void *, struct file *),
+			 void *priv)
+{
+	unsigned int i;
+	struct fd_slot *ptr;
+	struct file *file;
+
+	for (i = 0, ptr = fmap->slots + 1; i < fmap->size; i++, ptr++) {
+		if (fdmap_busy_slot(ptr)) {
+			file = (struct file *) ptr->prev;
+			if (file && (*proc)(priv, file))
+				break;
+		}
+	}
+}
+
+/**
+ * fdmap_next_flag_set - Retrieves the next, not empty set, of allocated file
+ *                       desciptors having the bit @bit set in their flags
+ *
+ * @fmap:   [in]     Pointer to the file descriptor map
+ * @bit:    [in]     Bit number to test for
+ * @start:  [in/out] Next position to scan from. Must be set to set to start
+ *                   a new scan, and it will be updated at every call to this
+ *                   function
+ * @base:   [out]    File descriptor base value for the returned set
+ * @fset:   [out]    Bit set of file desciptors having the bit @bit set in
+ *                   their flags. Bit #0 of @fset refers to the file desciptor
+ *                   @base, bit #1 to @base+1, etc...
+ *
+ * Returns a non zero value if the next set is available, or zero if no more
+ * file desciptors with the bit @bit set are available.
+ */
+int fdmap_next_flag_set(struct fd_map *fmap, int bit, unsigned int *start,
+			unsigned int *base, unsigned long *fset)
+{
+	unsigned int i, j;
+	unsigned long f, mask;
+	struct fd_slot *ptr;
+
+	mask = 1 << bit;
+	i = *start;
+	ptr = fmap->slots + FDMAP_FD(i);
+	do {
+		if (i >= fmap->size)
+			return 0;
+		*base = i + fmap->base;
+		for (j = 0, f = 0; i < fmap->size && j < BITS_PER_LONG;
+		     i++, j++, ptr++) {
+			if (fdmap_busy_slot(ptr) &&
+			    (ptr->next & mask))
+				f |= 1 << j;
+		}
+	} while (!f);
+	*start = i;
+	*fset = f;
+
+	return 1;
+}
+
+/**
+ * fdmap_copy - Copies the content of a file descriptor map to another
+ *
+ * @dfmap:  [in/out] Pointer to the destination file descriptor map
+ * @sfmap:  [in]     Pointer to the source file descriptor map
+ * @count:  [out]    Pointer to the number of allocated file descriptor
+ *                   transfered
+ * @dofget  [in]     Boolean indicating if the function should perform
+ *                   a get_file() for each trasfered file pointer
+ *
+ */
+void fdmap_copy(struct fd_map *dfmap, const struct fd_map *sfmap,
+		unsigned int *count, int dofget)
+{
+	unsigned int i, bcount;
+	struct fd_slot *dptr;
+	const struct fd_slot *sptr;
+
+	BUG_ON(dfmap->size < sfmap->size);
+
+	fdmap_init_slothead(&dfmap->slots[0]);
+	dptr = dfmap->slots + 1;
+	sptr = sfmap->slots + 1;
+	for (i = 0, bcount = 0; i < sfmap->size; i++, dptr++, sptr++) {
+		if (fdmap_busy_slot(sptr) && sptr->prev) {
+			if (dofget)
+				get_file((struct file *) sptr->prev);
+			*dptr = *sptr;
+			bcount++;
+		} else
+			fdmap_add_slot(&dfmap->slots[0], i + 1);
+	}
+	for (; i < dfmap->size; i++)
+		fdmap_add_slot(&dfmap->slots[0], i + 1);
+	if (count)
+		*count = bcount;
+}
+
+/**
+ * fdmap_alloc - Allocates a new file descriptor map
+ *
+ * @base:  [in] Starting value for the file descriptors allocated inside this map
+ * @size:  [in] Size of the map
+ * @init:  [in] Boolean indicating if the free-map initialization should be done.
+ *              When allocating a new must just to be copied over by fdmap_copy(),
+ *              it saves time to avoid to go through the whole map memory to
+ *              initialize it, when it will be overwritten soon after
+ *
+ */
+struct fd_map *fdmap_alloc(unsigned int base, unsigned int size, int init)
+{
+	unsigned int i;
+	struct fd_map *fmap;
+
+	if ((long) base + (long) size >= INT_MAX ||
+	    UINT_MAX / sizeof(struct fd_slot) < size)
+		return NULL;
+	fmap = kzalloc(sizeof(struct fd_map), GFP_KERNEL);
+	if (!fmap)
+		return NULL;
+	fmap->base = base;
+	fmap->size = size;
+	fmap->slots = fdmap_alloc_mem((size + 1) * sizeof(struct fd_slot));
+	if (!fmap->slots) {
+		kfree(fmap);
+		return NULL;
+	}
+	fdmap_init_slothead(&fmap->slots[0]);
+	if (init)
+		for (i = 0; i < size; i++)
+			fdmap_add_slot(&fmap->slots[0], i + 1);
+	INIT_RCU_HEAD(&fmap->rcu);
+
+	return fmap;
+}
+
+static void fdmap_free_rcu(struct rcu_head *rcu)
+{
+	struct fd_map *fmap = container_of(rcu, struct fd_map, rcu);
+	struct fdmap_defer *fddef;
+
+	BUG_ON(!fmap);
+
+	fddef = &get_cpu_var(fdmap_defer_list);
+	spin_lock(&fddef->lock);
+	fmap->next = fddef->next;
+	fddef->next = fmap;
+	schedule_work(&fddef->wq);
+	spin_unlock(&fddef->lock);
+	put_cpu_var(fdmap_defer_list);
+}
+
+/**
+ * fdmap_free - Frees a file descriptor map. File descriptor map deallocation
+ *              is done in an RCU way, since file descriptor maps must be RCU
+ *              friendly
+ *
+ * @fmap:   [in] Pointer to the file descriptor map to be freed
+ *
+ */
+void fdmap_free(struct fd_map *fmap)
+{
+	call_rcu(&fmap->rcu, fdmap_free_rcu);
+}
+
+static void free_fdtable_work(struct work_struct *work)
+{
+	struct fdmap_defer *f = container_of(work, struct fdmap_defer, wq);
+	struct fd_map *fmap, *next;
+
+	spin_lock_bh(&f->lock);
+	fmap = f->next;
+	f->next = NULL;
+	spin_unlock_bh(&f->lock);
+	while (fmap) {
+		next = fmap->next;
+		fdmap_free_mem(fmap->slots,
+			       (fmap->size + 1) * sizeof(struct fd_slot));
+		kfree(fmap);
+		fmap = next;
+	}
+}
+
+static int __init fdmap_defer_init(void)
+{
+	int i;
+	struct fdmap_defer *fddef;
+
+	for_each_possible_cpu(i) {
+		fddef = &per_cpu(fdmap_defer_list, i);
+		spin_lock_init(&fddef->lock);
+		INIT_WORK(&fddef->wq, free_fdtable_work);
+		fddef->next = NULL;
+	}
+	return 0;
+}
+__initcall(fdmap_defer_init);
+
Index: linux-2.6.mod/include/linux/fdmap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/include/linux/fdmap.h	2007-06-02 14:26:05.000000000 -0700
@@ -0,0 +1,92 @@
+/*
+ *  include/linux/fdmap.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_FDMAP_H
+#define _LINUX_FDMAP_H
+
+#include <linux/rcupdate.h>
+#include <linux/fs.h>
+
+/*
+ * Flags for the file map (BITS_PER_LONG - 1) is reserved.
+ */
+#define FDMAP_BIT_CLOEXEC	0
+#define FDMAP_F_CLOEXEC		(1UL << FDMAP_BIT_CLOEXEC)
+
+#define FDMAP_HINT_ANY		0
+#define FDMAP_HINT_FDUP(i)	(- (int) (i))
+#define FDMAP_HINT_EXACT(i)	((int) (i) + 1)
+
+struct fd_slot {
+	unsigned long prev, next;
+};
+
+struct fd_map {
+	struct fd_map *next;
+	struct rcu_head rcu;
+	unsigned int base;
+	unsigned int size;
+	struct fd_slot *slots;
+};
+
+/**
+ * fdmap_fdof - Tells if a file descriptor value falls inside the range
+ *              allowed byt @fmap
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] Previously allocated file descriptor
+ *
+ * Return non-zero if the file descriptor value falls inside the range
+ * allowed byt @fmap, or zero otherwise
+ */
+static inline int fdmap_fdof(struct fd_map *fmap, unsigned int fd)
+{
+	return fd >= fmap->base && fd < fmap->base + fmap->size;
+}
+
+/**
+ * fdmap_basefd - Returns the first file descriptor value that can be
+ *                allocated inside this map
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ *
+ */
+static inline unsigned int fdmap_basefd(const struct fd_map *fmap)
+{
+	return fmap->base;
+}
+
+/**
+ * fdmap_topfd - Returns the file descriptor value after the last
+ *               that can be allocated inside this map
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ *
+ */
+static inline unsigned int fdmap_topfd(const struct fd_map *fmap)
+{
+	return fmap->base + fmap->size;
+}
+
+struct file *fdmap_file_get(struct fd_map *fmap, unsigned int fd);
+void fdmap_install(struct fd_map *fmap, unsigned int fd, struct file *file);
+int fdmap_newfd(struct fd_map *fmap, int fd, unsigned long flags);
+void fdmap_putfd(struct fd_map *fmap, unsigned int fd);
+unsigned long fdmap_get_fdflags(struct fd_map *fmap, unsigned int fd);
+int fdmap_set_fdflags(struct fd_map *fmap, unsigned int fd, unsigned long fclear,
+		      unsigned long fadd);
+void fdmap_for_each_file(struct fd_map *fmap, int (*proc)(void *, struct file *),
+			 void *priv);
+int fdmap_next_flag_set(struct fd_map *fmap, int bit, unsigned int *start,
+			unsigned int *base, unsigned long *fset);
+void fdmap_copy(struct fd_map *dfmap, const struct fd_map *sfmap,
+		unsigned int *count, int dofget);
+struct fd_map *fdmap_alloc(unsigned int base, unsigned int size, int init);
+void fdmap_free(struct fd_map *fmap);
+
+#endif /* _LINUX_FDMAP_H */
+
Index: linux-2.6.mod/fs/Makefile
===================================================================
--- linux-2.6.mod.orig/fs/Makefile	2007-05-31 17:16:56.000000000 -0700
+++ linux-2.6.mod/fs/Makefile	2007-05-31 17:17:12.000000000 -0700
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 # 
 
-obj-y :=	open.o read_write.o file_table.o super.o \
+obj-y :=	open.o read_write.o file_table.o super.o fdmap.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \

