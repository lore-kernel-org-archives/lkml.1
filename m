Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIRJaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIRJaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYIRJa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:30:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24872 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYIRJa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:30:27 -0400
Message-Id: <48D23BF6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Thu, 18 Sep 2008 10:31:02 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com>
 <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu>
In-Reply-To: <20080918091003.GA3751@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 18.09.08 11:10 >>>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use 
>> > the former in ioremap's phys_addr_valid() check also on 32bit/PAE.
>> > 
>> > Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
>> applied to tip/x86/core, thanks Jan.
>
>hm, this commit quickly broke a -tip testsystem. The system booted up 
>fine but had no networking afterwards. (the eth0 interface came up fine 
>but no interrupts were emitted)
>
>i've pushed out the bad tree into tip/tmp.virt_bits.bad. The bad config 
>is attached.
>
>just check out tip/tmp.virt_bits.bad, boot into the kernel and see 
>forcedeth networking break (if you have a box with forcedeth). It's 
>reproducible. I've attached a 'good' and a 'bad' boot log as well.

I'm really sorry for that, yet another merge oversight (not caught because
only re-tested on x86-64). Here's a better one.

********************************************************

Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
former in ioremap's phys_addr_valid() check also on 32bit/PAE.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/common.c |   17 +++++++++++++++--
 arch/x86/mm/ioremap.c        |   17 ++++++++---------
 include/asm-x86/processor.h  |    4 ++--
 3 files changed, 25 insertions(+), 13 deletions(-)

--- linux-tip.orig/arch/x86/kernel/cpu/common.c
+++ linux-tip/arch/x86/kernel/cpu/common.c
@@ -439,6 +439,11 @@ void __cpuinit cpu_detect(struct cpuinfo
 			c->x86_cache_alignment = c->x86_clflush_size;
 		}
 	}
+
+#ifdef CONFIG_X86_32
+	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
+		c->x86_phys_bits = 36;
+#endif
 }
 
 static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
@@ -464,14 +469,18 @@ static void __cpuinit get_cpu_cap(struct
 		}
 	}
 
-#ifdef CONFIG_X86_64
 	if (c->extended_cpuid_level >= 0x80000008) {
 		u32 eax = cpuid_eax(0x80000008);
 
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
+		/* CPUID workaround for Intel 0F33/0F34 CPU */
+		if (c->x86_vendor == X86_VENDOR_INTEL
+		    && c->x86 == 0xF && c->x86_model == 0x3
+		    && (c->x86_mask == 0x3
+			|| c->x86_mask == 0x4))
+			c->x86_phys_bits = 36;
 	}
-#endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
@@ -519,6 +528,8 @@ static void __init early_identify_cpu(st
 	c->x86_clflush_size = 64;
 #else
 	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 
@@ -641,6 +652,8 @@ static void __cpuinit identify_cpu(struc
 #else
 	c->cpuid_level = -1;	/* CPUID not detected */
 	c->x86_clflush_size = 32;
+	c->x86_phys_bits = 32;
+	c->x86_virt_bits = 32;
 #endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
--- linux-tip.orig/arch/x86/mm/ioremap.c
+++ linux-tip/arch/x86/mm/ioremap.c
@@ -22,13 +22,17 @@
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
 
-#ifdef CONFIG_X86_64
-
-static inline int phys_addr_valid(unsigned long addr)
+static inline int phys_addr_valid(resource_size_t addr)
 {
-	return addr < (1UL << boot_cpu_data.x86_phys_bits);
+#ifdef CONFIG_RESOURCES_64BIT
+	return !(addr >> boot_cpu_data.x86_phys_bits);
+#else
+	return 1;
+#endif
 }
 
+#ifdef CONFIG_X86_64
+
 unsigned long __phys_addr(unsigned long x)
 {
 	if (x >= __START_KERNEL_map) {
@@ -47,11 +51,6 @@ EXPORT_SYMBOL(__phys_addr);
 
 #else
 
-static inline int phys_addr_valid(unsigned long addr)
-{
-	return 1;
-}
-
 #ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
--- linux-tip.orig/include/asm-x86/processor.h
+++ linux-tip/include/asm-x86/processor.h
@@ -74,9 +74,9 @@ struct cpuinfo_x86 {
 #else
 	/* Number of 4K pages in DTLB/ITLB combined(in pages): */
 	int			 x86_tlbsize;
-	__u8			x86_virt_bits;
-	__u8			x86_phys_bits;
 #endif
+	u8			x86_virt_bits;
+	u8			x86_phys_bits;
 	/* CPUID returned core id bits: */
 	__u8			x86_coreid_bits;
 	/* Max extended CPUID function supported: */


