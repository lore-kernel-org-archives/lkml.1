Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXHHHPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXHHHPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbXHHHIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXHHHIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:41 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Date: Wed,  8 Aug 2007 01:19:12 -0300
Message-Id: <11865468513077-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1186546847263-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com> <11865468281860-git-send-email-gc!
 osta@redhat.com> <11865468321629-git-send-email-gcosta@redhat.com> <11865468362401-git-send-email-gcosta@redhat.com> <11865468394005-git-send-email-gcosta@redhat.com> <11865468431616-git-send-email-gcosta@redhat.com> <1186546847263-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is finally, the patch we were all looking for. This
patch adds a paravirt.h header with the definition of paravirt_ops
struct. Also, it defines a bunch of inline functions that will
replace, or hook, the other calls. Every one of those functions
adds an entry in the parainstructions section (see vmlinux.lds.S).
Those entries can then be used to runtime-patch the paravirt_ops
functions.

paravirt.c contains implementations of paravirt functions that
are used natively, such as the native_patch. It also fill the
paravirt_ops structure with the whole lot of functions that
were (re)defined throughout this patch set.

There are also changes in asm-offsets.c. paravirt.h needs it
to find out the offsets into the structure of functions
such as irq_enable, used in assembly files.

The text in Kconfig is the same as i386 one.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/Kconfig              |   11 +
 arch/x86_64/kernel/Makefile      |    1 +
 arch/x86_64/kernel/asm-offsets.c |   14 +
 arch/x86_64/kernel/paravirt.c    |  455 +++++++++++++++++++
 arch/x86_64/kernel/vmlinux.lds.S |    6 +
 include/asm-x86_64/paravirt.h    |  901 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 1388 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index ffa0364..bfea34c 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -373,6 +373,17 @@ config NODES_SHIFT
 
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
+config PARAVIRT
+       bool "Paravirtualization support (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       help
+         Paravirtualization is a way of running multiple instances of
+         Linux on the same machine, under a hypervisor.  This option
+         changes the kernel so it can modify itself when it is run
+         under a hypervisor, improving performance significantly.
+         However, when run without a hypervisor the kernel is
+         theoretically slower.  If in doubt, say N.
+
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
        depends on NUMA
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index ff5d8c9..120467f 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_X86_VSMP)		+= vsmp.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
diff --git a/arch/x86_64/kernel/asm-offsets.c b/arch/x86_64/kernel/asm-offsets.c
index 778953b..a8ffc95 100644
--- a/arch/x86_64/kernel/asm-offsets.c
+++ b/arch/x86_64/kernel/asm-offsets.c
@@ -15,6 +15,9 @@
 #include <asm/segment.h>
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -72,6 +75,17 @@ int main(void)
 	       offsetof (struct rt_sigframe32, uc.uc_mcontext));
 	BLANK();
 #endif
+#ifdef CONFIG_PARAVIRT
+#define ENTRY(entry) DEFINE(PARAVIRT_ ## entry, offsetof(struct paravirt_ops, entry))
+	ENTRY(paravirt_enabled);
+	ENTRY(irq_disable);
+	ENTRY(irq_enable);
+	ENTRY(sysret);
+	ENTRY(iret);
+	ENTRY(read_cr2);
+	ENTRY(swapgs);
+	BLANK();
+#endif
 	DEFINE(pbe_address, offsetof(struct pbe, address));
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
 	DEFINE(pbe_next, offsetof(struct pbe, next));
diff --git a/arch/x86_64/kernel/paravirt.c b/arch/x86_64/kernel/paravirt.c
new file mode 100644
index 0000000..a41c1c0
--- /dev/null
+++ b/arch/x86_64/kernel/paravirt.c
@@ -0,0 +1,455 @@
+/*  Paravirtualization interfaces
+    Copyright (C) 2007 Glauber de Oliveira Costa and Steven Rostedt,
+    Red Hat Inc.
+    Based on i386 work by Rusty Russell.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+*/
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/efi.h>
+#include <linux/bcd.h>
+#include <linux/start_kernel.h>
+
+#include <asm/bug.h>
+#include <asm/paravirt.h>
+#include <asm/desc.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/delay.h>
+#include <asm/fixmap.h>
+#include <asm/apic.h>
+#include <asm/tlbflush.h>
+#include <asm/msr.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/proto.h>
+#include <asm/e820.h>
+#include <asm/time.h>
+#include <asm/asm-offsets.h>
+#include <asm/smp.h>
+#include <asm/irqflags.h>
+
+/* nop stub */
+void _paravirt_nop(void)
+{
+}
+
+/* natively, we do normal setup, but we still need to return something */
+static int native_arch_setup(void)
+{
+	return 0;
+}
+
+static void __init default_banner(void)
+{
+	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
+	       paravirt_ops.name);
+}
+
+void memory_setup(void)
+{
+	paravirt_ops.memory_setup();
+}
+
+void syscall_init(void)
+{
+	paravirt_ops.syscall_init();
+}
+
+/* Simple instruction patching code. */
+#define DEF_NATIVE(name, code)					\
+	extern const char start_##name[], end_##name[];		\
+	asm("start_" #name ": " code "; end_" #name ":")
+
+DEF_NATIVE(irq_disable, "cli");
+DEF_NATIVE(irq_enable, "sti");
+DEF_NATIVE(restore_fl, "pushq %rdi; popfq");
+DEF_NATIVE(save_fl, "pushfq; popq %rax");
+DEF_NATIVE(iret, "iretq");
+DEF_NATIVE(read_cr2, "movq %cr2, %rax");
+DEF_NATIVE(read_cr3, "movq %cr3, %rax");
+DEF_NATIVE(write_cr3, "movq %rdi, %cr3");
+DEF_NATIVE(flush_tlb_single, "invlpg (%rdi)");
+DEF_NATIVE(clts, "clts");
+DEF_NATIVE(wbinvd, "wbinvd");
+
+/* the three commands give us more control to how to do a sysret */
+DEF_NATIVE(sysret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
+DEF_NATIVE(swapgs, "swapgs");
+
+DEF_NATIVE(ud2a, "ud2a");
+
+static unsigned native_patch(u8 type, u16 clobbers, void *insns, unsigned len)
+{
+	const unsigned char *start, *end;
+	unsigned ret;
+
+	switch(type) {
+#define SITE(x)	case PARAVIRT_PATCH(x):	start = start_##x; end = end_##x; goto patch_site
+		SITE(irq_disable);
+		SITE(irq_enable);
+		SITE(restore_fl);
+		SITE(save_fl);
+		SITE(iret);
+		SITE(sysret);
+		SITE(swapgs);
+		SITE(read_cr2);
+		SITE(read_cr3);
+		SITE(write_cr3);
+		SITE(clts);
+		SITE(flush_tlb_single);
+		SITE(wbinvd);
+#undef SITE
+
+	patch_site:
+		ret = paravirt_patch_insns(insns, len, start, end);
+		break;
+
+	case PARAVIRT_PATCH(make_pgd):
+	case PARAVIRT_PATCH(pgd_val):
+	case PARAVIRT_PATCH(make_pte):
+	case PARAVIRT_PATCH(pte_val):
+	case PARAVIRT_PATCH(make_pmd):
+	case PARAVIRT_PATCH(pmd_val):
+	case PARAVIRT_PATCH(make_pud):
+	case PARAVIRT_PATCH(pud_val):
+		/* These functions end up returning what
+		   they're passed in the first argument */
+		ret = paravirt_patch_copy_reg(insns, len);
+		break;
+
+	case PARAVIRT_PATCH(set_pte):
+	case PARAVIRT_PATCH(set_pmd):
+	case PARAVIRT_PATCH(set_pud):
+	case PARAVIRT_PATCH(set_pgd):
+		/* These functions end up storing the second
+		 * argument in the location pointed by the first */
+		ret = paravirt_patch_store_reg(insns, len);
+		break;
+
+	default:
+		ret = paravirt_patch_default(type, clobbers, insns, len);
+		break;
+	}
+
+	return ret;
+}
+
+unsigned paravirt_patch_nop(void)
+{
+	return 0;
+}
+
+unsigned paravirt_patch_ignore(unsigned len)
+{
+	return len;
+}
+
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len)
+{
+	unsigned char *call = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(call+5);
+
+	if (tgt_clobbers & ~site_clobbers)
+		return len;	/* target would clobber too much for this site */
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*call++ = 0xe8;		/* call */
+	*(unsigned int *)call = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_copy_reg(void *site, unsigned len)
+{
+	unsigned char *mov = site;
+	if (len < 3)
+		return len;
+
+	/* This is mov %rdi, %rax */
+	*mov++ = 0x48;
+	*mov++ = 0x89;
+	*mov   = 0xf8;
+	return 3;
+}
+
+unsigned paravirt_patch_store_reg(void *site, unsigned len)
+{
+	unsigned char *mov = site;
+	if (len < 3)
+		return len;
+
+	/* This is mov %rsi, (%rdi) */
+	*mov++ = 0x48;
+	*mov++ = 0x89;
+	*mov   = 0x37;
+	return 3;
+}
+
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len)
+{
+	unsigned char *jmp = site;
+	unsigned long delta = (unsigned long)target - (unsigned long)(jmp+5);
+
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	*jmp++ = 0xe9;		/* jmp */
+	*(unsigned int *)jmp = delta;
+
+	return 5;
+}
+
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len)
+{
+	void *opfunc = *((void **)&paravirt_ops + type);
+	unsigned ret;
+
+	if (opfunc == NULL)
+		/* If there's no function, patch it with a ud2a (BUG) */
+		ret = paravirt_patch_insns(site, len, start_ud2a, end_ud2a);
+	else if (opfunc == paravirt_nop)
+		/* If the operation is a nop, then nop the callsite */
+		ret = paravirt_patch_nop();
+	else if (type == PARAVIRT_PATCH(iret) ||
+		 type == PARAVIRT_PATCH(sysret))
+		/* If operation requires a jmp, then jmp */
+		ret = paravirt_patch_jmp(opfunc, site, len);
+	else
+		/* Otherwise call the function; assume target could
+		   clobber any caller-save reg */
+		ret = paravirt_patch_call(opfunc, CLBR_ANY,
+						  site, clobbers, len);
+
+	return ret;
+}
+
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end)
+{
+	unsigned insn_len = end - start;
+
+	if (insn_len > len || start == NULL)
+		insn_len = len;
+	else
+		memcpy(site, start, insn_len);
+
+	return insn_len;
+}
+
+void init_IRQ(void)
+{
+	paravirt_ops.init_IRQ();
+}
+
+static unsigned long native_save_fl(void)
+{
+	unsigned long f;
+	asm volatile("pushfq ; popq %0":"=g" (f): /* no input */);
+	return f;
+}
+
+static void native_restore_fl(unsigned long f)
+{
+	asm volatile("pushq %0 ; popfq": /* no output */
+			     :"g" (f)
+			     :"memory", "cc");
+}
+
+static void native_irq_disable(void)
+{
+	asm volatile("cli": : :"memory");
+}
+
+static void native_irq_enable(void)
+{
+	asm volatile("sti": : :"memory");
+}
+
+static inline void native_write_dt_entry(void *dt, int entry, u32 entry_low, u32 entry_high)
+{
+	u32 *lp = (u32 *)((char *)dt + entry*8);
+	lp[0] = entry_low;
+	lp[1] = entry_high;
+}
+
+static void native_io_delay(void)
+{
+	asm volatile("outb %al,$0x80");
+}
+
+pte_t native_make_pte(unsigned long pte)
+{
+	return (pte_t){ pte };
+}
+
+pud_t native_make_pud(unsigned long pud)
+{
+	return (pud_t){ pud };
+}
+
+pmd_t native_make_pmd(unsigned long pmd)
+{
+	return (pmd_t){ pmd };
+}
+
+pgd_t native_make_pgd(unsigned long pgd)
+{
+	return (pgd_t){ pgd };
+}
+
+void native_set_pte_at(struct mm_struct *mm, u64 addr, pte_t *ptep,
+				pte_t pteval)
+{
+	native_set_pte(ptep,pteval);
+}
+
+void native_pte_clear(struct mm_struct *mm, u64 addr, pte_t *ptep)
+{
+	native_set_pte_at(mm,addr,ptep,__pte(0));
+}
+
+void native_pmd_clear(pmd_t *pmd)
+{
+	native_set_pmd(pmd,__pmd(0));
+}
+
+void native_swapgs(void)
+{
+	asm volatile ("swapgs" :: :"memory" );
+}
+
+/* These are in entry.S */
+extern void native_iret(void);
+extern void native_sysret(void);
+
+static int __init print_banner(void)
+{
+	paravirt_ops.banner();
+	return 0;
+}
+core_initcall(print_banner);
+
+struct paravirt_ops paravirt_ops = {
+	.kernel_rpl = 0,
+	.paravirt_enabled = 0,
+	.name = "bare hardware",
+	.mem_type = "BIOS-e820",
+
+	.patch = native_patch,
+	.banner = default_banner,
+	.arch_setup = native_arch_setup,
+	.memory_setup = setup_memory_region,
+	.syscall_init = x86_64_syscall_init,
+	.get_wallclock = do_get_cmos_time,
+	.set_wallclock = do_set_rtc_mmss,
+	.time_init = time_init_hook,
+	.init_IRQ = native_init_IRQ,
+
+	.cpuid = native_cpuid,
+	.get_debugreg = native_get_debugreg,
+	.set_debugreg = native_set_debugreg,
+	.clts = native_clts,
+	.read_cr0 = native_read_cr0,
+	.write_cr0 = native_write_cr0,
+	.read_cr2 = native_read_cr2,
+	.write_cr2 = native_write_cr2,
+	.read_cr3 = native_read_cr3,
+	.write_cr3 = native_write_cr3,
+	.read_cr4 = native_read_cr4,
+	.write_cr4 = native_write_cr4,
+	.save_fl = native_save_fl,
+	.restore_fl = native_restore_fl,
+	.irq_disable = native_irq_disable,
+	.irq_enable = native_irq_enable,
+	.safe_halt = native_raw_safe_halt,
+	.halt = native_halt,
+	.wbinvd = native_wbinvd,
+	.read_msr = native_read_msr_safe,
+	.write_msr = native_write_msr_safe,
+	.read_tsc = native_read_tsc,
+	.read_tscp = native_read_tscp,
+	.read_pmc = native_read_pmc,
+	.load_tr_desc = native_load_tr_desc,
+	.set_ldt = native_set_ldt,
+	.load_gdt = native_load_gdt,
+	.load_idt = native_load_idt,
+	.store_gdt = native_store_gdt,
+	.store_idt = native_store_idt,
+	.store_tr = native_store_tr,
+	.load_tls = native_load_tls,
+	.write_ldt_entry = native_write_ldt_entry,
+	.write_gdt_entry = native_write_gdt_entry,
+	.write_idt_entry = native_write_idt_entry,
+	.load_rsp0 = native_load_rsp0,
+
+	.io_delay = native_io_delay,
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	.apic_write = native_apic_write,
+	.apic_read = native_apic_read,
+	.setup_boot_clock = setup_boot_APIC_clock,
+	.setup_secondary_clock = setup_secondary_APIC_clock,
+	.startup_ipi_hook = paravirt_nop,
+#endif
+	.set_lazy_mode = paravirt_nop,
+	.ebda_info = native_ebda_info,
+
+	.flush_tlb_user = native_flush_tlb,
+	.flush_tlb_kernel = native_flush_tlb_all,
+	.flush_tlb_single = native_flush_tlb_one,
+	.flush_tlb_others = native_flush_tlb_others,
+
+	.release_pgd = paravirt_nop,
+
+	.set_pte = native_set_pte,
+	.set_pte_at = native_set_pte_at,
+	.set_pmd = native_set_pmd,
+	.set_pud = native_set_pud,
+	.set_pgd = native_set_pgd,
+
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
+
+	.pte_clear = native_pte_clear,
+	.pmd_clear = native_pmd_clear,
+	.pud_clear = native_pud_clear,
+	.pgd_clear = native_pgd_clear,
+
+	.pte_val = native_pte_val,
+	.pud_val = native_pud_val,
+	.pmd_val = native_pmd_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pmd = native_make_pmd,
+	.make_pud = native_make_pud,
+	.make_pgd = native_make_pgd,
+
+	.swapgs = native_swapgs,
+	.sysret = native_sysret,
+	.iret = native_iret,
+
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
+};
+
+EXPORT_SYMBOL(paravirt_ops);
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index ba8ea97..c3fce85 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -185,6 +185,12 @@ SECTIONS
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 	*(.altinstr_replacement)
   }
+  . = ALIGN(8);
+  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+  __parainstructions = .;
+	*(.parainstructions)
+  __parainstructions_end = .;
+  }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
diff --git a/include/asm-x86_64/paravirt.h b/include/asm-x86_64/paravirt.h
new file mode 100644
index 0000000..fb0347e
--- /dev/null
+++ b/include/asm-x86_64/paravirt.h
@@ -0,0 +1,901 @@
+#ifndef __ASM_PARAVIRT_H
+#define __ASM_PARAVIRT_H
+
+#ifdef CONFIG_PARAVIRT
+/* Various instructions on x86 need to be replaced for
+ * para-virtualization: those hooks are defined here. */
+#include <linux/linkage.h>
+#include <linux/stringify.h>
+#include <asm/desc_defs.h>
+#include <asm/page.h>
+#include <asm/types.h>
+#include <asm/pda.h>
+
+/* Bitmask of what can be clobbered: usually at least rax. */
+#define CLBR_NONE 0x000
+#define CLBR_RAX  0x001
+#define CLBR_RDI  0x002
+#define CLBR_RSI  0x004
+#define CLBR_RCX  0x008
+#define CLBR_RDX  0x010
+#define CLBR_R8	  0x020
+#define CLBR_R9	  0x040
+#define CLBR_R10  0x080
+#define CLBR_R11  0x100
+#define CLBR_ANY  0xfff
+
+
+#ifndef __ASSEMBLY__
+#include <linux/cpumask.h>
+#include <linux/types.h>
+
+void _paravirt_nop(void);
+#define paravirt_nop    ((void *)_paravirt_nop)
+
+/* Lazy mode for batching updates / context switch */
+enum paravirt_lazy_mode {
+        PARAVIRT_LAZY_NONE = 0,
+        PARAVIRT_LAZY_MMU = 1,
+        PARAVIRT_LAZY_CPU = 2,
+        PARAVIRT_LAZY_FLUSH = 3,
+};
+
+struct thread_struct;
+struct desc_struct;
+struct desc_ptr;
+struct tss_struct;
+struct mm_struct;
+
+/*
+ * integers must be use with care here. They can break the PARAVIRT_PATCH(x)
+ * macro, that divides the offset in the structure by 8, to get a number
+ * associated with the hook. Dividing by four would be a solution, but it
+ * would limit the future growth of the structure if needed.
+ *
+ * The first two integers are okay, because they sum up to a long, are packed
+ * together, and sum up to a long
+ */
+struct paravirt_ops
+{
+	unsigned int kernel_rpl;
+	int paravirt_enabled;
+	const char *name;
+	char *mem_type;
+
+	/*
+	 * Patch may replace one of the defined code sequences with arbitrary
+	 * code, subject to the same register constraints.  This generally
+	 * means the code is not free to clobber any registers other than RAX.
+	 * The patch function should return the number of bytes of code
+	 * generated, as we nop pad the rest in generic code.
+	 */
+	unsigned (*patch)(u8 type, u16 clobber, void *firstinsn, unsigned len);
+
+	int (*arch_setup)(void);
+	void (*memory_setup)(void);
+	void (*init_IRQ)(void);
+	void (*time_init)(void);
+
+	/* entry point for our hypervisor syscall handler */
+	void (*syscall_init)(void);
+
+	void (*banner)(void);
+
+	unsigned long (*get_wallclock)(void);
+	int (*set_wallclock)(unsigned long);
+
+	/* cpuid emulation, mostly so that caps bits can be disabled */
+	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
+		      unsigned int *ecx, unsigned int *edx);
+
+	unsigned long (*get_debugreg)(int regno);
+	void (*set_debugreg)(unsigned long value, int regno);
+
+	void (*clts)(void);
+
+	unsigned long (*read_cr0)(void);
+	void (*write_cr0)(unsigned long);
+
+	unsigned long (*read_cr2)(void);
+	void (*write_cr2)(unsigned long);
+
+	unsigned long (*read_cr3)(void);
+	void (*write_cr3)(unsigned long);
+
+	unsigned long (*read_cr4)(void);
+	void (*write_cr4)(unsigned long);
+
+	/*
+	* Get/set interrupt state.  save_fl and restore_fl are only
+	* expected to use X86_EFLAGS_IF; all other bits
+	* returned from save_fl are undefined, and may be ignored by
+	* restore_fl.
+	*/
+	unsigned long (*save_fl)(void);
+	void (*restore_fl)(unsigned long);
+	void (*irq_disable)(void);
+	void (*irq_enable)(void);
+	void (*safe_halt)(void);
+	void (*halt)(void);
+
+	void (*wbinvd)(void);
+
+	/* err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
+	unsigned long (*read_msr)(unsigned int msr, int *err);
+	long (*write_msr)(unsigned int msr, unsigned long val);
+
+	unsigned long (*read_tsc)(void);
+	unsigned long (*read_tscp)(int *aux);
+	unsigned long (*read_pmc)(int counter);
+
+	void (*load_tr_desc)(void);
+	void (*load_gdt)(const struct desc_ptr *);
+	void (*load_idt)(const struct desc_ptr *);
+	void (*store_gdt)(struct desc_ptr *);
+	void (*store_idt)(struct desc_ptr *);
+	void (*set_ldt)(const void *desc, unsigned entries);
+	unsigned long (*store_tr)(void);
+	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
+	void (*write_ldt_entry)(struct desc_struct *,
+				int entrynum, u32 low, u32 high);
+	void (*write_gdt_entry)(void *ptr, void *entry, unsigned type,
+					 unsigned size);
+	void (*write_idt_entry)(void *adr, struct gate_struct *s);
+
+	void (*load_rsp0)(struct tss_struct *tss,
+				   struct thread_struct *thread);
+
+	void (*io_delay)(void);
+
+	/*
+	* Hooks for intercepting the creation/use/destruction of an
+	* mm_struct.
+	*/
+	void (*activate_mm)(struct mm_struct *prev,
+				     struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+				  struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	void (*apic_write)(unsigned long reg, unsigned int v);
+	unsigned int (*apic_read)(unsigned long reg);
+	void (*setup_boot_clock)(void);
+	void (*setup_secondary_clock)(void);
+
+	void (*startup_ipi_hook)(int phys_apicid,
+				 unsigned long start_rip,
+				 unsigned long start_rsp);
+
+#endif
+
+	void (*flush_tlb_user)(void);
+	void (*flush_tlb_kernel)(void);
+	void (*flush_tlb_single)(unsigned long addr);
+	void (*flush_tlb_others)(cpumask_t cpus, struct mm_struct *mm,
+				 unsigned long va);
+
+	void (*release_pgd)(pgd_t *pgd);
+
+	void (*set_pte)(pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, u64 addr, pte_t *ptep, pte_t pteval);
+	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
+	void (*set_pgd)(pgd_t *pgdp, pgd_t pgdval);
+
+	void (*pte_update)(struct mm_struct *mm, u64 addr, pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm, u64 addr, pte_t *ptep);
+
+	void (*pte_clear)(struct mm_struct *mm, u64 addr, pte_t *ptep);
+	void (*pmd_clear)(pmd_t *pmdp);
+	void (*pud_clear)(pud_t *pudp);
+	void (*pgd_clear)(pgd_t *pgdp);
+
+	unsigned long (*pte_val)(pte_t);
+	unsigned long (*pud_val)(pud_t);
+	unsigned long (*pmd_val)(pmd_t);
+	unsigned long (*pgd_val)(pgd_t);
+
+	pte_t (*make_pte)(unsigned long pte);
+	pud_t (*make_pud)(unsigned long pud);
+	pmd_t (*make_pmd)(unsigned long pmd);
+	pgd_t (*make_pgd)(unsigned long pgd);
+
+	void (*swapgs)(void);
+	void (*ebda_info)(unsigned *addr, unsigned *size);
+	void (*set_lazy_mode)(int mode);
+
+	/* These two are jmp to, not actually called. */
+	void (*sysret)(void);
+	void (*iret)(void);
+};
+
+extern struct paravirt_ops paravirt_ops;
+
+/*
+ * This generates an indirect call based on the operation type number.
+ * The type number, computed in PARAVIRT_PATCH, is derived from the
+ * offset into the paravirt_ops structure, and can therefore be freely
+ * converted back into a structure offset. It induces a limitation in
+ * what can go in the paravirt_ops structure. For further information,
+ * see comments in the top of the struct
+ */
+#define PARAVIRT_PATCH(x)					\
+	(offsetof(struct paravirt_ops, x) / sizeof(void *))
+
+#define paravirt_type(type)					\
+	[paravirt_typenum] "i" (PARAVIRT_PATCH(type))
+#define paravirt_clobber(clobber)		\
+	[paravirt_clobber] "i" (clobber)
+
+/*
+ * Generate some code, and mark it as patchable by the
+ * apply_paravirt() alternate instruction patcher.
+ */
+#define _paravirt_alt(insn_string, type, clobber)	\
+	"771:\n\t" insn_string "\n" "772:\n"		\
+	".pushsection .parainstructions,\"a\"\n"	\
+	".align 8\n"	 				\
+	"  .quad 771b\n"				\
+	"  .byte " type "\n"				\
+	"  .byte 772b-771b\n"				\
+	"  .long " clobber "\n"			\
+	".popsection\n"
+
+/* Generate patchable code, with the default asm parameters. */
+#define paravirt_alt(insn_string)					\
+	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
+
+unsigned paravirt_patch_nop(void);
+unsigned paravirt_patch_ignore(unsigned len);
+unsigned paravirt_patch_call(void *target, u16 tgt_clobbers,
+			     void *site, u16 site_clobbers,
+			     unsigned len);
+unsigned paravirt_patch_jmp(void *target, void *site, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *site, unsigned len);
+unsigned paravirt_patch_copy_reg(void *site, unsigned len);
+unsigned paravirt_patch_store_reg(void *site, unsigned len);
+unsigned paravirt_patch_insns(void *site, unsigned len,
+			      const char *start, const char *end);
+/*
+ * This generates an indirect call based on the operation type number.
+ * The type number, computed in PARAVIRT_PATCH, is derived from the
+ * offset into the paravirt_ops structure, and can therefore be freely
+ * converted back into a structure offset.
+ */
+#define PARAVIRT_CALL	"call *(paravirt_ops+%c[paravirt_typenum]*8);"
+
+/*
+ * These macros are intended to wrap calls into a paravirt_ops
+ * operation, so that they can be later identified and patched at
+ * runtime.
+ *
+ * Normally, a call to a pv_op function is a simple indirect call:
+ * (paravirt_ops.operations)(args...).
+ *
+ * Unfortunately, this is a relatively slow operation for modern CPUs,
+ * because it cannot necessarily determine what the destination
+ * address is.  In this case, the address is a runtime constant, so at
+ * the very least we can patch the call to be a simple direct call, or
+ * ideally, patch an inline implementation into the callsite.  (Direct
+ * calls are essentially free, because the call and return addresses
+ * are completely predictable.)
+ *
+ * All caller-save registers are expected expected to be modified
+ * (either clobbered or used for return values). They are the return
+ * value (rax), the arguments potentially used by the functions, (rdi, rsi,
+ * rdx, rcx), and the others caller-saved (r8-r11)
+ *
+ * The call instruction itself is marked by placing its start address
+ * and size into the .parainstructions section, so that
+ * apply_paravirt() in arch/i386/kernel/alternative.c can do the
+ * appropriate patching under the control of the backend paravirt_ops
+ * implementation.
+ *
+ * Unfortunately there's no way to get gcc to generate the args setup
+ * for the call, and then allow the call itself to be generated by an
+ * inline asm.  Because of this, we must do the complete arg setup and
+ * return value handling from within these macros.  This is fairly
+ * cumbersome.
+ *
+ * There are 5 sets of PVOP_* macros for dealing with 0-4 arguments.
+ * It could be extended to more arguments, but there would be little
+ * to be gained from that.  For each number of arguments, there are
+ * the two VCALL and CALL variants for void and non-void functions.
+ * Small structures are passed and returned in registers.  The macro
+ * calling convention can't directly deal with this, so the wrapper
+ * functions must do this.
+ *
+ * These PVOP_* macros are only defined within this header.  This
+ * means that all uses must be wrapped in inline functions.  This also
+ * makes sure the incoming and outgoing types are always correct.
+*/
+#define CALL_CLOBBERS  "r8", "r9", "r10", "r11"
+
+#define __PVOP_CALL(rettype, op, pre, post, ...)			\
+	({								\
+		rettype __ret;						\
+		unsigned long __rax, __rdi, __rsi, __rdx, __rcx;	\
+		asm volatile(pre					\
+			     paravirt_alt(PARAVIRT_CALL)		\
+			     post					\
+			     : "=a" (__rax), "=D" (__rdi),		\
+			       "=S" (__rsi), "=d" (__rdx),		\
+			       "=c" (__rcx)				\
+			     : paravirt_type(op),			\
+			       paravirt_clobber(CLBR_ANY),		\
+			       ##__VA_ARGS__				\
+			     : "memory", CALL_CLOBBERS, "cc");		\
+		__ret = (rettype)__rax;					\
+	})
+
+#define __PVOP_VCALL(op, pre, post, ...)				\
+	({								\
+		unsigned long __rax, __rdi, __rsi, __rdx, __rcx;	\
+		asm volatile(pre					\
+			     paravirt_alt(PARAVIRT_CALL)		\
+			     post					\
+			     : "=a" (__rax), "=D" (__rdi),		\
+			       "=S" (__rsi), "=d" (__rdx),		\
+			       "=c" (__rcx)				\
+			     : paravirt_type(op),			\
+			       paravirt_clobber(CLBR_ANY),		\
+			       ##__VA_ARGS__				\
+			     : "memory", CALL_CLOBBERS, "cc");	\
+	})
+
+#define PVOP_CALL0(rettype, op)                                         \
+        __PVOP_CALL(rettype, op, "", "")
+#define PVOP_VCALL0(op)                                                 \
+        __PVOP_VCALL(op, "", "")
+
+#define PVOP_CALL1(rettype, op, arg1)                                   \
+        __PVOP_CALL(rettype, op, "", "", "D" ((u64)(arg1)))
+#define PVOP_VCALL1(op, arg1)                                           \
+        __PVOP_VCALL(op, "", "", "D" ((u64)(arg1)))
+
+#define PVOP_CALL2(rettype, op, arg1, arg2)                             \
+        __PVOP_CALL(rettype, op, "", "", "D" ((u64)(arg1)), "S" ((u64)(arg2)))
+#define PVOP_VCALL2(op, arg1, arg2)                                     \
+        __PVOP_VCALL(op, "", "", "D" ((u64)(arg1)), "S" ((u64)(arg2)))
+
+#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)                       \
+        __PVOP_CALL(rettype, op, "", "", "D" ((u64)(arg1)),             \
+                    "S"((u64)(arg2)), "d"((u64)(arg3)))
+#define PVOP_VCALL3(op, arg1, arg2, arg3)                               \
+        __PVOP_VCALL(op, "", "", "D" ((u64)(arg1)), "S"((u64)(arg2)),   \
+                     "d"((u64)(arg3)))
+
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)                 \
+        __PVOP_CALL(rettype, op, "", "", "D" ((u64)(arg1)),             \
+                    "S"((u64)(arg2)), "d"((u64)(arg3)), "c" ((u64)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)                         \
+        __PVOP_VCALL(op, "", "", "D" ((u64)(arg1)), "S"((u64)(arg2)),   \
+                     "d"((u64)(arg3)), "c"((u64)(arg4)))
+
+#define paravirt_arch_setup()	paravirt_ops.arch_setup()
+
+#define get_kernel_rpl	(paravirt_ops.kernel_rpl)
+
+static inline int paravirt_enabled(void)
+{
+	return paravirt_ops.paravirt_enabled;
+}
+
+static inline void load_rsp0(struct tss_struct *tss,
+				struct thread_struct *thread)
+{
+	PVOP_VCALL2(load_rsp0, tss,thread);
+}
+
+static inline void clts(void)
+{
+	PVOP_VCALL0(clts);
+}
+
+static inline unsigned long read_cr0(void)
+{
+	return PVOP_CALL0(unsigned long, read_cr0);
+}
+
+static inline void write_cr0(unsigned long x)
+{
+	PVOP_VCALL1(write_cr0, x);
+}
+
+static inline unsigned long read_cr2(void)
+{
+	return PVOP_CALL0(unsigned long, read_cr2);
+}
+
+static inline void write_cr2(unsigned long x)
+{
+	PVOP_VCALL1(write_cr2, x);
+}
+
+static inline unsigned long read_cr3(void)
+{
+	return PVOP_CALL0(unsigned long, read_cr3);
+}
+static inline void write_cr3(unsigned long x)
+{
+	PVOP_VCALL1(write_cr3, x);
+}
+
+static inline unsigned long read_cr4(void)
+{
+	return PVOP_CALL0(unsigned long, read_cr4);
+}
+static inline void write_cr4(unsigned long x)
+{
+	PVOP_VCALL1(write_cr4, x);
+}
+
+static inline void wbinvd(void)
+{
+	PVOP_VCALL0(wbinvd);
+}
+
+#define get_debugreg(var, reg) var = paravirt_ops.get_debugreg(reg)
+#define set_debugreg(val, reg) paravirt_ops.set_debugreg(reg, val)
+
+
+static inline void raw_safe_halt(void)
+{
+	PVOP_VCALL0(safe_halt);
+}
+
+static inline void halt(void)
+{
+	PVOP_VCALL0(safe_halt);
+}
+
+static inline unsigned long get_wallclock(void)
+{
+	return PVOP_CALL0(unsigned long, get_wallclock);
+}
+
+static inline int set_wallclock(unsigned long nowtime)
+{
+	return PVOP_CALL1(int, set_wallclock, nowtime);
+}
+
+static inline void do_time_init(void)
+{
+	PVOP_VCALL0(time_init);
+}
+
+/* The paravirtualized CPUID instruction. */
+static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
+			   unsigned int *ecx, unsigned int *edx)
+{
+	PVOP_VCALL4(cpuid, eax, ebx, ecx, edx);
+}
+
+
+static inline unsigned long read_msr(unsigned int msr)
+{
+	int __err;
+	return PVOP_CALL2(unsigned long, read_msr, msr, &__err);
+}
+
+static inline unsigned long write_msr(unsigned int msr, unsigned long val)
+{
+	return PVOP_CALL2(unsigned long, write_msr, msr, val);
+}
+
+static inline unsigned long read_msr_safe(unsigned int msr, int *err)
+{
+	return PVOP_CALL2(unsigned long, read_msr, msr, err);
+}
+
+static inline unsigned int write_msr_safe(unsigned int msr, unsigned long val)
+{
+	return PVOP_CALL2(unsigned long, write_msr, msr, val);
+}
+
+static inline unsigned long read_pmc(int counter)
+{
+	return PVOP_CALL1(unsigned long, read_pmc, counter);
+}
+
+static inline unsigned long read_tsc_reg(void)
+{
+	return PVOP_CALL0(unsigned long, read_tsc);
+}
+static inline unsigned long read_tscp(int *aux)
+{
+	return PVOP_CALL1(unsigned long, read_tscp, aux);
+}
+
+static inline void load_TR_desc(void)
+{
+	PVOP_VCALL0(load_tr_desc);
+}
+
+static inline void load_gdt(const struct desc_ptr *dtr)
+{
+	PVOP_VCALL1(load_gdt, dtr);
+}
+
+static inline void load_idt(const struct desc_ptr *dtr)
+{
+	PVOP_VCALL1(load_idt, dtr);
+}
+
+static inline void set_ldt(void *addr, unsigned entries)
+{
+	PVOP_VCALL2(set_ldt, addr, entries);
+}
+
+static inline void store_gdt(struct desc_ptr *dtr)
+{
+	PVOP_VCALL1(store_gdt, dtr);
+}
+
+static inline void store_idt(struct desc_ptr *dtr)
+{
+	PVOP_VCALL1(store_idt, dtr);
+}
+
+static inline unsigned long paravirt_store_tr(void)
+{
+	return PVOP_CALL0(unsigned long, store_tr);
+}
+
+#define store_tr(tr) 	(tr) = paravirt_store_tr();
+
+static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
+{
+	PVOP_VCALL2(load_tls, t,cpu);
+}
+
+static inline void write_ldt_entry(struct desc_struct *desc,
+				  int num, u32 entry1, u32 entry2)
+{
+	PVOP_VCALL4(write_ldt_entry, desc, num, entry1, entry2);
+}
+
+static inline void write_gdt_entry(void *ptr, void *entry,
+				   unsigned type, unsigned size)
+{
+	PVOP_VCALL4(write_gdt_entry, ptr, entry, type, size);
+}
+
+static inline void write_idt_entry(void *adr, struct gate_struct *s)
+{
+	PVOP_VCALL2(write_idt_entry, adr, s);
+}
+
+static inline pte_t __pte(unsigned long pte)
+{
+	return (pte_t) {PVOP_CALL1(unsigned long, make_pte, pte)};
+}
+static inline unsigned long pte_val(pte_t pte)
+{
+	return PVOP_CALL1(unsigned long, pte_val, pte.pte);
+}
+
+static inline pgd_t __pgd(unsigned long pgd)
+{
+	return (pgd_t) {PVOP_CALL1(unsigned long, make_pgd, pgd)};
+}
+static inline unsigned long pgd_val(pgd_t pgd)
+{
+	return PVOP_CALL1(unsigned long, pgd_val, pgd.pgd);
+}
+
+static inline pud_t __pud(unsigned long pud)
+{
+	return (pud_t) {PVOP_CALL1(unsigned long, make_pud, pud)};
+}
+static inline unsigned long pud_val(pud_t pud)
+{
+	return PVOP_CALL1(unsigned long, pud_val, pud.pud);
+}
+
+static inline pmd_t __pmd(unsigned long pmd)
+{
+	return (pmd_t) {PVOP_CALL1(unsigned long, make_pmd, pmd)};
+}
+static inline unsigned long pmd_val(pmd_t pmd)
+{
+	return PVOP_CALL1(unsigned long, pmd_val, pmd.pmd);
+}
+
+/* The paravirtualized I/O functions */
+static inline void slow_down_io(void) {
+	paravirt_ops.io_delay();
+#ifdef REALLY_SLOW_IO
+	paravirt_ops.io_delay();
+	paravirt_ops.io_delay();
+	paravirt_ops.io_delay();
+#endif
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+/*
+ * Basic functions accessing APICs.
+ */
+static inline void apic_write(unsigned long reg, unsigned long v)
+{
+	PVOP_VCALL2(apic_write, reg,v);
+}
+
+static inline unsigned int apic_read(unsigned long reg)
+{
+	return PVOP_CALL1(unsigned long, apic_read, reg);
+}
+
+static inline void setup_boot_clock(void)
+{
+	PVOP_VCALL0(setup_boot_clock);
+}
+
+static inline void setup_secondary_clock(void)
+{
+	PVOP_VCALL0(setup_secondary_clock);
+}
+
+static inline void startup_ipi_hook(int phys_apicid, unsigned long start_rip,
+					unsigned long init_rsp)
+{
+	PVOP_VCALL3(startup_ipi_hook, phys_apicid, start_rip, init_rsp);
+}
+
+#endif
+
+void native_nop(void);
+
+static inline void paravirt_activate_mm(struct mm_struct *prev,
+					struct mm_struct *next)
+{
+	PVOP_VCALL2(activate_mm, prev, next);
+}
+
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	PVOP_VCALL2(dup_mmap, oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	PVOP_VCALL1(exit_mmap, mm);
+}
+
+static inline void __flush_tlb(void)
+{
+	PVOP_VCALL0(flush_tlb_user);
+}
+static inline void __flush_tlb_all(void)
+{
+	PVOP_VCALL0(flush_tlb_kernel);
+}
+static inline void __flush_tlb_one(unsigned long addr)
+{
+	PVOP_VCALL1(flush_tlb_single, addr);
+}
+
+static inline void paravirt_release_pgd(pgd_t *pgd)
+{
+	PVOP_VCALL1(release_pgd, pgd);
+}
+
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL2(set_pte, ptep, pteval.pte);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, u64 addr, pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL4(set_pte_at, mm, addr, ptep, pteval.pte);
+}
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	PVOP_VCALL2(set_pmd, pmdp, pmdval.pmd);
+}
+
+static inline void pte_update(struct mm_struct *mm, u32 addr, pte_t *ptep)
+{
+	PVOP_VCALL3(pte_update, mm, addr, ptep);
+}
+
+static inline void pte_update_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
+{
+	PVOP_VCALL3(pte_update_defer, mm, addr, ptep);
+}
+
+
+static inline void set_pgd(pgd_t *pgdp, pgd_t pgdval)
+{
+	PVOP_VCALL2(set_pgd, pgdp, pgdval.pgd);
+}
+
+static inline void set_pud(pud_t *pudp, pud_t pudval)
+{
+	PVOP_VCALL2(set_pud, pudp, pudval.pud);
+}
+
+static inline void pte_clear(struct mm_struct *mm,
+			     unsigned long addr, pte_t *ptep)
+{
+	PVOP_VCALL3(pte_clear, mm, addr, ptep);
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	PVOP_VCALL1(pmd_clear, pmdp);
+}
+
+static inline void pud_clear(pud_t *pudp)
+{
+	PVOP_VCALL1(pud_clear, pudp);
+}
+
+static inline void pgd_clear(pgd_t *pgdp)
+{
+	PVOP_VCALL1(pgd_clear, pgdp);
+}
+
+#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
+#define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
+#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
+#define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+
+/* These functions tends to be very simple. So, if they touch any register,
+ * the calle-saved ones may already fulfill their needs, and hopefully we
+ * have no need to save any. */
+static inline unsigned long __raw_local_save_flags(void)
+{
+	unsigned long f;
+
+	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
+			     : "=a"(f)
+			     : paravirt_type(save_fl),
+			       paravirt_clobber(CLBR_RAX)
+			     : "memory", "cc");
+	return f;
+}
+
+static inline void raw_local_irq_restore(unsigned long f)
+{
+	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
+			     :
+			     : "D" (f),
+			       paravirt_type(restore_fl),
+			       paravirt_clobber(CLBR_RAX)
+			     : "memory", "rax", "cc");
+}
+
+static inline void raw_local_irq_disable(void)
+{
+	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
+			     :
+			     : paravirt_type(irq_disable),
+			       paravirt_clobber(CLBR_RAX)
+			     : "memory", "rax", "cc");
+}
+
+static inline void raw_local_irq_enable(void)
+{
+	__asm__ __volatile__(paravirt_alt(PARAVIRT_CALL)
+			     :
+			     : paravirt_type(irq_enable),
+			       paravirt_clobber(CLBR_RAX)
+			     : "memory", "rax", "cc");
+}
+
+/* These all sit in the .parainstructions section to tell us what to patch. */
+struct paravirt_patch_site {
+        u8 *instr;              /* original instructions */
+        u8 instrtype;           /* type of this instruction */
+        u8 len;                 /* length of original instruction */
+        u32 clobbers;           /* what registers you may clobber */
+} __attribute__((aligned(8)));
+
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
+
+#define CLI_STRING _paravirt_alt("call *paravirt_ops+%c[paravirt_cli_type];",	\
+			"%c[paravirt_cli_type]", "%c[paravirt_clobber]")
+
+#define STI_STRING _paravirt_alt("call *paravirt_ops+%c[paravirt_sti_type];",	\
+			"%c[paravirt_sti_type]", "%c[paravirt_clobber]")
+
+/* XXX: Should we clobber more? */
+#define CLI_STI_CLOBBERS "rax"
+#define CLI_STI_INPUT_ARGS \
+	[paravirt_cli_type] "i" (PARAVIRT_PATCH(irq_disable)),		\
+	[paravirt_sti_type] "i" (PARAVIRT_PATCH(irq_enable)),		\
+	paravirt_clobber(CLBR_RAX)
+
+#else  /* __ASSEMBLY__ */
+
+/* Make sure as little as possible of this mess escapes. */
+#undef PARAVIRT_CALL
+#undef __PVOP_CALL
+#undef __PVOP_VCALL
+#undef PVOP_VCALL0
+#undef PVOP_CALL0
+#undef PVOP_VCALL1
+#undef PVOP_CALL1
+#undef PVOP_VCALL2
+#undef PVOP_CALL2
+#undef PVOP_VCALL3
+#undef PVOP_CALL3
+#undef PVOP_VCALL4
+#undef PVOP_CALL4
+
+#define PARA_PATCH(off)	((off) / 8)
+
+#define PARA_SITE(ptype, clobbers, ops)		\
+771:;						\
+	ops;					\
+772:;						\
+	.pushsection .parainstructions,"a";	\
+	.align 8;				\
+	 .quad 771b;				\
+	 .byte ptype;				\
+	 .byte 772b-771b;			\
+	 .long clobbers;			\
+	.popsection
+
+/*
+ * For DISABLE/ENABLE_INTERRUPTS and SWAPGS
+ * we'll save some regs, but the callee needs to be careful
+ * not to touch others. We'll save the normal rax, rdi,
+ * rcx and rdx, but that's it!
+ */
+#define DISABLE_INTERRUPTS(clobbers)					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_disable), clobbers,		\
+		  pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx;	\
+		  call *paravirt_ops+PARAVIRT_irq_disable;		\
+		  popq %rdx; popq %rcx; popq %rdi; popq %rax;	\
+		);
+
+#define ENABLE_INTERRUPTS(clobbers)					\
+	PARA_SITE(PARA_PATCH(PARAVIRT_irq_enable), clobbers,		\
+		  pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx;	\
+		  call *%cs:paravirt_ops+PARAVIRT_irq_enable;		\
+		  popq %rdx; popq %rcx; popq %rdi; popq %rax;		\
+		);
+
+#define SWAPGS								\
+	PARA_SITE(PARA_PATCH(PARAVIRT_swapgs), CLBR_NONE,		\
+		  pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx;	\
+		  call *paravirt_ops+PARAVIRT_swapgs;			\
+		  popq %rdx; popq %rcx; popq %rdi; popq %rax;		\
+		);
+
+/*
+ * SYSRETQ and INTERRUPT_RETURN don't return, and we jump to a function.
+ * So it is all up to the callee to make sure that the registers
+ * are preserved.
+ */
+#define SYSRETQ							\
+	PARA_SITE(PARA_PATCH(PARAVIRT_sysret), CLBR_ANY,	\
+		  jmp *%cs:paravirt_ops+PARAVIRT_sysret)
+
+#define INTERRUPT_RETURN				\
+	PARA_SITE(PARA_PATCH(PARAVIRT_iret), CLBR_NONE,	\
+		  jmp *%cs:paravirt_ops+PARAVIRT_iret)
+
+
+/* this is needed in early_idt_handler */
+#define GET_CR2_INTO_RCX 				  \
+	call *paravirt_ops+PARAVIRT_read_cr2; 		  \
+	movq %rax, %rcx; 				  \
+	xorq %rax, %rax;				  \
+
+#endif	/* __ASSEMBLY__ */
+
+#else
+#  error "You should not include paravirt headers without paravirt support"
+#endif /* CONFIG_PARAVIRT */
+
+#endif	/* __ASM_PARAVIRT_H */
-- 
1.4.4.2

