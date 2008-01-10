Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYAJHbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYAJHbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYAJHa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:30:56 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43207 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751719AbYAJHaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:30:55 -0500
Message-ID: <399950262.02729@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 10 Jan 2008 15:30:46 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801091322.35133.lists@naasa.net> <399883439.31205@ustc.edu.cn> <200801091404.30330.lists@naasa.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <200801091404.30330.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCrsE-0000v4-Dz@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Joerg,

Can you try the attached patches? Thank you.
I cannot reliably reproduce the bug yet.

Fengguang

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="writeback-ext2-fix.patch"

 mm/filemap_xip.c |    1 +
 1 files changed, 1 insertion(+)

Index: linux/mm/filemap_xip.c
===================================================================
--- linux.orig/mm/filemap_xip.c
+++ linux/mm/filemap_xip.c
@@ -431,6 +431,7 @@ xip_truncate_page(struct address_space *
 			return PTR_ERR(page);
 	}
 	zero_user_page(page, offset, length, KM_USER0);
+	set_page_dirty(page);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="writeback-debug.patch"

---
 mm/page-writeback.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- linux-2.6.24-git17.orig/mm/page-writeback.c
+++ linux-2.6.24-git17/mm/page-writeback.c
@@ -98,6 +98,26 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                               \
+	__writeback_debug_report(n, wbc, __FILE__, __LINE__, __FUNCTION__); \
+} while (0)
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk(KERN_DEBUG "%s %d %s: %s(%d) %ld "
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
 
@@ -395,6 +415,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -421,6 +442,7 @@ static void balance_dirty_pages(struct a
 			break;		/* We've done our duty */
 
 		congestion_wait(WRITE, HZ/10);
+		writeback_debug_report(-pages_written, &wbc);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
@@ -515,6 +537,11 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
+		printk(KERN_DEBUG "throttle_vm_writeout: "
+				"congestion_wait on %lu+%lu > %lu\n",
+				global_page_state(NR_UNSTABLE_NFS),
+				global_page_state(NR_WRITEBACK),
+				dirty_thresh);
 
 		/*
 		 * The caller might hold locks which can prevent IO completion
@@ -557,6 +584,7 @@ static void background_writeout(unsigned
 		wbc.pages_skipped = 0;
 		writeback_inodes(&wbc);
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(min_pages, &wbc);
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
 			if (wbc.encountered_congestion || wbc.more_io)
@@ -630,6 +658,7 @@ static void wb_kupdate(unsigned long arg
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
+		writeback_debug_report(nr_to_write, &wbc);
 		if (wbc.nr_to_write > 0) {
 			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
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

--4Ckj6UjgE2iN1+kY--

