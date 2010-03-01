Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0CAT6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:58:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:40100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab0CAT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:58:14 -0500
Date: Mon, 1 Mar 2010 19:57:52 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267183361-20775-2-git-send-email-luca@luca-barbieri.com>
References: <1267183361-20775-2-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86: Implement atomic[64]_dec_if_positive()
Message-ID: <tip-d7f6de1e9c4a12e11ba7186c70f0f40caa76f590@git.kernel.org>
Git-Commit-ID: d7f6de1e9c4a12e11ba7186c70f0f40caa76f590
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7f6de1e9c4a12e11ba7186c70f0f40caa76f590
Gitweb:     http://git.kernel.org/tip/d7f6de1e9c4a12e11ba7186c70f0f40caa76f590
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Fri, 26 Feb 2010 12:22:41 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:38:42 -0800

x86: Implement atomic[64]_dec_if_positive()

Add support for atomic_dec_if_positive(), and
atomic64_dec_if_positive() for x86-64.

atomic64_dec_if_positive() for x86-32 was already implemented in a previous patch.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267183361-20775-2-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
