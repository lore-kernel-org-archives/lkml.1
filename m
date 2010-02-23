Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0BWTGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:06:11 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45974 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0BWTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:06:06 -0500
Date: Tue, 23 Feb 2010 20:06:14 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100223190614.GB2401@aftab>
References: <20100219164512.GA492@aftab>
 <4B7EC20C.30607@zytor.com>
 <20100222141737.GB21233@aftab>
 <4B82BD01.3030008@zytor.com>
 <20100222184945.GD21233@aftab>
 <4B82E144.1050007@zytor.com>
 <20100223155852.GF30382@aftab>
 <4B84118C.90203@zytor.com>
 <20100223175457.GA2401@aftab>
 <4B841BC3.1000908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B841BC3.1000908@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Feb 23, 2010 at 10:17:39AM -0800

> On 02/23/2010 09:54 AM, Borislav Petkov wrote:
> > 
> > Right, doh. Ok, just added it and it builds fine with a gcc (Gentoo
> > 4.4.1 p1.0) 4.4.1. If you have suspicion that some older gcc versions
> > might choke on it, I could leave the "=D" dummy constraint in?
> > 
> 
> I can try it with gcc 3.4 here.  -fcall-saved-rdi is cleaner, if it works.

Ok, here you go.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 11 Feb 2010 00:48:31 +0100
Subject: [PATCH] x86: Add optimized popcnt variants

Add support for the hardware version of the Hamming weight function,
popcnt, present in CPUs which advertize it under CPUID, Function
0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
default lib/hweight.c sw versions.

A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
a 3x speedup on a F10h machine.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig                          |    5 ++
 arch/x86/include/asm/alternative.h        |    9 +++-
 arch/x86/include/asm/arch_hweight.h       |   59 +++++++++++++++++++++++++++++
 arch/x86/include/asm/bitops.h             |    4 +-
 include/asm-generic/bitops/arch_hweight.h |   22 +++++++++--
 lib/Makefile                              |    3 +
 lib/hweight.c                             |   20 +++++-----
 scripts/Makefile.lib                      |    4 ++
 8 files changed, 108 insertions(+), 18 deletions(-)
 create mode 100644 arch/x86/include/asm/arch_hweight.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..4673dc5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -230,6 +230,11 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config ARCH_HWEIGHT_CFLAGS
+	string
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
+	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 69b74a7..0720c96 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -39,9 +39,6 @@
 #define LOCK_PREFIX ""
 #endif
 
-/* This must be included *after* the definition of LOCK_PREFIX */
-#include <asm/cpufeature.h>
-
 struct alt_instr {
 	u8 *instr;		/* original instruction */
 	u8 *replacement;
@@ -91,6 +88,12 @@ static inline void alternatives_smp_switch(int smp) {}
       ".previous"
 
 /*
+ * This must be included *after* the definition of ALTERNATIVE due to
+ * <asm/arch_hweight.h>
+ */
+#include <asm/cpufeature.h>
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
new file mode 100644
index 0000000..d1fc3c2
--- /dev/null
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -0,0 +1,59 @@
+#ifndef _ASM_X86_HWEIGHT_H
+#define _ASM_X86_HWEIGHT_H
+
+#ifdef CONFIG_64BIT
+/* popcnt %rdi, %rax */
+#define POPCNT ".byte 0xf3,0x48,0x0f,0xb8,0xc7"
+#define REG_IN "D"
+#define REG_OUT "a"
+#else
+/* popcnt %eax, %eax */
+#define POPCNT ".byte 0xf3,0x0f,0xb8,0xc0"
+#define REG_IN "a"
+#define REG_OUT "a"
+#endif
+
+/*
+ * __sw_hweightXX are called from within the alternatives below
+ * and callee-clobbered registers need to be taken care of. See
+ * ARCH_HWEIGHT_CFLAGS in <arch/x86/Kconfig> for the respective
+ * compiler switches.
+ */
+static inline unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+
+	return res;
+}
+
+static inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __arch_hweight32(w & 0xffff);
+}
+
+static inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight32(w & 0xff);
+}
+
+static inline unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned long res = 0;
+
+#ifdef CONFIG_X86_32
+	return  __arch_hweight32((u32)w) +
+		__arch_hweight32((u32)(w >> 32));
+#else
+	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+#endif /* CONFIG_X86_32 */
+
+	return res;
+}
+
+#endif
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..545776e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,9 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm/arch_hweight.h>
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 3a7be84..9a81c1e 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,9 +3,23 @@
 
 #include <asm/types.h>
 
-extern unsigned int __arch_hweight32(unsigned int w);
-extern unsigned int __arch_hweight16(unsigned int w);
-extern unsigned int __arch_hweight8(unsigned int w);
-extern unsigned long __arch_hweight64(__u64 w);
+inline unsigned int __arch_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
 
+inline unsigned int __arch_hweight16(unsigned int w)
+{
+	return __sw_hweight16(w);
+}
+
+inline unsigned int __arch_hweight8(unsigned int w)
+{
+	return __sw_hweight8(w);
+}
+
+inline unsigned long __arch_hweight64(__u64 w)
+{
+	return __sw_hweight64(w);
+}
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/lib/Makefile b/lib/Makefile
index 3b0b4a6..e2ad17c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,10 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
+
+CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
+
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
diff --git a/lib/hweight.c b/lib/hweight.c
index 9ff86df..f9ce440 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int __arch_hweight32(unsigned int w)
+unsigned int __sw_hweight32(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
@@ -17,30 +17,30 @@ unsigned int __arch_hweight32(unsigned int w)
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
 }
-EXPORT_SYMBOL(__arch_hweight32);
+EXPORT_SYMBOL(__sw_hweight32);
 
-unsigned int __arch_hweight16(unsigned int w)
+unsigned int __sw_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(__arch_hweight16);
+EXPORT_SYMBOL(__sw_hweight16);
 
-unsigned int __arch_hweight8(unsigned int w)
+unsigned int __sw_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(__arch_hweight8);
+EXPORT_SYMBOL(__sw_hweight8);
 
-unsigned long __arch_hweight64(__u64 w)
+unsigned long __sw_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return __arch_hweight32((unsigned int)(w >> 32)) +
-	       __arch_hweight32((unsigned int)w);
+	return __sw_hweight32((unsigned int)(w >> 32)) +
+	       __sw_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -57,4 +57,4 @@ unsigned long __arch_hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(__arch_hweight64);
+EXPORT_SYMBOL(__sw_hweight64);
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index f9bdf26..cbcd654 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -245,3 +245,7 @@ quiet_cmd_lzo = LZO    $@
 cmd_lzo = (cat $(filter-out FORCE,$^) | \
 	lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
 	(rm -f $@ ; false)
+
+# misc stuff
+# ---------------------------------------------------------------------------
+quote:="
-- 
1.6.4.2


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
