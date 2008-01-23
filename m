Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYAWR1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYAWR1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYAWRWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:22:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbYAWRWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:22:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/27] FS-Cache: Provide an add_wait_queue_tail() function
	[try #2]
To: Trond.Myklebust@netapp.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 23 Jan 2008 17:21:59 +0000
Message-ID: <20080123172158.11107.54199.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
References: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an add_wait_queue_tail() function to add a waiter to the back of a
wait queue instead of the front.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/pagemap.h |    7 +++++--
 include/linux/wait.h    |    2 ++
 kernel/wait.c           |   18 ++++++++++++++++++
 mm/filemap.c            |    2 +-
 4 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1ab7f9a..00b108c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -211,8 +211,11 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 
-/*
- * Wait for a PG_owner_priv_2 to become clear
+/**
+ * wait_on_page_owner_priv_2 - Wait for PG_owner_priv_2 to become clear
+ * @page: The page to monitor
+ *
+ * Wait for a PG_owner_priv_2 to become clear on the specified page.
  */
 static inline void wait_on_page_owner_priv_2(struct page *page)
 {
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0e68628..f1038d0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -118,6 +118,8 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 #define is_sync_wait(wait)	(!(wait) || ((wait)->private))
 
 extern void FASTCALL(add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
+extern void FASTCALL(add_wait_queue_tail(wait_queue_head_t *q,
+					 wait_queue_t *wait));
 extern void FASTCALL(add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t * wait));
 extern void FASTCALL(remove_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
 
diff --git a/kernel/wait.c b/kernel/wait.c
index 444ddbf..7acc9cc 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -29,6 +29,24 @@ void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue);
 
+/**
+ * add_wait_queue_tail - Add a waiter to the back of a waitqueue
+ * @q: the wait queue to append the waiter to
+ * @wait: the waiter to be queued
+ *
+ * Add a waiter to the back of a waitqueue so that it gets woken up last.
+ */
+void fastcall add_wait_queue_tail(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	unsigned long flags;
+
+	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue_tail(q, wait);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(add_wait_queue_tail);
+
 void fastcall add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
diff --git a/mm/filemap.c b/mm/filemap.c
index 5551410..90ccb10 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -572,7 +572,7 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * end_page_own - Clear PG_owner_priv_2 and wake up any waiters
+ * end_page_owner_priv_2 - Clear PG_owner_priv_2 and wake up any waiters
  * @page: the page
  *
  * Clear PG_owner_priv_2 and wake up any processes waiting for that event.

