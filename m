Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYLJXMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYLJXMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYLJXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:12:29 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33169 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbYLJXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:12:28 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27+ kernels
From: Zachary Amsden <zach@vmware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alok Kataria <alokkataria1@gmail.com>,
       Bruno =?ISO-8859-1?Q?Pr=E9mont?= <"bruno .premont"@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-BxDEXNPo8zR8d6/w66S3"
Date: Wed, 10 Dec 2008 16:06:20 -0800
Message-Id: <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BxDEXNPo8zR8d6/w66S3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-12-09 at 17:15 -0800, Yinghai Lu wrote:

> you can not move that late,
> 
> parse_setup_data==>early_memremap==>__early_ioremap

How does this look?

--=-BxDEXNPo8zR8d6/w66S3
Content-Disposition: attachment; filename=x86-vmi-boot-ioremap-fix-take-2.patch
Content-Type: text/x-patch; name=x86-vmi-boot-ioremap-fix-take-2.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

VMI initialiation can relocate the fixmap, causing early_ioremap
to malfunction if it is initialized before the relocation.
To fix this, VMI activation is split into two phases; the detection,
which must happen before setting up ioremap, and the activation,
which must happen after parsing early boot parameters.

This fixes a crash on boot when VMI is enabled under VMware.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/x86/include/asm/vmi.h b/arch/x86/include/asm/vmi.h
index b7c0dea..31dd52d 100644
--- a/arch/x86/include/asm/vmi.h
+++ b/arch/x86/include/asm/vmi.h
@@ -224,6 +224,7 @@ struct pci_header {
 
 /* Function prototypes for bootstrapping */
 extern void vmi_init(void);
+extern void vmi_activate(void);
 extern void vmi_bringup(void);
 extern void vmi_apply_boot_page_allocations(void);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..4c381cb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -794,6 +794,11 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+#ifdef CONFIG_VMI
+	/* VMI may relocate the fixmap; do this before touching ioremap area */
+	vmi_init();
+#endif
+
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -880,12 +885,9 @@ void __init setup_arch(char **cmdline_p)
 	check_efer();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be before kernel pagetables are setup
-	 * or fixmap area is touched.
-	 */
-	vmi_init();
+#if defined(CONFIG_VMI)
+	/* Must be before kernel pagetables are setup */
+	vmi_activate();
 #endif
 
 	/* after early param, so could get panic from serial */
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 8b6c393..22fd657 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -960,8 +960,6 @@ static inline int __init activate_vmi(void)
 
 void __init vmi_init(void)
 {
-	unsigned long flags;
-
 	if (!vmi_rom)
 		probe_vmi_rom();
 	else
@@ -973,13 +971,21 @@ void __init vmi_init(void)
 
 	reserve_top_address(-vmi_rom->virtual_top);
 
-	local_irq_save(flags);
-	activate_vmi();
-
 #ifdef CONFIG_X86_IO_APIC
 	/* This is virtual hardware; timer routing is wired correctly */
 	no_timer_check = 1;
 #endif
+}
+
+void vmi_activate(void)
+{
+	unsigned long flags;
+
+	if (!vmi_rom)
+		return;
+
+	local_irq_save(flags);
+	activate_vmi();
 	local_irq_restore(flags & X86_EFLAGS_IF);
 }
 

--=-BxDEXNPo8zR8d6/w66S3--

