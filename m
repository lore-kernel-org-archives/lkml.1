Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab0BSOWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:22:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42549 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0BSOWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:22:04 -0500
Date: Fri, 19 Feb 2010 15:22:05 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, Borislav Petkov <bp@amd64.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100219142205.GA32533@aftab>
References: <4B743F7D.3090605@zytor.com>
 <20100212170649.GC3114@aftab>
 <4B758FC0.1020600@zytor.com>
 <20100212174751.GD3114@aftab>
 <4B75A66A.70005@zytor.com>
 <4B7BF5D6.3030701@suse.cz>
 <20100217172040.GC13429@aftab>
 <4B7C27D8.9050408@suse.cz>
 <4B7C29C1.10906@suse.cz>
 <20100218061923.GA1594@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218061923.GA1594@liondog.tnic>
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

From: Borislav Petkov <borislav.petkov@amd.com>

Add support for the hardware version of the Hamming weight function,
popcnt, present in CPUs which advertize it under CPUID, Function
0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
default lib/hweight.c sw versions.

A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
a 3x speedup on a F10h machine.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig                          |    5 ++
 arch/x86/include/asm/bitops.h             |    7 +++-
 arch/x86/lib/Makefile                     |    2 +-
 arch/x86/lib/hweight.c                    |   62 +++++++++++++++++++++++++++++
 include/asm-generic/bitops/arch_hweight.h |   22 ++++++++--
 lib/Makefile                              |    3 +
 lib/hweight.c                             |   20 +++++-----
 scripts/Makefile.lib                      |    4 ++
 8 files changed, 109 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/lib/hweight.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index eb40925..176950e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -230,6 +230,11 @@ config X86_32_LAZY_GS
 	def_bool y
 	depends on X86_32 && !CC_STACKPROTECTOR
 
+config ARCH_HWEIGHT_CFLAGS
+	string
+	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
+	default "-fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
+
 config KTIME_SCALAR
 	def_bool X86_32
 source "init/Kconfig"
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..5ec3bd8 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,7 +444,12 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
-#include <asm-generic/bitops/hweight.h>
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..e811bbd 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -22,7 +22,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_KPROBES) += insn.o inat.o
 
-obj-y += msr.o msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/hweight.c b/arch/x86/lib/hweight.c
new file mode 100644
index 0000000..54d3cb0
--- /dev/null
+++ b/arch/x86/lib/hweight.c
@@ -0,0 +1,62 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+
+#ifdef CONFIG_64BIT
+/* popcnt %rdi, %rax */
+#define POPCNT ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc7"
+#define REG_IN "D"
+#define REG_OUT "a"
+#else
+/* popcnt %eax, %eax */
+#define POPCNT ".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc0"
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
+unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call __sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+
+	return res;
+}
+EXPORT_SYMBOL(__arch_hweight32);
+
+unsigned int __arch_hweight16(unsigned int w)
+{
+	return __arch_hweight32(w & 0xffff);
+}
+EXPORT_SYMBOL(__arch_hweight16);
+
+unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight32(w & 0xff);
+}
+EXPORT_SYMBOL(__arch_hweight8);
+
+unsigned long __arch_hweight64(__u64 w)
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
+EXPORT_SYMBOL(__arch_hweight64);
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 3a7be84..1c82306 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,9 +3,23 @@
 
 #include <asm/types.h>
 
-extern unsigned int __arch_hweight32(unsigned int w);
-extern unsigned int __arch_hweight16(unsigned int w);
-extern unsigned int __arch_hweight8(unsigned int w);
-extern unsigned long __arch_hweight64(__u64 w);
+unsigned int __arch_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
 
+unsigned int __arch_hweight16(unsigned int w)
+{
+	return __sw_hweight16(w);
+}
+
+unsigned int __arch_hweight8(unsigned int w)
+{
+	return __sw_hweight8(w);
+}
+
+unsigned long __arch_hweight64(__u64 w)
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
1.6.5.4

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
