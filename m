Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXKFIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXKFIA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbXKFIAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:00:14 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:56095 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754619AbXKFIAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:00:11 -0500
Message-ID: <394336012.27271@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 6 Nov 2007 16:00:06 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David <david@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
	startup
References: <472F5F8B.7090200@unsolicited.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <472F5F8B.7090200@unsolicited.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1IpJLy-0002ag-TL@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2007 at 06:23:07PM +0000, David wrote:
> I've been testing rc1 for a week or so, and about 25% of the time I'm
> seeing Firefox and Thunderbird getting stuck in 'D' state as they startup.
> 
> I've attached the output of Sysrq-T to this mail... system is a
> dual-core AMD64, and files are on a RAID-1 root partition connected two
> SATA disks on the on-board NVidia controller. I've had no problems
> before .24 rc1

David, thank you for the reporting.

Could you try with the attached 4 patches? Two of them are expected to
fix your problem, another two are debugging ones(in case the problem
persists).

Thank you,
Fengguang

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="reiserfs-writeback-fix.patch"

Subject: reiserfs: fix writeback

Reiserfs could leave newly created sub-page-size files in dirty state for ever.
They cannot be synced to disk by pdflush routines or an explicit `sync' command.
Only `umount' can do the trick.

This is not a new issue in 2.6.23-git17. 2.6.23 is buggy in the same way.

The direct cause is, the dirty page's PG_dirty is cleared on
reiserfs_file_release(). Call trace:

	 [<ffffffff8027e920>] cancel_dirty_page+0xd0/0xf0
	 [<ffffffff8816d470>] :reiserfs:reiserfs_cut_from_item+0x660/0x710
	 [<ffffffff8816d791>] :reiserfs:reiserfs_do_truncate+0x271/0x530
	 [<ffffffff8815872d>] :reiserfs:reiserfs_truncate_file+0xfd/0x3b0
	 [<ffffffff8815d3d0>] :reiserfs:reiserfs_file_release+0x1e0/0x340
	 [<ffffffff802a187c>] __fput+0xcc/0x1b0
	 [<ffffffff802a1ba6>] fput+0x16/0x20
	 [<ffffffff8029e676>] filp_close+0x56/0x90
	 [<ffffffff8029fe0d>] sys_close+0xad/0x110
	 [<ffffffff8020c41e>] system_call+0x7e/0x83

Fix the problem by simply removing the cancel_dirty_page() call.


Here are more detailed demonstrations of the problem:

1) the page has both PG_dirty(D)/PAGECACHE_TAG_DIRTY(d) after being written to;
   and then only PAGECACHE_TAG_DIRTY(d) remains after the file is closed.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# cat > /test/tiny
[T1] hi
[T2] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /home/wfg# echo /test/tiny > /proc/filecache
[T1] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___UD__Bd_      2
[T2] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___U___Bd_      2

2) note the non-zero `cancelled_write_bytes' after /tmp/hi is copied.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# echo hi > /tmp/hi
[T1] root /home/wfg# cp /tmp/hi /dev/stdin /test
[T2] hi
[T3] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /proc/4397# cd /proc/`pidof cp`
[T1] root /proc/4713# cat io
     rchar: 8396
     wchar: 3
     syscr: 20
     syscw: 1
     read_bytes: 0
     write_bytes: 20480
     cancelled_write_bytes: 4096
[T2] root /proc/4713# cat io
     rchar: 8399
     wchar: 6
     syscr: 21
     syscw: 2
     read_bytes: 0
     write_bytes: 24576
     cancelled_write_bytes: 4096

Cc: Maxim Levitsky <maximlevitsky@gmail.com>                                                                           
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/reiserfs/stree.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
+++ linux-2.6.24-git17/fs/reiserfs/stree.c
@@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
 				}
 				bh = next;
 			} while (bh != head);
-			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
-			}
 		}
 	}
 }

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="mm-speed-up-writeback-ramp-up-on-clean-systems.patch"

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: mm: speed up writeback ramp-up on clean systems

We allow violation of bdi limits if there is a lot of room on the
system. Once we hit half the total limit we start enforcing bdi limits
and bdi ramp-up should happen. Doing it this way avoids many small
writeouts on an otherwise idle system and should also speed up the
ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/page-writeback.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- linux-2.6.24-git17.orig/mm/page-writeback.c
+++ linux-2.6.24-git17/mm/page-writeback.c
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-debug.patch"

---
 mm/page-writeback.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- linux-2.6.23-rc8-mm2.orig/mm/page-writeback.c
+++ linux-2.6.23-rc8-mm2/mm/page-writeback.c
@@ -98,6 +98,26 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                               \
+	__writeback_debug_report(n, wbc, __FILE__, __LINE__, __FUNCTION__); \
+} while (0)
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk("%s %d %s: %s(%d) %ld "
+			"global %lu %lu %lu "
+			"wc %c%c tw %ld sk %ld\n",
+			file, line, func,
+			current->comm, current->pid, n,
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_WRITEBACK),
+			global_page_state(NR_UNSTABLE_NFS),
+			wbc->encountered_congestion ? 'C':'_',
+			wbc->more_io ? 'M':'_',
+			wbc->nr_to_write,
+			wbc->pages_skipped);
+}
 
 static void background_writeout(unsigned long _min_pages);
 
@@ -404,6 +424,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -568,6 +589,7 @@ static void background_writeout(unsigned
 		wbc.pages_skipped = 0;
 		writeback_inodes(&wbc);
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(min_pages, &wbc);
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
 			if (wbc.encountered_congestion)
@@ -643,6 +665,7 @@ static void wb_kupdate(unsigned long arg
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
+		writeback_debug_report(nr_to_write, &wbc);
 		if (wbc.nr_to_write > 0) {
 			if (wbc.encountered_congestion)
 				congestion_wait(WRITE, HZ/10);

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="requeue_io-debug.patch"

Subject: track redirty_tail() calls

It helps a lot to know how redirty_tail() are called.

Cc: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- linux-2.6.24-git17.orig/fs/fs-writeback.c
+++ linux-2.6.24-git17/fs/fs-writeback.c
@@ -164,12 +164,26 @@ static void redirty_tail(struct inode *i
 	list_move(&inode->i_list, &sb->s_dirty);
 }
 
+#define requeue_io(inode)						\
+	do {								\
+		__requeue_io(inode, __LINE__);				\
+	} while (0)
+
 /*
  * requeue inode for re-scanning after sb->s_io list is exhausted.
  */
-static void requeue_io(struct inode *inode)
+static void __requeue_io(struct inode *inode, int line)
 {
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+
+	printk(KERN_DEBUG "requeue_io %d: inode %lu size %llu at %02x:%02x(%s)\n",
+			line,
+			inode->i_ino,
+			i_size_read(inode),
+			MAJOR(inode->i_sb->s_dev),
+			MINOR(inode->i_sb->s_dev),
+			inode->i_sb->s_id
+			);
 }
 
 static void inode_sync_complete(struct inode *inode)

--cNdxnHkX5QqsyA0e--

