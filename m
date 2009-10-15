Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbZJOK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbZJOK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbZJOK4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:56:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51800 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762659AbZJOK4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:56:16 -0400
Date: Thu, 15 Oct 2009 12:55:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091015105505.GA26477@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      Revert "x86: linker script syntax nits"

Li Hong (1):
      x86, perf_event: Rename 'performance counter interrupt'


 arch/x86/kernel/acpi/realmode/wakeup.lds.S |    4 ++--
 arch/x86/kernel/irq.c                      |    4 ++--
 arch/x86/kernel/vmlinux.lds.S              |   17 +++++++++--------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
index 0e50e1e..7da00b7 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
@@ -56,6 +56,6 @@ SECTIONS
 	/DISCARD/ : {
 		*(.note*)
 	}
-}
 
-ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
+	. = ASSERT(_end <= WAKEUP_SIZE, "Wakeup too big!");
+}
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 74656d1..04bbd52 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -63,10 +63,10 @@ static int show_other_interrupts(struct seq_file *p, int prec)
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
 	seq_printf(p, "  Spurious interrupts\n");
-	seq_printf(p, "%*s: ", prec, "CNT");
+	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
-	seq_printf(p, "  Performance counter interrupts\n");
+	seq_printf(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PND");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_pending_irqs);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 8d6001a..92929fb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,8 +305,8 @@ SECTIONS
 
 
 #ifdef CONFIG_X86_32
-ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-       "kernel image bigger than KERNEL_IMAGE_SIZE");
+. = ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 #else
 /*
  * Per-cpu symbols which need to be offset from __per_cpu_load
@@ -319,12 +319,12 @@ INIT_PER_CPU(irq_stack_union);
 /*
  * Build-time check on the image size:
  */
-ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-       "kernel image bigger than KERNEL_IMAGE_SIZE");
+. = ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+	   "kernel image bigger than KERNEL_IMAGE_SIZE");
 
 #ifdef CONFIG_SMP
-ASSERT((per_cpu__irq_stack_union == 0),
-       "irq_stack_union is not at start of per-cpu area");
+. = ASSERT((per_cpu__irq_stack_union == 0),
+           "irq_stack_union is not at start of per-cpu area");
 #endif
 
 #endif /* CONFIG_X86_32 */
@@ -332,6 +332,7 @@ ASSERT((per_cpu__irq_stack_union == 0),
 #ifdef CONFIG_KEXEC
 #include <asm/kexec.h>
 
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big");
+. = ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+           "kexec control code size is too big");
 #endif
+
