Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYIVVK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYIVVK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYIVVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:10:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbYIVVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:10:10 -0400
Date: Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Chris Webb <chris@arachsys.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Memory management livelock
In-Reply-To: <20080911101616.GA24064@agk.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is a patch for MM livelock. The original bug report follows after the 
patch. To reproduce the bug on my computer, I had to change bs=4M to 
bs=65536 in examples in the original report.

Mikulas

---

Fix starvation in memory management.

The bug happens when one process is doing sequential buffered writes to
a block device (or file) and another process is attempting to execute
sync(), fsync() or direct-IO on that device (or file). This syncing
process will wait indefinitelly, until the first writing process
finishes.

For example, run these two commands:
dd if=/dev/zero of=/dev/sda1 bs=65536 &
dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct

The bug is caused by sequential walking of address space in
write_cache_pages and wait_on_page_writeback_range: if some other
process is constantly making dirty and writeback pages while these
functions run, the functions will wait on every new page, resulting in
indefinite wait.

To fix the starvation, I declared a mutex starvation_barrier in struct
address_space. When the mutex is taken, anyone making dirty pages on
that address space should stop. The functions that walk address space
sequentially first estimate a number of pages to process. If they
process more than this amount (plus some small delta), it means that
someone is making dirty pages under them --- they take the mutex and
hold it until they finish. When the mutex is taken, the function
balance_dirty_pages will wait and not allow more dirty pages being made.

The mutex is not really used as a mutex, it does not prevent access to
any critical section. It is used as a barrier that blocks new dirty
pages from being created. I use mutex and not wait queue to make sure
that the starvation can't happend the other way (if there were wait
queue, excessive calls to write_cache_pages and
wait_on_page_writeback_range would block balance_dirty_pages forever;
with mutex it is guaranteed that every process eventually makes
progress).

The essential property of this patch is that if the starvation doesn't
happen, no additional locks are taken and no atomic operations are
performed. So the patch shouldn't damage performance.

The indefinite starvation was observed in write_cache_pages and
wait_on_page_writeback_range. Another possibility where it could happen
is invalidate_inode_pages2_range.

There are two more functions that walk all the pages in address space,
but I think they don't need this starvation protection:
truncate_inode_pages_range: it is called with i_mutex locked, so no new
pages are created under it.
__invalidate_mapping_pages: it skips locked, dirty and writeback pages,
so there's no point in protecting the function against starving on them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/inode.c          |    1 +
 include/linux/fs.h  |    1 +
 mm/filemap.c        |   16 ++++++++++++++++
 mm/page-writeback.c |   30 +++++++++++++++++++++++++++++-
 mm/swap_state.c     |    1 +
 mm/truncate.c       |   20 +++++++++++++++++++-
 6 files changed, 67 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc7-devel/fs/inode.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/fs/inode.c	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/fs/inode.c	2008-09-22 23:04:34.000000000 +0200
@@ -214,6 +214,7 @@ void inode_init_once(struct inode *inode
 	spin_lock_init(&inode->i_data.i_mmap_lock);
 	INIT_LIST_HEAD(&inode->i_data.private_list);
 	spin_lock_init(&inode->i_data.private_lock);
+	mutex_init(&inode->i_data.starvation_barrier);
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
 	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
 	i_size_ordered_init(inode);
Index: linux-2.6.27-rc7-devel/include/linux/fs.h
===================================================================
--- linux-2.6.27-rc7-devel.orig/include/linux/fs.h	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/include/linux/fs.h	2008-09-22 23:04:34.000000000 +0200
@@ -539,6 +539,7 @@ struct address_space {
 	spinlock_t		private_lock;	/* for use by the address_space */
 	struct list_head	private_list;	/* ditto */
 	struct address_space	*assoc_mapping;	/* ditto */
+	struct mutex		starvation_barrier;	/* taken when fsync starves */
 } __attribute__((aligned(sizeof(long))));
 	/*
 	 * On most architectures that alignment is already the case; but
Index: linux-2.6.27-rc7-devel/mm/filemap.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/filemap.c	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/filemap.c	2008-09-22 23:04:34.000000000 +0200
@@ -269,10 +269,19 @@ int wait_on_page_writeback_range(struct 
 	int nr_pages;
 	int ret = 0;
 	pgoff_t index;
+	long pages_to_process;
 
 	if (end < start)
 		return 0;
 
+	/*
+	 * Estimate the number of pages to process. If we process significantly
+	 * more than this, someone is making writeback pages under us.
+	 * We must pull the anti-starvation plug.
+	 */
+	pages_to_process = bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
+	pages_to_process += pages_to_process >> 3;
+
 	pagevec_init(&pvec, 0);
 	index = start;
 	while ((index <= end) &&
@@ -288,6 +297,10 @@ int wait_on_page_writeback_range(struct 
 			if (page->index > end)
 				continue;
 
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					mutex_lock(&mapping->starvation_barrier);
+
 			wait_on_page_writeback(page);
 			if (PageError(page))
 				ret = -EIO;
@@ -296,6 +309,9 @@ int wait_on_page_writeback_range(struct 
 		cond_resched();
 	}
 
+	if (pages_to_process < 0)
+		mutex_unlock(&mapping->starvation_barrier);
+
 	/* Check for outstanding write errors */
 	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
 		ret = -ENOSPC;
Index: linux-2.6.27-rc7-devel/mm/page-writeback.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/page-writeback.c	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/page-writeback.c	2008-09-22 23:04:34.000000000 +0200
@@ -435,6 +435,15 @@ static void balance_dirty_pages(struct a
 
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	/*
+	 * If there is sync() starving on this address space, block
+	 * writers until it finishes.
+	 */
+	if (unlikely(mutex_is_locked(&mapping->starvation_barrier))) {
+		mutex_lock(&mapping->starvation_barrier);
+		mutex_unlock(&mapping->starvation_barrier);
+	}
+
 	for (;;) {
 		struct writeback_control wbc = {
 			.bdi		= bdi,
@@ -876,12 +885,21 @@ int write_cache_pages(struct address_spa
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	int range_whole = 0;
+	long pages_to_process;
 
 	if (wbc->nonblocking && bdi_write_congested(bdi)) {
 		wbc->encountered_congestion = 1;
 		return 0;
 	}
 
+	/*
+	 * Estimate the number of pages to process. If we process significantly
+	 * more than this, someone is making dirty pages under us.
+	 * Pull the anti-starvation plug to stop him.
+	 */
+	pages_to_process = bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+	pages_to_process += pages_to_process >> 3;
+
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
@@ -902,7 +920,13 @@ retry:
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
+
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					mutex_lock(&mapping->starvation_barrier);
+
+			page = pvec.pages[i];
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
@@ -958,6 +982,10 @@ retry:
 		index = 0;
 		goto retry;
 	}
+
+	if (pages_to_process < 0)
+		mutex_unlock(&mapping->starvation_barrier);
+
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
Index: linux-2.6.27-rc7-devel/mm/swap_state.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/swap_state.c	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/swap_state.c	2008-09-22 23:04:34.000000000 +0200
@@ -43,6 +43,7 @@ struct address_space swapper_space = {
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
 	.backing_dev_info = &swap_backing_dev_info,
+	.starvation_barrier = __MUTEX_INITIALIZER(swapper_space.starvation_barrier),
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
Index: linux-2.6.27-rc7-devel/mm/truncate.c
===================================================================
--- linux-2.6.27-rc7-devel.orig/mm/truncate.c	2008-09-22 23:04:31.000000000 +0200
+++ linux-2.6.27-rc7-devel/mm/truncate.c	2008-09-22 23:04:34.000000000 +0200
@@ -392,6 +392,14 @@ int invalidate_inode_pages2_range(struct
 	int ret2 = 0;
 	int did_range_unmap = 0;
 	int wrapped = 0;
+	long pages_to_process;
+
+	/*
+	 * Estimate number of pages to process. If we process more, someone
+	 * is making pages under us.
+	 */
+	pages_to_process = mapping->nrpages;
+	pages_to_process += pages_to_process >> 3;
 
 	pagevec_init(&pvec, 0);
 	next = start;
@@ -399,9 +407,15 @@ int invalidate_inode_pages2_range(struct
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
+			struct page *page;
 			pgoff_t page_index;
 
+			if (pages_to_process >= 0)
+				if (!pages_to_process--)
+					mutex_lock(&mapping->starvation_barrier);
+
+			page = pvec.pages[i];
+
 			lock_page(page);
 			if (page->mapping != mapping) {
 				unlock_page(page);
@@ -449,6 +463,10 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+
+	if (pages_to_process < 0)
+		mutex_unlock(&mapping->starvation_barrier);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);

> ----- Forwarded message from Chris Webb <chris@arachsys.com> -----
> 
> Date: Thu, 11 Sep 2008 10:47:36 +0100
> From: Chris Webb <chris@arachsys.com>
> Subject: Unexpected behaviour with O_DIRECT affecting lvm
> 
> To reproduce:
> 
>   # dd if=/dev/zero of=/dev/scratch/a bs=4M &
>   [1] 2612
>   # lvm lvrename /dev/scratch/b /dev/scratch/c
>   [hangs]
> 
> (Similarly for lvremote, lvcreate, etc., and it doesn't matter whether the
> operation is on the same VG or a different one.)
> 
> Stracing lvm, I saw
> 
>   stat64("/dev/dm-7", {st_mode=S_IFBLK|0600, st_rdev=makedev(251, 7), ...}) = 0
>   open("/dev/dm-7", O_RDWR|O_DIRECT|O_LARGEFILE|O_NOATIME) = 6
>   fstat64(6, {st_mode=S_IFBLK|0600, st_rdev=makedev(251, 7), ...}) = 0
>   ioctl(6, BLKBSZGET, 0x89bbb30)          = 0
>   _llseek(6, 0, [0], SEEK_SET)            = 0
>   read(6,
>   [hangs]
> 
> If I kill the dd at this point, the lvm unblocks and continues as normal:
> 
>   read(6, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
>   close(6)                                = 0
>   stat64("/dev/dm-8", {st_mode=S_IFBLK|0600, st_rdev=makedev(251, 8), ...}) = 0
>   stat64("/dev/dm-8", {st_mode=S_IFBLK|0600, st_rdev=makedev(251, 8), ...}) = 0
>   open("/dev/dm-8", O_RDWR|O_DIRECT|O_LARGEFILE|O_NOATIME) = 6
>   [etc]
> 
> /dev/dm-7 is the dm device corresponding to /dev/disk.1/0.0 which is being
> written to.
> 
> I wrote a tiny test program which does a single O_DIRECT read of 4096 bytes
> from a device, and can confirm that, more generally, an O_DIRECT read from a
> device being continuously written to always hangs indefinitely. This occurs
> even if I ionice -c3 the dd, and ionice -c1 -n0 the O_DIRECT reader...
> 
>   # dd if=/dev/zero of=/dev/disk.1/0.0 bs=4M &
>   [1] 2697
>   # ~/tmp/readtest
>   [hangs]
> 
>   # ionice -c3 dd if=/dev/zero of=/dev/disk.1/0.0 bs=4M &
>   [1] 2734
>   # ionice -c1 -n0 ~/tmp/readtest
>   [hangs]
> 
> There's no problem if the dd is in the other direction, reading continuously
> from the LV, nor if the test read isn't O_DIRECT. Attempting to kill -9 the
> O_DIRECT reader doesn't succeed until after the read() returns.
> 
> Finally, I've tried replacing the LV with a raw disk /dev/sdb, and the same
> behaviour appears there for all choices of IO scheduler for the disk, so
> it's neither device mapper specific nor even IO scheduler specific! This
> means that it isn't in any sense a bug in your code, of course, but given
> that the phenomenon seems to block any LVM management operation when heavy
> writes are going on, surely we can't be the first people to hit this whilst
> using the LVM tool. I'm wondering whether you've had other similar reports
> or have any other suggestions?
> 
> For what it's worth, these tests were initially done on our dev machine
> which is running lvm 2.02.38 and a kernel from the head of Linus' tree
> (usually no more than a couple of days old with a queue of my local patches
> that Ed hasn't integrated into the upstream ata-over-ethernet drivers yet),
> but the same behaviour appears on my totally standard desktop machine with
> much older 2.6.25 and 2.6.24.4 kernels 'as released', so I think it's pretty
> long-standing.
> 
> Best wishes,
> 
> Chris.
> 
> #define _GNU_SOURCE
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> 
> #define BLOCK 4096
> 
> int main(int argc, char **argv) {
>   int fd, n;
>   char *buffer;
> 
>   if (argc != 2) {
>     fprintf(stderr, "Usage: %s FILE\n", argv[0]);
>     return 1;
>   }
> 
>   buffer = valloc(BLOCK);
>   if (!buffer) {
>     perror("valloc");
>     return 1;
>   }
> 
>   fd = open(argv[1], O_RDONLY | O_LARGEFILE | O_DIRECT);
>   if (fd < 0) {
>     perror("open");
>     return 1;
>   }
> 
>   if (pread(fd, buffer, BLOCK, 0) < 0)
>     perror("pread");
> 
>   close(fd);
>   return 0;
> }
> 
> 
