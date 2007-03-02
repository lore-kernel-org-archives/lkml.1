Return-Path: <linux-kernel-owner+w=401wt.eu-S2992560AbXCBP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992560AbXCBP5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992548AbXCBPz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:55:57 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49720 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992550AbXCBPza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:30 -0500
Subject: [PATCH 9/9] mtd: Add swaponflash block driver
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:55:15 +0000
Message-Id: <1172850916.11149.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for allowing an mtd device to be used as a swap block device.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

 drivers/mtd/Kconfig   |    7 
 drivers/mtd/Makefile  |    1 
 drivers/mtd/mtdswap.c | 1187 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1195 insertions(+)

Index: linux/drivers/mtd/mtdswap.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/mtd/mtdswap.c	2007-02-28 18:12:48.000000000 +0000
@@ -0,0 +1,1187 @@
+/*
+ * Swap block device support for MTDs
+ * Turns an MTD device into a swap device with block wear leveling
+ *
+ * Copyright (C) 2007 Nokia Corporation. All rights reserved.
+ *
+ * Author: Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ * Features:
+ *  - The mtd partitions to turn into swap devices are listed in the module
+ *    parameters in the form 'partitions="1,3,5"'.
+ *  - A dummy swap header is added to the start of the device so mkswap isn't
+ *    needed.
+ *  - Since block erase counts are kept approximately equal, there is no need
+ *    to keep track of erase counts over driver restarts.
+ *  - Two threads are used, one for the bio queue, the other to handle garbage
+ *    collection such as erase block leveling, block erasing and
+ *    defragmentation. The bio thread can need to wait on the gc thread for
+ *    free blocks.
+ *  - For wear leveling there are two possible approaches, an in memory buffer
+ *    or keeping at least one erase block reserved. The latter approach is
+ *    taken. The driver becomes faster but less space efficent if given more
+ *    reserved blocks.
+ *  - The driver tracks erase blocks by placing them in one of five trees,
+ *    clean, used, low_frag, high_frag and dirty. A block will move between the
+ *    trees roughly in that order as its used. For convience, each tree is
+ *    sorted by erase count.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/swap.h>
+#include <linux/rbtree.h>
+#include <linux/mm.h>
+#include <linux/genhd.h>
+#include <linux/mutex.h>
+#include <linux/kthread.h>
+#include <linux/crc32.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/blktrans.h>
+
+
+#define MAX_PAGES_PER_EB 64
+/*
+ * The maximum difference in erase counts before we move blocks
+ */
+#define MAX_ERASECOUNT_DIFFERENCE 15
+/*
+ * How many blocks to reserve for garbage collection
+ * Must be >= 1
+ */
+#define NUMBER_SPARE_BLOCKS 1
+/*
+ * When changes are made to the number of active blocks in erase blocks,
+ * how long to wait before triggering garbage collection (in msec).
+ */
+#define GC_THREAD_DELAY 5000
+/*
+ * How many clean blocks should be available aabove which
+ * the garbage collection stops processing blocks.
+ */
+#define CLEAN_BLOCK_THRESHOLD 20
+/*
+ * Double check data from mtd with an extra crc?
+ */
+#define USE_CRC 1
+
+#undef DEBUG
+#ifdef DEBUG
+#define TRACE(fmt,a...) printk(KERN_DEBUG fmt, ##a)
+#else
+#define TRACE(fmt,a...)
+#endif
+
+struct swp_blk {
+	int mapno;
+#ifdef USE_CRC
+	unsigned long crc;
+#endif
+};
+
+struct swp_eblk {
+	struct rb_node rb;
+	struct rb_root *root;
+
+	int erase_count;
+	int bad_count;
+
+	DECLARE_BITMAP(active, MAX_PAGES_PER_EB);
+};
+
+#define EBLKADDR_TO_NUM(swpdev, addr) (addr - &swpdev->eblk_data[0])
+#define ERASE_COUNT_MIN(rbroot) (rb_entry(rb_first(rbroot), struct swp_eblk, rb)->erase_count)
+#define ERASE_COUNT_MAX(rbroot) (rb_entry(rb_last(rbroot), struct swp_eblk, rb)->erase_count)
+
+struct mtdswp_dev {
+	struct mtd_blktrans_dev mbd_dev;
+	struct mtd_info *mtd;
+	int fsdata_pos;
+
+	int pages;
+	struct swp_blk *blk_data;
+	int eblks;
+	struct swp_eblk *eblk_data;
+	int pages_per_blk;
+	int max_erase_count;
+
+        /* spinlock protects the fields in this block */
+	spinlock_t trees_lock;
+	struct rb_root clean;
+	struct rb_root used;
+	struct rb_root low_frag;
+	struct rb_root high_frag;
+	struct rb_root dirty;
+	int clean_count;
+	int used_count;
+	int low_frag_count;
+	int high_frag_count;
+	int dirty_count;
+
+        /* mutex protects the fields in this block */
+	struct mutex write_mutex;
+	int curr_write_pos;
+	struct swp_eblk *curr_write;
+
+	struct page *page;
+	char *page_buf;
+
+	struct task_struct* thread;
+	wait_queue_head_t thread_wq;
+	struct timer_list thread_timer;
+
+	wait_queue_head_t clean_wq;
+};
+
+struct swpdev_oobdata {
+	u16 magic;
+	u16 type;
+} __attribute__((packed));
+
+#define SWPDEV_MAGIC 		0x2095
+#define SWPDEV_TYPE_CLEAN 	0x0001
+#define SWPDEV_TYPE_DIRTY 	0x0002
+#define SWPDEV_OOBSIZE		sizeof(struct swpdev_oobdata)
+#define MAX_ERASE_FAILURES	2
+
+static int mtdswap_write_block(struct mtdswp_dev *swpdev, char *buf, int gc_context);
+
+/* return: 0 - clean, 1 - dirty, 2 - bad */
+static int swpdev_check_markers(struct mtdswp_dev *swpdev, struct swp_eblk *eblk)
+{
+	struct swpdev_oobdata n;
+	unsigned char buf[SWPDEV_OOBSIZE];
+	unsigned char *p;
+	int ret, i, retval = 0;
+	size_t offset;
+	struct mtd_oob_ops ops;
+
+	ops.len = SWPDEV_OOBSIZE;
+	ops.ooblen = SWPDEV_OOBSIZE;
+	ops.oobbuf = buf;
+	ops.ooboffs = swpdev->fsdata_pos;
+	ops.datbuf = NULL;
+	ops.mode = MTD_OOB_PLACE;
+
+	offset = EBLKADDR_TO_NUM(swpdev, eblk) * swpdev->mtd->erasesize;
+
+	/* Check first if the block is bad. */
+	if (swpdev->mtd->block_isbad
+			&& swpdev->mtd->block_isbad(swpdev->mtd, offset)) {
+		printk(KERN_WARNING "swpdev_check_markers(): Bad block at %08x\n", offset);
+		return 2;
+	}
+
+	if (swpdev->fsdata_pos == -1)
+		return 1;
+
+	offset = EBLKADDR_TO_NUM(swpdev, eblk) * swpdev->mtd->erasesize;
+
+	ret = swpdev->mtd->read_oob(swpdev->mtd, offset, &ops);
+
+	if (ret) {
+		printk(KERN_WARNING "swpdev_check_markers(): Read OOB failed %d for block at %08x\n",
+				ret, offset);
+		return ret;
+	}
+	if (ops.retlen < ops.len) {
+		printk(KERN_WARNING "swpdev_check_markers(): Read OOB return short read (%zd bytes not %d) for block at %08x\n",
+				ops.retlen, SWPDEV_OOBSIZE, offset);
+		return -EIO;
+	}
+
+	n.magic = SWPDEV_MAGIC;
+	n.type = SWPDEV_TYPE_CLEAN;
+	p = (unsigned char *) &n;
+	for (i = 0; i < SWPDEV_OOBSIZE; i++)
+		if (buf[i] != p[i])
+			retval = 1;
+
+	return retval;
+}
+
+static int swpdev_write_marker(struct mtdswp_dev *swpdev,
+		struct swp_eblk *eblk, u16 marker)
+{
+	struct swpdev_oobdata n;
+	int ret;
+	int offset;
+	struct mtd_oob_ops ops;
+
+	ops.len = SWPDEV_OOBSIZE;
+	ops.ooblen = SWPDEV_OOBSIZE;
+	ops.oobbuf = (uint8_t *)&n;
+	ops.ooboffs = swpdev->fsdata_pos;
+	ops.datbuf = NULL;
+	ops.mode = MTD_OOB_PLACE;
+
+	if (swpdev->fsdata_pos == -1)
+		return 0;
+
+	n.magic = SWPDEV_MAGIC;
+	n.type = marker;
+
+	offset = EBLKADDR_TO_NUM(swpdev, eblk) * swpdev->mtd->erasesize;
+
+	TRACE("Writing marker for %d\n", offset);
+
+	ret = swpdev->mtd->write_oob(swpdev->mtd, offset , &ops);
+
+	if (ret) {
+		printk(KERN_WARNING "swpdev_write_cleanmarker(): Write failed for block at %08x: error %d\n",
+				offset, ret);
+		return ret;
+	}
+	if (ops.retlen != ops.len) {
+		printk(KERN_WARNING "swpdev_write_cleanmarker(): Short write for block at %08x: %zd not %d\n",
+				offset, ops.retlen, SWPDEV_OOBSIZE);
+		return ret;
+	}
+	return 0;
+}
+
+static int swpdev_write_badblock(struct mtdswp_dev *swpdev, struct swp_eblk *eblk)
+{
+	int ret, offset;
+
+	offset = EBLKADDR_TO_NUM(swpdev, eblk) * swpdev->mtd->erasesize;
+
+	/* if the count is < max, we try to write the counter to
+	   the 2nd page oob area */
+	if( ++eblk->bad_count < MAX_ERASE_FAILURES)
+		return 0;
+
+	/* badblocks not supported */
+	if (!swpdev->mtd->block_markbad)
+		return 1;
+
+	printk(KERN_WARNING "swpdev_write_badblock(): Marking bad block at %08x\n",
+			offset);
+	ret = swpdev->mtd->block_markbad(swpdev->mtd, offset);
+
+	if (ret) {
+		printk(KERN_WARNING "swpdev_write_badblock(): Write failed for block at %08x: error %d\n",
+				offset, ret);
+		return ret;
+	}
+	return 1;
+}
+
+/* Assumes trees_lock held */
+static void counter_decrease(struct mtdswp_dev *swpdev, struct rb_root *root)
+{
+	if (!root)
+		return;
+	if (root == &swpdev->clean)
+		swpdev->clean_count--;
+	else if (root == &swpdev->used)
+		swpdev->used_count--;
+	else if (root == &swpdev->low_frag)
+		swpdev->low_frag_count--;
+	else if (root == &swpdev->high_frag)
+		swpdev->high_frag_count--;
+	else if (root == &swpdev->dirty)
+		swpdev->dirty_count--;
+}
+
+/* Assumes trees_lock held */
+static void counter_increase(struct mtdswp_dev *swpdev, struct rb_root *root)
+{
+	if (root == &swpdev->clean)
+		swpdev->clean_count++;
+	else if (root == &swpdev->used)
+		swpdev->used_count++;
+	else if (root == &swpdev->low_frag)
+		swpdev->low_frag_count++;
+	else if (root == &swpdev->high_frag)
+		swpdev->high_frag_count++;
+	else if (root == &swpdev->dirty)
+		swpdev->dirty_count++;
+}
+
+/* Assumes trees_lock held */
+static void mtdswap_rb_add(struct mtdswp_dev *swpdev, struct swp_eblk *eblk, struct rb_root *root)
+{
+	struct rb_node **p, *parent = NULL;
+
+	counter_decrease(swpdev, eblk->root);
+	if (eblk->root)
+		rb_erase(&eblk->rb, eblk->root);
+
+	p = &root->rb_node;
+	while (*p) {
+		struct swp_eblk *eblk1;
+
+		parent = *p;
+		eblk1 = rb_entry(parent, struct swp_eblk, rb);
+
+		if (eblk->erase_count > eblk1->erase_count)
+			p = &(*p)->rb_right;
+		else
+			p = &(*p)->rb_left;
+	}
+
+	rb_link_node(&eblk->rb, parent, p);
+	rb_insert_color(&eblk->rb, root);
+	eblk->root = root;
+	counter_increase(swpdev, root);
+}
+
+static struct swp_eblk * mtdswap_next_clean(struct mtdswp_dev *swpdev, int gc_context)
+{
+	struct swp_eblk *eblk;
+	unsigned long flags;
+
+	spin_lock_irqsave(&swpdev->trees_lock, flags);
+	/* Is the tree empty and can we sleep? */
+	if ((swpdev->clean.rb_node == NULL) && !gc_context) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+
+		TRACE("Sleeping until a clean block found\n");
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		add_wait_queue(&swpdev->clean_wq, &wait);
+		wake_up(&swpdev->thread_wq);
+		schedule();
+		remove_wait_queue(&swpdev->clean_wq, &wait);
+
+		TRACE("Clean block wake up\n");
+
+		spin_lock_irqsave(&swpdev->trees_lock, flags);
+	}
+
+	/* Is the tree still empty? */
+	if (swpdev->clean.rb_node == NULL) {
+		spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+		return NULL;
+	}
+
+	eblk = rb_entry(rb_first(&swpdev->clean), struct swp_eblk, rb);
+	rb_erase(&eblk->rb, &swpdev->clean);
+	eblk->root = NULL;
+	swpdev->clean_count--;
+	spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+
+	swpdev_write_marker(swpdev, eblk, SWPDEV_TYPE_DIRTY);
+
+	return eblk;
+}
+
+static void wake_swap_thread_delayed(struct mtdswp_dev *swpdev)
+{
+	mod_timer(&swpdev->thread_timer, jiffies + msecs_to_jiffies(GC_THREAD_DELAY));
+}
+
+/*
+ * Place eblk into a tree corresponding to its number of active blocks
+ * it contains:
+ *   100% active -> used tree
+ *   >50% active -> low_frag tree
+ *   <50% active -> high_frag tree
+ *   0% active   -> dirty tree
+ */
+static void mtdswap_store_block(struct mtdswp_dev *swpdev, struct swp_eblk *eblk)
+{
+	int weight = bitmap_weight(eblk->active, MAX_PAGES_PER_EB);
+	int maxweight = swpdev->pages_per_blk;
+	unsigned long flags;
+
+	if (eblk == swpdev->curr_write)
+		return;
+
+	spin_lock_irqsave(&swpdev->trees_lock, flags);
+	if (weight == maxweight) {
+		TRACE("Placing block in used tree\n");
+		if (eblk->root != &swpdev->used)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->used);
+	} else if (weight == 0) {
+		TRACE("Placing block in dirty tree\n");
+		if (eblk->root != &swpdev->dirty)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->dirty);
+	} else if (weight > (maxweight/2)) {
+		TRACE("Placing block in low frag tree\n");
+		if (eblk->root != &swpdev->low_frag)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->low_frag);
+	} else {
+		TRACE("Placing block in high frag tree\n");
+		if (eblk->root != &swpdev->high_frag)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->high_frag);
+	}
+	spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+	wake_swap_thread_delayed(swpdev);
+}
+
+static void erase_callback(struct erase_info *done)
+{
+	wait_queue_head_t *wait_q = (wait_queue_head_t *)done->priv;
+	wake_up(wait_q);
+}
+
+static int erase_block(struct mtdswp_dev *swpdev, struct swp_eblk *eblk)
+{
+	struct mtd_info *mtd = swpdev->mtd;
+	struct erase_info erase;
+	DECLARE_WAITQUEUE(wait, current);
+	wait_queue_head_t wait_q;
+	int ret;
+
+	eblk->erase_count++;
+	if (eblk->erase_count > swpdev->max_erase_count)
+		swpdev->max_erase_count = eblk->erase_count;
+
+	init_waitqueue_head(&wait_q);
+	erase.mtd = mtd;
+	erase.callback = erase_callback;
+	erase.addr = EBLKADDR_TO_NUM(swpdev, eblk) * mtd->erasesize;
+	erase.len = mtd->erasesize;
+	erase.priv = (u_long)&wait_q;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&wait_q, &wait);
+
+	ret = mtd->erase(mtd, &erase);
+	if (ret) {
+		set_current_state(TASK_RUNNING);
+		remove_wait_queue(&wait_q, &wait);
+		printk (KERN_WARNING "mtdswap: erase of region [0x%x, 0x%x] "
+				     "on \"%s\" failed\n",
+			erase.addr, erase.len, mtd->name);
+		if (!swpdev_write_badblock(swpdev, eblk))
+			return -EAGAIN;
+		return ret;
+	}
+
+	schedule();  /* Wait for erase to finish. */
+	remove_wait_queue(&wait_q, &wait);
+
+	swpdev_write_marker(swpdev, eblk, SWPDEV_TYPE_CLEAN);
+
+	return 0;
+}
+
+
+static int move_block(struct mtdswp_dev *swpdev, unsigned long block)
+{
+	struct mtd_info *mtd = swpdev->mtd;
+	unsigned long realblock;
+	int newblock;
+	size_t retlen;
+	int ret;
+
+	realblock = swpdev->blk_data[block].mapno;
+
+	ret = mtd->read(mtd, realblock << PAGE_SHIFT, PAGE_SIZE, &retlen, swpdev->page_buf);
+	if (ret < 0) {
+		printk(KERN_ERR "Read Error: %d (block %ld)\n", ret, block);
+		return ret;
+	}
+	if (retlen != PAGE_SIZE) {
+		printk(KERN_ERR "Short read: %d\n", retlen);
+		return -EAGAIN;
+	}
+
+	newblock = mtdswap_write_block(swpdev, swpdev->page_buf, 1);
+	if (newblock < 0) {
+		printk(KERN_ERR "Write error: %d\n", newblock);
+		return newblock;
+	}
+
+	TRACE("Moving block %ld (from %d to %d)\n", block, realblock, newblock);
+
+	swpdev->blk_data[block].mapno = newblock;
+
+	return 0;
+}
+
+static int empty_block(struct mtdswp_dev *swpdev, struct swp_eblk *eblk)
+{
+	int i, active;
+
+	active = bitmap_weight(eblk->active, MAX_PAGES_PER_EB);
+
+	TRACE("moving %d entires for block %d\n", active, EBLKADDR_TO_NUM(swpdev, eblk));
+	for (i = 0; i < active; i++) {
+		int ret, j, bnum, offset;
+
+		offset = find_first_bit(eblk->active, MAX_PAGES_PER_EB);
+		bnum = (EBLKADDR_TO_NUM(swpdev, eblk) * swpdev->pages_per_blk) + offset;
+
+		for (j = 0; j < swpdev->pages; j++)
+			if (swpdev->blk_data[j].mapno == bnum)
+				break;
+
+		if (j == swpdev->pages) {
+			/* block must have been unused since we made the active count */
+			TRACE("mapping for this block not found\n");
+			clear_bit(offset, eblk->active);
+			continue;
+		}
+
+		ret = move_block(swpdev, j);
+		if (ret < 0)
+			return ret;
+		else
+			clear_bit(offset, eblk->active);
+	}
+	return 0;
+}
+
+static void swpdev_timer_wakeup(unsigned long data)
+{
+	struct mtdswp_dev *swpdev = (struct mtdswp_dev *) data;
+	wake_up(&swpdev->thread_wq);
+}
+
+static int mtdswap_thread(void *arg)
+{
+	struct mtdswp_dev *swpdev = arg;
+
+	/* we're involved when memory gets low, so use PF_MEMALLOC */
+	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+
+	/* This isn't done by default since some kernel threads actually want
+           to deal with signals. We can't just call exit_sighand() since
+           that'll cause an oops when we finally do exit. */
+	spin_lock_irq(&current->sighand->siglock);
+	sigfillset(&current->blocked);
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	set_user_nice(current, -5);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!kthread_should_stop()) {
+		int ret = 0, empty = 0;
+		struct swp_eblk *eblk = NULL;
+		DECLARE_WAITQUEUE(wait, current);
+		unsigned long flags;
+
+		TRACE("Thread looping\n");
+
+		spin_lock_irqsave(&swpdev->trees_lock, flags);
+		if (swpdev->clean_count > CLEAN_BLOCK_THRESHOLD) {
+			/* We have enough clean blocks */
+		} else if (swpdev->dirty.rb_node != NULL) {
+			eblk = rb_entry(rb_first(&swpdev->dirty), struct swp_eblk, rb);
+			rb_erase(&eblk->rb, &swpdev->dirty);
+			eblk->root = NULL;
+			swpdev->dirty_count--;
+		} else if ((swpdev->used.rb_node != NULL) &&
+				((ERASE_COUNT_MIN(&swpdev->used) + MAX_ERASECOUNT_DIFFERENCE)
+				< swpdev->max_erase_count)) {
+			eblk = rb_entry(rb_first(&swpdev->used), struct swp_eblk, rb);
+			rb_erase(&eblk->rb, &swpdev->used);
+			eblk->root = NULL;
+			swpdev->used_count--;
+			empty = 1;
+		} else if (swpdev->high_frag.rb_node != NULL) {
+			eblk = rb_entry(rb_first(&swpdev->high_frag), struct swp_eblk, rb);
+			rb_erase(&eblk->rb, &swpdev->high_frag);
+			eblk->root = NULL;
+			swpdev->high_frag_count--;
+			empty = 1;
+		} else if ((swpdev->low_frag.rb_node != NULL) && ((swpdev->clean_count < 5) ||
+				((ERASE_COUNT_MIN(&swpdev->low_frag) + MAX_ERASECOUNT_DIFFERENCE)
+				< swpdev->max_erase_count))) {
+			eblk = rb_entry(rb_first(&swpdev->low_frag), struct swp_eblk, rb);
+			rb_erase(&eblk->rb, &swpdev->low_frag);
+			eblk->root = NULL;
+			swpdev->low_frag_count--;
+			empty = 1;
+		}
+		spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+
+		if (empty)
+			ret = empty_block(swpdev, eblk);
+
+		if (ret < 0) {
+			printk(KERN_ERR "empty block returned error: %d, aborting.\n", ret);
+			mtdswap_store_block(swpdev, eblk);
+			eblk = NULL;
+		}
+
+		if (!eblk) {
+			TRACE("Thread waiting\n");
+			add_wait_queue(&swpdev->thread_wq, &wait);
+			wake_up(&swpdev->clean_wq);
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+			remove_wait_queue(&swpdev->thread_wq, &wait);
+			continue;
+		}
+
+		TRACE("Erasing block %d (active = %d)\n",
+				EBLKADDR_TO_NUM(swpdev, eblk),
+				bitmap_weight(eblk->active, MAX_PAGES_PER_EB));
+
+		BUG_ON(bitmap_weight(eblk->active, MAX_PAGES_PER_EB) != 0);
+
+		ret = erase_block(swpdev, eblk);
+
+		spin_lock_irqsave(&swpdev->trees_lock, flags);
+		if (ret == -EAGAIN)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->dirty);
+		else if (ret >= 0)
+			mtdswap_rb_add(swpdev, eblk, &swpdev->clean);
+		spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+	}
+
+	set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+/*
+ * gc_context parameter tells us whether we're garbage collecting or responding
+ * to a swap read/write request. gc_context must have priority over swap
+ * requests as swap requests can wait on gc for free space but gc_context needs
+ * to use its reserved eraseblock(s).
+ */
+static int mtdswap_get_clean(struct mtdswp_dev *swpdev, int gc_context)
+{
+	int blockaddr;
+
+	/* Protect the last remaining block for gc only */
+	if ((swpdev->clean_count == 0) && !gc_context) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		TRACE("Get clean sleeping until more blocks free\n");
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		add_wait_queue(&swpdev->clean_wq, &wait);
+		wake_up(&swpdev->thread_wq);
+		schedule();
+		remove_wait_queue(&swpdev->clean_wq, &wait);
+
+		TRACE("get clean wake up\n");
+
+		if (swpdev->clean_count == 0) {
+			printk(KERN_ERR "too few free blocks!\n");
+			return -ENOSPC;
+		}
+
+	}
+
+	mutex_lock(&swpdev->write_mutex);
+
+	if ((swpdev->curr_write_pos == swpdev->pages_per_blk)
+			|| !swpdev->curr_write) {
+		struct swp_eblk *oldeblk = swpdev->curr_write;
+
+		swpdev->curr_write_pos = 0;
+		swpdev->curr_write = mtdswap_next_clean(swpdev, gc_context);
+
+		if (oldeblk)
+			mtdswap_store_block(swpdev, oldeblk);
+	}
+
+	if (swpdev->curr_write == NULL) {
+		mutex_unlock(&swpdev->write_mutex);
+		printk(KERN_ERR "No space!\n");
+		return -ENOSPC;
+	}
+
+	blockaddr = ((EBLKADDR_TO_NUM(swpdev, swpdev->curr_write)
+			* swpdev->pages_per_blk)
+			+ swpdev->curr_write_pos);
+
+	TRACE("Providing block %d (offset %d)\n", blockaddr, swpdev->curr_write_pos);
+
+	set_bit(swpdev->curr_write_pos, swpdev->curr_write->active);
+	swpdev->curr_write_pos++;
+
+	mutex_unlock(&swpdev->write_mutex);
+
+	return blockaddr;
+}
+
+static int mtdswap_mark_inactive(struct mtdswp_dev *swpdev, unsigned long blocknum)
+{
+	unsigned long offset = blocknum % swpdev->pages_per_blk;
+	struct swp_eblk *eblk = &swpdev->eblk_data[blocknum / swpdev->pages_per_blk];
+	int ret;
+
+	TRACE("Marking %ld as unused\n", blocknum);
+
+	ret = !test_and_clear_bit(offset, eblk->active);
+	if (ret)
+		TRACE("Marking block unused but hasn't been written to!\n", blocknum);
+
+	mtdswap_store_block(swpdev, eblk);
+
+	return ret;
+}
+
+static int mtdswap_write_block(struct mtdswp_dev *swpdev, char *buf, int gc_context)
+{
+	struct mtd_info *mtd = swpdev->mtd;
+	int blockaddr;
+	size_t retlen;
+	int ret;
+
+	blockaddr = mtdswap_get_clean(swpdev, gc_context);
+	if (blockaddr < 0)
+		return blockaddr;
+
+	ret =  mtd->write(mtd, blockaddr << PAGE_SHIFT, PAGE_SIZE, &retlen, buf);
+
+	if (retlen != PAGE_SIZE) {
+		mtdswap_mark_inactive(swpdev, blockaddr);
+		printk(KERN_ERR "Short write to MTD device: %d written\n",
+				retlen);
+		return -EAGAIN;
+	}
+
+	if (ret < 0) {
+		mtdswap_mark_inactive(swpdev, blockaddr);
+		printk(KERN_ERR "Write to MTD device failed: %d (%d written)\n",
+				ret, retlen);
+		return ret;
+	}
+
+	return blockaddr;
+}
+
+
+static int mtdswap_writesect(struct mtd_blktrans_dev *dev,
+			      unsigned long block, char *buf)
+{
+	struct mtdswp_dev *swpdev = container_of(dev, struct mtdswp_dev, mbd_dev);
+	int mtdblock;
+
+	/* Ignore writes to the header page */
+	if (unlikely(block == 0))
+		return 0;
+
+	block--;
+
+	if (swpdev->blk_data[block].mapno != -1) {
+		mtdswap_mark_inactive(swpdev, swpdev->blk_data[block].mapno);
+		swpdev->blk_data[block].mapno = -1;
+	}
+
+	mtdblock = mtdswap_write_block(swpdev, buf, 0);
+
+	if (mtdblock < 0)
+		return mtdblock;
+
+	TRACE("Mapping block %ld to %d\n", block, mtdblock);
+
+	swpdev->blk_data[block].mapno = mtdblock;
+#ifdef USE_CRC
+	swpdev->blk_data[block].crc = crc32(~0, buf, PAGE_SIZE);
+#endif
+	return 0;
+}
+
+/* Provide a dummy swap header for the kernel */
+static int read_swap_header(struct mtdswp_dev *swpdev, char *buf)
+{
+	union swap_header *header = (union swap_header *)(buf);
+
+	memset(buf, 0, PAGE_SIZE - 10);
+
+	header->info.version = 1;
+	header->info.last_page = (swpdev->mtd->size -
+		(swpdev->mtd->erasesize * NUMBER_SPARE_BLOCKS)) >> PAGE_SHIFT;
+	header->info.nr_badpages = 0;
+	header->info.flags = SWAPFLAG_UNUSED_IOCTL;
+
+	memcpy(buf + PAGE_SIZE - 10, "SWAPSPACE2", 10);
+
+	return 0;
+}
+
+static int mtdswap_readsect(struct mtd_blktrans_dev *dev,
+			      unsigned long block, char *buf)
+{
+	struct mtdswp_dev *swpdev = container_of(dev, struct mtdswp_dev, mbd_dev);
+	struct mtd_info *mtd = swpdev->mtd;
+	unsigned long realblock, offset;
+	struct swp_eblk *eblk;
+	size_t retlen;
+	int ret;
+
+	if (unlikely(block == 0))
+		return read_swap_header(swpdev, buf);
+
+	block--;
+	realblock = swpdev->blk_data[block].mapno;
+	eblk = &swpdev->eblk_data[realblock / swpdev->pages_per_blk];
+	offset = realblock % swpdev->pages_per_blk;
+
+	if (!test_bit(offset, eblk->active)) {
+		printk(KERN_ERR "Page %ld (block %ld) accessed but not written to!\n",
+			block, realblock);
+		return -EIO;
+	}
+
+	ret = mtd->read(mtd, realblock << PAGE_SHIFT, PAGE_SIZE, &retlen, buf);
+
+	TRACE("Reading block %ld (%ld)\n", block, realblock);
+
+	if (ret < 0) {
+		printk(KERN_ERR "Read error %d\n", ret);
+		return ret;
+	}
+
+	if (retlen != PAGE_SIZE) {
+		printk(KERN_ERR "Short read %d\n", retlen);
+		return -EAGAIN;
+	}
+
+#ifdef USE_CRC
+	if (crc32(~0, buf, PAGE_SIZE) != swpdev->blk_data[block].crc) {
+		printk(KERN_ERR "CRC mismatch for block %ld\n", block);
+		return -EIO;
+	}
+#endif
+
+	return ret;
+}
+
+static int mtdswap_ioctl(struct mtd_blktrans_dev *dev, unsigned int cmd,
+				unsigned long arg)
+{
+	struct mtdswp_dev *swpdev = container_of(dev, struct mtdswp_dev, mbd_dev);
+
+	switch (cmd) {
+	case BLKSWAPMARKUNUSED:
+                {
+		unsigned long eblknum, offset,realblock, page = arg - 1;
+		struct swp_eblk *eblk;
+
+		realblock = swpdev->blk_data[page].mapno;
+
+		if (realblock == -1) {
+			TRACE("Marking %ld (block %ld) unused but hasn't been written to!\n",
+					page, realblock);
+			return 0;
+		}
+
+		offset = realblock % swpdev->pages_per_blk;
+		eblknum = realblock / swpdev->pages_per_blk;
+		eblk = &swpdev->eblk_data[eblknum];
+
+		TRACE("Marking %ld as unused\n", page);
+
+		if (page > swpdev->pages) {
+			printk(KERN_ERR "Page outside of page range accessed (%ld, %d)\n",
+					page, swpdev->pages);
+			return 0;
+		}
+
+		if (!test_and_clear_bit(offset, eblk->active))
+			TRACE("Marking %ld (block %ld) unused but hasn't been written to!\n",
+					page, realblock);
+
+		mtdswap_store_block(swpdev, eblk);
+		swpdev->blk_data[page].mapno = -1;
+
+		return 0;
+		}
+	default:
+		return -ENOTTY;
+	}
+}
+
+static ssize_t mtdswap_show_stats_item(char *name, int count,
+		struct rb_root *root, char *buf, int buflen)
+{
+	int min = -1, max = -1;
+
+	if (root->rb_node != NULL) {
+		min = rb_entry(rb_first(root), struct swp_eblk, rb)->erase_count;
+		max = rb_entry(rb_last(root), struct swp_eblk, rb)->erase_count;
+	}
+
+	return snprintf(buf, buflen, "%s: %d (%d,%d) ", name, count, min, max);
+}
+
+static ssize_t mtdswap_show_stats(struct gendisk *disk, char *page)
+{
+	struct mtd_blktrans_dev *blkdev = disk->private_data;
+	struct mtdswp_dev *swpdev = container_of(blkdev, struct mtdswp_dev, mbd_dev);
+	ssize_t len = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&swpdev->trees_lock, flags);
+	len += mtdswap_show_stats_item("clean", swpdev->clean_count,
+			&swpdev->clean, page, PAGE_SIZE);
+	len += mtdswap_show_stats_item("used", swpdev->used_count,
+			&swpdev->used, page+len, PAGE_SIZE-len);
+	len += mtdswap_show_stats_item("low", swpdev->low_frag_count,
+			&swpdev->low_frag, page+len, PAGE_SIZE-len);
+	len += mtdswap_show_stats_item("high", swpdev->high_frag_count,
+			&swpdev->high_frag, page+len, PAGE_SIZE-len);
+	len += mtdswap_show_stats_item("dirty", swpdev->dirty_count,
+			&swpdev->dirty, page+len, PAGE_SIZE-len);
+	spin_unlock_irqrestore(&swpdev->trees_lock, flags);
+
+	len += snprintf(page+len, PAGE_SIZE-len, "\n");
+	return len;
+}
+
+static struct disk_attribute disk_attr_stats = {
+	.attr = {.name = "stat-mtdswap", .mode = S_IRUGO },
+	.show = mtdswap_show_stats
+};
+
+static int mtdswap_add_sysfs(struct mtd_blktrans_dev *blkdev)
+{
+	struct gendisk *gd = get_mtd_blktrans_gendisk(blkdev);
+
+	return sysfs_create_file(&gd->kobj, &disk_attr_stats.attr);
+}
+
+static void mtdswap_rm_sysfs(struct mtd_blktrans_dev *blkdev)
+{
+	struct gendisk *gd = get_mtd_blktrans_gendisk(blkdev);
+
+	sysfs_remove_link(&gd->kobj, "stat-mtdswap");
+}
+
+static int mtdswap_open(struct mtd_blktrans_dev *mbd)
+{
+	return 0;
+}
+
+static int mtdswap_release(struct mtd_blktrans_dev *mbd)
+{
+	return 0;
+}
+
+static int mtdswap_init(struct mtdswp_dev *swpdev)
+{
+	struct nand_ecclayout *oinfo;
+	struct mtd_info *mtd = swpdev->mbd_dev.mtd;
+	int i, ret = -ENOMEM;
+
+	swpdev->mtd = mtd;
+	swpdev->pages = mtd->size >> PAGE_SHIFT;
+	swpdev->eblks = mtd->size >> (ffs(mtd->erasesize) - 1);
+	swpdev->pages_per_blk = swpdev->pages / swpdev->eblks;
+
+	spin_lock_init(&swpdev->trees_lock);
+	mutex_init(&swpdev->write_mutex);
+	swpdev->clean = swpdev->used = swpdev->low_frag = RB_ROOT;
+	swpdev->high_frag = swpdev->dirty = RB_ROOT;
+
+	init_waitqueue_head(&swpdev->thread_wq);
+	init_waitqueue_head(&swpdev->clean_wq);
+	init_timer(&swpdev->thread_timer);
+	swpdev->thread_timer.function = swpdev_timer_wakeup;
+	swpdev->thread_timer.data = (unsigned long) swpdev;
+
+	if (swpdev->pages_per_blk > MAX_PAGES_PER_EB) {
+		printk(KERN_ERR "Error: Maximum of %d pages per eraseblock exceeded.\n",
+				MAX_PAGES_PER_EB);
+		ret = -EINVAL;
+		goto blk_fail;
+	}
+	if (mtd->writesize > PAGE_SIZE) {
+		printk(KERN_ERR "Error: mtd->writesize (%d) > PAGE_SIZE (%ld) unsupported\n",
+				mtd->writesize, PAGE_SIZE);
+		ret = -EINVAL;
+		goto blk_fail;
+	}
+
+	oinfo = swpdev->mtd->ecclayout;
+	if (!swpdev->mtd->oobsize || !oinfo
+			|| (oinfo->oobfree[0].length < SWPDEV_OOBSIZE))
+		swpdev->fsdata_pos = -1;
+	else
+		swpdev->fsdata_pos = oinfo->oobfree[0].offset;
+
+	swpdev->blk_data = vmalloc(sizeof(struct swp_blk) * swpdev->pages);
+	if (!swpdev->blk_data)
+		goto blk_fail;
+
+	swpdev->eblk_data = kzalloc(sizeof(struct swp_eblk) * swpdev->eblks, GFP_KERNEL);
+	if (!swpdev->eblk_data)
+		goto eblk_fail;
+
+	for (i = 0; i < swpdev->pages; i++)
+		swpdev->blk_data[i].mapno = -1;
+
+	for (i = 0; i < swpdev->eblks; i++) {
+		int status = swpdev_check_markers(swpdev, &swpdev->eblk_data[i]);
+
+		if (status == 2 || status < 0)
+			continue;
+		if (status == 0) {
+			mtdswap_rb_add(swpdev, &swpdev->eblk_data[i], &swpdev->clean);
+			swpdev->eblk_data[i].root = &swpdev->clean;
+		} else {
+			mtdswap_rb_add(swpdev, &swpdev->eblk_data[i], &swpdev->dirty);
+			swpdev->eblk_data[i].root = &swpdev->dirty;
+		}
+	}
+
+	swpdev->page = alloc_page(GFP_KERNEL);
+	if (!swpdev->page)
+		goto page_fail;
+
+	swpdev->page_buf = page_address(swpdev->page);
+
+	ret = mtdswap_add_sysfs(&swpdev->mbd_dev);
+	if (ret < 0)
+		goto sysfs_fail;
+
+	swpdev->thread = kthread_run(mtdswap_thread, swpdev, "mtdswapd_%d", swpdev->mtd->index);
+	if (IS_ERR(swpdev->thread)) {
+		ret = PTR_ERR(swpdev->thread);
+		goto thread_fail;
+	}
+
+	return 0;
+
+thread_fail:
+	mtdswap_rm_sysfs(&swpdev->mbd_dev);
+sysfs_fail:
+	__free_page(swpdev->page);
+page_fail:
+	kfree(swpdev->eblk_data);
+eblk_fail:
+	vfree(swpdev->blk_data);
+blk_fail:
+	kfree(swpdev);
+	printk(KERN_ERR "mtdswap init failed (%d)\n", ret);
+	return ret;
+}
+
+static void mtdswap_cleanup(struct mtdswp_dev *swpdev)
+{
+   	TRACE("mtdswap_release\n");
+
+	mtdswap_rm_sysfs(&swpdev->mbd_dev);
+
+	/* Clean up the kernel thread */
+	del_timer_sync(&swpdev->thread_timer);
+	kthread_stop(swpdev->thread);
+
+	kfree(swpdev->eblk_data);
+	vfree(swpdev->blk_data);
+	__free_page(swpdev->page);
+}
+
+static int mtdswap_flush(struct mtd_blktrans_dev *dev)
+{
+	struct mtdswp_dev *swpdev = container_of(dev, struct mtdswp_dev, mbd_dev);
+
+	if (swpdev->mtd->sync)
+		swpdev->mtd->sync(swpdev->mtd);
+	return 0;
+}
+
+static char partitions[128] = "";
+module_param_string(partitions, partitions, sizeof(partitions), 0);
+MODULE_PARM_DESC(partitions, "MTD partitions numbers to use as swap: partitions=\"1,3,5\"");
+
+static void mtdswap_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
+{
+	struct mtdswp_dev *dev;
+	struct mtd_blktrans_dev *mbd_dev;
+	char *parts = &partitions[0];
+	char *this_opt;
+	char *opt_end;
+	int part = -1;
+
+	if (!parts || !*parts)
+		return;
+
+	while ((this_opt = strsep(&parts, ",")) != NULL) {
+		part = simple_strtoul(this_opt, &opt_end, 0);
+		if (this_opt == opt_end)
+			continue;
+		if (mtd->index == part)
+			break;
+	}
+
+	if ((part == -1) || (mtd->index != part) || (this_opt == opt_end))
+		return;
+
+	printk(KERN_INFO "Enabling MTD swap on device %d\n", part);
+
+	dev = kzalloc(sizeof(struct mtdswp_dev), GFP_KERNEL);
+	if (!dev)
+		return;
+
+	mbd_dev = &dev->mbd_dev;
+	mbd_dev->mtd = mtd;
+	mbd_dev->devnum = mtd->index;
+	mbd_dev->size = ((mtd->size - (mtd->erasesize * NUMBER_SPARE_BLOCKS))
+			>> PAGE_SHIFT) + 1;
+	mbd_dev->tr = tr;
+
+	if (!(mtd->flags & MTD_WRITEABLE))
+		mbd_dev->readonly = 1;
+
+	if (add_mtd_blktrans_dev(mbd_dev) < 0)
+		return;
+	mtdswap_init(dev);
+}
+
+static void mtdswap_remove_dev(struct mtd_blktrans_dev *dev)
+{
+	struct mtdswp_dev *swpdev = container_of(dev, struct mtdswp_dev, mbd_dev);
+
+	mtdswap_cleanup(swpdev);
+	del_mtd_blktrans_dev(dev);
+	kfree(swpdev);
+}
+
+static struct mtd_blktrans_ops mtdswap_ops = {
+	.name		= "mtdswap",
+	.major		= 0,
+	.part_bits	= 0,
+	.blksize 	= PAGE_SIZE,
+	.open		= mtdswap_open,
+	.flush		= mtdswap_flush,
+	.release	= mtdswap_release,
+	.readsect	= mtdswap_readsect,
+	.writesect	= mtdswap_writesect,
+	.ioctl		= mtdswap_ioctl,
+	.add_mtd	= mtdswap_add_mtd,
+	.remove_dev	= mtdswap_remove_dev,
+	.owner		= THIS_MODULE,
+};
+
+static int __init mtdswap_modinit(void)
+{
+	return register_mtd_blktrans(&mtdswap_ops);
+}
+
+static void __exit mtdswap_modexit(void)
+{
+	deregister_mtd_blktrans(&mtdswap_ops);
+}
+
+module_init(mtdswap_modinit);
+module_exit(mtdswap_modexit);
+
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Richard Purdie <richard@openedhand.com>");
+MODULE_DESCRIPTION("Block device access to an MTD suitable for using as swap space");
Index: linux/drivers/mtd/Kconfig
===================================================================
--- linux.orig/drivers/mtd/Kconfig	2007-02-28 18:12:16.000000000 +0000
+++ linux/drivers/mtd/Kconfig	2007-02-28 18:12:48.000000000 +0000
@@ -282,6 +282,13 @@ config SSFDC
 	  This enables read only access to SmartMedia formatted NAND
 	  flash. You can mount it with FAT file system.
 
+config MTD_SWAP
+        tristate "Swap on MTD device support"
+	depends on MTD && SWAP
+	select MTD_BLKDEVS
+	---help---
+	  This provides support for swap space on an mtd device.
+
 source "drivers/mtd/chips/Kconfig"
 
 source "drivers/mtd/maps/Kconfig"
Index: linux/drivers/mtd/Makefile
===================================================================
--- linux.orig/drivers/mtd/Makefile	2007-02-28 18:12:16.000000000 +0000
+++ linux/drivers/mtd/Makefile	2007-02-28 18:12:48.000000000 +0000
@@ -23,6 +23,7 @@ obj-$(CONFIG_NFTL)		+= nftl.o
 obj-$(CONFIG_INFTL)		+= inftl.o
 obj-$(CONFIG_RFD_FTL)		+= rfd_ftl.o
 obj-$(CONFIG_SSFDC)		+= ssfdc.o
+obj-$(CONFIG_MTD_SWAP)		+= mtdswap.o
 
 nftl-objs		:= nftlcore.o nftlmount.o
 inftl-objs		:= inftlcore.o inftlmount.o


