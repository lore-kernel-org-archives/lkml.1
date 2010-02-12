Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0BLRGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 12:06:55 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44016 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab0BLRGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 12:06:52 -0500
Date: Fri, 12 Feb 2010 18:06:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100212170649.GC3114@aftab>
References: <1265299457.22001.72.camel@laptop>
 <20100205121139.GA9044@aftab>
 <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
 <20100208095945.GA14740@a1.tnic>
 <20100211172424.GB19779@aftab>
 <4B743F7D.3090605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B743F7D.3090605@zytor.com>
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

On Thu, Feb 11, 2010 at 09:33:49AM -0800, H. Peter Anvin wrote:
> You don't do the push/pop inline -- if you're going to take the hit of
> pushing this into the caller, it's better to list them as explicit
> clobbers and let the compiler figure out how to do it.  The point of
> doing an explicit push/pop is that it can be pushed into the out-of-line
> subroutine.

Doh! Of course, this was wrong. See below.

> Furthermore, you're still putting "volatile" on there... this is a pure
> computation -- no side effects -- so it is exactly when you *shouldn't*
> declare your asm statement volatile.

Also gone.

> Note: given how simple and regular a popcnt actually is, it might be
> preferrable to have the out-of-line implementation either in assembly,
> or using gcc's -fcall-saved-* options to reduce the number of registers
> that is clobbered by the routine.

Yep, this is actually a very good idea. And it seems to work, I've
tested it on an F10, K8 and even on an Atom and no blow ups so far...

---
 arch/alpha/include/asm/bitops.h            |    4 ++
 arch/ia64/include/asm/bitops.h             |    1 +
 arch/sparc/include/asm/bitops_64.h         |    4 ++
 arch/x86/include/asm/bitops.h              |   10 ++++
 arch/x86/lib/Makefile                      |    8 +++-
 arch/x86/lib/hweight.c                     |   72 ++++++++++++++++++++++++++++
 include/asm-generic/bitops/arch_hweight.h  |    8 ++--
 include/asm-generic/bitops/const_hweight.h |   43 +++++++++++++++--
 lib/hweight.c                              |   20 ++++----
 9 files changed, 151 insertions(+), 19 deletions(-)
 create mode 100644 arch/x86/lib/hweight.c

diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index 296da1d..7fe6943 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -409,21 +409,25 @@ static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
+#define __arch_hweight64 __arch_hweight64
 
 static inline unsigned int __arch_weight32(unsigned int w)
 {
 	return __arch_hweight64(w);
 }
+#define __arch_hweight32 __arch_hweight32
 
 static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	return __arch_hweight64(w & 0xffff);
 }
+#define __arch_hweight16 __arch_hweight16
 
 static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	return __arch_hweight64(w & 0xff);
 }
+#define __arch_hweight8 __arch_hweight8
 #else
 #include <asm-generic/bitops/arch_hweight.h>
 #endif
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 9da3df6..9b64f59 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -443,6 +443,7 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 	result = ia64_popcnt(x);
 	return result;
 }
+#define __arch_hweight64 __arch_hweight64
 
 #define __arch_hweight32(x) ((unsigned int) __arch_hweight64((x) & 0xfffffffful))
 #define __arch_hweight16(x) ((unsigned int) __arch_hweight64((x) & 0xfffful))
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 766121a..4982bc4 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -51,6 +51,7 @@ static inline unsigned int __arch_hweight64(unsigned long w)
 	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w));
 	return res;
 }
+#define __arch_hweight64 __arch_hweight64
 
 static inline unsigned int __arch_hweight32(unsigned int w)
 {
@@ -59,6 +60,7 @@ static inline unsigned int __arch_hweight32(unsigned int w)
 	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xffffffff));
 	return res;
 }
+#define __arch_hweight32 __arch_hweight32
 
 static inline unsigned int __arch_hweight16(unsigned int w)
 {
@@ -67,6 +69,7 @@ static inline unsigned int __arch_hweight16(unsigned int w)
 	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xffff));
 	return res;
 }
+#define __arch_hweight16 __arch_hweight16
 
 static inline unsigned int __arch_hweight8(unsigned int w)
 {
@@ -75,6 +78,7 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 	__asm__ ("popc %1,%0" : "=r" (res) : "r" (w & 0xff));
 	return res;
 }
+#define __arch_hweight8 __arch_hweight8
 
 #else
 
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..187defe 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -444,6 +444,16 @@ static inline int fls(int x)
 
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
+
+#define __arch_hweight32 __arch_hweight32
+#define __arch_hweight16 __arch_hweight16
+#define __arch_hweight8 __arch_hweight8
+#define __arch_hweight64 __arch_hweight64
+
 #include <asm-generic/bitops/hweight.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..ddc32eb 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -22,9 +22,11 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_KPROBES) += insn.o inat.o
 
-obj-y += msr.o msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 
 ifeq ($(CONFIG_X86_32),y)
+	CFLAGS_hweight.o = -fcall-saved-ecx -fcall-saved-edx
+
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
@@ -34,6 +36,10 @@ ifneq ($(CONFIG_X86_CMPXCHG64),y)
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
+	CFLAGS_hweight.o = -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx \
+			   -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 \
+			   -fcall-saved-r11
+
         obj-y += io_64.o iomap_copy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
diff --git a/arch/x86/lib/hweight.c b/arch/x86/lib/hweight.c
new file mode 100644
index 0000000..9b4bfa5
--- /dev/null
+++ b/arch/x86/lib/hweight.c
@@ -0,0 +1,72 @@
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
+ * Those are called out-of-line in the alternative below and are added here only
+ * so that gcc is able to figure out which registers have been clobbered by
+ * __sw_hweightXX so that it could restore their values before returning from
+ * the __arch_hweightXX versions. See also <arch/x86/lib/Makefile>.
+ */
+unsigned int _sw_hweight32(unsigned int w)
+{
+	return __sw_hweight32(w);
+}
+
+unsigned long _sw_hweight64(__u64 w)
+{
+	return __sw_hweight64(w);
+}
+
+unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm (ALTERNATIVE("call _sw_hweight32", POPCNT, X86_FEATURE_POPCNT)
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
+	asm (ALTERNATIVE("call _sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
+		     : "="REG_OUT (res)
+		     : REG_IN (w));
+#endif /* CONFIG_X86_32 */
+
+	return res;
+}
+EXPORT_SYMBOL(__arch_hweight64);
diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
index 3a7be84..c72de8b 100644
--- a/include/asm-generic/bitops/arch_hweight.h
+++ b/include/asm-generic/bitops/arch_hweight.h
@@ -3,9 +3,9 @@
 
 #include <asm/types.h>
 
-extern unsigned int __arch_hweight32(unsigned int w);
-extern unsigned int __arch_hweight16(unsigned int w);
-extern unsigned int __arch_hweight8(unsigned int w);
-extern unsigned long __arch_hweight64(__u64 w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b..8cf8169 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -18,13 +18,48 @@
 #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
 #define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
 
+static inline unsigned int _hweight8(unsigned int w)
+{
+#ifdef __arch_hweight8
+       return __arch_hweight8(w);
+#else
+       return __sw_hweight8(w);
+#endif
+}
+
+static inline unsigned int _hweight16(unsigned int w)
+{
+#ifdef __arch_hweight16
+       return __arch_hweight16(w);
+#else
+       return __sw_hweight16(w);
+#endif
+}
+
+static inline unsigned int _hweight32(unsigned int w)
+{
+#ifdef __arch_hweight32
+       return __arch_hweight32(w);
+#else
+       return __sw_hweight32(w);
+#endif
+}
+
+static inline unsigned long _hweight64(__u64 w)
+{
+#ifdef __arch_hweight64
+       return __arch_hweight64(w);
+#else
+       return __sw_hweight64(w);
+#endif
+}
 /*
  * Generic interface.
  */
-#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))
-#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
-#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
-#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
+#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : _hweight8(w))
+#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : _hweight16(w))
+#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : _hweight32(w))
+#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : _hweight64(w))
 
 /*
  * Interface for known constant arguments
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
-- 
1.6.6.1


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
