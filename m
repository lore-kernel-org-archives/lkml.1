Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZEMAeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZEMAeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZEMAdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:33:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:35665 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbZEMAdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:33:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x0Gpn0EVTgIRyQ87FWk8lro3TkvN+fY35Rfr0JBF8qac2dQEDZjU7jPQ7/mFdq+4js
         lj0yi/7MYl9ZGYGXOnF/4Twa5SlJhzC8V2LHlAX1zDlp9px0rbiJTv92gsTULt/rNFIY
         v3xZZgfHjVH71sx8XP1M2c+cZLd5RqxHsNBXw=
From: tom.leiming@gmail.com
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kernel:async function call:introduce async_run
Date: Wed, 13 May 2009 08:33:49 +0800
Message-Id: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

In fact, some async function call does not need to check, async_run
is right for this kind of function call. Also, async_run is very
suitable to used to start a thread in atomic context to do somthing,
for now there is no such kind of kernel api, eg. kthread_run
can not be started in atomic context.

This patch is againt my another patch:
   kernel/async.c:introduce async_schedule*_atomic
please review.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/async.h |    1 +
 kernel/async.c        |   24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index ede9849..5390572 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -16,6 +16,7 @@
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
+extern void async_run(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 					    struct list_head *list);
diff --git a/kernel/async.c b/kernel/async.c
index 6bf565b..9cc4670 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -60,6 +60,7 @@ asynchronous and synchronous parts of the kernel.
 
 static async_cookie_t next_cookie = 1;
 
+#define MAX_COOKIE	(~0)
 #define MAX_THREADS	256
 #define MAX_WORK	32768
 
@@ -207,7 +208,10 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
 	entry->running = running;
 
 	spin_lock_irqsave(&async_lock, flags);
-	newcookie = entry->cookie = next_cookie++;
+	if (atomic == 1)
+		newcookie = entry->cookie = next_cookie++;
+	else
+		newcookie = entry->cookie = MAX_COOKIE;
 	list_add_tail(&entry->list, &async_pending);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
@@ -216,6 +220,24 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
 }
 
 /**
+ * async_run - schedule a function for asynchronous execution
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * Note:we do not allocate a cookie for this kind of aysnchronous
+ * function to decrease the wait time of async_synchronize_full().
+ * In fact, some function does not need to check, async_run is right
+ * for this kind of function call. Also, async_run is very suitable to
+ * start a thread to do somthing in atomic context,for now there is no such
+ * kind of kernel api, eg. kthread_run can not be run in atomic context.
+ */
+void async_run(async_func_ptr *ptr, void *data)
+{
+	__async_schedule(ptr, data, &async_running, 2);
+}
+EXPORT_SYMBOL_GPL(async_run);
+
+/**
  * async_schedule - schedule a function for asynchronous execution
  * @ptr: function to execute asynchronously
  * @data: data pointer to pass to the function
-- 
1.6.0.GIT

