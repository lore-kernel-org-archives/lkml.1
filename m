Return-Path: <linux-kernel-owner+w=401wt.eu-S935811AbXFGEX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbXFGEX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXFGEXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:23:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58843 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXFGEXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:23:50 -0400
Date: Thu, 7 Jun 2007 09:54:21 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       Patrick Andrieux <patrick.andrieux@gmail.com>,
       DCCP Mailing List <dccp@vger.kernel.org>, jbeulich@novell.com,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] Kprobes x86_64 fix for mark ro data
Message-ID: <20070607042421.GB9350@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com> <46673B76.2090508@redhat.com> <5640c7e00706061612h62074699wdbd2725654a164@mail.gmail.com> <20070607042229.GA9350@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607042229.GA9350@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the problem of page protection introduced by
CONFIG_DEBUG_RODATA for x86_64 architecture. As per Andi
Kleen's suggestion, the kernel text pages are marked writeable
only for a short duration to insert or remove the breakpoints.

Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
Ack-ed-by: Jim Keniston <jkenisto@us.ibm.com>


 arch/x86_64/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
 arch/x86_64/mm/init.c        |    6 +++++-
 include/asm-x86_64/kprobes.h |   10 ++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/kprobes.c~kprobes-mark-ro-data-fix-x86_64 arch/x86_64/kernel/kprobes.c
--- linux-2.6.22-rc2/arch/x86_64/kernel/kprobes.c~kprobes-mark-ro-data-fix-x86_64	2007-06-07 09:20:33.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/arch/x86_64/kernel/kprobes.c	2007-06-07 09:20:33.000000000 +0530
@@ -209,16 +209,42 @@ static void __kprobes arch_copy_kprobe(s
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long)p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+		page_readonly = 1;
+	}
 	*p->addr = BREAKPOINT_INSTRUCTION;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	if (page_readonly) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long)p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_EXEC);
+		global_flush_tlb();
+		page_readonly = 1;
+	}
+
 	*p->addr = p->opcode;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+
+	if (page_readonly) {
+		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff -puN include/asm-x86_64/kprobes.h~kprobes-mark-ro-data-fix-x86_64 include/asm-x86_64/kprobes.h
--- linux-2.6.22-rc2/include/asm-x86_64/kprobes.h~kprobes-mark-ro-data-fix-x86_64	2007-06-07 09:20:33.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/include/asm-x86_64/kprobes.h	2007-06-07 09:20:33.000000000 +0530
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <asm-generic/sections.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
@@ -88,4 +89,13 @@ extern int kprobe_handler(struct pt_regs
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kernel_text_is_ro;
+static inline int kernel_readonly_text(unsigned long address)
+{
+	if (kernel_text_is_ro && ((address >= (unsigned long)_stext)
+					&& (address < (unsigned long) _etext)))
+		return 1;
+
+	return 0;
+}
 #endif				/* _ASM_KPROBES_H */
diff -puN arch/x86_64/mm/init.c~kprobes-mark-ro-data-fix-x86_64 arch/x86_64/mm/init.c
--- linux-2.6.22-rc2/arch/x86_64/mm/init.c~kprobes-mark-ro-data-fix-x86_64	2007-06-07 09:20:33.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/arch/x86_64/mm/init.c	2007-06-07 09:20:33.000000000 +0530
@@ -48,6 +48,7 @@
 #define Dprintk(x...)
 #endif
 
+int kernel_text_is_ro;
 const struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
@@ -598,10 +599,13 @@ void mark_rodata_ro(void)
 {
 	unsigned long start = (unsigned long)_stext, end;
 
+	kernel_text_is_ro = 1;
 #ifdef CONFIG_HOTPLUG_CPU
 	/* It must still be possible to apply SMP alternatives. */
-	if (num_possible_cpus() > 1)
+	if (num_possible_cpus() > 1) {
 		start = (unsigned long)_etext;
+		kernel_text_is_ro = 0;
+	}
 #endif
 	end = (unsigned long)__end_rodata;
 	start = (start + PAGE_SIZE - 1) & PAGE_MASK;

_
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
