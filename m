Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZELPPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZELPPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbZELPOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:14:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:51111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbZELPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ct0D5XfSYcZ9stfeDuNZWaJ02+C3QYLvtR/ppsb1IWyyx4CMo0fbvAryVOq97b78EM
         jiFg7+URi+FXkN7/o2XfagCbCBDQucNEc1Xgwl93K1xlsDNwLoSNFbxlxpvYxc6o//ca
         GsDfif1UsyJlu+7oF3iZ2j20aUzrFYL/PiOdk=
From: tom.leiming@gmail.com
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Date: Tue, 12 May 2009 23:13:42 +0800
Message-Id: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The async_schedule* may not be called in atomic contexts if out of
memory or if there's too much work pending already, because the
async function to be called may sleep.

This patch fixes the comment of async_schedule*, and introduces
async_schedules*_atomic to allow them called from atomic contexts
safely.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/async.h |    3 ++
 kernel/async.c        |   56 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 68a9530..ede9849 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -19,6 +19,9 @@ typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 					    struct list_head *list);
+extern async_cookie_t async_schedule_atomic(async_func_ptr *ptr, void *data);
+extern async_cookie_t async_schedule_domain_atomic(async_func_ptr *ptr, \
+					void *data, struct list_head *list);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct list_head *list);
 extern void async_synchronize_cookie(async_cookie_t cookie);
diff --git a/kernel/async.c b/kernel/async.c
index 968ef94..6bf565b 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -172,12 +172,13 @@ out:
 }
 
 
-static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
+static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
+				struct list_head *running, int atomic)
 {
 	struct async_entry *entry;
 	unsigned long flags;
 	async_cookie_t newcookie;
-	
+	int  sync_run = 0;
 
 	/* allow irq-off callers */
 	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
@@ -186,7 +187,9 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 	 * If we're out of memory or if there's too much work
 	 * pending already, we execute synchronously.
 	 */
-	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
+	sync_run = !async_enabled || !entry || \
+			atomic_read(&entry_count) > MAX_WORK;
+	if (sync_run && !atomic) {
 		kfree(entry);
 		spin_lock_irqsave(&async_lock, flags);
 		newcookie = next_cookie++;
@@ -195,7 +198,10 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
 		/* low on memory.. run synchronously */
 		ptr(data, newcookie);
 		return newcookie;
+	} else if (sync_run) {
+		return 0;
 	}
+
 	entry->func = ptr;
 	entry->data = data;
 	entry->running = running;
@@ -215,15 +221,31 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
  * @data: data pointer to pass to the function
  *
  * Returns an async_cookie_t that may be used for checkpointing later.
- * Note: This function may be called from atomic or non-atomic contexts.
+ * Note:This function may be called from non-atomic contexts,and not
+ * 	called from atomic contexts with safety. Please use
+ * 	async_schedule_atomic in atomic contexts.
  */
 async_cookie_t async_schedule(async_func_ptr *ptr, void *data)
 {
-	return __async_schedule(ptr, data, &async_running);
+	return __async_schedule(ptr, data, &async_running, 0);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
 /**
+ * async_schedule_atomic - schedule a function for asynchronous execution
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * Note: This function can be called from atomic contexts safely.
+ */
+async_cookie_t async_schedule_atomic(async_func_ptr *ptr, void *data)
+{
+	return __async_schedule(ptr, data, &async_running, 1);
+}
+EXPORT_SYMBOL_GPL(async_schedule_atomic);
+
+/**
  * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
  * @ptr: function to execute asynchronously
  * @data: data pointer to pass to the function
@@ -233,16 +255,36 @@ EXPORT_SYMBOL_GPL(async_schedule);
  * @running may be used in the async_synchronize_*_domain() functions
  * to wait within a certain synchronization domain rather than globally.
  * A synchronization domain is specified via the running queue @running to use.
- * Note: This function may be called from atomic or non-atomic contexts.
+ * Note:This function may be called from non-atomic contexts,and not
+ * 	called from atomic contexts with safety. Please use
+ * 	async_schedule_domain_atomic in atomic contexts.
  */
 async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 				     struct list_head *running)
 {
-	return __async_schedule(ptr, data, running);
+	return __async_schedule(ptr, data, running, 0);
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
 /**
+ * async_schedule_domain_atomic - schedule a function for asynchronous execution within a certain domain
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ * @running: running list for the domain
+ *
+ * Returns an async_cookie_t that may be used for checkpointing later.
+ * @running may be used in the async_synchronize_*_domain() functions
+ * to wait within a certain synchronization domain rather than globally.
+ * A synchronization domain is specified via the running queue @running to use.
+ * Note: This function can be called from atomic contexts safely.
+ */
+async_cookie_t async_schedule_domain_atomic(async_func_ptr *ptr, void *data,
+				     struct list_head *running)
+{
+	return __async_schedule(ptr, data, running, 1);
+}
+EXPORT_SYMBOL_GPL(async_schedule_domain_atomic);
+/**
  * async_synchronize_full - synchronize all asynchronous function calls
  *
  * This function waits until all asynchronous function calls have been done.
-- 
1.6.0.GIT

