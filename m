Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZEPNyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZEPNyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZEPNy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:54:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:26046 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbZEPNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qWiiIc+Rl+NVeZbwAEC3NSRLyCtupYq5psGQTU1ksXYW5RKszWuccplV0JcoU3X69d
         6l4Tw0T50EVFUnNez2ywokntdkB4n4VwQoe0V406pKVuc3IMpPJOVE2JlFKotP8UGXiY
         laJQOzOnFj4c8msbG4falCbi29ammezzGR0EA=
From: tom.leiming@gmail.com
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cornelia.huck@de.ibm.com, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] kernel:async function call:introduce async_run_inatomic(v3)
Date: Sat, 16 May 2009 21:54:17 +0800
Message-Id: <1242482058-5203-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The purpose of this function is to offer a simple way to schedule an
asynchronous thread from an atomic context, because there are not any
functions which can create and start a kernel thread in atomic contexts.
Now async_run_inatomic() uses a distinct running list in order to avoid
slowing down synchronization within the general domain.

The comment for async_run_inatomic is under guideline from Cornelia Huck.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/linux/async.h |    2 ++
 kernel/async.c        |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 18ce92b..9ff62af 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -16,6 +16,8 @@
 typedef u64 async_cookie_t;
 typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
 
+extern int async_run_inatomic(async_func_ptr *ptr, void *data);
+
 extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
 extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
 					    struct list_head *list);
diff --git a/kernel/async.c b/kernel/async.c
index 8663f5b..adc0455 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -65,6 +65,7 @@ static async_cookie_t next_cookie = 1;
 
 static LIST_HEAD(async_pending);
 static LIST_HEAD(async_running);
+static LIST_HEAD(async_running_no_sync);
 static DEFINE_SPINLOCK(async_lock);
 
 static int async_enabled = 0;
@@ -222,6 +223,28 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data,
 	return newcookie;
 }
 
+ /**
+ * async_run_inatomic - in atomic contexts schedule a function for
+ * 			asynchronous execution
+ *
+ * @ptr: function to execute asynchronously
+ * @data: data pointer to pass to the function
+ *
+ * The purpose of this function is to offer a simple way to schedule an
+ * asynchronous thread from an atomic context.
+ *
+ * Return zero one success, !zero on failured
+ * Note: async_run_inatomic() uses a distinct running list in order
+ * to avoid slowing down synchronization within the general domain.
+ * Since it does not return a cookie for checkpointing, it is for callers
+ * that don't need later synchronization.
+ */
+int async_run_inatomic(async_func_ptr *ptr, void *data)
+{
+	return !__async_schedule(ptr, data, &async_running_no_sync, 1);
+}
+EXPORT_SYMBOL_GPL(async_run_inatomic);
+
 /**
  * async_schedule - schedule a function for asynchronous execution
  * @ptr: function to execute asynchronously
-- 
1.6.0.GIT

