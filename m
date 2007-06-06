Return-Path: <linux-kernel-owner+w=401wt.eu-S936317AbXFFWar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936317AbXFFWar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764852AbXFFWaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1315 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXFFWae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:34 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 1/8] fdmap v2 - fdmap core
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169031.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Core code for the fdmap implementation. Random allocation, exact allocation,
de-allocation and lookup are all O(1) operations. It also support the "legacy"
sequential (compact) file descriptor allocation, that is O(N) like the old
fdtable implementation.
Like the old "struct fdtable", fdmap is RCU friendly too.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/fs/fdmap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/fs/fdmap.c	2007-06-06 12:47:31.000000000 -0700
@@ -0,0 +1,549 @@
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
+#define FDMAP_BMPSIZE(s)	(FDMAP_BMP_LONGS(s) * sizeof(long))
+
+#define FDMAP_KMALLOC_LIMIT	PAGE_SIZE
+
+struct fdmap_defer {
+	spinlock_t lock;
+	struct work_struct wq;
+	struct fd_map *next;
+};
+
+static DEFINE_PER_CPU(struct fdmap_defer, fdmap_defer_list);
+
+static inline void fdmap_insert(struct list_head *new,
+				struct list_head *prev, struct list_head *next)
+{
+	/*
+	 * The insert function is used to re-insert the slot inside
+	 * the list of free slots, so basically during fd release time.
+	 * The ->next field is used by fdmap_busy_slot() to test if a
+	 * slot is allocated or not. We need to make sure the ->next
+	 * fields are properly set, before the updates to the ->prev
+	 * fields are visible. The list is not *walked* in RCU fashion
+	 * (simply looked up by entry), so we are fine with the code below.
+	 */
+	new->next = next;
+	smp_wmb();
+	new->prev = prev;
+	next->prev = new;
+	prev->next = new;
+}
+
+static void fdmap_remove(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+}
+
+static inline void fdmap_add_slot(struct list_head *head, struct list_head *new)
+{
+	fdmap_insert(new, head->prev, head);
+}
+
+static void *fdmap_alloc_mem(unsigned long size)
+{
+	if (size <= FDMAP_KMALLOC_LIMIT)
+		return kmalloc(size, GFP_KERNEL);
+	else
+		return vmalloc(size);
+}
+
+static void fdmap_free_mem(void *data, unsigned long size)
+{
+	if (size <= FDMAP_KMALLOC_LIMIT)
+		kfree(data);
+	else
+		vfree(data);
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
+	fmap->slots[fd - fmap->base].prev = (struct list_head *) file;
+}
+
+static int fdmap_alloc_tail(struct fd_map *fmap, int fd, unsigned long flags)
+{
+	struct list_head *ptr = fmap->slots + fd;
+
+	fdmap_remove(ptr);
+	__set_bit(fd, fmap->map);
+	/*
+	 * We need to make sure that at the time ->next is marked as allocated,
+	 * ->prev is properly initialize to NULL. This way the RCU-aware
+	 * fdmap_file_get() can return the "correct" invalid NULL value, instead
+	 * of garbage.
+	 */
+	ptr->prev = NULL;
+	smp_wmb();
+	FDMAP_SETFLAGS(ptr, FDMAP_F_BUSYSLOT | flags);
+
+	return fmap->base + fd;
+}
+
+/**
+ * fdmap_newfd - Allocates a new random file descriptor
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @fd:     [in] File descriptor to allocate, or -1 to allocate a random one
+ * @flags:  [in] Flags to be associated with the file descriptor
+ *
+ * Return the newly allocated file descriptor, or a negative value in case
+ * of error.
+ */
+int fdmap_newfd(struct fd_map *fmap, int fd, unsigned long flags)
+{
+	if (likely(fd < 0)) {
+		if (unlikely(list_empty(&fmap->slist)))
+			return -ENOSPC;
+		fd = (int) (fmap->slist.next - fmap->slots);
+	} else {
+		fd = fd - fmap->base;
+		if (unlikely(fdmap_busy_slot(&fmap->slots[fd])))
+			return -EBUSY;
+	}
+
+	return fdmap_alloc_tail(fmap, fd, flags);
+}
+
+/**
+ * fdmap_newfd_seq - Allocates a new sequential file descriptor
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @start:  [in] Start position from where to allocated the new file
+ *               descriptor. It must be inside the area of allocation of @fmap,
+ *               or it can be zero (in which case the lower file descriptor
+ *               will be returned)
+ * @limit:  [in] Maximum (not included) value for the returned fd
+ * @flags:  [in] Flags to be associated with the file descriptor
+ *
+ * Return the newly allocated file descriptor, or a negative value in case
+ * of error.
+ */
+int fdmap_newfd_seq(struct fd_map *fmap, unsigned int start,
+		    unsigned int limit, unsigned long flags)
+{
+	int fd;
+
+	if (unlikely(start))
+		start = start - fmap->base;
+	if (likely(start < fmap->fdnext))
+		start = fmap->fdnext;
+	fd = find_next_zero_bit(fmap->map, fmap->size, start);
+	if (unlikely(fd >= limit))
+		return -EMFILE;
+	if (unlikely(fd >= fmap->size))
+		return -ENOSPC;
+	fmap->fdnext = fd + 1;
+
+	return fdmap_alloc_tail(fmap, fd, flags);
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
+	fd = fd - fmap->base;
+
+	/*
+	 * The smp_wmb() inside fdmap_insert() takes care of making
+	 * the transaction RCU friendly.
+	 */
+	fdmap_add_slot(&fmap->slist, &fmap->slots[fd]);
+	__clear_bit(fd, fmap->map);
+	if (fd < fmap->fdnext)
+		fmap->fdnext = fd;
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
+	struct list_head *ptr;
+
+	ptr = fmap->slots + fd - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return 0;
+
+	return FDMAP_GETFLAGS(ptr) & ~FDMAP_F_BUSYSLOT;
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
+	struct list_head *ptr;
+
+	ptr = fmap->slots + fd - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return -EBADF;
+	fclear &= ~FDMAP_F_BUSYSLOT;
+	/*
+	 * There's no race here WRT the FDMAP_F_BUSYSLOT flag. The flag
+	 * is there before (otherwise the fdmap_busy_slot() check would
+	 * fail, and is never cleared. So an external viewer either sees
+	 * the old value, or the new one, and both have FDMAP_F_BUSYSLOT set.
+	 */
+	ptr->next = (void *) ((FDMAP_GETFLAGS(ptr) & ~fclear) | fadd);
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
+ * @reset:  [in] Should the file pointer be atomically reset to NULL?
+ * @proc:   [in] Callback to be invoked for every file pointer
+ * @priv:   [in] Private data for the callback (passed in the first parameter)
+ *
+ */
+void fdmap_for_each_file(struct fd_map *fmap, int reset,
+			 int (*proc)(void *, struct file *, int), void *priv)
+{
+	unsigned int i;
+	struct list_head *ptr;
+	struct file *file;
+
+	for (i = 0, ptr = fmap->slots; i < fmap->size; i++, ptr++) {
+		if (fdmap_busy_slot(ptr)) {
+			if (reset)
+				file = (struct file *) xchg(&ptr->prev, NULL);
+			else
+				file = (struct file *) ptr->prev;
+			if (file && (*proc)(priv, file, i + fmap->base))
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
+ * @clear:  [in]     Should the flag bit be cleared?
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
+int fdmap_next_flag_set(struct fd_map *fmap, int bit, int clear,
+			unsigned int *start, unsigned int *base,
+			unsigned long *fset)
+{
+	unsigned int i, j;
+	unsigned long f, mask, v;
+	struct list_head *ptr;
+
+	mask = 1UL << bit;
+	i = *start;
+	ptr = fmap->slots + i;
+	f = 0;
+	do {
+		if (i >= fmap->size)
+			return 0;
+		*base = i + fmap->base;
+		for (j = 0; i < fmap->size && j < BITS_PER_LONG;
+		     i++, j++, ptr++) {
+			if (!fdmap_busy_slot(ptr))
+				continue;
+			v = FDMAP_GETFLAGS(ptr);
+			if (v & mask) {
+				f |= 1UL << j;
+				if (clear)
+					FDMAP_SETFLAGS(ptr, v & ~mask);
+			}
+		}
+	} while (!f);
+	*start = i;
+	*fset = f;
+
+	return 1;
+}
+
+/**
+ * fdmap_top_open_fd - Finds the top file descriptor allocated
+ *
+ * @fmap:   [in]     Pointer to the file descriptor map
+ *
+ * Returns the top allocated file descriptor, or (base - 1) if no open
+ * file descriptors are found.
+ */
+int fdmap_top_open_fd(const struct fd_map *fmap)
+{
+	int i, j;
+	unsigned long tset, mask;
+	const unsigned long *map;
+
+	i = (int) (FDMAP_BMPSIZE(fmap->size) / sizeof(long)) - 1;
+	for (map = fmap->map + i; i >= 0 && !*map; i--, map--);
+	if (i >= 0) {
+		/*
+		 * Unfortunately, __fls is not everywhere.
+		 */
+		tset = *map;
+		/* Set "mask" to top BITS_PER_BYTE set */
+		mask = ~((1UL << (BITS_PER_LONG - BITS_PER_BYTE)) - 1);
+		for (j = BITS_PER_LONG; j && !(tset & mask);
+		     j -= BITS_PER_BYTE, mask >>= BITS_PER_BYTE);
+		j--;
+		mask = 1UL << j;
+		for (; j && !(tset & mask); j--, mask >>= 1);
+		i = i * BITS_PER_LONG + j;
+	}
+	return (int) fmap->base + i;
+}
+
+/**
+ * fdmap_copy - Copies the content of a file descriptor map to another
+ *
+ * @dfmap:  [in/out] Pointer to the destination file descriptor map
+ * @sfmap:  [in]     Pointer to the source file descriptor map
+ * @count:  [out]    Pointer to the number of allocated file descriptor
+ *                   transfered
+ * @cpflags [in]     Flags to control how files are copied
+ *
+ * Copies the content of one file descriptor map to another. The size
+ * of the destination map must be greater than the maximum allocated
+ * file descriptor in the source map.
+ */
+void fdmap_copy(struct fd_map *dfmap, const struct fd_map *sfmap,
+		unsigned int *count, unsigned long cpflags)
+{
+	unsigned int i, bcount, size;
+	struct list_head *dptr;
+	const struct list_head *sptr;
+
+	INIT_LIST_HEAD(&dfmap->slist);
+	memset(dfmap->map, 0, FDMAP_BMPSIZE(dfmap->size));
+	dptr = dfmap->slots;
+	sptr = sfmap->slots;
+	size = min(sfmap->size, dfmap->size);
+	for (i = 0, bcount = 0; i < size; i++, dptr++, sptr++) {
+		if (fdmap_busy_slot(sptr) && sptr->prev) {
+			if (cpflags & FDMAP_CPF_FORKMODE) {
+				if (FDMAP_GETFLAGS(sptr) & FDMAP_F_CLOFORK)
+					goto add_free_list;
+				get_file((struct file *) sptr->prev);
+			}
+			*dptr = *sptr;
+			__set_bit(i, dfmap->map);
+			bcount++;
+			continue;
+		}
+add_free_list:
+		fdmap_add_slot(&dfmap->slist, dptr);
+	}
+	/*
+	 * Source map can be greter in size than destination map,
+	 * but no open file descriptors must be present in the higher
+	 * part of the source map.
+	 */
+	for (; i < sfmap->size; i++, sptr++)
+		BUG_ON(fdmap_busy_slot(sptr) && sptr->prev);
+	for (i = size; i < dfmap->size; i++, dptr++)
+		fdmap_add_slot(&dfmap->slist, dptr);
+	if (count)
+		*count = bcount;
+}
+
+/**
+ * fdmap_init_map - Initialize a pre-allocated map
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ * @base:   [in] Starting value for the file descriptors allocated inside this map
+ * @size:   [in] Size of the map
+ * @init:   [in] Boolean indicating if the free-map initialization should be done
+ *
+ */
+void fdmap_init_map(struct fd_map *fmap, unsigned int base, unsigned int size,
+		    int init)
+{
+	int i;
+
+	fmap->next = NULL;
+	fmap->base = base;
+	fmap->size = size;
+	fmap->fdnext = 0;
+	fmap->freecb = NULL;
+	fmap->freecb_priv = NULL;
+	INIT_RCU_HEAD(&fmap->rcu);
+	INIT_LIST_HEAD(&fmap->slist);
+	if (init) {
+		for (i = 0; i < size; i++)
+			fdmap_add_slot(&fmap->slist, &fmap->slots[i]);
+		memset(fmap->map, 0, FDMAP_BMPSIZE(size));
+	}
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
+	struct fd_map *fmap;
+
+	if ((long) base + (long) size >= INT_MAX ||
+	    UINT_MAX / sizeof(struct list_head) < size)
+		return NULL;
+	fmap = kzalloc(sizeof(struct fd_map), GFP_KERNEL);
+	if (!fmap)
+		return NULL;
+	fmap->slots = fdmap_alloc_mem(size * sizeof(struct list_head));
+	if (!fmap->slots)
+		goto out_free;
+	fmap->map = fdmap_alloc_mem(FDMAP_BMPSIZE(size));
+	if (!fmap->map)
+		goto out_free;
+	fdmap_init_map(fmap, base, size, init);
+
+	return fmap;
+
+out_free:
+	fdmap_free_mem(fmap->slots,
+		       size * sizeof(struct list_head));
+	kfree(fmap);
+	return NULL;
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
+static void free_fdmap_work(struct work_struct *work)
+{
+	struct fdmap_defer *fddef = container_of(work, struct fdmap_defer, wq);
+	struct fd_map *fmap, *next;
+
+	spin_lock_bh(&fddef->lock);
+	fmap = fddef->next;
+	fddef->next = NULL;
+	spin_unlock_bh(&fddef->lock);
+	while (fmap) {
+		next = fmap->next;
+		/*
+		 * The struct fd_map may be embedded inside other strctures,
+		 * and we give the ability to set custom RCU free functions.
+		 */
+		if (fmap->freecb)
+			(*fmap->freecb)(fmap->freecb_priv, fmap);
+		else {
+			fdmap_free_mem(fmap->map, FDMAP_BMPSIZE(fmap->size));
+			fdmap_free_mem(fmap->slots,
+				       fmap->size * sizeof(struct list_head));
+			kfree(fmap);
+		}
+		fmap = next;
+	}
+}
+
+/**
+ * fdmap_module_init - Early initialization function for the file descriptors
+ *                     allocator module
+ *
+ */
+int fdmap_module_init(void)
+{
+	int i;
+	struct fdmap_defer *fddef;
+
+	for_each_possible_cpu(i) {
+		fddef = &per_cpu(fdmap_defer_list, i);
+		spin_lock_init(&fddef->lock);
+		INIT_WORK(&fddef->wq, free_fdmap_work);
+		fddef->next = NULL;
+	}
+	return 0;
+}
+
Index: linux-2.6.mod/include/linux/fdmap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/include/linux/fdmap.h	2007-06-06 12:47:54.000000000 -0700
@@ -0,0 +1,185 @@
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
+#include <linux/list.h>
+
+/*
+ * We use bit zero for the special FDMAP_F_BUSYSLOT flag. This
+ * will be an indicator that the slot is busy, and we take advantage
+ * that pointers to "slots" will always have alignment greater than one.
+ */
+#define FDMAP_BIT_BUSYSLOT	0
+#define FDMAP_F_BUSYSLOT	(1UL << FDMAP_BIT_BUSYSLOT)
+
+#define FDMAP_BIT_CLOEXEC	1
+#define FDMAP_F_CLOEXEC		(1UL << FDMAP_BIT_CLOEXEC)
+
+#define FDMAP_BIT_CLOFORK	2
+#define FDMAP_F_CLOFORK		(1UL << FDMAP_BIT_CLOFORK)
+
+#define FDMAP_CPF_FORKMODE	(1UL << 0)
+
+#define FDMAP_GETFLAGS(p)	((unsigned long) (p)->next)
+#define FDMAP_SETFLAGS(p, f)	(p)->next = (void *) (f)
+#define FDMAP_BMP_LONGS(s)	DIV_ROUND_UP((s) + 1, BITS_PER_LONG)
+
+struct fd_map {
+	struct fd_map *next;
+	struct rcu_head rcu;
+	unsigned int base;
+	unsigned int size;
+	struct list_head slist;
+	struct list_head *slots;
+	unsigned int fdnext;
+	unsigned long *map;
+	void (*freecb)(void *, struct fd_map *);
+	void *freecb_priv;
+};
+
+/**
+ * fdmap_busy_slot - Returns the BUSY status of an allocation slot
+ *
+ * @ptr:   [in] Pointer to the allocation slot
+ *
+ * Returns a non-zero value if the slot pointed by @ptr is allocated, zero
+ * otherwise
+ */
+static inline int fdmap_busy_slot(const struct list_head *ptr)
+{
+	smp_rmb();
+	return !!(FDMAP_GETFLAGS(ptr) & FDMAP_F_BUSYSLOT);
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
+static inline struct file *fdmap_file_get(struct fd_map *fmap, unsigned int fd)
+{
+	struct list_head *ptr;
+
+	ptr = fmap->slots + fd - fmap->base;
+	if (unlikely(!fdmap_busy_slot(ptr)))
+		return NULL;
+	return (struct file *) ptr->prev;
+}
+
+/**
+ * fdmap_fdof - Tells if a file descriptor value falls inside the range
+ *              allowed by @fmap
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
+ * fdmap_size - Returns the size of this alocation map
+ *
+ * @fmap:   [in] Pointer to the file descriptor map
+ *
+ */
+static inline unsigned int fdmap_size(const struct fd_map *fmap)
+{
+	return fmap->size;
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
+/**
+ * fdmap_set_rcufree - Sets the RCU-free parameters to allow custom free code
+ *
+ * @fmap:       [in] Pointer to the file descriptor map
+ * @freecb:     [in] Pointer to the free callback
+ * @freecb_priv [in] Pointer to the free callback data
+ *
+ */
+static inline void fdmap_set_freecb(struct fd_map *fmap,
+				    void (*freecb)(void *, struct fd_map *),
+				    void *freecb_priv)
+{
+	fmap->freecb = freecb;
+	fmap->freecb_priv = freecb_priv;
+}
+
+/**
+ * fdmap_get_allocmap - Returns the allocation map for this file descriptor map
+ *
+ * @fmap:       [in] Pointer to the file descriptor map
+ *
+ * The first bit of the map is '1', if the file descriptor at fdmap_basefd() is
+ * allocated. The second bit of the map is '1', if the file descriptor at
+ * fdmap_basefd()+1 is allocated. And so on.
+ */
+static inline const unsigned long *fdmap_get_allocmap(const struct fd_map *fmap)
+{
+	return fmap->map;
+}
+
+struct file *fdmap_file_get(struct fd_map *fmap, unsigned int fd);
+void fdmap_install(struct fd_map *fmap, unsigned int fd, struct file *file);
+int fdmap_newfd(struct fd_map *fmap, int fd, unsigned long flags);
+int fdmap_newfd_seq(struct fd_map *fmap, unsigned int start,
+		    unsigned int limit, unsigned long flags);
+void fdmap_putfd(struct fd_map *fmap, unsigned int fd);
+unsigned long fdmap_get_fdflags(struct fd_map *fmap, unsigned int fd);
+int fdmap_set_fdflags(struct fd_map *fmap, unsigned int fd, unsigned long fclear,
+		      unsigned long fadd);
+void fdmap_for_each_file(struct fd_map *fmap, int reset,
+			 int (*proc)(void *, struct file *, int), void *priv);
+int fdmap_next_flag_set(struct fd_map *fmap, int bit, int clear,
+			unsigned int *start, unsigned int *base,
+			unsigned long *fset);
+int fdmap_top_open_fd(const struct fd_map *fmap);
+void fdmap_copy(struct fd_map *dfmap, const struct fd_map *sfmap,
+		unsigned int *count, unsigned long cpflags);
+void fdmap_init_map(struct fd_map *fmap, unsigned int base, unsigned int size,
+		    int init);
+struct fd_map *fdmap_alloc(unsigned int base, unsigned int size, int init);
+void fdmap_free(struct fd_map *fmap);
+int fdmap_module_init(void);
+
+#endif /* _LINUX_FDMAP_H */
+
Index: linux-2.6.mod/fs/Makefile
===================================================================
--- linux-2.6.mod.orig/fs/Makefile	2007-06-06 12:38:28.000000000 -0700
+++ linux-2.6.mod/fs/Makefile	2007-06-06 12:38:29.000000000 -0700
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 # 
 
-obj-y :=	open.o read_write.o file_table.o super.o \
+obj-y :=	open.o read_write.o file_table.o super.o fdmap.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o fifo.o locks.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \

