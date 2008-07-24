Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbYGXPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbYGXPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYGXPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:12:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYGXPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:12:20 -0400
Date: Thu, 24 Jul 2008 17:12:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080724151200.GA19266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Hugh Dickins (1):
      x86: BUILD_IRQ say .text to avoid .data.percpu

Jeremy Fitzhardinge (2):
      x86: call early_cpu_init at the same point
      xen: don't use sysret for sysexit32

Vegard Nossum (1):
      x86: fix header export, asm-x86/processor-flags.h, CONFIG_* leaks


 arch/x86/kernel/irqinit_64.c      |    2 +-
 arch/x86/kernel/setup.c           |    5 +----
 arch/x86/xen/xen-asm_64.S         |    2 +-
 include/asm-x86/processor-flags.h |    2 ++
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 0373e88..9414125 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -43,7 +43,7 @@
 
 #define BUILD_IRQ(nr)				\
 	asmlinkage void IRQ_NAME(nr);		\
-	asm("\n.p2align\n"			\
+	asm("\n.text\n.p2align\n"		\
 	    "IRQ" #nr "_interrupt:\n\t"		\
 	    "push $~(" #nr ") ; "		\
 	    "jmp common_interrupt");
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4aacb9..b520dae 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -597,11 +597,11 @@ void __init setup_arch(char **cmdline_p)
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
 	pre_setup_arch_hook();
-	early_cpu_init();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	early_cpu_init();
 	early_ioremap_init();
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
@@ -665,9 +665,6 @@ void __init setup_arch(char **cmdline_p)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
-#ifdef CONFIG_X86_64
-	early_cpu_init();
-#endif
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 4038cbf..7f58304 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -173,7 +173,7 @@ ENTRY(xen_sysexit)
 	pushq $__USER32_CS
 	pushq %rdx
 
-	pushq $VGCF_in_syscall
+	pushq $0
 1:	jmp hypercall_iret
 ENDPATCH(xen_sysexit)
 RELOC(xen_sysexit, 1b+1)
diff --git a/include/asm-x86/processor-flags.h b/include/asm-x86/processor-flags.h
index 092b39b..eff2ecd 100644
--- a/include/asm-x86/processor-flags.h
+++ b/include/asm-x86/processor-flags.h
@@ -88,10 +88,12 @@
 #define CX86_ARR_BASE	0xc4
 #define CX86_RCR_BASE	0xdc
 
+#ifdef __KERNEL__
 #ifdef CONFIG_VM86
 #define X86_VM_MASK	X86_EFLAGS_VM
 #else
 #define X86_VM_MASK	0 /* No VM86 support */
 #endif
+#endif
 
 #endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
