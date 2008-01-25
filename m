Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbYAYIsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbYAYIsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbYAYIg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:36:26 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62509 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbYAYIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:36:21 -0500
Date: Fri, 25 Jan 2008 00:42:52 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: trim ram need to check if mtrr is there v3
In-reply-to: <4799930B.40006@goop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801250042.53074.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com>
 <4799930B.40006@goop.org>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: trim ram need to check if mtrr is there v3

> >Jeremy Fitzhardinge wrote:
> > When booting a current x86.git kernel under kvm, I get this:
> > 
> > (qemu) Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925 
> > (Red Hat 4.1.2-33)) #1928 SMP PREEMPT Thu Jan 24 17:09:04 PST 2008
> > early_ioremap_init()
> > BIOS-provided physical RAM map:
> > BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> > BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> > BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> > BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
> > BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
> > BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> > console [earlyser0] enabled
> > 0MB HIGHMEM available.
> > 511MB LOWMEM available.
> > Scan SMP from c0000000 for 1024 bytes.
> > Scan SMP from c009fc00 for 1024 bytes.
> > Scan SMP from c00f0000 for 65536 bytes.
> > Scan SMP from c009fc00 for 1024 bytes.
> > ***************
> > **** WARNING: likely BIOS bug
> > **** MTRRs don't cover all of memory, trimmed 131056 pages
> > ***************
> 
> H. Peter Anvin wrote:
> Looks like the code doesn't check that the CPU *has* MTRRs...

so more strict check if mtrr is there really.
bail out if mtrr all blank when qemu cpu model is used

and check if is AMD as early
also remove 4G less check, according to hpa.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -642,13 +642,10 @@ early_param("disable_mtrr_trim", disable
 #define Tom2Enabled (1U << 21)
 #define Tom2ForceMemTypeWB (1U << 22)
 
-static __init int amd_special_default_mtrr(unsigned long end_pfn)
+static __init int amd_special_default_mtrr(void)
 {
 	u32 l, h;
 
-	/* Doesn't apply to memory < 4GB */
-	if (end_pfn <= (0xffffffff >> PAGE_SHIFT))
-		return 0;
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
@@ -686,9 +683,14 @@ int __init mtrr_trim_uncached_memory(uns
 	 * Make sure we only trim uncachable memory on machines that
 	 * support the Intel MTRR architecture:
 	 */
+	if (!is_cpu(INTEL) || disable_mtrr_trim)
+		return 0;
 	rdmsr(MTRRdefType_MSR, def, dummy);
 	def &= 0xff;
-	if (!is_cpu(INTEL) || disable_mtrr_trim || def != MTRR_TYPE_UNCACHABLE)
+	if (def != MTRR_TYPE_UNCACHABLE)
+		return 0;
+
+	if (amd_special_default_mtrr())
 		return 0;
 
 	/* Find highest cached pfn */
@@ -702,8 +704,14 @@ int __init mtrr_trim_uncached_memory(uns
 			highest_addr = base + size;
 	}
 
-	if (amd_special_default_mtrr(end_pfn))
+	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
+	if (!highest_addr) {
+		printk(KERN_WARNING "***************\n");
+		printk(KERN_WARNING "**** WARNING: likely strange cpu\n");
+		printk(KERN_WARNING "**** MTRRs all blank, cpu in qemu?\n");
+		printk(KERN_WARNING "***************\n");
 		return 0;
+	}
 
 	if ((highest_addr >> PAGE_SHIFT) < end_pfn) {
 		printk(KERN_WARNING "***************\n");
