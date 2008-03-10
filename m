Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYCJGqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYCJGqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYCJGqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:46:24 -0400
Received: from phunq.net ([64.81.85.152]:46461 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbYCJGqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:46:20 -0400
From: Daniel Phillips <phillips@phunq.net>
Subject: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 9 Mar 2008 22:46:16 -0800
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803092346.17556.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every little factor of 25 performance increase really helps.

Ramback is a new virtual device with the ability to back a ramdisk
by a real disk, obtaining the performance level of a ramdisk but with
the data durability of a hard disk.  To work this magic, ramback needs
a little help from a UPS.  In a typical test, ramback reduced a 25
second file operation[1] to under one second including sync.  Even
greater gains are possible for seek-intensive applications.

The difference between ramback and an ordinary ramdisk is: when the 
machine powers down the data does not vanish because it is continuously 
saved to backing store.  When line power returns, the backing store
repopulates the ramdisk while allowing application io to proceed 
concurrently.  Once fully populated, a little green light winks on and 
file operations once again run at ramdisk speed.

So now you can ask some hard questions: what if the power goes out 
completely or the host crashes or something else goes wrong while 
critical data is still in the ramdisk?  Easy: use reliable components.  
Don't crash.  Measure your UPS window.  This is not much to ask in 
order to transform your mild mannered hard disk into a raging superdisk 
able to leap tall benchmarks at a single bound.

If line power goes out while ramback is running, the UPS kicks in and a 
power management script switches the driver from writeback to 
writethrough mode.  Ramback proceeds to save all remaining dirty data 
while forcing each new application write through to backing store 
immediately.

If UPS power runs out while ramback still holds unflushed dirty data 
then things get ugly.  Hopefully a fsck -f will be able to pull 
something useful out of the mess.  (This is where you might want to be 
running Ext3.)  The name of the game is to install sufficient UPS power 
to get your dirty ramdisk data onto stable storage this time, every 
time.

The basic design premise of ramback is alluringly simple: each write to 
a ramdisk sets a per-chunk dirty bit.  A kernel daemon continuously 
scans for and flushes dirty chunks to backing store.  It sounds easy, 
but in practice a number of additional requirements increase the design 
complexity considerably:

 * Previously saved data must be reloaded into the ramdisk on startup.

 * Applications need to be able to read and write ramback data during
   initial loading.

 * If line power is restored before the battery runs out then ramdisk
   level performance should resume immediately.

 * Applications data should continue to be available and writable even
   during emergency data flushing.

 * Racy application writes should not be able to cause the contents of
   backing store to diverge from the contents of the ramdisk.

 * If UPS power is limited then maximum dirty data must be limited as 
   well, so that power does not run out while dirty data remains.

 * Cannot transfer directly between ramdisk and backing store, so must 
   first transfer into memory then relaunch to destination.

 * Cannot submit a transfer directly from completion interrupt, so a 
   helper daemon is needed.

 * Per chunk locking is not feasible for a terabyte scale ramdisk.

In addition, there are two nasty races to consider:

 1) Populate race
    A chunk dirtied by an application write may be overwritten by a 
    chunk simultaneously read from backing store during initial populate

 2) Flush race
    A dirty chunk flush must not overwrite an application write.  Even 
    though applications IO always goes to the ramdisk, in flush mode the
    resulting writethrough transfer may overtake a previously launched 
    dirty chunk flush and stale data will land in backing store.  Also,
    so that the backing store always has exactly the contents of the
    ramdisk for each completed write, we would like to preserve
    application write order for overlapping writes, even though this can
    only happen with a racy application.

To give some sense of the resulting complexity, here is the algorithm I 
implemented to close the writethrough race:

   Write algorithm when in writethrough mode

   Kick writethrough:
      If writethrough queue empty, done
      If head of writethrough queue does not overlap any member of
      storing list
         Remove head from writethrough queue, add to storing list
         and submit
      (else it will be submitted when save completes)

   On application write in writethrough mode: (after populating)
      Mark region clean
      Add to tail of writethrough queue
      Kick writethrough

   On save complete:
      Remove from storing list
      Kick writethrough

   On writethrough complete:
      Remove from storing list
      Kick writethrough
      Endio on original write

   On daemon finding a dirty chunk:
      Mark chunk clean and add to storing list
      submit it

For the most part, ramback just solves a classic cache consistency
problem.  As such, some of the techniques will be familiar to vm
hackers, such as clearing the chunk dirty bit immediately on placing
dirty data under writeout, and keeping track of inflight dirty data
separately.  There are significant differences as well, but this post
is already long so I will save these details for later.

What Works Now:

  * Ramdisk populates from backing store when created.
  * Application io allowed during initial populating.
  * Application io allowed during flush on line power loss.
  * Populate vs application write race closed in theory.
  * Flush vs application writethrough race closed in theory.
  * Writethrough mode on line power loss apparently working.
  * Proc interface controls writeback vs writethrough mode.
  * Proc interface displays useful status.

Corners Cut in the Interest of Releasing Early:

  * Simple linear bitmap scan costs too much cpu.
  * Linear algorithms for list searching will not scale.
  * Could use atomic ops instead of spinlocks in places.
  * Should load and save range instead of single chunks.
  * Serializing all writes in writethrough mode is overkill.
  * Introduce populate vs application write balancing.
  * Introduce flush vs application writethrough balancing.
  * Handle chunk size other than PAGE_SIZE.
  * Handle noninteger number of chunks.
  * Too much cut and paste bio code.

Bugs:

  * Oops on dmsetup remove.
  * Buggy spinlocks, so no smp for now.
  * Block layer anti deadlock measures needed.
  * Writeback transfers sometimes starve application writes.
  * Backing disk is sometimes idle while populating.
  * Ramdisk chunks sometimes stay dirty forever.
  * Undoubtedly more under the rug...

Plea for help:

This driver is ready to try for a sufficiently brave developer.  It will 
deadlock and livelock in various ways and you will have to reboot to 
remove it.  But it can already be coaxed into running well enough for 
benchmarks, and when it solidifies it will be pretty darn amazing.  
Note that massive amounts of tracing output can be enabled or disabled, 
very handy for finding out how it tied itself in a knot.

  * If you would like to carve your name in this driver, please send me
    a bug fix.

  * If you would like to carve your name in the man page, please send an
    oops or SysRq backtrace to lkml so somebody can send me a bug fix.

  * Please send beer for no reason at all.

Many thanks to Violin Memory[2] who inspired and supported the ramback 
effort.  Can you guess why they are interested in stable backing store
for large ramdisks?

[1] Untar a 2.2 kernel on a laptop

[2] http://www.violin-memory.com

User Documentation
------------------

Create a ramback with chunksize 1<<12 (only size supported for now):

   echo 0 100 ramback /dev/ramdev /dev/backdev | dmsetup create <name>

Set ramback to flush mode:

  echo 1 >/proc/driver/ramback/<devname>

Set ramback to normal mode:

  echo 0 >/proc/driver/ramback/<devname>

Turn trace output on:

  echo 256 >/proc/driver/ramback/<devname>

Show ramback status:

  cat /proc/driver/ramback/<devname>

Progress monitor:

  watch -n1 cat /proc/driver/ramback/<devname>

Patch applies to 2.6.23.12:

  cd linux-2.6.23.12 && cat this.mail >patch -p1

A note on device mapper target names:

  There is actually no way for a device mapper target to obtain its
  own name, which is apparently by design, because each device mapper
  device is actually a table of devices and the name of an individual
  target would have to include something to distinguish it from other
  targets belonging to the same virtual device.  This is actually just
  a symptom of deep design flaws in device mapper.  For today, ramback
  uses the ascii address of its struct dm_target as its own name.  If
  you only have one this will not be a problem, but something really
  needs to be done about this.  Namely, rewriting dm-ramback as a
  standard block device.  There is actually no reason for ramback to
  be a device mapper device other than lack of a library for creating
  standard block devices, and that can be fixed.

--- 2.6.23.12.base/drivers/md/dm-ramback.c	2008-03-08 16:47:29.000000000 -0800
+++ 2.6.23.12/drivers/md/dm-ramback.c	2008-03-09 22:54:19.000000000 -0700
@@ -0,0 +1,962 @@
+#include <linux/version.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <asm/bug.h>
+#include <linux/bio.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/blkdev.h>
+#include <linux/kthread.h>
+#include <linux/vmalloc.h>
+#include "dm.h"
+
+#include <linux/delay.h>
+
+#define warn(string, args...) do { printk("%s: " string "\n", __func__, ##args); } while (0)
+#define error(string, args...) do { warn(string, ##args); BUG(); } while (0)
+#define assert(expr) do { if (!(expr)) error("Assertion " #expr " failed!\n"); } while (0)
+#define enable(args) args
+#define disable(args)
+
+/*
+ * Ramback version 0.0
+ *
+ * Backing store for ramdisks
+ *
+ * (C) 2008 Violin Memory Inc.
+ *
+ * Original Author: Daniel Phillips <phillips@phunq.net>
+ *
+ * License: GPL v2
+ */
+
+#define SECTOR_SHIFT 9
+#define FLUSH_FLAG 1
+#define TRACE_FLAG (1 << 8)
+
+typedef uint32_t chunk_t; // up to 16 TB with 4K chunksize
+
+/*
+ * Flush mode:
+ *
+ * In flush mode, the ramback daemon stops loading but continues flushing.
+ * Application IO is forced through synchrously to the backing device.  On
+ * exit from flush mode, loading resumes if it was incomplete.  (Once fully
+ * populated, no chunk may become empty again.)
+ *
+ * Populate transfers may occur even in writethrough mode, just for partial
+ * chunks at the beginning and end of a writethrough region.
+ *
+ * Each daemon write in flush mode marks chunks clean before launching so
+ * these writes will never overwrite application writes, but each application
+ * write has to wait for any overlapping flush to complete before proceeding,
+ * to prevent the latter from stomping on top of the former.  See nasty race.
+ */
+
+struct devinfo {
+	spinlock_t lock;
+	wait_queue_head_t fast_wait, slow_wait;
+	struct dm_dev *dm_ramdev, *dm_backdev;
+	struct block_device *ramdev, *backdev;
+	struct task_struct *fast_daemon, *slow_daemon;
+	struct list_head loading, storing, fast_submits, slow_submits, thru_queue;
+	struct hook *prehook;
+	chunk_t chunks, dirty, flushing, inflight, inflight_max;
+	unsigned flags, chunkshift, chunk_sector_shift, populated;
+	long long loaded, saved;
+	unsigned char *state;
+};
+
+/*
+ * Attach some working space to a bio, also remember how to chain back to
+ * original endio if endio had to be hooked for custom processing.
+ */
+struct hook {
+	void *old_private;
+	bio_end_io_t *old_endio;
+	struct list_head member, queue;
+	struct bio *bio, *cloned;
+	struct devinfo *info;
+	chunk_t start, limit;
+};
+
+/*
+ * Statistics
+ *
+ * Inflight and dirty counts need to be computed accurately because they
+ * control daemon wakeup.  Dirty count must be accounted on transition between
+ * clean and dirty (in future, also empty to dirty).  Needless to say, must
+ * only account under the lock.
+ */
+
+/* proc interface */
+
+static struct proc_dir_entry *ramback_proc_root;
+
+static int ramback_proc_show(struct seq_file *seq, void *offset)
+{
+	struct devinfo *info = seq->private;
+	seq_printf(seq, "flags: %i\n", info->flags);
+	seq_printf(seq, "trace: %i\n", !!(info->flags & TRACE_FLAG));
+	seq_printf(seq, "loading: %i\n", !info->populated);
+	seq_printf(seq, "storing: %i\n", !!(info->flags & FLUSH_FLAG));
+	seq_printf(seq, "chunks: %i\n", info->chunks);
+	seq_printf(seq, "loaded: %Li\n", info->loaded);
+	seq_printf(seq, "stored: %Li\n", info->saved);
+	seq_printf(seq, "dirty: %i\n", info->dirty);
+	seq_printf(seq, "inflight: %i\n", info->inflight);
+	return 0;
+}
+
+static ssize_t ramback_proc_write(struct file *file, const char __user *buf, size_t count, loff_t *offset)
+{
+	struct devinfo *info = PROC_I(file->f_dentry->d_inode)->pde->data;
+	char text[16], *end;
+	int n;
+	memset(text, 0, sizeof(text));
+	if (count >= sizeof(text))
+		return -EINVAL;
+	if (copy_from_user(text, buf, count))
+		return -EFAULT;
+	n = simple_strtoul(text, &end, 10);
+	if (end == text)
+		return -EINVAL;
+	if (n & 1) // factor me
+		info->flags |= FLUSH_FLAG;
+	else
+		info->flags &= ~FLUSH_FLAG;
+
+	if (n & 0x100) // factor me
+		info->flags |= TRACE_FLAG;
+	else
+		info->flags &= ~TRACE_FLAG;
+	return count;
+}
+
+static int ramback_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ramback_proc_show, PDE(inode)->data);
+}
+
+static struct file_operations ramback_proc_fops = {
+	.open = ramback_proc_open,
+	.read = seq_read,
+	.write = ramback_proc_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void ramback_proc_create(struct dm_target *target, void *data)
+{
+	struct proc_dir_entry *proc;
+	char name[24];
+	snprintf(name, sizeof(name), "%p", target);
+	proc = create_proc_entry(name, 0, ramback_proc_root);
+	proc->owner = THIS_MODULE;
+	proc->data = data;
+	proc->proc_fops = &ramback_proc_fops;
+}
+
+static void ramback_proc_remove(struct dm_target *target)
+{
+	char name[24];
+	snprintf(name, sizeof(name), "%p", target);
+	remove_proc_entry(name, ramback_proc_root);
+}
+
+/* The driver */
+
+#if 0
+static void show_loading(struct devinfo *info)
+{
+	struct list_head *list;
+	int paranoid = 0;
+	printk("loading: ");
+	list_for_each(list, &info->loading) {
+		struct hook *hook = list_entry(list, struct hook, member);
+		printk("%p (%i..%i) ", hook->bio, hook->start, hook->limit - 1);
+		if (++paranoid > 10000) {
+			printk("list way too long\n");
+			break;
+		}
+	}
+	printk("\n");
+}
+#endif
+
+static void trace(struct devinfo *info, const char *fmt, ...)
+{
+	if (info->flags & TRACE_FLAG) {
+		va_list args;
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+	}
+}
+
+static struct kmem_cache *ramback_hooks;
+
+static struct hook *alloc_hook(void)
+{
+	return kmem_cache_alloc(ramback_hooks, GFP_NOIO|__GFP_NOFAIL);
+}
+
+static void free_hook(struct hook *hook)
+{
+	kmem_cache_free(ramback_hooks, hook);
+}
+
+static void unhook_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	bio->bi_end_io = hook->old_endio;
+	bio->bi_private = hook->old_private;
+	free_hook(hook);
+	bio_endio(bio, bio->bi_size, error);
+}
+
+static void free_bio_pages(struct bio *bio)
+{
+	int i;
+	for (i = 0; i < bio->bi_vcnt; i++) {
+		__free_pages(bio->bi_io_vec[i].bv_page, 0);
+		bio->bi_io_vec[i].bv_page = (void *)0xdeadbeef;
+	}
+}
+
+enum chunk_state { CHUNK_EMPTY, CHUNK_CLEAN, CHUNK_DIRTY };
+
+static unsigned get_chunk_state(struct devinfo *info, chunk_t chunk)
+{
+	unsigned shift = 2 * (chunk & 3), offset = chunk >> 2, mask = 3;
+	return (info->state[offset] >> shift) & mask;
+}
+
+static void set_chunk_state(struct devinfo *info, chunk_t chunk, int state)
+{
+	unsigned shift = 2 * (chunk & 3), offset = chunk >> 2, mask = 3;
+	info->state[offset] = (info->state[offset] & ~(mask << shift)) | (state << shift);
+}
+
+static int is_empty(struct devinfo *info, chunk_t chunk)
+{
+	return get_chunk_state(info, chunk) == CHUNK_EMPTY;
+}
+
+static int is_dirty(struct devinfo *info, chunk_t chunk)
+{
+	return get_chunk_state(info, chunk) == CHUNK_DIRTY;
+}
+
+static int is_loading(struct devinfo *info, chunk_t chunk)
+{
+	struct list_head *list;
+	list_for_each(list, &info->loading) {
+		struct hook *this = list_entry(list, struct hook, member);
+		if (chunk >= this->start && chunk < this->limit)
+			return 1;
+	}
+	return 0;
+}
+
+static int change_state(struct devinfo *info, chunk_t chunk, chunk_t limit, int state)
+{
+	int changed = 0;
+	for (; chunk < limit; chunk++) {
+		if (get_chunk_state(info, chunk) == state)
+			continue;
+		set_chunk_state(info, chunk, state);
+		changed++;
+	}
+	return changed;
+}
+
+static int set_clean_locked(struct devinfo *info, chunk_t chunk, chunk_t limit)
+{
+	return change_state(info, chunk, limit, CHUNK_CLEAN);
+}
+
+static int set_dirty_locked(struct devinfo *info, chunk_t chunk, chunk_t limit)
+{
+	return change_state(info, chunk, limit, CHUNK_DIRTY);
+}
+
+static void queue_to_ramdev(struct hook *hook)
+{
+	hook->bio->bi_bdev = hook->info->ramdev;
+	list_add_tail(&hook->queue, &hook->info->fast_submits);
+	wake_up(&hook->info->fast_wait);
+	
+}
+
+static void queue_to_backdev(struct hook *hook)
+{
+	hook->bio->bi_bdev = hook->info->backdev;
+	list_add_tail(&hook->queue, &hook->info->slow_submits);
+	wake_up(&hook->info->slow_wait);
+	
+}
+
+/*
+ * Nasty race: daemon populate must not overwrite application write
+ * Application read or write has to 
+ */
+
+/*
+ * Nasty race: daemon writeback must not overwrite application writethrough.
+ * Also, we try to have application writes land on the backing dev in the same
+ * order they arrived on the ramdisk, so that when the daemon has fully synced
+ * up all writeback chunks, the backing store data is henceforth always a point
+ * in time version of the ramdisk.  This is done crudely by simply serializing
+ * application writes when in writethrough mode.  Very slow!  However, bear in
+ * mind that the line power is off at this point so we care a whole lot more
+ * about data consistency than how fast an app can write.  It should consider
+ * itself lucky to be allowed to write at all, its lights may go out soon.
+ *
+ * Write algorithm when in writethrough mode
+ *
+ * Kick writethrough if any:
+ *    If writethrough queue empty, done
+ *    If head of writethrough queue does not overlap any member of storing list
+ *       remove head from writethrough queue, add to storing list and submit
+ *    (else it will be submitted when save completes)
+ * 
+ * On application write in writethrough mode: (after populating)
+ *    Mark region clean
+ *    Add to tail of writethrough queue
+ *    Kick writethrough queue
+ * 
+ * On save complete:
+ *    Remove from storing list
+ *    Kick writethrough
+ * 
+ * On writethrough complete:
+ *    as for save complete plus endio on original write
+ * 
+ * On daemon finding a dirty chunk:
+ *    Mark chunk clean and add chunk to storing list
+ *    submit it
+ */
+
+/*
+ * If head of writethrough queue does not overlap any member of storing list
+ * then submit it.
+ */
+static void kick_thru(struct devinfo *info)
+{
+	struct hook *hook;
+	spin_lock(&info->lock);
+	if (!list_empty(&info->thru_queue)) {
+		struct list_head *list;
+		hook = list_entry(info->thru_queue.next, struct hook, queue);
+		list_for_each(list, &info->storing) {
+			struct hook *that = list_entry(list, struct hook, member);
+			if ((hook->start < that->limit && hook->limit >= that->start))
+				goto overlap;
+		}
+		trace(info, ">>> kick_thru bio %p: chunk %i..%i\n", hook->bio, hook->start, hook->limit - 1);
+		list_del(&hook->queue);
+		list_add_tail(&hook->member, &hook->info->storing);
+		queue_to_ramdev(hook);
+	}
+overlap:
+	spin_unlock(&info->lock);
+}
+
+/* Twisty little maze of io completions, all different */
+
+/*
+ * Completes a transfer to populate a chunk (later a range) of the
+ * ramdisk and relaunches any application IO that had to wait for empty
+ * chunks to be populated.
+ */
+static int load_write_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	struct list_head *list, *next;
+	spinlock_t *lock = &info->lock;
+	chunk_t chunk = hook->start;
+	trace(info, "load_write_endio on bio %p chunk %zi\n", bio, chunk);
+
+	spin_lock(lock);
+	info->loaded++;
+	info->inflight--;
+	if (info->inflight == info->inflight_max / 2)
+		wake_up(&info->slow_wait);
+	BUG_ON(!is_empty(info, chunk));
+	set_clean_locked(info, hook->start, hook->limit);
+	//hexdump(info->state, (info->chunks + 3) >> 2);
+	list_del(&hook->member);
+	put_page(bio->bi_io_vec[0].bv_page);
+	free_hook(bio->bi_private);
+	bio_put(bio);
+
+	//show_loading(info);
+	list_for_each_safe(list, next, &info->loading) {
+		struct hook *hook = list_entry(list, struct hook, member);
+		for (chunk = hook->start; chunk < hook->limit; chunk++)
+			if (is_empty(info, chunk))
+				goto keep;
+		trace(info, "unblock bio %p\n", hook->bio);
+		list_del(&hook->member);
+		queue_to_backdev(hook); // !!! _fast
+keep:
+		continue;
+	}
+	spin_unlock(lock);
+	return 0;
+}
+
+static int load_read_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	trace(info, "load_read_endio on bio %p chunk %zi\n", bio, hook->start);
+	bio->bi_rw |= WRITE; // !!! need a set_bio_dir(bio) function
+	bio->bi_end_io = load_write_endio;
+	bio->bi_sector = hook->start << info->chunk_sector_shift;
+	bio->bi_size = (hook->limit - hook->start) << info->chunkshift;
+	bio->bi_next = NULL;
+	bio->bi_idx = 0;
+	queue_to_ramdev(hook);
+	return 0;
+}
+
+static int save_write_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	trace(info, "save_write_endio on bio %p chunk %zi\n", bio, hook->start);
+	put_page(bio->bi_io_vec[0].bv_page); // !!! handle range
+	list_del(&hook->member);
+	free_hook(bio->bi_private);
+	bio_put(bio);
+	spin_lock(&info->lock);
+	info->saved++;
+	info->inflight--;
+	spin_unlock(&info->lock);
+	kick_thru(info);
+	return 0;
+}
+
+static int save_read_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	trace(info, "save_read_endio on bio %p chunk %zi\n", bio, hook->start);
+	bio->bi_rw |= WRITE; // !!! need a set_bio_dir(bio) function
+	bio->bi_end_io = save_write_endio;
+	bio->bi_sector = hook->start << info->chunk_sector_shift;
+	bio->bi_size = (hook->limit - hook->start) << info->chunkshift;
+	bio->bi_next = NULL;
+	bio->bi_idx = 0;
+	queue_to_backdev(hook);
+	return 0;
+}
+
+
+static int thru_write_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	struct bio *cloned = hook->cloned;
+	trace(info, "thru_write_endio on bio %p chunk %zi\n", bio, hook->start);
+	free_bio_pages(bio);
+	bio_put(bio);
+
+	list_del(&hook->member);
+	unhook_endio(cloned, done, error);
+	spin_lock(&info->lock);
+	info->inflight--;
+	spin_unlock(&info->lock);
+	kick_thru(info);
+	return 0;
+}
+
+static int thru_read_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	trace(info, "thru_read_endio on bio %p chunk %zi\n", bio, hook->start);
+	bio->bi_rw |= WRITE;
+	bio->bi_end_io = thru_write_endio;
+	bio->bi_sector = hook->start << info->chunk_sector_shift;
+	bio->bi_size = (hook->limit - hook->start) << info->chunkshift;
+	bio->bi_next = NULL;
+	bio->bi_idx = 0;
+	queue_to_backdev(hook);
+	return 0;
+}
+
+static int write_endio(struct bio *bio, unsigned done, int error)
+{
+	struct hook *hook = bio->bi_private;
+	struct devinfo *info = hook->info;
+	chunk_t dirtied;
+
+	trace(info, ">>> write_endio bio %p: chunk %i..%i\n", bio, hook->start, hook->limit - 1);
+	if ((info->flags & FLUSH_FLAG)) {
+		trace(info, ">>> write_endio writethrough\n");
+		bio->bi_end_io = thru_read_endio;
+		bio->bi_size = 0; /* will allocate pages in submit_list */
+		spin_lock(&info->lock);
+		info->dirty -= set_clean_locked(info, hook->start, hook->limit);
+		list_add_tail(&hook->queue, &info->thru_queue);
+		spin_unlock(&info->lock);
+		kick_thru(info);
+		return 0;
+	}
+	spin_lock(&info->lock); // irqsave!!!
+	info->dirty += dirtied = set_dirty_locked(info, hook->start, hook->limit);
+	spin_unlock(&info->lock);
+	//hexdump(info->state, (info->chunks + 3) >> 2);
+	unhook_endio(bio, done, error);
+	if (dirtied)
+		wake_up(&info->slow_wait);
+	return 0;
+}
+
+/* Daemons */
+
+/*
+ * Launch the read side of chunk transfer to or from backing store.  The read
+ * endio resubmits the bio as a write to complete the transfer.
+ */
+static void transfer_chunk(struct hook *hook, struct block_device *dev, bio_end_io_t *endio)
+{
+	struct devinfo *info = hook->info;
+	struct page *page = alloc_pages(GFP_KERNEL|__GFP_NOFAIL, 0);
+	struct bio *bio = bio_alloc(GFP_KERNEL|__GFP_NOFAIL, 1);
+	trace(info, ">>> transfer chunk %i\n", hook->start);
+
+	spin_lock(&info->lock);
+	info->inflight++;
+	spin_unlock(&info->lock);
+	bio->bi_sector = hook->start << info->chunk_sector_shift;
+	bio->bi_size = 1 << info->chunkshift;
+	bio->bi_bdev = dev;
+	bio->bi_end_io = endio;
+	bio->bi_vcnt = 1; // !!! should support multiple pages
+	bio->bi_io_vec[0].bv_page = page;
+	bio->bi_io_vec[0].bv_len = PAGE_CACHE_SIZE;
+	bio->bi_private = hook;
+	hook->bio = bio;
+	generic_make_request(bio);
+}
+
+/*
+ * Do not know for sure whether an allocation has to be done to hook an IO
+ * until after taking spinlock but cannot do a slab allocation while
+ * holding a spinlock.  Keep one item preallocated so it can be used
+ * while holding a spinlock.
+ */
+static void preallocate_hook_and_lock(struct devinfo *info)
+{
+	struct hook *hook;
+	spinlock_t *lock = &info->lock;
+
+	spin_lock(lock);
+	if (info->prehook)
+		return;
+
+	spin_unlock(lock);
+	hook = alloc_hook();
+	spin_lock(lock);
+	if (info->prehook)
+		kmem_cache_free(ramback_hooks, hook);
+	else
+		info->prehook = hook;
+}
+
+struct hook *consume_hook(struct devinfo *info)
+{
+	struct hook *hook = info->prehook;
+	info->prehook = NULL;
+	return hook;
+}
+
+/*
+ * Block device IO cannot be submitted from interrupt context in which
+ * endio functions normally run, so instead the endio pushes the bio onto
+ * a list to be submitted by a daemon.  This submits and empties the list.
+ */
+static int submit_list(struct list_head *submits, spinlock_t *lock)
+{
+	//trace(info, "submit_list\n");
+	spin_lock(lock);
+	while (!list_empty(submits)) {
+		struct list_head *entry = submits->next;
+		struct hook *hook = list_entry(entry, struct hook, queue);
+		struct devinfo *info = hook->info;
+		trace(info, ">>> submit bio %p for chunk %zi, size = %i\n", hook->bio, hook->start, hook->limit - hook->start);
+		list_del(entry);
+		spin_unlock(lock);
+		if (!hook->bio)
+			return 1;
+		if (!hook->bio->bi_size) { /* allocate on behalf of endio */
+			int pages = hook->limit - hook->start, i; // !!! assumes chunk size = page size
+			struct bio *bio = hook->bio, *clone = bio_alloc(__GFP_NOFAIL, pages);
+			trace(info, ">>> clone and submit bio %p for chunk %zi, size = %i\n", hook->bio, hook->start, hook->limit - hook->start);
+			clone->bi_sector = hook->start << info->chunk_sector_shift;
+			clone->bi_size = (hook->limit - hook->start) << info->chunkshift;
+			clone->bi_end_io = bio->bi_end_io;
+			clone->bi_bdev = bio->bi_bdev;
+			clone->bi_vcnt = pages;
+			for (i = 0; i < pages; i++) {
+				struct page *page = alloc_pages(GFP_KERNEL|__GFP_NOFAIL, 0);
+				*(clone->bi_io_vec + i) = (struct bio_vec){ .bv_page = page, .bv_len = PAGE_CACHE_SIZE };
+			}
+			clone->bi_private = hook;
+			hook->cloned = bio;
+			hook->bio = clone;
+		}
+		generic_make_request(hook->bio);
+		spin_lock(lock);
+	}
+	spin_unlock(lock);
+	return 0;
+}
+
+/*
+ * Premature optimization: submissions to the backing device will back up and
+ * block, so there is one daemon that is supposed to avoid blocking by
+ * checking the block device congestion before submitting, and another that
+ * just blocks when the disk is busy, controlling the writeback rate.
+ */
+static int fast_daemon(void *data)
+{
+	struct devinfo *info = data;
+	struct list_head *submits = &info->fast_submits;
+	spinlock_t *lock = &info->lock;
+	trace(info, "fast daemon started\n");
+
+	while (1) {
+		if (submit_list(submits, lock))
+			return 0;
+		trace(info, "fast daemon sleeps\n");
+		wait_event(info->fast_wait, !list_empty(submits));
+		trace(info, "fast daemon wakes\n");
+//		if (kthread_should_stop()) {
+//			BUG_ON(!list_empty(submits));
+//			return 0;
+//		}
+	}
+}
+
+/*
+ * Responsible for initial ramdisk loading and dirty chunk writeback
+ */
+static int slow_daemon(void *data)
+{
+	struct devinfo *info = data;
+	struct list_head *submits = &info->slow_submits;
+	disable(trace_off(int die = 0);)
+	spinlock_t *lock = &info->lock;
+	chunk_t chunk = 0, chunks = info->chunks, i;
+	trace(info, "slow daemon started, %i chunks\n", chunks);
+	disable(msleep(1000);)
+
+	while (1) {
+		disable(BUG_ON(++die == 100);)
+		for (i = 0; i < chunks; i++, chunk++) {
+			if (chunk == chunks) {
+				info->populated = 1;
+				chunk = 0;
+			}
+			disable(show_loading(info);)
+			preallocate_hook_and_lock(info);
+			if (!list_empty(submits)) {
+				spin_unlock(lock);
+				if (submit_list(submits, lock))
+					return 0;
+				preallocate_hook_and_lock(info);
+			}
+			BUG_ON(info->flushing > info->dirty);
+			trace(info, "check chunk %i %i\n", chunk, is_dirty(info, chunk));
+			if (info->populated && !info->dirty) {
+				spin_unlock(lock);
+				break;
+			}
+			if (is_dirty(info, chunk)) {
+				struct hook *hook = consume_hook(info);
+				trace(info, ">>> dirty chunk %i\n", chunk);
+				BUG_ON(is_loading(info, chunk));
+				*hook = (struct hook){ .info = info, .start = chunk, .limit = chunk + 1 };
+				list_add_tail(&hook->member, &info->storing);
+				info->dirty -= set_clean_locked(info, hook->start, hook->limit);
+				spin_unlock(lock);
+				transfer_chunk(hook, info->ramdev, save_read_endio);
+			} else if (1 && !info->populated && is_empty(info, chunk) && !is_loading(info, chunk)) {
+				struct hook *hook = consume_hook(info);
+				trace(info, ">>> empty chunk %i\n", chunk);
+				*hook = (struct hook){ .info = info, .start = chunk, .limit = chunk + 1 };
+				list_add_tail(&hook->member, &info->loading);
+				spin_unlock(lock);
+				transfer_chunk(hook, info->backdev, load_read_endio);
+			}
+			if (info->inflight >= info->inflight_max) // !!! racy
+				wait_event(info->slow_wait, info->inflight <= info->inflight_max / 2);
+		}
+		trace(info, "slow daemon sleeps %i %i %i\n", info->inflight, info->dirty, !list_empty(submits));
+		wait_event(info->slow_wait, info->dirty || !list_empty(submits));
+		trace(info, "slow daemon wakes %i %i %i\n", info->inflight, info->dirty, !list_empty(submits));
+		BUG_ON(info->inflight > chunks);
+//		if (kthread_should_stop()) {
+//			BUG_ON(!list_empty(submits));
+//			return 0;
+//		}
+	}
+}
+
+/* Device mapper methods */
+
+/*
+ * Map a bio tranfer to the ramdisk.  All chunks covered by a read transfer
+ * or zero to two partial chunks covered by a write transfer may need to be
+ * populated before the transfer proceeds. If loading is needed then the
+ * bio goes on the loading list and will be submitted when all covered chunks
+ * have been populated.  For now be lazy and populate the inner chunks of
+ * a write even though this is not required.
+ */
+static int ramback_map(struct dm_target *target, struct bio *bio, union map_info *context)
+{
+	struct devinfo *info = target->private;
+	unsigned shift = info->chunk_sector_shift;
+	unsigned sectors_per_chunk = 1 << shift;
+	unsigned sectors = bio->bi_size >> SECTOR_SHIFT;
+	chunk_t start = bio->bi_sector >> shift;
+	chunk_t limit = (bio->bi_sector + sectors + sectors_per_chunk - 1) >> shift;
+	chunk_t chunk;
+	struct hook *hook = NULL;
+	trace(info, ">>> ramback_map bio %p: %Li %i\n", bio, (long long)bio->bi_sector, sectors);
+	bio->bi_bdev = info->ramdev;
+	/*
+	 * will need a hook for any write or sometimes for a read if still
+	 * loading, but will not know for sure until after taking locks
+	 */
+	if (bio_data_dir(bio) == WRITE) {
+		// !!! block until under dirty threshold
+		hook = alloc_hook();
+		*hook = (struct hook){
+			.old_endio = bio->bi_end_io,
+			.old_private = bio->bi_private,
+			.start = start, .limit = limit,
+			.info = info, .bio = bio };
+		bio->bi_end_io = write_endio;
+		bio->bi_private = hook;
+	}
+	if (info->populated)
+		goto simple;
+	preallocate_hook_and_lock(info);
+	for (chunk = start; chunk < limit; chunk++)
+		if (1 && is_empty(info, chunk) && !is_loading(info, chunk))
+			goto populate;
+	spin_unlock(&info->lock);
+	goto simple;
+populate:
+	if (!hook) { /* must be a read */
+		hook = consume_hook(info);
+		*hook = (struct hook){
+			.start = start, .limit = limit,
+			.info = info, .bio = bio };
+	}
+	list_add_tail(&hook->member, &info->loading);
+	spin_unlock(&info->lock);
+
+	for (chunk = start; chunk < limit; chunk++)
+		if (is_empty(info, chunk)) { // !!! locking ???
+			struct hook *hook = alloc_hook();
+			*hook = (struct hook){
+				.start = chunk, .limit = chunk + 1,
+				.info = info };
+			list_add_tail(&hook->member, &info->loading);
+			transfer_chunk(hook, info->backdev, load_read_endio);
+		}
+	// !!! verify at least one populate in flight so bio will progress
+	return 0;
+simple:
+	generic_make_request(bio);
+	return 0;
+}
+
+static void ramback_destroy(struct dm_target *target)
+{
+	struct devinfo *info = target->private;
+	if (!info)
+		return;
+	trace(info, ">>> destroy ramback\n");
+	ramback_proc_remove(target);
+	if (info->fast_daemon) {
+		queue_to_ramdev(&(struct hook){ .info = info });
+		kthread_stop(info->fast_daemon);
+	}
+	trace(info, "fast daemon stopped\n");
+	if (info->slow_daemon) {
+		queue_to_backdev(&(struct hook){ .info = info });
+		kthread_stop(info->slow_daemon);
+	}
+	trace(info, "slow daemon stopped\n");
+	if (info->ramdev)
+		dm_put_device(target, info->dm_ramdev);
+	if (info->backdev)
+		dm_put_device(target, info->dm_backdev);
+	if (info->state)
+		vfree(info->state);
+	kfree(info);
+}
+
+static int open_device(struct dm_target *target, char *name, struct dm_dev **result)
+{
+	int mode = dm_table_get_mode(target->table);
+	return dm_get_device(target, name, 0, 0, mode, result);
+}
+
+struct hash_cell {
+	struct list_head name_list;
+	struct list_head uuid_list;
+	
+	char *name;
+	char *uuid;
+	struct mapped_device *md;
+	struct dm_table *new_map;
+};
+
+static int ramback_create(struct dm_target *target, unsigned argc, char **argv)
+{
+	struct devinfo *info;
+	int chunkshift = 12, chunk_sector_shift, statebytes, err;
+	chunk_t chunks;
+	char *error;
+
+	error = "ramback usage: ramdev backdev [chunkshift]";
+	err = -EINVAL;
+	if (argc < 2)
+		goto fail;
+
+	if (argc > 2)
+		chunkshift = simple_strtol(argv[2], NULL, 0);
+
+	chunk_sector_shift = chunkshift - SECTOR_SHIFT;
+	chunks = (target->len + (1 << chunk_sector_shift) - 1) >> chunk_sector_shift;
+	statebytes = (chunks + 3) >> 2;
+	err = -ENOMEM;
+	error = "get kernel memory failed";
+	if (!(info = kmalloc(sizeof(struct devinfo), GFP_KERNEL)))
+		goto fail;
+	*info = (struct devinfo){
+		.inflight_max = 50,
+		//.flags = FLUSH_FLAG, // test it
+		.chunkshift = chunkshift, .chunks = chunks,
+		.chunk_sector_shift = chunk_sector_shift,
+		.fast_submits = LIST_HEAD_INIT(info->fast_submits),
+		.slow_submits = LIST_HEAD_INIT(info->slow_submits),
+		.thru_queue = LIST_HEAD_INIT(info->thru_queue),
+		.loading = LIST_HEAD_INIT(info->loading),
+		.storing = LIST_HEAD_INIT(info->storing)};
+
+	init_waitqueue_head(&info->slow_wait);
+	init_waitqueue_head(&info->fast_wait);
+	target->private = info;
+
+	trace(info, ">>> create ramback, chunks = %i\n", chunks);
+	if (!(info->state = vmalloc(statebytes)))
+		goto fail;
+	memset(info->state, 0, statebytes);
+	error = "get ramdisk device failed";
+	if ((err = open_device(target, argv[0], &info->dm_ramdev)))
+		goto fail;
+	info->ramdev = info->dm_ramdev->bdev;
+
+	error = "get backing device failed";
+	if ((err = open_device(target, argv[1], &info->dm_backdev)))
+		goto fail;
+	info->backdev = info->dm_backdev->bdev;
+
+	error = "start daemon failed";
+	if (!(info->fast_daemon = kthread_run(fast_daemon, info, "ramback-fast")))
+		goto fail;
+
+	if (!(info->slow_daemon = kthread_run(slow_daemon, info, "ramback-slow")))
+		goto fail;
+
+	ramback_proc_create(target, target->private);
+	return 0;
+fail:
+	ramback_destroy(target);
+	target->error = error;
+	return err;
+}
+
+static int ramback_status(struct dm_target *target, status_type_t type, char *result, unsigned maxlen)
+{
+	switch (type) {
+	case STATUSTYPE_INFO:
+		snprintf(result, maxlen, "nothing here yet");
+		break;
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "nothing here yet");
+		break;
+	}
+	return 0;
+}
+
+static struct target_type ramback = {
+	.name = "ramback",
+	.version = { 0, 0, 0 },
+	.module = THIS_MODULE,
+	.ctr = ramback_create,
+	.dtr = ramback_destroy,
+	.map = ramback_map,
+	.status = ramback_status,
+};
+
+static void ramback_error(char *action, int err)
+{
+	printk(KERN_ERR "ramback: %s failed (error %i)", action, err);
+}
+
+void ramback_exit(void)
+{
+	int err;
+	char *action;
+
+	action = "unregister target";
+	err = dm_unregister_target(&ramback);
+	if (ramback_hooks)
+		kmem_cache_destroy(ramback_hooks);
+	action = "remove proc entry";
+	remove_proc_entry("ramback", proc_root_driver);
+	if (!err)
+		return;
+	ramback_error(action, -err);
+}
+
+int __init ramback_init(void)
+{
+	int err = -ENOMEM;
+	char *action;
+
+	action = "create caches";
+	if (!(ramback_hooks = kmem_cache_create("ramback-hooks",
+		sizeof(struct hook), __alignof__(struct hook), 0, NULL)))
+		goto fail;
+	action = "register ramback driver";
+	if ((err = dm_register_target(&ramback)))
+		goto fail;
+	action = "create ramback proc entry";
+	if (!(ramback_proc_root = proc_mkdir("ramback", proc_root_driver)))
+		goto fail;
+	ramback_proc_root->owner = THIS_MODULE;
+	return 0;
+fail:
+	ramback_error(action, -err);
+	ramback_exit();
+	return err;
+}
+
+module_init(ramback_init);
+module_exit(ramback_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Violin Memory Inc");
--- 2.6.23.12.base/drivers/md/Makefile	2008-02-14 02:01:41.000000000 -0800
+++ 2.6.23.12/drivers/md/Makefile	2008-03-04 21:32:09.000000000 -0800
@@ -39,6 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rd
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-y				+= dm-ramback.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
