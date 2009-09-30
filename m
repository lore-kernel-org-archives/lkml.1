Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZI3UlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZI3UlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZI3UlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:41:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:56028 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZI3UlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:41:17 -0400
Date: Wed, 30 Sep 2009 20:40:00 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com,
       schwidefsky@de.ibm.com, arjan@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, johnstul@us.ibm.com,
       a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, arjan@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090930170754.0886ff2e@infradead.org>
References: <20090930170754.0886ff2e@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] x86: Provide an alternative() based cmpxchg64()
Message-ID: <tip-e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c@git.kernel.org>
Git-Commit-ID: e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 30 Sep 2009 20:40:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c
Gitweb:     http://git.kernel.org/tip/e87aaa7b6d80474ec07a2d2be3f50ef574ffe36c
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Wed, 30 Sep 2009 17:07:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Sep 2009 22:35:44 +0200

x86: Provide an alternative() based cmpxchg64()

cmpxchg64() today generates, to quote Linus, "barf bag" code.

cmpxchg64() is about to get used in the scheduler to a bug there,
but it's a prerequisite that cmpxchg64() first be made non-sucking.

This patch turns cmpxchg64() into an efficient implementation that
uses the alternative() mechanism to just use the raw instruction on
all modern systens

Note: the fallback is NOT smp safe, just like the current fallback
is not SMP safe. (Interested parties with i486 based SMP systems
are welcome to submit fix patches for that.)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
[ fixed asm constraint bug ]
Fixed-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090930170754.0886ff2e@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/cmpxchg_32.h |   30 +++++++++++--------
 arch/x86/kernel/i386_ksyms_32.c   |    8 +++++
 arch/x86/lib/Makefile             |    2 +-
 arch/x86/lib/cmpxchg8b_emu.S      |   56 +++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 82ceb78..ee1931b 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -312,19 +312,23 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
 
 extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 
-#define cmpxchg64(ptr, o, n)						\
-({									\
-	__typeof__(*(ptr)) __ret;					\
-	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	else								\
-		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
-				(unsigned long long)(o),		\
-				(unsigned long long)(n));		\
-	__ret;								\
-})
+#define cmpxchg64(ptr, o, n)					\
+({								\
+	__typeof__(*(ptr)) __ret;				\
+	__typeof__(*(ptr)) __old = (o);				\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io("call cmpxchg8b_emu",			\
+			"lock; cmpxchg8b (%%esi)" ,		\
+		       X86_FEATURE_CX8,				\
+		       "=A" (__ret),				\
+		       "S" ((ptr)), "0" (__old),		\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		       : "memory");				\
+	__ret; })
+
+
+
 #define cmpxchg64_local(ptr, o, n)					\
 ({									\
 	__typeof__(*(ptr)) __ret;					\
diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
index 43cec6b..1736c5a 100644
--- a/arch/x86/kernel/i386_ksyms_32.c
+++ b/arch/x86/kernel/i386_ksyms_32.c
@@ -10,6 +10,14 @@
 EXPORT_SYMBOL(mcount);
 #endif
 
+/*
+ * Note, this is a prototype to get at the symbol for
+ * the export, but dont use it from C code, it is used
+ * by assembly code and is not using C calling convention!
+ */
+extern void cmpxchg8b_emu(void);
+EXPORT_SYMBOL(cmpxchg8b_emu);
+
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 9e60920..3e549b8 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -15,7 +15,7 @@ ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += semaphore_32.o string_32.o
+        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
 
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
new file mode 100644
index 0000000..0c5e5fa
--- /dev/null
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -0,0 +1,56 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+
+.text
+
+/*
+ * Inputs:
+ * %esi : memory location to compare
+ * %eax : low 32 bits of old value
+ * %edx : high 32 bits of old value
+ * %ebx : low 32 bits of new value
+ * %ecx : high 32 bits of new value
+ */
+ENTRY(cmpxchg8b_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg8b (%esi)' except we don't
+# set the whole ZF thing (caller will just
+# compare eax:edx with the expected value)
+#
+cmpxchg8b_emu:
+	pushfl
+	cli
+
+	cmpl  (%esi), %eax
+	jne not_same
+	cmpl 4(%esi), %edx
+	jne not_same
+
+	movl %ebx,  (%esi)
+	movl %ecx, 4(%esi)
+
+	popfl
+	ret
+
+ not_same:
+	movl  (%esi), %eax
+	movl 4(%esi), %edx
+
+	popfl
+	ret
+
+CFI_ENDPROC
+ENDPROC(cmpxchg8b_emu)
