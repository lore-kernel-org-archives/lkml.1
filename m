Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXFGEWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXFGEWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXFGEV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:21:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38719 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbXFGEV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:21:57 -0400
Date: Thu, 7 Jun 2007 09:52:29 +0530
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
Subject: Re: [PATCH] Kprobes i386 fix for mark ro data
Message-ID: <20070607042229.GA9350@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com> <46673B76.2090508@redhat.com> <5640c7e00706061612h62074699wdbd2725654a164@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5640c7e00706061612h62074699wdbd2725654a164@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 11:12:32AM +1200, Ian McDonald wrote:
> On 6/7/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> >On 06/06/2007 04:47 PM, Ian McDonald wrote:
> >> Hi there,
> >>
> >> We've seen a report of a problem with dccp_probe as shown below. The
> >> user has also verified that it occurs in tcp_probe as well. This is on
> >> Dave Miller's tree but that currently tracks Linus' tree quite
> >> closely. I do note that it is around 2.6.22-rc2 timeframe so there is
> >> a possibility fixes may have gone in since.
> >>
> >
> >It faulted when it tried to write the breakpoint instruction into the
> >running kernel's executable code. Apparently the kernel code is now marked
> >read-only?
> >
> >
> Yes it would appear to be the case as user has CONFIG_DEBUG_RODATA
> set. Patrick - can you turn this off and retest? It's under Kernel
> Hacking, Write protect kernel read only data structures.
> 
> The list of commits that I see around this are at:
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=DEBUG_RODATA
> 
> I suspect it's probably one of the latter ones giving the timing.
> 
> I guess there are a couple of solutions here - either make kprobes
> conflict with CONFIG_DEBUG_RODATA so you can do one or the other, or
> look into more detail what access kprobes need.
> 
> Ian

Ian,

Please find the fix as suggested by Andi Kleen 
for the above stated problem.

Thanks
Prasanna


This patch fixes the problem of page protection introduced by
CONFIG_DEBUG_RODATA. CONFIG_DEBUG_RODATA marks the text pages as
read-only, hence kprobes is unable to insert breakpoints in the
kernel text. This patch overrides the page protection when adding
or removing a probe for the i386 architecture.

Signed-off-by: Prasanna S P<prasanna@in.ibm.com>
Ack-ed-by: Jim Keniston <jkenisto@us.ibm.com>



 arch/i386/kernel/kprobes.c |   26 ++++++++++++++++++++++++++
 arch/i386/mm/init.c        |    2 ++
 include/asm-i386/kprobes.h |   12 ++++++++++++
 include/asm-i386/pgtable.h |    2 ++
 4 files changed, 42 insertions(+)

diff -puN arch/i386/kernel/kprobes.c~kprobes-mark-ro-data-fix-i386 arch/i386/kernel/kprobes.c
--- linux-2.6.22-rc2/arch/i386/kernel/kprobes.c~kprobes-mark-ro-data-fix-i386	2007-06-07 09:19:26.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/arch/i386/kernel/kprobes.c	2007-06-07 09:19:26.000000000 +0530
@@ -169,16 +169,42 @@ int __kprobes arch_prepare_kprobe(struct
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long) p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		page_readonly = 1;
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
+		global_flush_tlb();
+	}
+
 	*p->addr = BREAKPOINT_INSTRUCTION;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+
+	if (page_readonly) {
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
+	unsigned long addr = (unsigned long) p->addr;
+	int page_readonly = 0;
+
+	if (kernel_readonly_text(addr)) {
+		page_readonly = 1;
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RWX);
+		global_flush_tlb();
+	}
 	*p->addr = p->opcode;
 	flush_icache_range((unsigned long) p->addr,
 			   (unsigned long) p->addr + sizeof(kprobe_opcode_t));
+	if (page_readonly) {
+		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RX);
+		global_flush_tlb();
+	}
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff -puN include/asm-i386/kprobes.h~kprobes-mark-ro-data-fix-i386 include/asm-i386/kprobes.h
--- linux-2.6.22-rc2/include/asm-i386/kprobes.h~kprobes-mark-ro-data-fix-i386	2007-06-07 09:19:26.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/include/asm-i386/kprobes.h	2007-06-07 09:19:26.000000000 +0530
@@ -26,6 +26,8 @@
  */
 #include <linux/types.h>
 #include <linux/ptrace.h>
+#include <linux/pfn.h>
+#include <asm-generic/sections.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
@@ -90,4 +92,14 @@ static inline void restore_interrupts(st
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern int kernel_text_is_ro;
+static inline int kernel_readonly_text(unsigned long address)
+{
+
+	if (kernel_text_is_ro && ((address >= PFN_ALIGN(_text))
+				&& (address < PFN_ALIGN(_etext))))
+		return 1;
+
+	return 0;
+}
 #endif				/* _ASM_KPROBES_H */
diff -puN include/asm-i386/pgtable.h~kprobes-mark-ro-data-fix-i386 include/asm-i386/pgtable.h
--- linux-2.6.22-rc2/include/asm-i386/pgtable.h~kprobes-mark-ro-data-fix-i386	2007-06-07 09:19:26.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/include/asm-i386/pgtable.h	2007-06-07 09:19:26.000000000 +0530
@@ -159,6 +159,7 @@ void paging_init(void);
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
+#define __PAGE_KERNEL_RWX		(__PAGE_KERNEL_EXEC | _PAGE_RW)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -167,6 +168,7 @@ extern unsigned long long __PAGE_KERNEL,
 #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
+#define PAGE_KERNEL_RWX		__pgprot(__PAGE_KERNEL_RWX)
 #define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
 #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
diff -puN arch/i386/mm/init.c~kprobes-mark-ro-data-fix-i386 arch/i386/mm/init.c
--- linux-2.6.22-rc2/arch/i386/mm/init.c~kprobes-mark-ro-data-fix-i386	2007-06-07 09:19:26.000000000 +0530
+++ linux-2.6.22-rc2-prasanna/arch/i386/mm/init.c	2007-06-07 09:19:26.000000000 +0530
@@ -45,6 +45,7 @@
 #include <asm/sections.h>
 #include <asm/paravirt.h>
 
+int kernel_text_is_ro;
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -807,6 +808,7 @@ void mark_rodata_ro(void)
 		change_page_attr(virt_to_page(start),
 		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
 		printk("Write protecting the kernel text: %luk\n", size >> 10);
+		kernel_text_is_ro = 1;
 	}
 
 	start += size;

_
