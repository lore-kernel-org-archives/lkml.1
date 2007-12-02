Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbXLBTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbXLBTNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXLBTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:13:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbXLBTNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:13:05 -0500
Date: Sun, 2 Dec 2007 20:12:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20071202191245.GA31657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86.git

two kexec related hpet fixes from Ogawa Hirofumi. (the #ifdefs will be 
eliminated later on, these are the tested patches for -rc4)

Thanks!

	Ingo

------------------>
OGAWA Hirofumi (2):
      x86: disable hpet on shutdown
      x86: disable hpet legacy replacement for kdump

 arch/x86/kernel/crash.c     |    4 ++++
 arch/x86/kernel/hpet.c      |   14 ++++++++++++++
 arch/x86/kernel/reboot_32.c |    4 ++++
 arch/x86/kernel/reboot_64.c |    4 ++++
 include/asm-x86/hpet.h      |    1 +
 5 files changed, 27 insertions(+)

Index: linux-x86.q/arch/x86/kernel/crash.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/crash.c
+++ linux-x86.q/arch/x86/kernel/crash.c
@@ -22,6 +22,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
@@ -140,5 +141,8 @@ void machine_crash_shutdown(struct pt_re
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
Index: linux-x86.q/arch/x86/kernel/hpet.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/hpet.c
+++ linux-x86.q/arch/x86/kernel/hpet.c
@@ -446,6 +446,20 @@ static __init int hpet_late_init(void)
 }
 fs_initcall(hpet_late_init);
 
+void hpet_disable(void)
+{
+	if (is_hpet_capable()) {
+		unsigned long cfg = hpet_readl(HPET_CFG);
+
+		if (hpet_legacy_int_enabled) {
+			cfg &= ~HPET_CFG_LEGACY;
+			hpet_legacy_int_enabled = 0;
+		}
+		cfg &= ~HPET_CFG_ENABLE;
+		hpet_writel(cfg, HPET_CFG);
+	}
+}
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
Index: linux-x86.q/arch/x86/kernel/reboot_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot_32.c
+++ linux-x86.q/arch/x86/kernel/reboot_32.c
@@ -11,6 +11,7 @@
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
 #include <asm/reboot_fixups.h>
@@ -326,6 +327,9 @@ static void native_machine_shutdown(void
 #ifdef CONFIG_X86_IO_APIC
 	disable_IO_APIC();
 #endif
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 }
 
 void __attribute__((weak)) mach_reboot_fixups(void)
Index: linux-x86.q/arch/x86/kernel/reboot_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/reboot_64.c
+++ linux-x86.q/arch/x86/kernel/reboot_64.c
@@ -17,6 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <asm/gart.h>
 
 /*
@@ -113,6 +114,9 @@ void machine_shutdown(void)
 
 	disable_IO_APIC();
 
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 	local_irq_restore(flags);
 
 	pci_iommu_shutdown();
Index: linux-x86.q/include/asm-x86/hpet.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/hpet.h
+++ linux-x86.q/include/asm-x86/hpet.h
@@ -61,6 +61,7 @@ extern unsigned long force_hpet_address;
 extern int hpet_force_user;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+extern void hpet_disable(void);
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
 
