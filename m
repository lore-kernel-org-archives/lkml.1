Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934992Ab0BZLXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:23:01 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37561 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934303Ab0BZLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rEhGG5dw1CEGwPCxf+neAcRo8E+z+YyvRH2AExD4WyShfVpI5hl5Je/tOMCqwy5Pyd
         AU1oPqgp13ciPEIgkHFeU/WLJ6yq9I3M47ob5De69i18hgh5zDiM94Zrre3PxlLM8r2d
         xY5APZKQ1WiOWhT1xMXuwZOZZ8jNTb5+6NA9I=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 2/2] x86: implement atomic[64]_dec_if_positive
Date: Fri, 26 Feb 2010 12:22:41 +0100
Message-Id: <1267183361-20775-2-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
References: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were missing.

atomic64_dec_if_positive for x86-32 is implemented in my atomic64
improvements for x86-32 patchset.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/atomic.h      |   23 +++++++++++++++++++++++
 arch/x86/include/asm/atomic64_64.h |   23 +++++++++++++++++++++++
 lib/atomic64_test.c                |    2 +-
 3 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 8f8217b..706c694 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -246,6 +246,29 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+static inline int atomic_dec_if_positive(atomic_t *v)
+{
+	int c, old, dec;
+	c = atomic_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 /**
  * atomic_inc_short - increment of a short integer
  * @v: pointer to type int
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index 51c5b40..4d6e2cd 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -221,4 +221,27 @@ static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
+/*
+ * atomic64_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+static inline long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long c, old, dec;
+	c = atomic64_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic64_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 #endif /* _ASM_X86_ATOMIC64_64_H */
diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 0effcac..58efdab 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -112,7 +112,7 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
-#if defined(CONFIG_X86_32) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
+#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
-- 
1.6.6.1.476.g01ddb

