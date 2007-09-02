Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbXIBCrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbXIBCrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 22:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXIBCq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 22:46:59 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:48533 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbXIBCq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 22:46:58 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/5] Add lock_page_killable
Date: Sat,  1 Sep 2007 22:46:53 -0400
Message-Id: <11887012142366-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <20070902024348.GJ14130@parisc-linux.org>
References: <20070902024348.GJ14130@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

and associated infrastructure such as sync_page_killable and
fatal_signal_pending.  Use lock_page_killable in do_generic_mapping_read()
to allow us to kill `cat' of a file on an NFS-mounted filesystem.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 include/linux/pagemap.h |   14 ++++++++++++++
 include/linux/sched.h   |    9 ++++++++-
 kernel/signal.c         |    5 +++++
 mm/filemap.c            |   25 +++++++++++++++++++++----
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 8a83537..8b4f533 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -154,6 +154,7 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 }
 
 extern void FASTCALL(__lock_page(struct page *page));
+extern int FASTCALL(__lock_page_killable(struct page *page));
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
@@ -168,6 +169,19 @@ static inline void lock_page(struct page *page)
 }
 
 /*
+ * lock_page_killable is like lock_page but can be interrupted by fatal
+ * signals.  It returns 0 if it locked the page and -EINTR if it was
+ * killed while waiting.
+ */
+static inline int lock_page_killable(struct page *page)
+{
+	might_sleep();
+	if (TestSetPageLocked(page))
+		return __lock_page_killable(page);
+	return 0;
+}
+
+/*
  * lock_page_nosync should only be used if we can't pin the page's inode.
  * Doesn't play quite so well with block device plugging.
  */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6769179..e6f20da 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1769,7 +1769,14 @@ static inline int signal_pending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
-  
+
+extern int FASTCALL(__fatal_signal_pending(struct task_struct *p));
+
+static inline int fatal_signal_pending(struct task_struct *p)
+{
+	return signal_pending(p) && __fatal_signal_pending(p);
+}
+
 static inline int need_resched(void)
 {
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
diff --git a/kernel/signal.c b/kernel/signal.c
index 986ba10..2b4fe29 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1003,6 +1003,11 @@ void zap_other_threads(struct task_struct *p)
 	}
 }
 
+int fastcall __fatal_signal_pending(struct task_struct *tsk)
+{
+	return sigismember(&tsk->pending.signal, SIGKILL);
+}
+
 /*
  * Must be called under rcu_read_lock() or with tasklist_lock read-held.
  */
diff --git a/mm/filemap.c b/mm/filemap.c
index 90b657b..235f092 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -170,6 +170,12 @@ static int sync_page(void *word)
 	return 0;
 }
 
+static int sync_page_killable(void *word)
+{
+	sync_page(word);
+	return fatal_signal_pending(current) ? -EINTR : 0;
+}
+
 /**
  * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
  * @mapping:	address space structure to write
@@ -574,6 +580,14 @@ void fastcall __lock_page(struct page *page)
 }
 EXPORT_SYMBOL(__lock_page);
 
+int fastcall __lock_page_killable(struct page *page)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
+
+	return __wait_on_bit_lock(page_waitqueue(page), &wait,
+					sync_page_killable, TASK_KILLABLE);
+}
+
 /*
  * Variant of lock_page that does not require the caller to hold a reference
  * on the page's mapping.
@@ -975,7 +989,8 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		lock_page(page);
+		if (lock_page_killable(page))
+			goto readpage_eio;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -1003,7 +1018,8 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			lock_page(page);
+			if (lock_page_killable(page))
+				goto readpage_eio;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1014,15 +1030,16 @@ readpage:
 					goto find_page;
 				}
 				unlock_page(page);
-				error = -EIO;
 				shrink_readahead_size_eio(filp, &ra);
-				goto readpage_error;
+				goto readpage_eio;
 			}
 			unlock_page(page);
 		}
 
 		goto page_ok;
 
+readpage_eio:
+		error = -EIO;
 readpage_error:
 		/* UHHUH! A synchronous read error occurred. Report it */
 		desc->error = error;
-- 
1.4.4.2

