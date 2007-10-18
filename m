Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbXJRW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbXJRW1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763516AbXJRWZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:25:47 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:56680 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbXJRWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:25:44 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/5] Add lock_page_killable
Date: Thu, 18 Oct 2007 18:26:01 -0400
Message-Id: <11927463624043-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11927463623428-git-send-email-matthew@wil.cx>
References: <11927463623428-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

and associated infrastructure such as sync_page_killable and
fatal_signal_pending.  Use lock_page_killable in do_generic_mapping_read()
to allow us to kill `cat' of a file on an NFS-mounted filesystem.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/pagemap.h |   14 ++++++++++++++
 include/linux/sched.h   |    9 ++++++++-
 kernel/signal.c         |    5 +++++
 mm/filemap.c            |   25 +++++++++++++++++++++----
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index db8a410..4b62a10 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -157,6 +157,7 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 }
 
 extern void FASTCALL(__lock_page(struct page *page));
+extern int FASTCALL(__lock_page_killable(struct page *page));
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
@@ -171,6 +172,19 @@ static inline void lock_page(struct page *page)
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
index f02ade4..077893d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1738,7 +1738,14 @@ static inline int signal_pending(struct task_struct *p)
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
index 3f28990..f89ab8d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -995,6 +995,11 @@ void zap_other_threads(struct task_struct *p)
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
index 79f24a9..1498e24 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -171,6 +171,12 @@ static int sync_page(void *word)
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
@@ -575,6 +581,14 @@ void fastcall __lock_page(struct page *page)
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
@@ -966,7 +980,8 @@ page_ok:
 
 page_not_up_to_date:
 		/* Get exclusive access to the page ... */
-		lock_page(page);
+		if (lock_page_killable(page))
+			goto readpage_eio;
 
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
@@ -994,7 +1009,8 @@ readpage:
 		}
 
 		if (!PageUptodate(page)) {
-			lock_page(page);
+			if (lock_page_killable(page))
+				goto readpage_eio;
 			if (!PageUptodate(page)) {
 				if (page->mapping == NULL) {
 					/*
@@ -1005,15 +1021,16 @@ readpage:
 					goto find_page;
 				}
 				unlock_page(page);
-				error = -EIO;
 				shrink_readahead_size_eio(filp, ra);
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

