Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0BEML3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 07:11:29 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44856 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0BEML1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 07:11:27 -0500
Date: Fri, 5 Feb 2010 13:11:39 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100205121139.GA9044@aftab>
References: <20100203070825.e36b3932.akpm@linux-foundation.org>
 <1265210157.24455.646.camel@laptop>
 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
 <20100203181425.GB1367@aftab>
 <1265222875.24455.1020.camel@laptop>
 <4B69D362.10608@zytor.com>
 <20100204151050.GC32711@aftab>
 <1265296432.22001.18.camel@laptop>
 <20100204155419.GD32711@aftab>
 <1265299457.22001.72.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265299457.22001.72.camel@laptop>
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

On Thu, Feb 04, 2010 at 05:04:17PM +0100, Peter Zijlstra wrote:
> No, just don't touch hweight_long(), simply provide
> __arch_hweight{8,16,32,64} and all will be well.

Ok, another day, another version :)

It is, of course, completely untested but it builds and the asm looks
ok. I think I've addressed all concerns so far.

--
 arch/x86/include/asm/hweight.h       |   14 ++++++++
 arch/x86/lib/Makefile                |    2 +-
 arch/x86/lib/hweight.c               |   57 ++++++++++++++++++++++++++++++++++
 include/asm-generic/bitops/hweight.h |   45 ++++++++++++++++++++++++--
 lib/hweight.c                        |   16 +++++-----
 5 files changed, 121 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/include/asm/hweight.h
 create mode 100644 arch/x86/lib/hweight.c

diff --git a/arch/x86/include/asm/hweight.h b/arch/x86/include/asm/hweight.h
new file mode 100644
index 0000000..762125f
--- /dev/null
+++ b/arch/x86/include/asm/hweight.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_HWEIGHT_H
+#define _ASM_X86_HWEIGHT_H
+
+#define __arch_hweight8 __arch_hweight8
+#define __arch_hweight16 __arch_hweight16
+#define __arch_hweight32 __arch_hweight32
+#define __arch_hweight64 __arch_hweight64
+
+extern unsigned int __arch_hweight8(unsigned int);
+extern unsigned int __arch_hweight16(unsigned int);
+extern unsigned int __arch_hweight32(unsigned int);
+extern unsigned long __arch_hweight64(__u64);
+
+#endif /*_ASM_X86_HWEIGHT_H */
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
index 0000000..3cf51c8
--- /dev/null
+++ b/arch/x86/lib/hweight.c
@@ -0,0 +1,57 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+
+#define POPCNT32 ".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xff"
+#define POPCNT64 ".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xff"
+
+#define __arch_hweight_alt(size)	\
+	ALTERNATIVE("call _hweight"#size, POPCNT##size, X86_FEATURE_POPCNT)
+
+unsigned int __arch_hweight16(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm volatile("xor %%dh, %%dh\n\t"
+		     __arch_hweight_alt(32)
+			: "=di" (res)
+			: "di" (w)
+			: "ecx", "memory");
+
+	return res;
+}
+EXPORT_SYMBOL(__arch_hweight16);
+
+unsigned int __arch_hweight8(unsigned int w)
+{
+	return __arch_hweight16(w & 0xff);
+}
+EXPORT_SYMBOL(__arch_hweight8);
+
+unsigned int __arch_hweight32(unsigned int w)
+{
+	unsigned int res = 0;
+
+	asm volatile(__arch_hweight_alt(32)
+			: "=di" (res)
+			: "di" (w)
+			: "ecx", "memory");
+
+	return res;
+
+}
+EXPORT_SYMBOL(__arch_hweight32);
+
+unsigned long __arch_hweight64(__u64 w)
+{
+	unsigned int res = 0;
+
+	asm volatile(__arch_hweight_alt(64)
+			: "=di" (res)
+			: "di" (w)
+			: "rsi", "rcx", "r8", "r9", "r10", "r11",
+			  "memory");
+
+	return res;
+}
+EXPORT_SYMBOL(__arch_hweight64);
diff --git a/include/asm-generic/bitops/hweight.h b/include/asm-generic/bitops/hweight.h
index fbbc383..340ad4e 100644
--- a/include/asm-generic/bitops/hweight.h
+++ b/include/asm-generic/bitops/hweight.h
@@ -2,10 +2,47 @@
 #define _ASM_GENERIC_BITOPS_HWEIGHT_H_
 
 #include <asm/types.h>
+#include <asm/hweight.h>
 
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+extern unsigned int _hweight32(unsigned int w);
+extern unsigned int _hweight16(unsigned int w);
+extern unsigned int _hweight8(unsigned int w);
+extern unsigned long _hweight64(__u64 w);
+
+static inline unsigned int hweight8(unsigned int w)
+{
+#ifdef __arch_hweight8
+	return __arch_hweight8(w);
+#else
+	return _hweight8(w);
+#endif
+}
+
+static inline unsigned int hweight16(unsigned int w)
+{
+#ifdef __arch_hweight16
+	return __arch_hweight16(w);
+#else
+	return _hweight16(w);
+#endif
+}
+
+static inline unsigned int hweight32(unsigned int w)
+{
+#ifdef __arch_hweight32
+	return __arch_hweight32(w);
+#else
+	return _hweight32(w);
+#endif
+}
+
+static inline unsigned long hweight64(__u64 w)
+{
+#ifdef __arch_hweight64
+	return __arch_hweight64(w);
+#else
+	return _hweight64(w);
+#endif
+}
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/lib/hweight.c b/lib/hweight.c
index 389424e..f7b81a1 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int _hweight32(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
@@ -17,26 +17,26 @@ unsigned int hweight32(unsigned int w)
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
 }
-EXPORT_SYMBOL(hweight32);
+EXPORT_SYMBOL(_hweight32);
 
-unsigned int hweight16(unsigned int w)
+unsigned int _hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(hweight16);
+EXPORT_SYMBOL(_hweight16);
 
-unsigned int hweight8(unsigned int w)
+unsigned int _hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(hweight8);
+EXPORT_SYMBOL(_hweight8);
 
-unsigned long hweight64(__u64 w)
+unsigned long _hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
 	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
@@ -56,4 +56,4 @@ unsigned long hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(hweight64);
+EXPORT_SYMBOL(_hweight64);
-- 
1.6.4.2


-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
