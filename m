Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbXJ3HyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbXJ3HyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbXJ3HyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:54:10 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36917 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751708AbXJ3HyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:54:09 -0400
Message-ID: <393730849.26180@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 30 Oct 2007 15:54:03 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Florin Iucha <florin@iucha.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
References: <20071028152428.GJ7918@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20071028152428.GJ7918@iucha.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1ImlvH-0003YH-Qf@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 28, 2007 at 10:24:29AM -0500, Florin Iucha wrote:
[...]
>    [ 3687.824468] 
>    [ 3687.824470] pdflush       D ffffffff805787c0     0   248      2
>    [ 3687.824473]  ffff810006001d90 0000000000000046 0000000000000000 0000000000000286
>    [ 3687.824476]  ffff8100057fc770 ffff810003062000 ffff8100057fc978 0000000106001da0
>    [ 3687.824480]  0000000000000003 ffffffff8023b1b2 0000000000000000 0000000000000000
>    [ 3687.824483] Call Trace:
>    [ 3687.824488]  [<ffffffff8023b1b2>] __mod_timer+0xb8/0xca
>    [ 3687.824492]  [<ffffffff8055c87a>] schedule_timeout+0x8d/0xb4
>    [ 3687.824496]  [<ffffffff8023ad6c>] process_timeout+0x0/0xb
>    [ 3687.824499]  [<ffffffff8055c79a>] io_schedule_timeout+0x28/0x33
>    [ 3687.824503]  [<ffffffff8026bb24>] congestion_wait+0x6b/0x87
>    [ 3687.824506]  [<ffffffff80245983>] autoremove_wake_function+0x0/0x38
>    [ 3687.824510]  [<ffffffff8029e684>] writeback_inodes+0xcd/0xd5
>    [ 3687.824514]  [<ffffffff80266dc4>] wb_kupdate+0xbb/0x10d
>    [ 3687.824518]  [<ffffffff80267165>] pdflush+0x0/0x1c3
>    [ 3687.824520]  [<ffffffff8026727d>] pdflush+0x118/0x1c3
>    [ 3687.824523]  [<ffffffff80266d09>] wb_kupdate+0x0/0x10d
>    [ 3687.824527]  [<ffffffff80245876>] kthread+0x49/0x77
>    [ 3687.824530]  [<ffffffff8020c598>] child_rip+0xa/0x12
>    [ 3687.824535]  [<ffffffff8024582d>] kthread+0x0/0x77
>    [ 3687.824538]  [<ffffffff8020c58e>] child_rip+0x0/0x12
>    [ 3687.824540] 
> 
> What could cause this?  I use NFS4 to automount the home directories
> from a Solaris10 server, and this box found a few bugs in the NFS4
> code (fixed in the 2.6.22 kernel).
> 
> I'll try running with 2.6.23 again for a few days, to see if I get the
> pdflush stuck.  Any other ideas?

It could be triggered by the more aggressive writeback behavior - the
new code will keep on retrying as long as there are dirty inodes pending.

Florin, would you try the attached patches against 2.6.24-git?
They may generate big traffic of printk messages, but will help
debug the problem.

Thank you,
Fengguang

--fdj2RfSjLxBAspz7
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

--fdj2RfSjLxBAspz7
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

--fdj2RfSjLxBAspz7--

