Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbXBTAU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbXBTAU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbXBTAUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:20:34 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36066 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbXBTAHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:14 -0500
Date: Tue, 20 Feb 2007 01:07:13 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: [-mm patch] {rd,wr}msr_on_cpu SMP=n optimization
Message-ID: <20070220000713.GP13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +rdmsr_on_cpu-wrmsr_on_cpu.patch
>...
>  x86 updates
>...

Let's save a few bytes in the CONFIG_SMP=n case.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: currently -ENOUSERS

 arch/i386/lib/Makefile     |    2 +-
 arch/i386/lib/msr-on-cpu.c |   12 ------------
 arch/x86_64/lib/Makefile   |    3 ++-
 include/asm-i386/msr.h     |   11 +++++++++++
 include/asm-x86_64/msr.h   |   11 +++++++++++
 5 files changed, 25 insertions(+), 14 deletions(-)

--- linux-2.6.20-mm1/arch/i386/lib/Makefile.old	2007-02-16 14:13:20.000000000 +0100
+++ linux-2.6.20-mm1/arch/i386/lib/Makefile	2007-02-16 14:14:22.000000000 +0100
@@ -8,4 +8,4 @@
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
 
-obj-y = msr-on-cpu.o
+obj-$(CONFIG_SMP)	+= msr-on-cpu.o
--- linux-2.6.20-mm1/arch/x86_64/lib/Makefile.old	2007-02-16 14:13:52.000000000 +0100
+++ linux-2.6.20-mm1/arch/x86_64/lib/Makefile	2007-02-16 14:14:14.000000000 +0100
@@ -4,7 +4,8 @@
 
 CFLAGS_csum-partial.o := -funroll-loops
 
-obj-y := io.o iomap_copy.o msr-on-cpu.o
+obj-y := io.o iomap_copy.o
+obj-$(CONFIG_SMP)	+= msr-on-cpu.o
 
 lib-y := csum-partial.o csum-copy.o csum-wrappers.o delay.o \
 	usercopy.o getuser.o putuser.o  \
--- linux-2.6.20-mm1/include/asm-i386/msr.h.old	2007-02-16 14:14:43.000000000 +0100
+++ linux-2.6.20-mm1/include/asm-i386/msr.h	2007-02-16 14:16:00.000000000 +0100
@@ -83,8 +83,19 @@
 			  : "c" (counter))
 #endif	/* !CONFIG_PARAVIRT */
 
+#ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+#else  /*  CONFIG_SMP  */
+static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	rdmsr(msr_no, *l, *h);
+}
+static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	wrmsr(msr_no, l, h);
+}
+#endif  /*  CONFIG_SMP  */
 
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
--- linux-2.6.20-mm1/include/asm-x86_64/msr.h.old	2007-02-16 14:16:12.000000000 +0100
+++ linux-2.6.20-mm1/include/asm-x86_64/msr.h	2007-02-16 14:16:50.000000000 +0100
@@ -160,8 +160,19 @@
 #define MSR_IA32_UCODE_WRITE		0x79
 #define MSR_IA32_UCODE_REV		0x8b
 
+#ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+#else  /*  CONFIG_SMP  */
+static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	rdmsr(msr_no, *l, *h);
+}
+static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	wrmsr(msr_no, l, h);
+}
+#endif  /*  CONFIG_SMP  */
 
 #endif
 
--- linux-2.6.20-mm1/arch/i386/lib/msr-on-cpu.c.old	2007-02-16 14:17:06.000000000 +0100
+++ linux-2.6.20-mm1/arch/i386/lib/msr-on-cpu.c	2007-02-16 14:17:49.000000000 +0100
@@ -3,7 +3,6 @@
 #include <linux/smp.h>
 #include <asm/msr.h>
 
-#ifdef CONFIG_SMP
 struct msr_info {
 	u32 msr_no;
 	u32 l, h;
@@ -54,17 +53,6 @@
 	}
 	preempt_enable();
 }
-#else
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	rdmsr(msr_no, *l, *h);
-}
-
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	wrmsr(msr_no, l, h);
-}
-#endif
 
 EXPORT_SYMBOL(rdmsr_on_cpu);
 EXPORT_SYMBOL(wrmsr_on_cpu);
