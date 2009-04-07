Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZDGKIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZDGKIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZDGKIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:08:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:37293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZDGKIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:08:21 -0400
Date: Tue, 7 Apr 2009 10:06:31 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090406094518.445450972@chello.nl>
References: <20090406094518.445450972@chello.nl>
Subject: [tip:perfcounters/core] x86, perfcounters: add atomic64_xchg()
Message-ID: <tip-98c2aaf8be5baf7193be37fb28bce8e7327158bc@git.kernel.org>
Git-Commit-ID: 98c2aaf8be5baf7193be37fb28bce8e7327158bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 10:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98c2aaf8be5baf7193be37fb28bce8e7327158bc
Gitweb:     http://git.kernel.org/tip/98c2aaf8be5baf7193be37fb28bce8e7327158bc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 7 Apr 2009 11:30:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 12:02:41 +0200

x86, perfcounters: add atomic64_xchg()

Complete atomic64_t support on the 32-bit side by adding atomic64_xch().

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090406094518.445450972@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/atomic_32.h |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 977250e..aff9f1f 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -291,19 +291,37 @@ atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
 }
 
 /**
- * atomic64_set - set atomic64 variable
+ * atomic64_xchg - xchg atomic64 variable
  * @ptr:      pointer to type atomic64_t
  * @new_val:  value to assign
+ * @old_val:  old value that was there
  *
- * Atomically sets the value of @ptr to @new_val.
+ * Atomically xchgs the value of @ptr to @new_val and returns
+ * the old value.
  */
-static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
+
+static inline unsigned long long
+atomic64_xchg(atomic64_t *ptr, unsigned long long new_val)
 {
 	unsigned long long old_val;
 
 	do {
 		old_val = atomic_read(ptr);
 	} while (atomic64_cmpxchg(ptr, old_val, new_val) != old_val);
+
+	return old_val;
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+static inline void atomic64_set(atomic64_t *ptr, unsigned long long new_val)
+{
+	atomic64_xchg(ptr, new_val);
 }
 
 /**
