Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYLKV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYLKV3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYLKV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:29:22 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:52115 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221AbYLKV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:29:21 -0500
Subject: Re: [PATCH] Fix VMI crash on boot in 2.6.27, 2.6.28 kernels
From: Zachary Amsden <zach@vmware.com>
To: Greg KH <gregkh@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Huang Ying <ying.huang@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "norman@thebacks.co.uk" <norman@thebacks.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <alokkataria1@gmail.com>,
       "bruno.premont@restena.lu" <bruno.premont@restena.lu>,
       "xl@xlsigned.net" <xl@xlsigned.net>, "dsd@gentoo.org" <dsd@gentoo.org>
In-Reply-To: <20081211033105.GA31972@suse.de>
References: <1228870222.8766.15.camel@bodhitayantram.eng.vmware.com>
	 <86802c440812091715r775d514eh3acf9add9e24184e@mail.gmail.com>
	 <1228953980.8766.42.camel@bodhitayantram.eng.vmware.com>
	 <49405CB6.6010006@kernel.org>  <20081211033105.GA31972@suse.de>
Content-Type: multipart/mixed; boundary="=-pEoLuG3kFwTEU5VIW37q"
Date: Thu, 11 Dec 2008 14:23:11 -0800
Message-Id: <1229034191.8766.63.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pEoLuG3kFwTEU5VIW37q
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-12-10 at 19:31 -0800, Greg KH wrote:

> > +#ifdef CONFIG_VMI
> > +	/* VMI may relocate the fixmap; do this before touching ioremap area */
> > +	vmi_init();
> > +#endif
> 
> Shouldn't the #ifdef not be needed here if the .h files are set up
> properly for the vmi_init prototype?  Please try to keep them out of .c
> files wherever possible.

Yes, they should.  Judging by setup.c though, you would think the
opposite... in any case I fixed it.  Please apply - and yes, I tested
compile both ways.

--=-pEoLuG3kFwTEU5VIW37q
Content-Disposition: attachment; filename=x86-vmi-boot-ioremap-fix-take-3.patch
Content-Type: text/x-patch; name=x86-vmi-boot-ioremap-fix-take-3.patch; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

VMI initialiation can relocate the fixmap, causing early_ioremap
to malfunction if it is initialized before the relocation.
To fix this, VMI activation is split into two phases; the detection,
which must happen before setting up ioremap, and the activation,
which must happen after parsing early boot parameters.

This fixes a crash on boot when VMI is enabled under VMware.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/x86/include/asm/vmi.h b/arch/x86/include/asm/vmi.h
index b7c0dea..128958a 100644
--- a/arch/x86/include/asm/vmi.h
+++ b/arch/x86/include/asm/vmi.h
@@ -223,9 +223,15 @@ struct pci_header {
 } __attribute__((packed));
 
 /* Function prototypes for bootstrapping */
+#ifdef CONFIG_VMI
 extern void vmi_init(void);
+extern void vmi_activate(void);
 extern void vmi_bringup(void);
-extern void vmi_apply_boot_page_allocations(void);
+#else
+#define vmi_init()
+#define vmi_activate()
+#define vmi_bringup()
+#endif
 
 /* State needed to start an application processor in an SMP system. */
 struct vmi_ap_state {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..bdec76e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -794,6 +794,9 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	/* VMI may relocate the fixmap; do this before touching ioremap area */
+	vmi_init();
+
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -880,13 +883,8 @@ void __init setup_arch(char **cmdline_p)
 	check_efer();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be before kernel pagetables are setup
-	 * or fixmap area is touched.
-	 */
-	vmi_init();
-#endif
+	/* Must be before kernel pagetables are setup */
+	vmi_activate();
 
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7b10933..f71f96f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -294,9 +294,7 @@ static void __cpuinit start_secondary(void *unused)
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
-#ifdef CONFIG_VMI
 	vmi_bringup();
-#endif
 	cpu_init();
 	preempt_disable();
 	smp_callin();
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
 

--=-pEoLuG3kFwTEU5VIW37q--

