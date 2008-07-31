Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYGaWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYGaWvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759075AbYGaWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbYGaWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lPPBZ4piYul/qLRAnAJLXPmhWAVMRkVGt668G0ccxapMxXMiENIA0cdjELmiEvqXTf
         6Z+cG64699KNR5MG5A947NsLHh6ZV+0Wo36nhnAETMBlbk95mzitlww1cWVT+lOYyelw
         DvPKSz/BMHIcWJkU5jZPE5uMVnqIRF+rh1xN4=
From: Andrea Righi <righi.andrea@gmail.com>
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com
Cc: Matt Heaton <matt@bluehost.com>, Mark Seger <Mark.Seger@hp.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 4/4] per block device IO accounting instrumentation
Date: Fri,  1 Aug 2008 00:49:59 +0200
Message-Id: <1217544599-8935-5-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new block device i/o accounting functions.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/blk-core.c    |    2 +-
 fs/buffer.c         |   10 +++++++++-
 fs/cifs/file.c      |    2 +-
 fs/direct-io.c      |    3 ++-
 kernel/exit.c       |   16 +++++++++++++---
 kernel/fork.c       |    7 ++++---
 mm/page-writeback.c |    9 ++++++++-
 mm/readahead.c      |    5 ++++-
 mm/truncate.c       |    9 +++++++--
 9 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fef79cc..3f7daf0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1478,7 +1478,7 @@ void submit_bio(int rw, struct bio *bio)
 		if (rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
-			task_io_account_read(bio->bi_size);
+			task_io_account_read(bio->bi_bdev, bio->bi_size);
 			count_vm_events(PGPGIN, count);
 		}
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 9749a90..b7647ab 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -708,6 +708,8 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static int __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
+	size_t io_acct = 0;
+
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
 
@@ -722,13 +724,19 @@ static int __set_page_dirty(struct page *page,
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
 			__inc_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
-			task_io_account_write(PAGE_CACHE_SIZE);
+			io_acct = PAGE_CACHE_SIZE;
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
 	spin_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	if (io_acct) {
+		struct block_device *bdev = (mapping->host &&
+				mapping->host->i_sb->s_bdev) ?
+				mapping->host->i_sb->s_bdev : NULL;
+		task_io_account_write(bdev, io_acct);
+	}
 
 	return 1;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b8a893..6e80927 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1872,7 +1872,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 			cFYI(1, ("Read error in readpages: %d", rc));
 			break;
 		} else if (bytes_read > 0) {
-			task_io_account_read(bytes_read);
+			task_io_account_read(NULL, bytes_read);
 			pSMBr = (struct smb_com_read_rsp *)smb_read_data;
 			cifs_copy_cache_pages(mapping, page_list, bytes_read,
 				smb_read_data + 4 /* RFC1001 hdr */ +
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9606ee8..1e82a05 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -660,7 +660,8 @@ submit_page_section(struct dio *dio, struct page *page,
 		/*
 		 * Read accounting is performed in submit_bio()
 		 */
-		task_io_account_write(len);
+		struct block_device *bdev = dio->bio ? dio->bio->bi_bdev : NULL;
+		task_io_account_write(bdev, len);
 	}
 
 	/*
diff --git a/kernel/exit.c b/kernel/exit.c
index c446b84..428d7b1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -121,7 +121,10 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-		task_io_accounting_add(&sig->ioac, &tsk->ioac);
+
+		task_io_account_add(&sig->ioac, &tsk->ioac);
+		task_io_account_merge_stat(&sig->ioac, &tsk->ioac);
+
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
@@ -1346,9 +1349,16 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
-		task_io_accounting_add(&psig->ioac, &p->ioac);
-		task_io_accounting_add(&psig->ioac, &sig->ioac);
+
+		task_io_account_add(&psig->ioac, &p->ioac);
+		task_io_account_add(&psig->ioac, &sig->ioac);
+		task_io_account_merge_stat(&psig->ioac, &p->ioac);
+		task_io_account_merge_stat(&psig->ioac, &sig->ioac);
+
 		spin_unlock_irq(&p->parent->sighand->siglock);
+	} else {
+		task_io_account_cleanup(&p->signal->ioac);
+		task_io_account_cleanup(&p->ioac);
 	}
 
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 63a87ff..c72c376 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -826,7 +826,9 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
-	task_io_accounting_init(&sig->ioac);
+
+	task_io_account_init(&sig->ioac);
+
 	sig->sum_sched_runtime = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
@@ -1008,8 +1010,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->last_switch_count = 0;
 	p->last_switch_timestamp = 0;
 #endif
-
-	task_io_accounting_init(&p->ioac);
+	task_io_account_init(&p->ioac);
 	acct_clear_integrals(p);
 
 	p->it_virt_expires = cputime_zero;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index c6d6088..06ec4b2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1080,6 +1080,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 		struct address_space *mapping2;
+		ssize_t io_acct = 0;
 
 		if (!mapping)
 			return 1;
@@ -1093,7 +1094,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
 				__inc_bdi_stat(mapping->backing_dev_info,
 						BDI_RECLAIMABLE);
-				task_io_account_write(PAGE_CACHE_SIZE);
+				io_acct = PAGE_CACHE_SIZE;
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
@@ -1103,6 +1104,12 @@ int __set_page_dirty_nobuffers(struct page *page)
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
+		if (io_acct) {
+			struct block_device *bdev = (mapping->host &&
+					mapping->host->i_sb->s_bdev) ?
+					mapping->host->i_sb->s_bdev : NULL;
+			task_io_account_write(bdev, io_acct);
+		}
 		return 1;
 	}
 	return 0;
diff --git a/mm/readahead.c b/mm/readahead.c
index 137bc56..614f55a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -58,6 +58,9 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 			int (*filler)(void *, struct page *), void *data)
 {
 	struct page *page;
+	struct block_device *bdev =
+		(mapping->host && mapping->host->i_sb->s_bdev) ?
+		mapping->host->i_sb->s_bdev : NULL;
 	int ret = 0;
 
 	while (!list_empty(pages)) {
@@ -75,7 +78,7 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 			put_pages_list(pages);
 			break;
 		}
-		task_io_account_read(PAGE_CACHE_SIZE);
+		task_io_account_read(bdev, PAGE_CACHE_SIZE);
 	}
 	return ret;
 }
diff --git a/mm/truncate.c b/mm/truncate.c
index 4d129a5..17c42b7 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -76,8 +76,13 @@ void cancel_dirty_page(struct page *page, unsigned int account_size)
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
-			if (account_size)
-				task_io_account_cancelled_write(account_size);
+			if (account_size) {
+				struct block_device *bdev =
+					mapping->host->i_sb->s_bdev ?
+					mapping->host->i_sb->s_bdev : NULL;
+				task_io_account_cancelled_write(bdev,
+							account_size);
+			}
 		}
 	}
 }
-- 
1.5.4.3

