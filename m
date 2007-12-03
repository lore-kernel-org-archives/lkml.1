Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbXLCQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbXLCQih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXLCQia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:38:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXLCQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:38:29 -0500
Date: Mon, 3 Dec 2007 17:38:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
Message-ID: <20071203163808.GA12157@elte.hu>
References: <20071202191245.GA31657@elte.hu> <alpine.LFD.0.9999.0712030821430.8458@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712030821430.8458@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Linus, please pull the latest x86 git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86.git
> 
> Ingo, there is no such tree on kernel.org. Forgot to push it out?

hm, i found the reason - a wrong URI made it into the pull request. The 
correct uri is to the shared x86 tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

NOTE: i've meanwhile finished the testing of another fixlet so it's 3 
patches - i've re-pushed the whole tree because i first thought i forgot 
the pull. The pull request email is below.

	Ingo

---------------------------->
Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Thanks!

	Ingo

------------------>
Eric W. Biederman (1):
      x86: fix x86-32 early fixmap initialization.

OGAWA Hirofumi (2):
      x86: disable hpet on shutdown
      x86: disable hpet legacy replacement for kdump

 arch/x86/kernel/crash.c     |    4 ++++
 arch/x86/kernel/head_32.S   |   12 ++++++------
 arch/x86/kernel/hpet.c      |   14 ++++++++++++++
 arch/x86/kernel/reboot_32.c |    4 ++++
 arch/x86/kernel/reboot_64.c |    4 ++++
 include/asm-x86/hpet.h      |    1 +
 6 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 8bb482f..9a5fa0a 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -22,6 +22,7 @@
 #include <asm/nmi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
@@ -140,5 +141,8 @@ void machine_crash_shutdown(struct pt_regs *regs)
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
 #endif
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 374b7ec..ac0637a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -193,6 +193,12 @@ default_entry:
 	jb 10b
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
+	/* Do an early initialization of the fixmap area */
+	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
+	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
+	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
+	movl %eax, 4092(%edx)
+
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
 	jmp 3f
 /*
@@ -208,12 +214,6 @@ default_entry:
 .section .init.text,"ax",@progbits
 #endif
 
-	/* Do an early initialization of the fixmap area */
-	movl $(swapper_pg_dir - __PAGE_OFFSET), %edx
-	movl $(swapper_pg_pmd - __PAGE_OFFSET), %eax
-	addl $0x007, %eax			/* 0x007 = PRESENT+RW+USER */
-	movl %eax, 4092(%edx)
-
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 53303f2..4a86ffd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
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
diff --git a/arch/x86/kernel/reboot_32.c b/arch/x86/kernel/reboot_32.c
index 9e2269d..bb1a0f8 100644
--- a/arch/x86/kernel/reboot_32.c
+++ b/arch/x86/kernel/reboot_32.c
@@ -11,6 +11,7 @@
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 #include <asm/apic.h>
+#include <asm/hpet.h>
 #include <asm/desc.h>
 #include "mach_reboot.h"
 #include <asm/reboot_fixups.h>
@@ -326,6 +327,9 @@ static void native_machine_shutdown(void)
 #ifdef CONFIG_X86_IO_APIC
 	disable_IO_APIC();
 #endif
+#ifdef CONFIG_HPET_TIMER
+	hpet_disable();
+#endif
 }
 
 void __attribute__((weak)) mach_reboot_fixups(void)
diff --git a/arch/x86/kernel/reboot_64.c b/arch/x86/kernel/reboot_64.c
index 71b13c5..53620a9 100644
--- a/arch/x86/kernel/reboot_64.c
+++ b/arch/x86/kernel/reboot_64.c
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
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index b1f3c1e..ad8d6e7 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -61,6 +61,7 @@ extern unsigned long force_hpet_address;
 extern int hpet_force_user;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
+extern void hpet_disable(void);
 extern unsigned long hpet_readl(unsigned long a);
 extern void force_hpet_resume(void);
 
