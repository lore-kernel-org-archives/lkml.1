Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbYKXISB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbYKXISB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYKXIRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:17:49 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:59695 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYKXIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=RVFvNwpGZkCp8tl7pP2rEZ3kV9vhi4YQMgNYYw6wFOS2G9m/NwZRSnYaUXE6C0CH6U
         xZSY9eqcm+eOdtAiFvGWxK4I53hLbllmOMbFAIiu/oaoSNwc2GNcROmjoriuOqhHHTOd
         HazJXGS4Vv0y0bC1pw5XFVwEkuF+lQPBvCOEE=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH] __used is needed for function referenced only from inline asm
Date: Mon, 24 Nov 2008 10:17:42 +0200
Message-Id: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the gcc manual, the 'used' attribute should be applied to
functions referenced only from inline assembly.
This fixes a build failure with llvm-gcc-4.2, which deleted
__mutex_lock_slowpath, __mutex_unlock_slowpath.

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 kernel/mutex.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 39a3816..4f45d4b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static void noinline __sched
+static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
 /***
@@ -96,7 +96,7 @@ void inline __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /***
  * mutex_unlock - release the mutex
@@ -268,7 +268,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static noinline void
+static __used noinline void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -313,7 +313,7 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static noinline void __sched
+static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-- 
1.5.6.5

