Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0BDPKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:10:43 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40811 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab0BDPKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:10:41 -0500
Date: Thu, 4 Feb 2010 16:10:50 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100204151050.GC32711@aftab>
References: <20100130094515.475881280@intel.com>
 <20100130094957.692671259@intel.com>
 <20100201124825.cc024f2a.akpm@linux-foundation.org>
 <20100203133951.GA24357@localhost>
 <20100203070825.e36b3932.akpm@linux-foundation.org>
 <1265210157.24455.646.camel@laptop>
 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
 <20100203181425.GB1367@aftab>
 <1265222875.24455.1020.camel@laptop>
 <4B69D362.10608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B69D362.10608@zytor.com>
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

On Wed, Feb 03, 2010 at 11:49:54AM -0800, H. Peter Anvin wrote:
> On 02/03/2010 10:47 AM, Peter Zijlstra wrote:
> > On Wed, 2010-02-03 at 19:14 +0100, Borislav Petkov wrote:
> > 
> >> alternative("call hweightXX", "popcnt", X86_FEATURE_POPCNT)
> > 
> > Make sure to apply a 0xff bitmask to the popcnt r16 call for hweight8(),
> > and hweight64() needs a bit of magic for 32bit, but yes, something like
> > that ought to work nicely.
> > 
> 
> Arguably the "best" option is to have the alternative being a jump to an
> out-of-line stub which does the necessary parameter marshalling before
> calling a stub.  This technique is already used in a few other places.

Ok, here's a first alpha prototype and completely untested. The asm
output looks ok though. I've added separate 32-bit and 64-bit helpers in
order to dispense with the if-else tests. The hw-popcnt versions are the
opcodes for "popcnt %eax, %eax" and "popcnt %rax, %rax", respectively,
so %rAX has to be preloaded with the bitmask and the computed value
has to be retrieved from there afterwards. And yes, it looks not that
elegant so I'm open for suggestions.

The good thing is, this should work on any toolchain since we don't rely
on the compiler to know about popcnt and we're protected by CPUID flag
so that the hw-popcnt version is used only on processors which support
it.

Please take a good look and let me know what do you guys think.

Thanks.

--
 arch/x86/include/asm/bitops.h |    4 ++
 arch/x86/lib/Makefile         |    2 +-
 arch/x86/lib/popcnt.c         |   62 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/lib/popcnt.c

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..deb5013 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -434,6 +434,10 @@ static inline int fls(int x)
 #endif
 	return r + 1;
 }
+
+
+extern int arch_hweight_long(unsigned long);
+
 #endif /* __KERNEL__ */
 
 #undef ADDR
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..c03fe2d 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -22,7 +22,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_KPROBES) += insn.o inat.o
 
-obj-y += msr.o msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o popcnt.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/popcnt.c b/arch/x86/lib/popcnt.c
new file mode 100644
index 0000000..179a6e8
--- /dev/null
+++ b/arch/x86/lib/popcnt.c
@@ -0,0 +1,62 @@
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+
+int _hweight32(void)
+{
+	unsigned long w;
+
+	asm volatile("" : "=a" (w));
+
+	return hweight32(w);
+}
+
+int _hweight64(void)
+{
+	unsigned long w;
+
+	asm volatile("" : "=a" (w));
+
+	return hweight64(w);
+}
+
+int _popcnt32(void)
+{
+
+	unsigned long w;
+
+	asm volatile(".byte 0xf3\n\t.byte 0x0f\n\t.byte 0xb8\n\t.byte 0xc0\n\t"
+			: "=a" (w));
+
+	return w;
+}
+
+int _popcnt64(void)
+{
+
+	unsigned long w;
+
+	asm volatile(".byte 0xf3\n\t.byte 0x48\n\t.byte 0x0f\n\t."
+		     "byte 0xb8\n\t.byte 0xc0\n\t"
+		     : "=a" (w));
+
+	return w;
+}
+
+int arch_hweight_long(unsigned long w)
+{
+	if (sizeof(w) == 4) {
+		asm volatile("movl %[w], %%eax" :: [w] "r" (w));
+		alternative("call _hweight32",
+			    "call _popcnt32",
+			    X86_FEATURE_POPCNT);
+		asm volatile("" : "=a" (w));
+
+	} else {
+		asm volatile("movq %[w], %%rax" :: [w] "r" (w));
+		alternative("call _hweight64",
+			    "call _popcnt64",
+			    X86_FEATURE_POPCNT);
+		asm volatile("" : "=a" (w));
+	}
+	return w;
+}
-- 
1.6.6

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
