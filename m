Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYEXRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYEXRWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbYEXRWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:22:14 -0400
Received: from host135-133-dynamic.55-82-r.retail.telecomitalia.it ([82.55.133.135]:29456
	"EHLO linux.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755626AbYEXRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:22:13 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com, menage@google.com
Cc: matt@bluehost.com, roberto@unbit.it, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io-throttle accounting and control
Date: Sat, 24 May 2008 18:56:57 +0200
Message-Id: <1211648217-13361-4-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply the io-throttle controller to the opportune kernel functions. Both
accounting and throttling functionalities are performed by cgroup_io_account().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/blk-core.c    |    2 ++
 fs/buffer.c         |    6 ++++++
 fs/direct-io.c      |    2 ++
 mm/page-writeback.c |    5 +++++
 mm/readahead.c      |    2 ++
 5 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6a9cc0d..d6b3353 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -26,6 +26,7 @@
 #include <linux/swap.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blk-io-throttle.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/blktrace_api.h>
@@ -1485,6 +1486,7 @@ void submit_bio(int rw, struct bio *bio)
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_size);
+			cgroup_io_account(bio->bi_size);
 			count_vm_events(PGPGIN, count);
 		}
 
diff --git a/fs/buffer.c b/fs/buffer.c
index a073f3f..eb4893c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -35,6 +35,7 @@
 #include <linux/suspend.h>
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blk-io-throttle.h>
 #include <linux/bio.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
@@ -700,6 +701,8 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static int __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
+	size_t cgroup_io_acct = 0;
+
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
 
@@ -715,12 +718,15 @@ static int __set_page_dirty(struct page *page,
 			__inc_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
 			task_io_account_write(PAGE_CACHE_SIZE);
+			cgroup_io_acct = PAGE_CACHE_SIZE;
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
 	write_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	if (cgroup_io_acct)
+		cgroup_io_account(cgroup_io_acct);
 
 	return 1;
 }
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 9e81add..1b82224 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/rwsem.h>
 #include <linux/uio.h>
+#include <linux/blk-io-throttle.h>
 #include <asm/atomic.h>
 
 /*
@@ -667,6 +668,7 @@ submit_page_section(struct dio *dio, struct page *page,
 		 * Read accounting is performed in submit_bio()
 		 */
 		task_io_account_write(len);
+		cgroup_io_account(len);
 	}
 
 	/*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 789b6ad..97a0c74 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blk-io-throttle.h>
 #include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
@@ -1077,6 +1078,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 		struct address_space *mapping2;
+		size_t cgroup_io_acct = 0;
 
 		if (!mapping)
 			return 1;
@@ -1091,6 +1093,7 @@ int __set_page_dirty_nobuffers(struct page *page)
 				__inc_bdi_stat(mapping->backing_dev_info,
 						BDI_RECLAIMABLE);
 				task_io_account_write(PAGE_CACHE_SIZE);
+				cgroup_io_acct = PAGE_CACHE_SIZE;
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
@@ -1100,6 +1103,8 @@ int __set_page_dirty_nobuffers(struct page *page)
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
+		if (cgroup_io_acct)
+			cgroup_io_account(cgroup_io_acct);
 		return 1;
 	}
 	return 0;
diff --git a/mm/readahead.c b/mm/readahead.c
index d8723a5..fe2f865 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -14,6 +14,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blk-io-throttle.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
 
@@ -76,6 +77,7 @@ int read_cache_pages(struct address_space *mapping, struct list_head *pages,
 			break;
 		}
 		task_io_account_read(PAGE_CACHE_SIZE);
+		cgroup_io_account(PAGE_CACHE_SIZE);
 	}
 	return ret;
 }
-- 
1.5.4.3

