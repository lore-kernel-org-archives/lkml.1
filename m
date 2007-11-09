Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXKIVg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXKIVg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbXKIV3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147AbXKIV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:48 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 23/24] consolidation of paravirt for 32 and 64 bits
Date: Fri,  9 Nov 2007 16:43:04 -0200
Message-Id: <11946339082711-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946339033567-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com> <1194633888761-git-send-email-gco!
 sta@redhat.com> <11946338932611-git-send-email-gcosta@redhat.com> <1194633898545-git-send-email-gcosta@redhat.com> <11946339033567-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies the paravirt ops structures for usage in
x86_64 and i386 architectures. Some new field had to be created
to accomodate the differences between the architectures.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/Kconfig.x86_64             |   11 +
 arch/x86/kernel/Makefile            |    3 +
 arch/x86/kernel/Makefile_32         |    1 -
 arch/x86/kernel/asm-offsets.c       |    8 +
 arch/x86/kernel/asm-offsets_32.c    |    8 -
 arch/x86/kernel/asm-offsets_64.c    |   22 +-
 arch/x86/kernel/paravirt.c          |  447 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/paravirt_32.c       |  472 -----------------------------------
 arch/x86/kernel/paravirt_patch_32.c |   52 ++++
 arch/x86/kernel/paravirt_patch_64.c |   56 ++++
 arch/x86/kernel/vmlinux_64.lds.S    |    6 +
 include/asm-x86/paravirt.h          |  472 +++++++++++++++++++++++++++++------
 12 files changed, 987 insertions(+), 571 deletions(-)

diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
index b45855c..568ba7a 100644
--- a/arch/x86/Kconfig.x86_64
+++ b/arch/x86/Kconfig.x86_64
@@ -372,6 +372,17 @@ config NODES_SHIFT
 
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
+config PARAVIRT
+	bool
+	depends on EXPERIMENTAL
+	help
+	  Paravirtualization is a way of running multiple instances of
+	  Linux on the same machine, under a hypervisor.  This option
+	  changes the kernel so it can modify itself when it is run
+	  under a hypervisor, improving performance significantly.
+	  However, when run without a hypervisor the kernel is
+	  theoretically slower.  If in doubt, say N.
+
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
        depends on NUMA
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 3857334..f444d0e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -1,8 +1,11 @@
 ifeq ($(CONFIG_X86_32),y)
 include ${srctree}/arch/x86/kernel/Makefile_32
+obj-$(CONFIG_PARAVIRT)		+= paravirt_patch_32.o
 else
 include ${srctree}/arch/x86/kernel/Makefile_64
+obj-$(CONFIG_PARAVIRT)		+= paravirt_patch_64.o
 endif
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 # Workaround to delete .lds files with make clean
 # The problem is that we do not enter Makefile_32 with make clean.
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index b0da543..44ba1d6 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -43,7 +43,6 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
 obj-y				+= pcspeaker.o
 
 obj-$(CONFIG_SCx200)		+= scx200_32.o
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cfa82c8..25530d5 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -1,3 +1,11 @@
+#define DEFINE(sym, val) \
+        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem));
+
 #ifdef CONFIG_X86_32
 # include "asm-offsets_32.c"
 #else
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index c1ccfab..f320b2d 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -25,14 +25,6 @@
 #include "../../../drivers/lguest/lg.h"
 #endif
 
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem));
-
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
 
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index d1b6ed9..3ef77dd 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -16,14 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
 #include <asm/bootparam.h>
-
-#define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
-
-#define BLANK() asm volatile("\n->" : : )
-
-#define OFFSET(sym, str, mem) \
-	DEFINE(sym, offsetof(struct str, mem))
+#include <asm/paravirt.h>
 
 #define __NO_STUBS 1
 #undef __SYSCALL
@@ -76,6 +69,19 @@ int main(void)
 	       offsetof (struct rt_sigframe32, uc.uc_mcontext));
 	BLANK();
 #endif
+#ifdef CONFIG_PARAVIRT
+	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
+	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
+	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
+	OFFSET(PARAVIRT_PATCH_pv_mmu_ops, paravirt_patch_template, pv_mmu_ops);
+	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
+	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
+	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
+	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
+	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
+	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
+	BLANK();
+#endif
 	DEFINE(pbe_address, offsetof(struct pbe, address));
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
 	DEFINE(pbe_next, offsetof(struct pbe, next));
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
new file mode 100644
index 0000000..8fc21ed
--- /dev/null
+++ b/arch/x86/kernel/paravirt.c
@@ -0,0 +1,447 @@
+/*  Paravirtualization interfaces
+    Copyright (C) 2006 Rusty Russell IBM Corporation
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
+
+    2007 - x86_64 support added by Glauber de Oliveira Costa
+*/
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/efi.h>
+#include <linux/bcd.h>
+#include <linux/highmem.h>
+#include <linux/pci_regs.h>
+#include <linux/pci_ids.h>
+
+#include <asm/bug.h>
+#include <asm/paravirt.h>
+#include <asm/desc.h>
+#include <asm/setup.h>
+#include <asm/arch_hooks.h>
+#include <asm/time.h>
+#include <asm/irq.h>
+#include <asm/delay.h>
+#include <asm/fixmap.h>
+#include <asm/apic.h>
+#include <asm/tlbflush.h>
+#include <asm/timer.h>
+#include <asm/io.h>
+#include <asm/pci-direct.h>
+
+
+/* nop stub */
+void _paravirt_nop(void)
+{
+}
+
+static void __init default_banner(void)
+{
+	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
+	       pv_info.name);
+}
+
+char *memory_setup(void)
+{
+	return pv_init_ops.memory_setup();
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
+struct branch {
+	unsigned char opcode;
+	u32 delta;
+} __attribute__((packed));
+
+unsigned paravirt_patch_call(void *insnbuf,
+			     const void *target, u16 tgt_clobbers,
+			     unsigned long addr, u16 site_clobbers,
+			     unsigned len)
+{
+	struct branch *b = insnbuf;
+	unsigned long delta = (unsigned long)target - (addr+5);
+
+	if (tgt_clobbers & ~site_clobbers)
+		return len;	/* target would clobber too much for this site */
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	b->opcode = 0xe8; /* call */
+	b->delta = delta;
+	BUILD_BUG_ON(sizeof(*b) != 5);
+
+	return 5;
+}
+
+unsigned paravirt_patch_jmp(void *insnbuf, const void *target,
+			    unsigned long addr, unsigned len)
+{
+	struct branch *b = insnbuf;
+	unsigned long delta = (unsigned long)target - (addr+5);
+
+	if (len < 5)
+		return len;	/* call too long for patch site */
+
+	b->opcode = 0xe9;	/* jmp */
+	b->delta = delta;
+
+	return 5;
+}
+
+/* Undefined instruction for dealing with missing ops pointers. */
+static const unsigned char ud2a[] = { 0x0f, 0x0b };
+
+/* Neat trick to map patch type back to the call within the
+ * corresponding structure. */
+static void *get_call_destination(u8 type)
+{
+	struct paravirt_patch_template tmpl = {
+		.pv_init_ops = pv_init_ops,
+		.pv_time_ops = pv_time_ops,
+		.pv_cpu_ops = pv_cpu_ops,
+		.pv_irq_ops = pv_irq_ops,
+		.pv_apic_ops = pv_apic_ops,
+		.pv_mmu_ops = pv_mmu_ops,
+	};
+	return *((void **)&tmpl + type);
+}
+
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
+				unsigned long addr, unsigned len)
+{
+	void *opfunc = get_call_destination(type);
+	unsigned ret;
+
+	if (opfunc == NULL)
+		/* If there's no function, patch it with a ud2a (BUG) */
+		ret = paravirt_patch_insns(insnbuf, len, ud2a, ud2a+sizeof(ud2a));
+	else if (opfunc == paravirt_nop)
+		/* If the operation is a nop, then nop the callsite */
+		ret = paravirt_patch_nop();
+	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
+		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
+		/* If operation requires a jmp, then jmp */
+		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
+	else
+		/* Otherwise call the function; assume target could
+		   clobber any caller-save reg */
+		ret = paravirt_patch_call(insnbuf, opfunc, CLBR_ANY,
+					  addr, clobbers, len);
+
+	return ret;
+}
+
+unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
+			      const char *start, const char *end)
+{
+	unsigned insn_len = end - start;
+
+	if (insn_len > len || start == NULL)
+		insn_len = len;
+	else
+		memcpy(insnbuf, start, insn_len);
+
+	return insn_len;
+}
+
+void init_IRQ(void)
+{
+	pv_irq_ops.init_IRQ();
+}
+
+static void native_flush_tlb(void)
+{
+	__native_flush_tlb();
+}
+
+/*
+ * Global pages have to be flushed a bit differently. Not a real
+ * performance problem because this does not happen often.
+ */
+static void native_flush_tlb_global(void)
+{
+	__native_flush_tlb_global();
+}
+
+static void native_flush_tlb_single(unsigned long addr)
+{
+	__native_flush_tlb_single(addr);
+}
+
+/* These are in entry.S */
+extern void native_iret(void);
+extern void native_irq_enable_syscall_ret(void);
+
+static int __init print_banner(void)
+{
+	pv_init_ops.banner();
+	return 0;
+}
+core_initcall(print_banner);
+
+static struct resource reserve_ioports = {
+	.start = 0,
+	.end = IO_SPACE_LIMIT,
+	.name = "paravirt-ioport",
+	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
+};
+
+static struct resource reserve_iomem = {
+	.start = 0,
+	.end = -1,
+	.name = "paravirt-iomem",
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+};
+
+/*
+ * Reserve the whole legacy IO space to prevent any legacy drivers
+ * from wasting time probing for their hardware.  This is a fairly
+ * brute-force approach to disabling all non-virtual drivers.
+ *
+ * Note that this must be called very early to have any effect.
+ */
+int paravirt_disable_iospace(void)
+{
+	int ret;
+
+	ret = request_resource(&ioport_resource, &reserve_ioports);
+	if (ret == 0) {
+		ret = request_resource(&iomem_resource, &reserve_iomem);
+		if (ret)
+			release_resource(&reserve_ioports);
+	}
+
+	return ret;
+}
+
+static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+
+static inline void enter_lazy(enum paravirt_lazy_mode mode)
+{
+	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
+	BUG_ON(preemptible());
+
+	__get_cpu_var(paravirt_lazy_mode) = mode;
+}
+
+void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
+{
+	BUG_ON(__get_cpu_var(paravirt_lazy_mode) != mode);
+	BUG_ON(preemptible());
+
+	__get_cpu_var(paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
+}
+
+void paravirt_enter_lazy_mmu(void)
+{
+	enter_lazy(PARAVIRT_LAZY_MMU);
+}
+
+void paravirt_leave_lazy_mmu(void)
+{
+	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
+}
+
+void paravirt_enter_lazy_cpu(void)
+{
+	enter_lazy(PARAVIRT_LAZY_CPU);
+}
+
+void paravirt_leave_lazy_cpu(void)
+{
+	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
+}
+
+enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
+{
+	return __get_cpu_var(paravirt_lazy_mode);
+}
+
+struct pv_info pv_info = {
+	.name = "bare hardware",
+	.paravirt_enabled = 0,
+	.kernel_rpl = 0,
+	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
+};
+
+struct pv_init_ops pv_init_ops = {
+	.patch = native_patch,
+	.banner = default_banner,
+	.arch_setup = paravirt_nop,
+	.memory_setup = machine_specific_memory_setup,
+};
+
+struct pv_time_ops pv_time_ops = {
+	.time_init = hpet_time_init,
+	.get_wallclock = native_get_wallclock,
+	.set_wallclock = native_set_wallclock,
+	.sched_clock = native_sched_clock,
+	.get_cpu_khz = native_calculate_cpu_khz,
+};
+
+struct pv_irq_ops pv_irq_ops = {
+	.init_IRQ = native_init_IRQ,
+	.save_fl = native_save_fl,
+	.restore_fl = native_restore_fl,
+	.irq_disable = native_irq_disable,
+	.irq_enable = native_irq_enable,
+	.safe_halt = native_safe_halt,
+	.halt = native_halt,
+	.read_cr8 = native_read_cr8,
+	.write_cr8 = native_write_cr8,
+};
+
+struct pv_cpu_ops pv_cpu_ops = {
+	.cpuid = native_cpuid,
+	.get_debugreg = native_get_debugreg,
+	.set_debugreg = native_set_debugreg,
+	.clts = native_clts,
+	.read_cr0 = native_read_cr0,
+	.write_cr0 = native_write_cr0,
+	.read_cr4 = native_read_cr4,
+	.read_cr4_safe = native_read_cr4_safe,
+	.write_cr4 = native_write_cr4,
+	.wbinvd = native_wbinvd,
+	.read_msr = native_read_msr_safe,
+	.write_msr = native_write_msr_safe,
+	.read_tsc = native_read_tsc,
+	.read_pmc = native_read_pmc,
+	.read_tscp = native_read_tscp,
+	.load_tr_desc = native_load_tr_desc,
+	.set_ldt = native_set_ldt,
+	.load_gdt = native_load_gdt,
+	.load_idt = native_load_idt,
+	.store_gdt = native_store_gdt,
+	.store_idt = native_store_idt,
+	.store_tr = native_store_tr,
+	.load_tls = native_load_tls,
+	.write_ldt_entry = write_dt_entry,
+#ifdef CONFIG_X86_32
+	.write_gdt_entry = write_dt_entry,
+	.write_idt_entry = write_dt_entry,
+#else
+	.write_gdt_entry = native_write_gdt_entry,
+	.write_idt_entry = native_write_idt_entry,
+#endif
+	.load_esp0 = native_load_esp0,
+
+	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
+	.iret = native_iret,
+	.swapgs = native_swapgs,
+
+	.set_iopl_mask = native_set_iopl_mask,
+	.io_delay = native_io_delay,
+
+	.lazy_mode = {
+		.enter = paravirt_nop,
+		.leave = paravirt_nop,
+	},
+};
+
+struct pv_apic_ops pv_apic_ops = {
+#ifdef CONFIG_X86_LOCAL_APIC
+	.apic_write = native_apic_write,
+	.apic_write_atomic = native_apic_write_atomic,
+	.apic_read = native_apic_read,
+	.setup_boot_clock = setup_boot_APIC_clock,
+	.setup_secondary_clock = setup_secondary_APIC_clock,
+	.startup_ipi_hook = paravirt_nop,
+#endif
+};
+
+struct pv_mmu_ops pv_mmu_ops = {
+#ifdef CONFIG_X86_32
+	.pagetable_setup_start = native_pagetable_setup_start,
+	.pagetable_setup_done = native_pagetable_setup_done,
+#else
+	.pagetable_setup_start = paravirt_nop,
+	.pagetable_setup_done = paravirt_nop,
+#endif
+
+	.read_cr2 = native_read_cr2,
+	.write_cr2 = native_write_cr2,
+	.read_cr3 = native_read_cr3,
+	.write_cr3 = native_write_cr3,
+
+	.flush_tlb_user = native_flush_tlb,
+	.flush_tlb_kernel = native_flush_tlb_global,
+	.flush_tlb_single = native_flush_tlb_single,
+	.flush_tlb_others = native_flush_tlb_others,
+
+	.alloc_pt = paravirt_nop,
+	.alloc_pd = paravirt_nop,
+	.alloc_pd_clone = paravirt_nop,
+	.release_pt = paravirt_nop,
+	.release_pd = paravirt_nop,
+
+	.set_pte = native_set_pte,
+	.set_pte_at = native_set_pte_at,
+	.set_pmd = native_set_pmd,
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
+
+#ifdef CONFIG_HIGHPTE
+	.kmap_atomic_pte = kmap_atomic,
+#endif
+
+#ifdef CONFIG_X86_PAE
+	.set_pte_atomic = native_set_pte_atomic,
+	.set_pte_present = native_set_pte_present,
+#endif
+#if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
+	.set_pud = native_set_pud,
+	.pte_clear = native_pte_clear,
+	.pmd_clear = native_pmd_clear,
+	.pmd_val = native_pmd_val,
+	.make_pmd = native_make_pmd,
+#endif
+	.pte_val = native_pte_val,
+	.pgd_val = native_pgd_val,
+
+	.make_pte = native_make_pte,
+	.make_pgd = native_make_pgd,
+#ifdef CONFIG_X86_64
+	.set_pgd = native_set_pgd,
+
+	.pud_clear = native_pud_clear,
+	.pgd_clear = native_pgd_clear,
+
+	.pud_val = native_pud_val,
+
+	.make_pud = native_make_pud,
+#endif
+	.dup_mmap = paravirt_nop,
+	.exit_mmap = paravirt_nop,
+	.activate_mm = paravirt_nop,
+
+	.lazy_mode = {
+		.enter = paravirt_nop,
+		.leave = paravirt_nop,
+	},
+};
+
+EXPORT_SYMBOL_GPL(pv_time_ops);
+EXPORT_SYMBOL_GPL(pv_cpu_ops);
+EXPORT_SYMBOL_GPL(pv_mmu_ops);
+EXPORT_SYMBOL_GPL(pv_apic_ops);
+EXPORT_SYMBOL_GPL(pv_info);
+EXPORT_SYMBOL    (pv_irq_ops);
diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
deleted file mode 100644
index 04f51d0..0000000
--- a/arch/x86/kernel/paravirt_32.c
+++ /dev/null
@@ -1,472 +0,0 @@
-/*  Paravirtualization interfaces
-    Copyright (C) 2006 Rusty Russell IBM Corporation
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-*/
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/efi.h>
-#include <linux/bcd.h>
-#include <linux/highmem.h>
-
-#include <asm/bug.h>
-#include <asm/paravirt.h>
-#include <asm/desc.h>
-#include <asm/setup.h>
-#include <asm/arch_hooks.h>
-#include <asm/time.h>
-#include <asm/irq.h>
-#include <asm/delay.h>
-#include <asm/fixmap.h>
-#include <asm/apic.h>
-#include <asm/tlbflush.h>
-#include <asm/timer.h>
-
-/* nop stub */
-void _paravirt_nop(void)
-{
-}
-
-static void __init default_banner(void)
-{
-	printk(KERN_INFO "Booting paravirtualized kernel on %s\n",
-	       pv_info.name);
-}
-
-char *memory_setup(void)
-{
-	return pv_init_ops.memory_setup();
-}
-
-/* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code)					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
-
-DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
-DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
-DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
-DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
-DEF_NATIVE(pv_cpu_ops, iret, "iret");
-DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
-DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
-DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
-DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
-DEF_NATIVE(pv_cpu_ops, clts, "clts");
-DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
-
-/* Undefined instruction for dealing with missing ops pointers. */
-static const unsigned char ud2a[] = { 0x0f, 0x0b };
-
-static unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
-			     unsigned long addr, unsigned len)
-{
-	const unsigned char *start, *end;
-	unsigned ret;
-
-	switch(type) {
-#define SITE(ops, x)						\
-	case PARAVIRT_PATCH(ops.x):				\
-		start = start_##ops##_##x;			\
-		end = end_##ops##_##x;				\
-		goto patch_site
-
-	SITE(pv_irq_ops, irq_disable);
-	SITE(pv_irq_ops, irq_enable);
-	SITE(pv_irq_ops, restore_fl);
-	SITE(pv_irq_ops, save_fl);
-	SITE(pv_cpu_ops, iret);
-	SITE(pv_cpu_ops, irq_enable_syscall_ret);
-	SITE(pv_mmu_ops, read_cr2);
-	SITE(pv_mmu_ops, read_cr3);
-	SITE(pv_mmu_ops, write_cr3);
-	SITE(pv_cpu_ops, clts);
-	SITE(pv_cpu_ops, read_tsc);
-#undef SITE
-
-	patch_site:
-		ret = paravirt_patch_insns(ibuf, len, start, end);
-		break;
-
-	default:
-		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
-		break;
-	}
-
-	return ret;
-}
-
-unsigned paravirt_patch_nop(void)
-{
-	return 0;
-}
-
-unsigned paravirt_patch_ignore(unsigned len)
-{
-	return len;
-}
-
-struct branch {
-	unsigned char opcode;
-	u32 delta;
-} __attribute__((packed));
-
-unsigned paravirt_patch_call(void *insnbuf,
-			     const void *target, u16 tgt_clobbers,
-			     unsigned long addr, u16 site_clobbers,
-			     unsigned len)
-{
-	struct branch *b = insnbuf;
-	unsigned long delta = (unsigned long)target - (addr+5);
-
-	if (tgt_clobbers & ~site_clobbers)
-		return len;	/* target would clobber too much for this site */
-	if (len < 5)
-		return len;	/* call too long for patch site */
-
-	b->opcode = 0xe8; /* call */
-	b->delta = delta;
-	BUILD_BUG_ON(sizeof(*b) != 5);
-
-	return 5;
-}
-
-unsigned paravirt_patch_jmp(void *insnbuf, const void *target,
-			    unsigned long addr, unsigned len)
-{
-	struct branch *b = insnbuf;
-	unsigned long delta = (unsigned long)target - (addr+5);
-
-	if (len < 5)
-		return len;	/* call too long for patch site */
-
-	b->opcode = 0xe9;	/* jmp */
-	b->delta = delta;
-
-	return 5;
-}
-
-/* Neat trick to map patch type back to the call within the
- * corresponding structure. */
-static void *get_call_destination(u8 type)
-{
-	struct paravirt_patch_template tmpl = {
-		.pv_init_ops = pv_init_ops,
-		.pv_time_ops = pv_time_ops,
-		.pv_cpu_ops = pv_cpu_ops,
-		.pv_irq_ops = pv_irq_ops,
-		.pv_apic_ops = pv_apic_ops,
-		.pv_mmu_ops = pv_mmu_ops,
-	};
-	return *((void **)&tmpl + type);
-}
-
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
-				unsigned long addr, unsigned len)
-{
-	void *opfunc = get_call_destination(type);
-	unsigned ret;
-
-	if (opfunc == NULL)
-		/* If there's no function, patch it with a ud2a (BUG) */
-		ret = paravirt_patch_insns(insnbuf, len, ud2a, ud2a+sizeof(ud2a));
-	else if (opfunc == paravirt_nop)
-		/* If the operation is a nop, then nop the callsite */
-		ret = paravirt_patch_nop();
-	else if (type == PARAVIRT_PATCH(pv_cpu_ops.iret) ||
-		 type == PARAVIRT_PATCH(pv_cpu_ops.irq_enable_syscall_ret))
-		/* If operation requires a jmp, then jmp */
-		ret = paravirt_patch_jmp(insnbuf, opfunc, addr, len);
-	else
-		/* Otherwise call the function; assume target could
-		   clobber any caller-save reg */
-		ret = paravirt_patch_call(insnbuf, opfunc, CLBR_ANY,
-					  addr, clobbers, len);
-
-	return ret;
-}
-
-unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
-			      const char *start, const char *end)
-{
-	unsigned insn_len = end - start;
-
-	if (insn_len > len || start == NULL)
-		insn_len = len;
-	else
-		memcpy(insnbuf, start, insn_len);
-
-	return insn_len;
-}
-
-void init_IRQ(void)
-{
-	pv_irq_ops.init_IRQ();
-}
-
-static void native_flush_tlb(void)
-{
-	__native_flush_tlb();
-}
-
-/*
- * Global pages have to be flushed a bit differently. Not a real
- * performance problem because this does not happen often.
- */
-static void native_flush_tlb_global(void)
-{
-	__native_flush_tlb_global();
-}
-
-static void native_flush_tlb_single(unsigned long addr)
-{
-	__native_flush_tlb_single(addr);
-}
-
-/* These are in entry.S */
-extern void native_iret(void);
-extern void native_irq_enable_syscall_ret(void);
-
-static int __init print_banner(void)
-{
-	pv_init_ops.banner();
-	return 0;
-}
-core_initcall(print_banner);
-
-static struct resource reserve_ioports = {
-	.start = 0,
-	.end = IO_SPACE_LIMIT,
-	.name = "paravirt-ioport",
-	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
-};
-
-static struct resource reserve_iomem = {
-	.start = 0,
-	.end = -1,
-	.name = "paravirt-iomem",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
-};
-
-/*
- * Reserve the whole legacy IO space to prevent any legacy drivers
- * from wasting time probing for their hardware.  This is a fairly
- * brute-force approach to disabling all non-virtual drivers.
- *
- * Note that this must be called very early to have any effect.
- */
-int paravirt_disable_iospace(void)
-{
-	int ret;
-
-	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0) {
-		ret = request_resource(&iomem_resource, &reserve_iomem);
-		if (ret)
-			release_resource(&reserve_ioports);
-	}
-
-	return ret;
-}
-
-static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;
-
-static inline void enter_lazy(enum paravirt_lazy_mode mode)
-{
-	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
-	BUG_ON(preemptible());
-
-	x86_write_percpu(paravirt_lazy_mode, mode);
-}
-
-void paravirt_leave_lazy(enum paravirt_lazy_mode mode)
-{
-	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
-	BUG_ON(preemptible());
-
-	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
-}
-
-void paravirt_enter_lazy_mmu(void)
-{
-	enter_lazy(PARAVIRT_LAZY_MMU);
-}
-
-void paravirt_leave_lazy_mmu(void)
-{
-	paravirt_leave_lazy(PARAVIRT_LAZY_MMU);
-}
-
-void paravirt_enter_lazy_cpu(void)
-{
-	enter_lazy(PARAVIRT_LAZY_CPU);
-}
-
-void paravirt_leave_lazy_cpu(void)
-{
-	paravirt_leave_lazy(PARAVIRT_LAZY_CPU);
-}
-
-enum paravirt_lazy_mode paravirt_get_lazy_mode(void)
-{
-	return x86_read_percpu(paravirt_lazy_mode);
-}
-
-struct pv_info pv_info = {
-	.name = "bare hardware",
-	.paravirt_enabled = 0,
-	.kernel_rpl = 0,
-	.shared_kernel_pmd = 1,	/* Only used when CONFIG_X86_PAE is set */
-};
-
-struct pv_init_ops pv_init_ops = {
-	.patch = native_patch,
-	.banner = default_banner,
-	.arch_setup = paravirt_nop,
-	.memory_setup = machine_specific_memory_setup,
-};
-
-struct pv_time_ops pv_time_ops = {
-	.time_init = hpet_time_init,
-	.get_wallclock = native_get_wallclock,
-	.set_wallclock = native_set_wallclock,
-	.sched_clock = native_sched_clock,
-	.get_cpu_khz = native_calculate_cpu_khz,
-};
-
-struct pv_irq_ops pv_irq_ops = {
-	.init_IRQ = native_init_IRQ,
-	.save_fl = native_save_fl,
-	.restore_fl = native_restore_fl,
-	.irq_disable = native_irq_disable,
-	.irq_enable = native_irq_enable,
-	.safe_halt = native_safe_halt,
-	.halt = native_halt,
-};
-
-struct pv_cpu_ops pv_cpu_ops = {
-	.cpuid = native_cpuid,
-	.get_debugreg = native_get_debugreg,
-	.set_debugreg = native_set_debugreg,
-	.clts = native_clts,
-	.read_cr0 = native_read_cr0,
-	.write_cr0 = native_write_cr0,
-	.read_cr4 = native_read_cr4,
-	.read_cr4_safe = native_read_cr4_safe,
-	.write_cr4 = native_write_cr4,
-	.wbinvd = native_wbinvd,
-	.read_msr = native_read_msr_safe,
-	.write_msr = native_write_msr_safe,
-	.read_tsc = native_read_tsc,
-	.read_pmc = native_read_pmc,
-	.load_tr_desc = native_load_tr_desc,
-	.set_ldt = native_set_ldt,
-	.load_gdt = native_load_gdt,
-	.load_idt = native_load_idt,
-	.store_gdt = native_store_gdt,
-	.store_idt = native_store_idt,
-	.store_tr = native_store_tr,
-	.load_tls = native_load_tls,
-	.write_ldt_entry = write_dt_entry,
-	.write_gdt_entry = write_dt_entry,
-	.write_idt_entry = write_dt_entry,
-	.load_esp0 = native_load_esp0,
-
-	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
-	.iret = native_iret,
-
-	.set_iopl_mask = native_set_iopl_mask,
-	.io_delay = native_io_delay,
-
-	.lazy_mode = {
-		.enter = paravirt_nop,
-		.leave = paravirt_nop,
-	},
-};
-
-struct pv_apic_ops pv_apic_ops = {
-#ifdef CONFIG_X86_LOCAL_APIC
-	.apic_write = native_apic_write,
-	.apic_write_atomic = native_apic_write_atomic,
-	.apic_read = native_apic_read,
-	.setup_boot_clock = setup_boot_APIC_clock,
-	.setup_secondary_clock = setup_secondary_APIC_clock,
-	.startup_ipi_hook = paravirt_nop,
-#endif
-};
-
-struct pv_mmu_ops pv_mmu_ops = {
-	.pagetable_setup_start = native_pagetable_setup_start,
-	.pagetable_setup_done = native_pagetable_setup_done,
-
-	.read_cr2 = native_read_cr2,
-	.write_cr2 = native_write_cr2,
-	.read_cr3 = native_read_cr3,
-	.write_cr3 = native_write_cr3,
-
-	.flush_tlb_user = native_flush_tlb,
-	.flush_tlb_kernel = native_flush_tlb_global,
-	.flush_tlb_single = native_flush_tlb_single,
-	.flush_tlb_others = native_flush_tlb_others,
-
-	.alloc_pt = paravirt_nop,
-	.alloc_pd = paravirt_nop,
-	.alloc_pd_clone = paravirt_nop,
-	.release_pt = paravirt_nop,
-	.release_pd = paravirt_nop,
-
-	.set_pte = native_set_pte,
-	.set_pte_at = native_set_pte_at,
-	.set_pmd = native_set_pmd,
-	.pte_update = paravirt_nop,
-	.pte_update_defer = paravirt_nop,
-
-#ifdef CONFIG_HIGHPTE
-	.kmap_atomic_pte = kmap_atomic,
-#endif
-
-#ifdef CONFIG_X86_PAE
-	.set_pte_atomic = native_set_pte_atomic,
-	.set_pte_present = native_set_pte_present,
-	.set_pud = native_set_pud,
-	.pte_clear = native_pte_clear,
-	.pmd_clear = native_pmd_clear,
-
-	.pmd_val = native_pmd_val,
-	.make_pmd = native_make_pmd,
-#endif
-
-	.pte_val = native_pte_val,
-	.pgd_val = native_pgd_val,
-
-	.make_pte = native_make_pte,
-	.make_pgd = native_make_pgd,
-
-	.dup_mmap = paravirt_nop,
-	.exit_mmap = paravirt_nop,
-	.activate_mm = paravirt_nop,
-
-	.lazy_mode = {
-		.enter = paravirt_nop,
-		.leave = paravirt_nop,
-	},
-};
-
-EXPORT_SYMBOL_GPL(pv_time_ops);
-EXPORT_SYMBOL_GPL(pv_cpu_ops);
-EXPORT_SYMBOL_GPL(pv_mmu_ops);
-EXPORT_SYMBOL_GPL(pv_apic_ops);
-EXPORT_SYMBOL_GPL(pv_info);
-EXPORT_SYMBOL    (pv_irq_ops);
diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
new file mode 100644
index 0000000..46ae585
--- /dev/null
+++ b/arch/x86/kernel/paravirt_patch_32.c
@@ -0,0 +1,52 @@
+#include <asm/paravirt.h>
+
+DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
+DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
+DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
+DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
+DEF_NATIVE(pv_cpu_ops, iret, "iret");
+DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
+DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
+DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
+DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
+DEF_NATIVE(pv_cpu_ops, clts, "clts");
+DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
+
+/* Undefined instruction for dealing with missing ops pointers. */
+static const unsigned char ud2a[] = { 0x0f, 0x0b };
+
+unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+		      unsigned long addr, unsigned len)
+{
+	const unsigned char *start, *end;
+	unsigned ret;
+
+#define PATCH_SITE(ops, x)					\
+		case PARAVIRT_PATCH(ops.x):			\
+			start = start_##ops##_##x;		\
+			end = end_##ops##_##x;			\
+			goto patch_site
+	switch(type) {
+		PATCH_SITE(pv_irq_ops, irq_disable);
+		PATCH_SITE(pv_irq_ops, irq_enable);
+		PATCH_SITE(pv_irq_ops, restore_fl);
+		PATCH_SITE(pv_irq_ops, save_fl);
+		PATCH_SITE(pv_cpu_ops, iret);
+		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
+		PATCH_SITE(pv_mmu_ops, read_cr2);
+		PATCH_SITE(pv_mmu_ops, read_cr3);
+		PATCH_SITE(pv_mmu_ops, write_cr3);
+		PATCH_SITE(pv_cpu_ops, clts);
+		PATCH_SITE(pv_cpu_ops, read_tsc);
+
+	patch_site:
+		ret = paravirt_patch_insns(ibuf, len, start, end);
+		break;
+
+	default:
+		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
+		break;
+	}
+#undef PATCH_SITE
+	return ret;
+}
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
new file mode 100644
index 0000000..cbfc4f3
--- /dev/null
+++ b/arch/x86/kernel/paravirt_patch_64.c
@@ -0,0 +1,56 @@
+#include <asm/paravirt.h>
+#include <asm/asm-offsets.h>
+
+DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
+DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
+DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
+DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
+DEF_NATIVE(pv_cpu_ops, iret, "iretq");
+DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
+DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
+DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
+DEF_NATIVE(pv_mmu_ops, flush_tlb_single, "invlpg (%rdi)");
+DEF_NATIVE(pv_cpu_ops, clts, "clts");
+DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
+
+/* the three commands give us more control to how to return from a syscall */
+DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
+DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
+
+unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+		      unsigned long addr, unsigned len)
+{
+	const unsigned char *start, *end;
+	unsigned ret;
+
+#define PATCH_SITE(ops, x)					\
+		case PARAVIRT_PATCH(ops.x):			\
+			start = start_##ops##_##x;		\
+			end = end_##ops##_##x;			\
+			goto patch_site
+	switch(type) {
+		PATCH_SITE(pv_irq_ops, restore_fl);
+		PATCH_SITE(pv_irq_ops, save_fl);
+		PATCH_SITE(pv_irq_ops, irq_enable);
+		PATCH_SITE(pv_irq_ops, irq_disable);
+		PATCH_SITE(pv_cpu_ops, iret);
+		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
+		PATCH_SITE(pv_cpu_ops, swapgs);
+		PATCH_SITE(pv_mmu_ops, read_cr2);
+		PATCH_SITE(pv_mmu_ops, read_cr3);
+		PATCH_SITE(pv_mmu_ops, write_cr3);
+		PATCH_SITE(pv_cpu_ops, clts);
+		PATCH_SITE(pv_mmu_ops, flush_tlb_single);
+		PATCH_SITE(pv_cpu_ops, wbinvd);
+
+	patch_site:
+		ret = paravirt_patch_insns(ibuf, len, start, end);
+		break;
+
+	default:
+		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
+		break;
+	}
+#undef PATCH_SITE
+	return ret;
+}
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index ba8ea97..c3fce85 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
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
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index d81a361..13291e2 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -7,23 +7,42 @@
 #include <asm/page.h>
 
 /* Bitmask of what can be clobbered: usually at least eax. */
-#define CLBR_NONE 0x0
-#define CLBR_EAX 0x1
-#define CLBR_ECX 0x2
-#define CLBR_EDX 0x4
-#define CLBR_ANY 0x7
+#define CLBR_NONE 0
+#define CLBR_EAX  (1 << 0)
+#define CLBR_ECX  (1 << 1)
+#define CLBR_EDX  (1 << 2)
+
+#ifdef CONFIG_X86_64
+#define CLBR_RSI  (1 << 3)
+#define CLBR_RDI  (1 << 4)
+#define CLBR_R8   (1 << 5)
+#define CLBR_R9   (1 << 6)
+#define CLBR_R10  (1 << 7)
+#define CLBR_R11  (1 << 8)
+#define CLBR_ANY  ((1 << 9) - 1)
+#include <asm/desc_defs.h>
+#else
+/* CLBR_ANY should match all regs platform has. For i386, that's just it */
+#define CLBR_ANY  ((1 << 3) - 1)
+#endif /* X86_64 */
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
 #include <asm/kmap_types.h>
+#include <linux/stringify.h>
 
 struct page;
 struct thread_struct;
-struct Xgt_desc_struct;
 struct tss_struct;
 struct mm_struct;
 struct desc_struct;
+/* FIXME: Ideally, the two arches would use the same data structure */
+#ifdef CONFIG_X86_64
+typedef struct desc_ptr x86_descr_ptr;
+#else
+typedef struct Xgt_desc_struct x86_descr_ptr;
+#endif
 
 /* general info */
 struct pv_info {
@@ -54,7 +73,6 @@ struct pv_init_ops {
 	void (*banner)(void);
 };
 
-
 struct pv_lazy_ops {
 	/* Set deferred update mode, used for batching operations. */
 	void (*enter)(void);
@@ -86,21 +104,29 @@ struct pv_cpu_ops {
 	unsigned long (*read_cr4)(void);
 	void (*write_cr4)(unsigned long);
 
+
 	/* Segment descriptor handling */
 	void (*load_tr_desc)(void);
-	void (*load_gdt)(const struct Xgt_desc_struct *);
-	void (*load_idt)(const struct Xgt_desc_struct *);
-	void (*store_gdt)(struct Xgt_desc_struct *);
-	void (*store_idt)(struct Xgt_desc_struct *);
+	void (*load_gdt)(const x86_descr_ptr *);
+	void (*load_idt)(const x86_descr_ptr *);
+	void (*store_gdt)(x86_descr_ptr *);
+	void (*store_idt)(x86_descr_ptr *);
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
 	void (*write_ldt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
+#ifdef CONFIG_X86_32
 	void (*write_gdt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
 	void (*write_idt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
+#else
+	void (*write_gdt_entry)(void *ptr, void *entry, unsigned type,
+					 unsigned size);
+	void (*write_idt_entry)(void *adr, struct gate_struct *s);
+#endif
+
 	void (*load_esp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
@@ -115,15 +141,18 @@ struct pv_cpu_ops {
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr)(unsigned int msr, int *err);
-	int (*write_msr)(unsigned int msr, u64 val);
+	int (*write_msr)(unsigned int msr, unsigned int low, unsigned int high);
 
 	u64 (*read_tsc)(void);
-	u64 (*read_pmc)(void);
+	u64 (*read_pmc)(int counter);
+	u64 (*read_tscp)(int *aux);
 
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_syscall_ret)(void);
 	void (*iret)(void);
 
+	void (*swapgs)(void);
+
 	struct pv_lazy_ops lazy_mode;
 };
 
@@ -142,6 +171,10 @@ struct pv_irq_ops {
 	void (*irq_enable)(void);
 	void (*safe_halt)(void);
 	void (*halt)(void);
+
+	/* cr8 register has interrupt priority information on x86_64 */
+	unsigned long (*read_cr8)(void);
+	void (*write_cr8)(unsigned long);
 };
 
 struct pv_apic_ops {
@@ -150,9 +183,9 @@ struct pv_apic_ops {
 	 * Direct APIC operations, principally for VMI.  Ideally
 	 * these shouldn't be in this interface.
 	 */
-	void (*apic_write)(unsigned long reg, unsigned long v);
-	void (*apic_write_atomic)(unsigned long reg, unsigned long v);
-	unsigned long (*apic_read)(unsigned long reg);
+	void (*apic_write)(unsigned long reg, u32 v);
+	void (*apic_write_atomic)(unsigned long reg, u32 v);
+	u32 (*apic_read)(unsigned long reg);
 	void (*setup_boot_clock)(void);
 	void (*setup_secondary_clock)(void);
 
@@ -216,6 +249,8 @@ struct pv_mmu_ops {
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
+#endif
+#if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
@@ -227,6 +262,16 @@ struct pv_mmu_ops {
 	pte_t (*make_pte)(unsigned long long pte);
 	pmd_t (*make_pmd)(unsigned long long pmd);
 	pgd_t (*make_pgd)(unsigned long long pgd);
+  #ifdef CONFIG_X86_64
+	void (*set_pgd)(pgd_t *pgdp, pgd_t pgdval);
+
+	void (*pud_clear)(pud_t *pudp);
+	void (*pgd_clear)(pgd_t *pgdp);
+
+	unsigned long long (*pud_val)(pud_t);
+
+	pud_t (*make_pud)(unsigned long long pud);
+  #endif
 #else
 	unsigned long (*pte_val)(pte_t);
 	unsigned long (*pgd_val)(pgd_t);
@@ -255,6 +300,12 @@ struct paravirt_patch_template
 	struct pv_mmu_ops pv_mmu_ops;
 };
 
+#ifdef CONFIG_X86_64
+#define WORDSIZE_STR	"  .quad"
+#else
+#define WORDSIZE_STR	"  .long"
+#endif
+
 extern struct pv_info pv_info;
 extern struct pv_init_ops pv_init_ops;
 extern struct pv_time_ops pv_time_ops;
@@ -279,7 +330,8 @@ extern struct pv_mmu_ops pv_mmu_ops;
 #define _paravirt_alt(insn_string, type, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
-	"  .long 771b\n"				\
+	".align 8\n"					\
+	WORDSIZE_STR "  771b\n"				\
 	"  .byte " type "\n"				\
 	"  .byte 772b-771b\n"				\
 	"  .short " clobber "\n"			\
@@ -289,6 +341,11 @@ extern struct pv_mmu_ops pv_mmu_ops;
 #define paravirt_alt(insn_string)					\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
+/* Simple instruction patching code. */
+#define DEF_NATIVE(ops, name, code) 					\
+	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
+
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ignore(unsigned len);
 unsigned paravirt_patch_call(void *insnbuf,
@@ -303,6 +360,9 @@ unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
 unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
 			      const char *start, const char *end);
 
+unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+                      unsigned long addr, unsigned len);
+
 int paravirt_disable_iospace(void);
 
 /*
@@ -319,22 +379,29 @@ int paravirt_disable_iospace(void);
  * runtime.
  *
  * Normally, a call to a pv_op function is a simple indirect call:
- * (paravirt_ops.operations)(args...).
+ * (pv_op_struct.operations)(args...).
  *
  * Unfortunately, this is a relatively slow operation for modern CPUs,
  * because it cannot necessarily determine what the destination
- * address is.  In this case, the address is a runtime constant, so at
- * the very least we can patch the call to e a simple direct call, or
+ * address is. In this case, the address is a runtime constant, so at
+ * the very least we can patch the call to be a simple direct call, or
  * ideally, patch an inline implementation into the callsite.  (Direct
  * calls are essentially free, because the call and return addresses
  * are completely predictable.)
  *
- * These macros rely on the standard gcc "regparm(3)" calling
+ * For i386, these macros rely on the standard gcc "regparm(3)" calling
  * convention, in which the first three arguments are placed in %eax,
  * %edx, %ecx (in that order), and the remaining arguments are placed
  * on the stack.  All caller-save registers (eax,edx,ecx) are expected
  * to be modified (either clobbered or used for return values).
  *
+ * X86_64, on the other hand, already specifies a register-based calling
+ * conventions, returning at %rax, with parameteres going on %rdi, %rsi,
+ * %rdx, and %rcx. Note that for this reason, x86_64 does not need any
+ * special handling for dealing with 4 arguments, unlike i386.
+ * However, x86_64 also have to clobber all caller saved registers, which
+ * unfortunately, are quite a bit (r8 - r11)
+ *
  * The call instruction itself is marked by placing its start address
  * and size into the .parainstructions section, so that
  * apply_paravirt() in arch/i386/kernel/alternative.c can do the
@@ -356,9 +423,10 @@ int paravirt_disable_iospace(void);
  * the return type.  The macro then uses sizeof() on that type to
  * determine whether its a 32 or 64 bit value, and places the return
  * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
- * 64-bit).
+ * 64-bit). For x86_64 machines, it just returns at %rax regardless of
+ * the return value size.
  *
- * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
+ * i386 also passes 64-bit arguments as a pair of adjacent 32-bit arguments
  * in low,high order.
  *
  * Small structures are passed and returned in registers.  The macro
@@ -369,46 +437,67 @@ int paravirt_disable_iospace(void);
  * means that all uses must be wrapped in inline functions.  This also
  * makes sure the incoming and outgoing types are always correct.
  */
+#ifdef CONFIG_X86_32
+#define PVOP_VCALL_ARGS			unsigned long __eax,__edx,__ecx
+#define PVOP_CALL_ARGS			PVOP_VCALL_ARGS
+#define PVOP_VCALL_CLOBBERS		"=a" (__eax), "=d" (__edx),	\
+					"=c" (__ecx)
+#define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
+#define EXTRA_CLOBBERS
+#define VEXTRA_CLOBBERS
+#else
+#define PVOP_VCALL_ARGS		unsigned long __edi,__esi,__edx,__ecx
+#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+#define PVOP_VCALL_CLOBBERS	"=D" (__edi),				\
+				"=S" (__esi), "=d" (__edx),		\
+				"=c" (__ecx)
+
+#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
+
+#define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
+#define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
+#endif
+
 #define __PVOP_CALL(rettype, op, pre, post, ...)			\
 	({								\
 		rettype __ret;						\
-		unsigned long __eax, __edx, __ecx;			\
+		PVOP_CALL_ARGS;					\
+		/* This is 32-bit specific, but is okay in 64-bit */	\
+		/* since this condition will never hold */		\
 		if (sizeof(rettype) > sizeof(unsigned long)) {		\
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
+				     : PVOP_CALL_CLOBBERS		\
 				     : paravirt_type(op),		\
 				       paravirt_clobber(CLBR_ANY),	\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
+				     : "memory", "cc" EXTRA_CLOBBERS);	\
 			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
 		} else {						\
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
+				     : PVOP_CALL_CLOBBERS		\
 				     : paravirt_type(op),		\
 				       paravirt_clobber(CLBR_ANY),	\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
+				     : "memory", "cc" EXTRA_CLOBBERS);	\
 			__ret = (rettype)__eax;				\
 		}							\
 		__ret;							\
 	})
 #define __PVOP_VCALL(op, pre, post, ...)				\
 	({								\
-		unsigned long __eax, __edx, __ecx;			\
+		PVOP_VCALL_ARGS;					\
 		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
 			     post					\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : PVOP_VCALL_CLOBBERS			\
 			     : paravirt_type(op),			\
 			       paravirt_clobber(CLBR_ANY),		\
 			       ##__VA_ARGS__				\
-			     : "memory", "cc");				\
+			     : "memory", "cc" VEXTRA_CLOBBERS);		\
 	})
 
 #define PVOP_CALL0(rettype, op)						\
@@ -417,22 +506,27 @@ int paravirt_disable_iospace(void);
 	__PVOP_VCALL(op, "", "")
 
 #define PVOP_CALL1(rettype, op, arg1)					\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)))
 #define PVOP_VCALL1(op, arg1)						\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)))
 
 #define PVOP_CALL2(rettype, op, arg1, arg2)				\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)), 	\
+	"1" ((unsigned long)(arg2)))
+
 #define PVOP_VCALL2(op, arg1, arg2)					\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)), 		\
+	"1" ((unsigned long)(arg2)))
 
 #define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)),		\
-		    "1"((u32)(arg2)), "2"((u32)(arg3)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
 #define PVOP_VCALL3(op, arg1, arg2, arg3)				\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1"((u32)(arg2)),	\
-		     "2"((u32)(arg3)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
 
+/* This is the only difference in x86_64. We can make it much simpler */
+#ifdef CONFIG_X86_32
 #define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
 	__PVOP_CALL(rettype, op,					\
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
@@ -443,6 +537,16 @@ int paravirt_disable_iospace(void);
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
 		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
 		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+#else
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
+	"3"((unsigned long)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
+	"3"((unsigned long)(arg4)))
+#endif
 
 static inline int paravirt_enabled(void)
 {
@@ -540,6 +644,15 @@ static inline void write_cr4(unsigned long x)
 	PVOP_VCALL1(pv_cpu_ops.write_cr4, x);
 }
 
+static inline unsigned long read_cr8(void)
+{
+	return PVOP_CALL0(unsigned long, pv_irq_ops.read_cr8);
+}
+
+static inline void write_cr8(unsigned long x)
+{
+	PVOP_VCALL1(pv_irq_ops.write_cr8, x);
+}
 static inline void raw_safe_halt(void)
 {
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
@@ -561,6 +674,7 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
+
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
@@ -613,8 +727,6 @@ static inline unsigned long long paravirt_sched_clock(void)
 }
 #define calculate_cpu_khz() (pv_time_ops.get_cpu_khz())
 
-#define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
-
 static inline unsigned long long paravirt_read_pmc(int counter)
 {
 	return PVOP_CALL1(u64, pv_cpu_ops.read_pmc, counter);
@@ -626,15 +738,36 @@ static inline unsigned long long paravirt_read_pmc(int counter)
 	high = _l >> 32;			\
 } while(0)
 
+static inline unsigned long paravirt_readt_scp(int *aux)
+{
+	return PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
+}
+
+#define rdtscp(low, high, aux)				\
+do {							\
+	int __aux;					\
+	unsigned long __val = paravirt_rdtscp(&__aux);	\
+	(low) = (u32)__val;				\
+	(high) = (u32)(__val >> 32);			\
+	(aux) = __aux;					\
+} while (0)
+
+#define rdtscpll(val, aux)				\
+do {							\
+	unsigned long __aux; 				\
+	val = paravirt_rdtscp(&__aux);			\
+	(aux) = __aux;					\
+} while (0)
+
 static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);
 }
-static inline void load_gdt(const struct Xgt_desc_struct *dtr)
+static inline void load_gdt(const x86_descr_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.load_gdt, dtr);
 }
-static inline void load_idt(const struct Xgt_desc_struct *dtr)
+static inline void load_idt(const x86_descr_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.load_idt, dtr);
 }
@@ -642,11 +775,11 @@ static inline void set_ldt(const void *addr, unsigned entries)
 {
 	PVOP_VCALL2(pv_cpu_ops.set_ldt, addr, entries);
 }
-static inline void store_gdt(struct Xgt_desc_struct *dtr)
+static inline void store_gdt(x86_descr_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_gdt, dtr);
 }
-static inline void store_idt(struct Xgt_desc_struct *dtr)
+static inline void store_idt(x86_descr_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_idt, dtr);
 }
@@ -663,6 +796,8 @@ static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_ldt_entry, dt, entry, low, high);
 }
+
+#ifdef CONFIG_X86_32
 static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, low, high);
@@ -671,6 +806,19 @@ static inline void write_idt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_idt_entry, dt, entry, low, high);
 }
+#else
+static inline void write_gdt_entry(void *ptr, void *entry,
+				   unsigned type, unsigned size)
+{
+	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, ptr, entry, type, size);
+}
+
+static inline void write_idt_entry(void *adr, struct gate_struct *s)
+{
+	PVOP_VCALL2(pv_cpu_ops.write_idt_entry, adr, s);
+}
+#endif
+
 static inline void set_iopl_mask(unsigned mask)
 {
 	PVOP_VCALL1(pv_cpu_ops.set_iopl_mask, mask);
@@ -690,19 +838,19 @@ static inline void slow_down_io(void) {
 /*
  * Basic functions accessing APICs.
  */
-static inline void apic_write(unsigned long reg, unsigned long v)
+static inline void apic_write(unsigned long reg, u32 v)
 {
 	PVOP_VCALL2(pv_apic_ops.apic_write, reg, v);
 }
 
-static inline void apic_write_atomic(unsigned long reg, unsigned long v)
+static inline void apic_write_atomic(unsigned long reg, u32 v)
 {
 	PVOP_VCALL2(pv_apic_ops.apic_write_atomic, reg, v);
 }
 
-static inline unsigned long apic_read(unsigned long reg)
+static inline u32 apic_read(unsigned long reg)
 {
-	return PVOP_CALL1(unsigned long, pv_apic_ops.apic_read, reg);
+	return PVOP_CALL1(u32, pv_apic_ops.apic_read, reg);
 }
 
 static inline void setup_boot_clock(void)
@@ -762,10 +910,12 @@ static inline void __flush_tlb(void)
 {
 	PVOP_VCALL0(pv_mmu_ops.flush_tlb_user);
 }
+
 static inline void __flush_tlb_global(void)
 {
 	PVOP_VCALL0(pv_mmu_ops.flush_tlb_kernel);
 }
+
 static inline void __flush_tlb_single(unsigned long addr)
 {
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
@@ -908,7 +1058,103 @@ static inline void pmd_clear(pmd_t *pmdp)
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
 
-#else  /* !CONFIG_X86_PAE */
+#elif defined(CONFIG_X86_64)
+/* FIXME: There ought to be a way to do it that duplicate less code */
+static inline pte_t __pte(unsigned long long val)
+{
+	unsigned long long ret;
+	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pte, val);
+	return (pte_t) { ret };
+}
+
+static inline pmd_t __pmd(unsigned long long val)
+{
+	unsigned long long ret;
+	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pmd, val);
+	return (pmd_t) { ret };
+}
+
+static inline pud_t __pud(unsigned long long val)
+{
+	unsigned long long ret;
+	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pud, val);
+	return (pud_t) { ret };
+}
+
+static inline pgd_t __pgd(unsigned long long val)
+{
+	unsigned long long ret;
+	ret = PVOP_CALL1(unsigned long long, pv_mmu_ops.make_pgd, val);
+	return (pgd_t) { ret };
+}
+
+static inline unsigned long long pte_val(pte_t x)
+{
+	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pte_val, x.pte);
+}
+
+static inline unsigned long long pmd_val(pmd_t x)
+{
+	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pmd_val, x.pmd);
+}
+
+static inline unsigned long long pud_val(pud_t x)
+{
+	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pud_val, x.pud);
+}
+
+static inline unsigned long long pgd_val(pgd_t x)
+{
+	return PVOP_CALL1(unsigned long long, pv_mmu_ops.pgd_val, x.pgd);
+}
+
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, pteval.pte);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pteval.pte);
+}
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pmd);
+}
+
+static inline void set_pud(pud_t *pudp, pud_t pudval)
+{
+	PVOP_VCALL2(pv_mmu_ops.set_pud, pudp, pudval.pud);
+}
+
+static inline void set_pgd(pgd_t *pgdp, pgd_t pgdval)
+{
+	PVOP_VCALL2(pv_mmu_ops.set_pgd, pgdp, pgdval.pgd);
+}
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
+}
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
+}
+
+static inline void pud_clear(pud_t *pudp)
+{
+	PVOP_VCALL1(pv_mmu_ops.pud_clear, pudp);
+}
+
+static inline void pgd_clear(pgd_t *pgdp)
+{
+	PVOP_VCALL1(pv_mmu_ops.pgd_clear, pgdp);
+}
+
+#else  /* !CONFIG_X86_PAE && !CONFIG_X86_64*/
 
 static inline pte_t __pte(unsigned long val)
 {
@@ -1014,52 +1260,68 @@ struct paravirt_patch_site {
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
+#ifdef CONFIG_X86_32
+#define PV_SAVE_REGS "pushl %%ecx; pushl %%edx;"
+#define PV_RESTORE_REGS "popl %%edx; popl %%ecx"
+#define PV_FLAGS_ARG "0"
+#define PV_EXTRA_CLOBBERS
+#define PV_VEXTRA_CLOBBERS
+#else
+/* We save some registers, but all of them, that's too much. We clobber all
+ * caller saved registers but the argument parameter */
+#define PV_SAVE_REGS "pushq %%rdi;"
+#define PV_RESTORE_REGS "popq %%rdi;"
+#define PV_EXTRA_CLOBBERS EXTRA_CLOBBERS, "rcx" , "rdx"
+#define PV_VEXTRA_CLOBBERS EXTRA_CLOBBERS, "rdi", "rcx" , "rdx"
+#define PV_FLAGS_ARG "D"
+#endif
+
 static inline unsigned long __raw_local_save_flags(void)
 {
 	unsigned long f;
 
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     : "=a"(f)
 		     : paravirt_type(pv_irq_ops.save_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+		     : "memory", "cc" PV_VEXTRA_CLOBBERS);
 	return f;
 }
 
 static inline void raw_local_irq_restore(unsigned long f)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     : "=a"(f)
-		     : "0"(f),
+		     : PV_FLAGS_ARG (f),
 		       paravirt_type(pv_irq_ops.restore_fl),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "cc");
+		     : "memory", "cc" PV_EXTRA_CLOBBERS);
 }
 
 static inline void raw_local_irq_disable(void)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_disable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+		     : "memory", "eax", "cc" PV_VEXTRA_CLOBBERS);
 }
 
 static inline void raw_local_irq_enable(void)
 {
-	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
+	asm volatile(paravirt_alt(PV_SAVE_REGS
 				  PARAVIRT_CALL
-				  "popl %%edx; popl %%ecx")
+				  PV_RESTORE_REGS)
 		     :
 		     : paravirt_type(pv_irq_ops.irq_enable),
 		       paravirt_clobber(CLBR_EAX)
-		     : "memory", "eax", "cc");
+		     : "memory", "eax", "cc" PV_VEXTRA_CLOBBERS);
 }
 
 static inline unsigned long __raw_local_irq_save(void)
@@ -1071,27 +1333,41 @@ static inline unsigned long __raw_local_irq_save(void)
 	return f;
 }
 
+#ifdef CONFIG_X86_32
+#define SAVE_REGS "pushl %%ecx; pushl %%edx;"
+#define RESTORE_REGS "popl %%edx; popl %%ecx"
+#define CLI_STI_CLOBBERS , "%eax"
+#else /* !X86_32 */
+#define SAVE_REGS "pushq %%rcx; pushq %%rdx;"
+#define RESTORE_REGS "popq %%rdx; popq %%rcx"
+#define CLI_STI_CLOBBERS , "%rax", "%rdi", "%rsi", "%r8", "%r9", "%r10",\
+			"%r11", "%r12", "%r13", "%r14", "%r15"
+#endif /* X86_32 */
+
 #define CLI_STRING							\
-	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
+	_paravirt_alt(SAVE_REGS						\
 		      "call *%[paravirt_cli_opptr];"			\
-		      "popl %%edx; popl %%ecx",				\
+		      RESTORE_REGS,					\
 		      "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
 
+
 #define STI_STRING							\
-	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
+	_paravirt_alt(SAVE_REGS						\
 		      "call *%[paravirt_sti_opptr];"			\
-		      "popl %%edx; popl %%ecx",				\
+		      RESTORE_REGS,					\
 		      "%c[paravirt_sti_type]", "%c[paravirt_clobber]")
 
-#define CLI_STI_CLOBBERS , "%eax"
-#define CLI_STI_INPUT_ARGS						\
-	,								\
-	[paravirt_cli_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_disable)),		\
+
+#define CLI_STI_INPUT_ARGS						 \
+	,								 \
+	[paravirt_cli_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_disable)),\
 	[paravirt_cli_opptr] "m" (pv_irq_ops.irq_disable),		\
-	[paravirt_sti_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_enable)),		\
+	[paravirt_sti_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_enable)),\
 	[paravirt_sti_opptr] "m" (pv_irq_ops.irq_enable),		\
 	paravirt_clobber(CLBR_EAX)
 
+
+
 /* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
 #undef __PVOP_CALL
@@ -1106,48 +1382,80 @@ static inline unsigned long __raw_local_irq_save(void)
 #undef PVOP_CALL3
 #undef PVOP_VCALL4
 #undef PVOP_CALL4
+#undef PV_SAVE_REGS
+#undef PV_RESTORE_REGS
 
 #else  /* __ASSEMBLY__ */
 
-#define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 4)
-
-#define PARA_SITE(ptype, clobbers, ops)		\
+#define _PARA_SITE(ptype, clobbers, ops, word)	\
 771:;						\
 	ops;					\
 772:;						\
 	.pushsection .parainstructions,"a";	\
-	 .long 771b;				\
+	 .align 8;				\
+	 word 771b;				\
 	 .byte ptype;				\
 	 .byte 772b-771b;			\
 	 .short clobbers;			\
 	.popsection
 
+#ifdef CONFIG_X86_64
+#define PV_SAVE_REGS	pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx
+#define PV_RESTORE_REGS popq %rdx; popq %rcx; popq %rdi; popq %rax
+#define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 8)
+#define PARA_SITE(ptype, clobbers, ops) _PARA_SITE(ptype, clobbers, ops, .quad)
+#else
+#define PV_SAVE_REGS	pushl %eax; pushl %edi; pushl %ecx; pushl %edx
+#define PV_RESTORE_REGS popl %edx; popl %ecx; popl %edi; popl %eax
+#define PARA_PATCH(struct, off)	((PARAVIRT_PATCH_##struct + (off)) / 4)
+#define PARA_SITE(ptype, clobbers, ops) _PARA_SITE(ptype, clobbers, ops, .long)
+#endif
+
 #define INTERRUPT_RETURN						\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_iret), CLBR_NONE,	\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_iret)
 
 #define DISABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_disable), clobbers, \
-		  pushl %eax; pushl %ecx; pushl %edx;			\
+		  PV_SAVE_REGS;						\
 		  call *%cs:pv_irq_ops+PV_IRQ_irq_disable;		\
-		  popl %edx; popl %ecx; popl %eax)			\
+		  PV_RESTORE_REGS;)
 
 #define ENABLE_INTERRUPTS(clobbers)					\
 	PARA_SITE(PARA_PATCH(pv_irq_ops, PV_IRQ_irq_enable), clobbers,	\
-		  pushl %eax; pushl %ecx; pushl %edx;			\
+		  PV_SAVE_REGS;						\
 		  call *%cs:pv_irq_ops+PV_IRQ_irq_enable;		\
-		  popl %edx; popl %ecx; popl %eax)
+		  PV_RESTORE_REGS;)
 
 #define ENABLE_INTERRUPTS_SYSCALL_RET					\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_irq_enable_syscall_ret),\
 		  CLBR_NONE,						\
 		  jmp *%cs:pv_cpu_ops+PV_CPU_irq_enable_syscall_ret)
 
+#ifdef CONFIG_X86_32
 #define GET_CR0_INTO_EAX			\
 	push %ecx; push %edx;			\
 	call *pv_cpu_ops+PV_CPU_read_cr0;	\
 	pop %edx; pop %ecx
 
+#else
+/* Those are x86_64 specific */
+#define SWAPGS								\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
+		  pushq %rax; pushq %rdi; pushq %rcx; pushq %rdx;	\
+		  call *pv_cpu_ops+PV_CPU_swapgs;			\
+		  popq %rdx; popq %rcx; popq %rdi; popq %rax;		\
+		 )
+
+#define GET_CR2_INTO_RCX					\
+	call *pv_mmu_ops+PV_MMU_read_cr2;			\
+	movq %rax, %rcx;					\
+	xorq %rax, %rax;
+
+#endif
+
+#undef WSIZE
+
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_PARAVIRT */
 #endif	/* __ASM_PARAVIRT_H */
-- 
1.4.4.2

