Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIZOzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIZOzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZIZOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:35023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZIZOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:55:17 -0400
Date: Sat, 26 Sep 2009 14:54:45 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090926143301.2c396b94@infradead.org>
References: <20090926143301.2c396b94@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use __builtin_object_size() to validate the buffer size for copy_from_user()
Message-ID: <tip-9f0cf4adb6aa0bfccf675c938124e68f7f06349d@git.kernel.org>
Git-Commit-ID: 9f0cf4adb6aa0bfccf675c938124e68f7f06349d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 26 Sep 2009 14:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f0cf4adb6aa0bfccf675c938124e68f7f06349d
Gitweb:     http://git.kernel.org/tip/9f0cf4adb6aa0bfccf675c938124e68f7f06349d
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 26 Sep 2009 14:33:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 26 Sep 2009 16:25:41 +0200

x86: Use __builtin_object_size() to validate the buffer size for copy_from_user()

gcc (4.x) supports the __builtin_object_size() builtin, which
reports the size of an object that a pointer point to, when known
at compile time. If the buffer size is not known at compile time, a
constant -1 is returned.

This patch uses this feature to add a sanity check to
copy_from_user(); if the target buffer is known to be smaller than
the copy size, the copy is aborted and a WARNing is emitted in
memory debug mode.

These extra checks compile away when the object size is not known,
or if both the buffer size and the copy length are constants.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20090926143301.2c396b94@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uaccess_32.h |   19 ++++++++++++++++++-
 arch/x86/include/asm/uaccess_64.h |   19 ++++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c  |    2 +-
 arch/x86/lib/copy_user_64.S       |    4 ++--
 arch/x86/lib/usercopy_32.c        |    4 ++--
 include/linux/compiler-gcc4.h     |    2 ++
 include/linux/compiler.h          |    4 ++++
 7 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 632fb44..582d6ae 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -187,9 +187,26 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 
 unsigned long __must_check copy_to_user(void __user *to,
 					const void *from, unsigned long n);
-unsigned long __must_check copy_from_user(void *to,
+unsigned long __must_check _copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n);
+
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+	int ret = -EFAULT;
+
+	if (likely(sz == -1 || sz >= n))
+		ret = _copy_from_user(to, from, n);
+#ifdef CONFIG_DEBUG_VM
+	else
+		WARN(1, "Buffer overflow detected!\n");
+#endif
+	return ret;
+}
+
 long __must_check strncpy_from_user(char *dst, const char __user *src,
 				    long count);
 long __must_check __strncpy_from_user(char *dst,
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index db24b21..ce6fec7 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -21,10 +21,27 @@ copy_user_generic(void *to, const void *from, unsigned len);
 __must_check unsigned long
 copy_to_user(void __user *to, const void *from, unsigned len);
 __must_check unsigned long
-copy_from_user(void *to, const void __user *from, unsigned len);
+_copy_from_user(void *to, const void __user *from, unsigned len);
 __must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+	int ret = -EFAULT;
+
+	if (likely(sz == -1 || sz >= n))
+		ret = _copy_from_user(to, from, n);
+#ifdef CONFIG_DEBUG_VM
+	else
+		WARN(1, "Buffer overflow detected!\n");
+#endif
+	return ret;
+}
+
+
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 3909e3b..a0cdd8c 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -30,7 +30,7 @@ EXPORT_SYMBOL(__put_user_8);
 
 EXPORT_SYMBOL(copy_user_generic);
 EXPORT_SYMBOL(__copy_user_nocache);
-EXPORT_SYMBOL(copy_from_user);
+EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(copy_to_user);
 EXPORT_SYMBOL(__copy_from_user_inatomic);
 
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 6ba0f7b..4be3c41 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -78,7 +78,7 @@ ENTRY(copy_to_user)
 ENDPROC(copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
-ENTRY(copy_from_user)
+ENTRY(_copy_from_user)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rax)
 	movq %rsi,%rcx
@@ -88,7 +88,7 @@ ENTRY(copy_from_user)
 	jae bad_from_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
-ENDPROC(copy_from_user)
+ENDPROC(_copy_from_user)
 
 ENTRY(copy_user_generic)
 	CFI_STARTPROC
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 1f118d4..8498684 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -874,7 +874,7 @@ EXPORT_SYMBOL(copy_to_user);
  * data to the requested size using zero bytes.
  */
 unsigned long
-copy_from_user(void *to, const void __user *from, unsigned long n)
+_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
@@ -882,4 +882,4 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 		memset(to, 0, n);
 	return n;
 }
-EXPORT_SYMBOL(copy_from_user);
+EXPORT_SYMBOL(_copy_from_user);
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 450fa59..a3aef5d 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -37,3 +37,5 @@
 #define __cold			__attribute__((__cold__))
 
 #endif
+
+#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04fb513..8e54108 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -266,6 +266,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Compile time object size, -1 for unknown */
+#ifndef __compiletime_object_size
+# define __compiletime_object_size(obj) -1
+#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
