Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbZEMPvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbZEMPvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZEMPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:51:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:29724 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZEMPvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gjYF2Lpnx9bHZA2Gd6NGTpCETyi3ibQ7YB1Zj7kjbT/mcraSqY52vkewt/pkP1MFEC
         gET7GLJgIciymPBHBIvjtgVTlSXf/x2G4RrFFuiL2tW9v9hlEK1FS0UYLXp8sgsjxWZ3
         IFxuoqLTAgVbEtUOJxp868bfbNUbFkOuyINW0=
From: tom.leiming@gmail.com
To: arjan@infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ming Lei <tom.leiming@gmail.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH] kernel:async function call:introduce async_run_inatomic(v2)
Date: Wed, 13 May 2009 23:51:39 +0800
Message-Id: <1242229899-16761-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The purpose of this function is to offer a simple way to schedule an
asynchronous thread from an atomic context, because there are not any
functions which can create and start a kernel thread in atomic contexts
now. We use async_running_no_sync as running list to make callers that
don't want to synchronize on cookies, so can avoid some side effects for
async_synchronize_full().

Part of note for async_run_inatomic and some guideline is from Cornelia Huck.

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
index 8663f5b..cb527b3 100644
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
+ * Return zero if success, or else return others if failured
+ * Note:
+ * The purpose of this function is to offer a simple way to schedule an
+ * asynchronous thread from an atomic context, because there are not any
+ * functions which can create and start a kernel thread in atomic contexts
+ * now. We use async_running_no_sync as running list to make callers that
+ * don't want to synchronize on cookies, so can avoid some side effects for
+ * async_synchronize_full().
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

