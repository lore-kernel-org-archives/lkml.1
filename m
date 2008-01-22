Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYAVBOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYAVBOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYAVBOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:14:05 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:21969 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753981AbYAVBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:14:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=UdeGW54QiX/OkgaCaRSaNbpZV/9x2j3hCxb0S3bZ0baOB4zhbwPjg1X3ugJRqWny2LVRp6ZOKKnRQDP+DVahac0kwbbinlKgite/Y2ssPsSuW7/4vsnXAoT3yEhwvvkh9eiCcs9Ag+/3gag3OLeenf4fa0Hm4raEEDKiqoCwa7k=  ;
X-YMail-OSG: _khvEhEVM1nUKURt9WwDVT05q.YeM22kOGL.wep04wehNFcGML3plskb3_OUjop6VRN7simhXw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: what's up for v2.6.25 in x86.git
Date: Tue, 22 Jan 2008 12:13:53 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080121201437.GA31469@elte.hu>
In-Reply-To: <20080121201437.GA31469@elte.hu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_RNUlHiXV1OGCkQl"
Message-Id: <200801221213.53490.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_RNUlHiXV1OGCkQl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 22 January 2008 07:14, Ingo Molnar wrote:

> Nick Piggin (5):
>       mm: fix PageUptodate memory ordering bug

This should actually be named differently. It should be
called

x86: don't unconditionally enable expensive SMP ppro workaround

I actually had a more complete patch which printed a warning if
booting such a system without the config option.

--Boundary-00=_RNUlHiXV1OGCkQl
Content-Type: text/x-diff;
  charset="iso-8859-1";
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
@@ -322,9 +322,20 @@ config X86_XADD
 	default y
 
 config X86_PPRO_FENCE
-	bool
-	depends on M686 || M586MMX || M586TSC || M586 || M486 || M386 || MGEODEGX1
-	default y
+	bool "PentiumPro memory ordering errata workaround"
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
@@ -108,6 +108,25 @@ static void __cpuinit trap_init_f00f_bug
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
+			printk(KERN_WARNING "WARNING: Pentium Pro with Errata#66, #92, #51 detected.");
+		else
+			printk(KERN_WARNING "WARNING: Pentium Pro with Errata#66, #92 detected.");
+
+		printk("running this kernel may cause inconsistent results and errors. Enable CONFIG_X86_PPRO_FENCE in your kernel config.\n");
+	}
+#endif
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
@@ -132,6 +151,8 @@ static void __cpuinit init_intel(struct 
 	}
 #endif
 
+	ppro_memory_bug();
+
 	select_idle_routine(c);
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {

--Boundary-00=_RNUlHiXV1OGCkQl--
