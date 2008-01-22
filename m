Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYAVB2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYAVB2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYAVB2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:28:30 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:39778 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751483AbYAVB23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:28:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=nSowLyx4jzIhzDFkgIblAL9ZcFWS0GCGr3l9mNWhUPYe1PLvTOFEWfCApiPa4lxSlkR1Qi3jiGAFfZQwFqdoiXCTgkkq5RCPJ7PyypCukzeQv3V2fYP/jw7G3r/6OhrMLzQGtoHBBDnjEGFTyzuOhLaN/iBCRmnpxPkN3s+PGPc=  ;
X-YMail-OSG: rnPATNEVM1lLMOWf3Fk6xFalLMGB74j76vg6w6fr0Iu.8ylWY0cfPcgTVa1f4tzdWMSTEzEEgA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: what's up for v2.6.25 in x86.git
Date: Tue, 22 Jan 2008 12:28:21 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080121201437.GA31469@elte.hu> <200801221213.53490.nickpiggin@yahoo.com.au>
In-Reply-To: <200801221213.53490.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1aUlHYjLMpLn1wz"
Message-Id: <200801221228.21404.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1aUlHYjLMpLn1wz
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 22 January 2008 12:13, Nick Piggin wrote:
> On Tuesday 22 January 2008 07:14, Ingo Molnar wrote:
> > Nick Piggin (5):
> >       mm: fix PageUptodate memory ordering bug
>
> This should actually be named differently. It should be
> called
>
> x86: don't unconditionally enable expensive SMP ppro workaround
>
> I actually had a more complete patch which printed a warning if
> booting such a system without the config option.

Ah sorry, here is a refreshed version

--Boundary-00=_1aUlHYjLMpLn1wz
Content-Type: text/x-diff;
  charset="utf-8";
  name="x86-no-ppro-fence.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="x86-no-ppro-fence.patch"

The selection of many CPU architecture families causes pentium pro memory
ordering errata workarounds to be enabled. This causes memory barriers and
spinlocks to become much more expensive, just to provide a few hacks for a very
rare (nowadays) class of system.

Just print a warning if such a machine is detected. Also suggest a new CONFIG option that can be enabled to support such CPUs.

This saves nearly 1KB of icache in mm/ alone.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/arch/x86/Kconfig.cpu
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig.cpu
+++ linux-2.6/arch/x86/Kconfig.cpu
@@ -322,9 +322,21 @@ config X86_XADD
 	default y
 
 config X86_PPRO_FENCE
-	bool
+	bool "PentiumPro memory ordering errata workaround"
 	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
-	default y
+	default n
+	help
+         Old PentiumPro multiprocessor systems had errata that could cause
+         memory operations to violate the x86 ordering standard in rare cases.
+         Enabling this option will attempt to work around some (but not all)
+         occurances of these problems, at the cost of much heavier spinlock
+         and memory barrier operations.
+
+         If you say N here, these systems will be detected and limited to a
+         single CPU at boot time.
+
+         If unsure, say N here. Even distro kernels should think twice before
+         enabling this: there are few systems, and an unlikely bug.
 
 config X86_F00F_BUG
 	bool
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -108,6 +108,32 @@ static void __cpuinit trap_init_f00f_bug
 }
 #endif
 
+/*
+ * Errata #66, #92, #51
+ */
+static void __cpuinit ppro_memory_bug(void)
+{
+#ifndef CONFIG_X86_PPRO_FENCE
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	    boot_cpu_data.x86 == 6 &&
+	    boot_cpu_data.x86_model == 1) {
+		if (boot_cpu_data.x86_mask < 8)
+			printk(KERN_WARNING "WARNING: Pentium Pro with "
+			 "Errata#66, #92, #51 detected. Running this kernel "
+			 "may cause inconsistent results. "
+			 "Enable CONFIG_X86_PPRO_FENCE.\n");
+
+#ifdef CONFIG_SMP
+		else
+			printk(KERN_WARNING "WARNING: Pentium Pro with "
+			 "Errata#66, #92, #51 detected. Running this kernel "
+			 "in an SMP system may cause inconsistent results. "
+			 "Enable CONFIG_X86_PPRO_FENCE if using SMP system.\n");
+#endif
+	}
+#endif
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
@@ -132,6 +158,8 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
+	ppro_memory_bug();
+
 	select_idle_routine(c);
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {

--Boundary-00=_1aUlHYjLMpLn1wz--
