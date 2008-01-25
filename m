Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYAYC0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYAYC0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYAYC0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:26:23 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43052 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYAYC0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:26:23 -0500
Date: Thu, 24 Jan 2008 18:32:55 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: x86.git: mtrr trimming removes all memory under kvm
In-reply-to: <4799400C.1060102@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200801241832.55910.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 05:49:00 pm H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
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
> Looks like the code doesn't check that the CPU *has* MTRRs...

please try this

[PATCH] x86: trim RAM need to check if mtrr is there

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index a1551d0..a0b6f55 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -646,9 +646,6 @@ static __init int amd_special_default_mtrr(unsigned long end_pfn)
 {
 	u32 l, h;
 
-	/* Doesn't apply to memory < 4GB */
-	if (end_pfn <= (0xffffffff >> PAGE_SHIFT))
-		return 0;
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
@@ -682,6 +679,12 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	mtrr_type type;
 	u64 trim_start, trim_size;
 
+	/* Doesn't apply to memory < 4GB */
+	if (end_pfn <= (0xffffffffUL >> PAGE_SHIFT))
+		return 0;
+
+	if (!cpu_has_mtrr)
+		return 0;
 	/*
 	 * Make sure we only trim uncachable memory on machines that
 	 * support the Intel MTRR architecture:
