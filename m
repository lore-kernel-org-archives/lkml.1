Return-Path: <linux-kernel-owner+w=401wt.eu-S934886AbZDIPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934886AbZDIPsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934916AbZDIPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:47:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbZDIPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:47:49 -0400
Date: Thu, 9 Apr 2009 17:47:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090409154736.GA20896@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86: DMI match for the Dell DXP061 as it needs BIOS reboot

David Woodhouse (1):
      x86, intel-iommu: fix X2APIC && !ACPI build failure

H. Peter Anvin (1):
      x86, setup: un-resequence mode setting for VGA 80x34 and 80x60 modes

Hidetoshi Seto (1):
      x86: smarten /proc/interrupts output for new counters

Jaswinder Singh Rajput (1):
      x86: cpu_debug remove execute permission

Yinghai Lu (1):
      x86: make 64 bit to use default_inquire_remote_apic


 arch/x86/Kconfig                    |    6 +-----
 arch/x86/boot/video-vga.c           |   33 +++++++++++++++++++++++----------
 arch/x86/kernel/apic/apic_flat_64.c |    4 ++--
 arch/x86/kernel/irq.c               |    2 +-
 arch/x86/kernel/reboot.c            |    8 ++++++++
 5 files changed, 35 insertions(+), 18 deletions(-)
 mode change 100755 => 100644 arch/x86/include/asm/cpu_debug.h
 mode change 100755 => 100644 arch/x86/kernel/cpu/cpu_debug.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4b34082..bc25b9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -252,17 +252,13 @@ config SMP
 
 config X86_X2APIC
 	bool "Support x2apic"
-	depends on X86_LOCAL_APIC && X86_64
-	select INTR_REMAP
+	depends on X86_LOCAL_APIC && X86_64 && INTR_REMAP
 	---help---
 	  This enables x2apic support on CPUs that have this feature.
 
 	  This allows 32-bit apic IDs (so it can support very large systems),
 	  and accesses the local apic via MSRs not via mmio.
 
-	  ( On certain CPU models you may need to enable INTR_REMAP too,
-	    to get functional x2apic mode. )
-
 	  If you don't know what to do here, say N.
 
 config SPARSE_IRQ
diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index 95d86ce..9e0587a 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -129,22 +129,18 @@ u16 vga_crtc(void)
 	return (inb(0x3cc) & 1) ? 0x3d4 : 0x3b4;
 }
 
-static void vga_set_480_scanlines(int lines)
+static void vga_set_480_scanlines(void)
 {
 	u16 crtc;		/* CRTC base address */
 	u8  csel;		/* CRTC miscellaneous output register */
-	u8  ovfw;		/* CRTC overflow register */
-	int end = lines-1;
 
 	crtc = vga_crtc();
 
-	ovfw = 0x3c | ((end >> (8-1)) & 0x02) | ((end >> (9-6)) & 0x40);
-
 	out_idx(0x0c, crtc, 0x11); /* Vertical sync end, unlock CR0-7 */
 	out_idx(0x0b, crtc, 0x06); /* Vertical total */
-	out_idx(ovfw, crtc, 0x07); /* Vertical overflow */
+	out_idx(0x3e, crtc, 0x07); /* Vertical overflow */
 	out_idx(0xea, crtc, 0x10); /* Vertical sync start */
-	out_idx(end,  crtc, 0x12); /* Vertical display end */
+	out_idx(0xdf, crtc, 0x12); /* Vertical display end */
 	out_idx(0xe7, crtc, 0x15); /* Vertical blank start */
 	out_idx(0x04, crtc, 0x16); /* Vertical blank end */
 	csel = inb(0x3cc);
@@ -153,21 +149,38 @@ static void vga_set_480_scanlines(int lines)
 	outb(csel, 0x3c2);
 }
 
+static void vga_set_vertical_end(int lines)
+{
+	u16 crtc;		/* CRTC base address */
+	u8  ovfw;		/* CRTC overflow register */
+	int end = lines-1;
+
+	crtc = vga_crtc();
+
+	ovfw = 0x3c | ((end >> (8-1)) & 0x02) | ((end >> (9-6)) & 0x40);
+
+	out_idx(ovfw, crtc, 0x07); /* Vertical overflow */
+	out_idx(end,  crtc, 0x12); /* Vertical display end */
+}
+
 static void vga_set_80x30(void)
 {
-	vga_set_480_scanlines(30*16);
+	vga_set_480_scanlines();
+	vga_set_vertical_end(30*16);
 }
 
 static void vga_set_80x34(void)
 {
+	vga_set_480_scanlines();
 	vga_set_14font();
-	vga_set_480_scanlines(34*14);
+	vga_set_vertical_end(34*14);
 }
 
 static void vga_set_80x60(void)
 {
+	vga_set_480_scanlines();
 	vga_set_8font();
-	vga_set_480_scanlines(60*8);
+	vga_set_vertical_end(60*8);
 }
 
 static int vga_set_mode(struct mode_info *mode)
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
old mode 100755
new mode 100644
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 0014714..306e5e8 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -212,7 +212,7 @@ struct apic apic_flat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
@@ -362,7 +362,7 @@ struct apic apic_physflat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
old mode 100755
new mode 100644
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3aaf7b9..c3fe010 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -65,7 +65,7 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "  Spurious interrupts\n");
 #endif
 	if (generic_interrupt_extension) {
-		seq_printf(p, "PLT: ");
+		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", irq_stats(j)->generic_irqs);
 		seq_printf(p, "  Platform interrupts\n");
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 2aef36d..1340dad 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -224,6 +224,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell DXP061 */
+		.callback = set_bios_reboot,
+		.ident = "Dell DXP061",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DXP061"),
+		},
+	},
 	{ }
 };
 
