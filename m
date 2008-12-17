Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759470AbYLQAOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbYLQAOL (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYLQAFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:05:53 -0500
Received: from kroah.org ([198.145.64.141]:41202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757126AbYLQAFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:52 -0500
Date: Tue, 16 Dec 2008 16:04:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zachary Amsden <zach@vmware.com>
Subject: [patch 04/22] x86 Fix VMI crash on boot in 2.6.28-rc8
Message-ID: <20081217000405.GE4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-vmi-crash-on-boot-in-2.6.28-rc8.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zach@vmware.com>

commit ae8d04e2ecbb233926860e9ce145eac19c7835dc upstream.

VMI initialiation can relocate the fixmap, causing early_ioremap to
malfunction if it is initialized before the relocation.  To fix this,
VMI activation is split into two phases; the detection, which must
happen before setting up ioremap, and the activation, which must happen
after parsing early boot parameters.

This fixes a crash on boot when VMI is enabled under VMware.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/setup.c   |   12 +++++-------
 arch/x86/kernel/smpboot.c |    2 --
 arch/x86/kernel/vmi_32.c  |   16 +++++++++++-----
 include/asm-x86/vmi.h     |    8 +++++++-
 4 files changed, 23 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -634,6 +634,9 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	/* VMI may relocate the fixmap; do this before touching ioremap area */
+	vmi_init();
+
 	early_cpu_init();
 	early_ioremap_init();
 
@@ -707,13 +710,8 @@ void __init setup_arch(char **cmdline_p)
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
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -289,9 +289,7 @@ static void __cpuinit start_secondary(vo
 	 * fragile that we want to limit the things done here to the
 	 * most necessary things.
 	 */
-#ifdef CONFIG_VMI
 	vmi_bringup();
-#endif
 	cpu_init();
 	preempt_disable();
 	smp_callin();
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -960,8 +960,6 @@ static inline int __init activate_vmi(vo
 
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
 
--- a/include/asm-x86/vmi.h
+++ b/include/asm-x86/vmi.h
@@ -223,9 +223,15 @@ struct pci_header {
 } __attribute__((packed));
 
 /* Function prototypes for bootstrapping */
+#ifdef CONFIG_VMI
 extern void vmi_init(void);
+extern void vmi_activate(void);
 extern void vmi_bringup(void);
-extern void vmi_apply_boot_page_allocations(void);
+#else
+static inline void vmi_init(void) {}
+static inline void vmi_activate(void) {}
+static inline void vmi_bringup(void) {}
+#endif
 
 /* State needed to start an application processor in an SMP system. */
 struct vmi_ap_state {

