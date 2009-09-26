Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZIZMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZIZMcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZIZMcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:32:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:58472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZIZMcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:32:41 -0400
Date: Sat, 26 Sep 2009 14:33:01 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: [PATCH] x86: Use __builtin_object_size to validate the buffer size
 for copy_from_user
Message-ID: <20090926143301.2c396b94@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 524a1da3c45683cec77480acc6cab1d33ae8d5cb Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 26 Sep 2009 12:36:21 +0200
Subject: [PATCH] x86: Use __builtin_object_size to validate the buffer size for copy_from_user

gcc (4.x) supports the __builtin_object_size() builtin, which reports the
size of an object that a pointer point to, when known at compile time.
If the buffer size is not known at compile time, a constant -1 is returned.

This patch uses this feature to add a sanity check to copy_from_user();
if the target buffer is known to be smaller than the copy size, the copy
is aborted and a WARNing is emitted in memory debug mode.

These extra checks compile away when the object size is not known,
or if both the buffer size and the copy length are constants.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
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
index 9d4c4b0..9c42853 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -185,6 +185,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 #endif
 
+/* Compile time object size, -1 for unknown */
+#ifndef __compiletime_object_size
+# define __compiletime_object_size(obj) -1
+#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
