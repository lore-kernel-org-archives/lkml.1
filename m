Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZI3WEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZI3WEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbZI3WEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:04:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZI3WEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:04:09 -0400
Date: Thu, 1 Oct 2009 00:03:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090930220342.GA2118@elte.hu>
References: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930185315.GA9716@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Ingo - I suspect both those patches should just go through you. You 
> > do both x86 and scheduler, so I'll happily pull the end result.
> 
> Yeah - working on it - just got back from a trip. It's two risky 
> patches and if that place breaks everyone will be affected so i'll 
> probably send the pull request tomorrow.

Ok, it now looks good in all tests here so Linus please pull the latest 
sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: Provide an alternative() based cmpxchg64()

Eric Dumazet (1):
      sched_clock: Fix atomicity/continuity bug by using cmpxchg64()


 arch/x86/include/asm/cmpxchg_32.h |   30 +++++++++++--------
 arch/x86/kernel/i386_ksyms_32.c   |    8 +++++
 arch/x86/lib/Makefile             |    2 +-
 arch/x86/lib/cmpxchg8b_emu.S      |   57 +++++++++++++++++++++++++++++++++++++
 kernel/sched_clock.c              |    4 +-
 5 files changed, 85 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/lib/cmpxchg8b_emu.S

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
index 0000000..828cb71
--- /dev/null
+++ b/arch/x86/lib/cmpxchg8b_emu.S
@@ -0,0 +1,57 @@
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
+# Emulate 'cmpxchg8b (%esi)' on UP except we don't
+# set the whole ZF thing (caller will just compare
+# eax:edx with the expected value)
+#
+cmpxchg8b_emu:
+	pushfl
+	cli
+
+	cmpl  (%esi), %eax
+	jne not_same
+	cmpl 4(%esi), %edx
+	jne half_same
+
+	movl %ebx,  (%esi)
+	movl %ecx, 4(%esi)
+
+	popfl
+	ret
+
+ not_same:
+	movl  (%esi), %eax
+ half_same:
+	movl 4(%esi), %edx
+
+	popfl
+	ret
+
+CFI_ENDPROC
+ENDPROC(cmpxchg8b_emu)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index ac2e1dc..479ce56 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -127,7 +127,7 @@ again:
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+	if (cmpxchg64(&scd->clock, old_clock, clock) != old_clock)
 		goto again;
 
 	return clock;
@@ -163,7 +163,7 @@ again:
 		val = remote_clock;
 	}
 
-	if (cmpxchg(ptr, old_val, val) != old_val)
+	if (cmpxchg64(ptr, old_val, val) != old_val)
 		goto again;
 
 	return val;
