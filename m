Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbXLLPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbXLLPlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXLLPjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:39:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640AbXLLPjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:39:21 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 06/19] change write_idt_entry signature
Date: Wed, 12 Dec 2007 10:53:51 -0200
Message-Id: <11974640813511-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11974640752137-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <11974640522688-git-send-email-gcosta@redhat.com> <1197464057242-git-send-email-gcosta@redhat.com> <11974640653022-git-send-email-gcosta@redhat.com> <1197464070228-git-send-email-gcosta@redhat.com> <11974640752137-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch changes write_idt_entry signature. It now takes a gate_desc
instead of the a and b parameters. It will allow it to be later unified
between i386 and x86_64.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge.citrix.com>
---
 arch/x86/kernel/paravirt_32.c |    2 +-
 arch/x86/kernel/vmi_32.c      |   10 +++++++++-
 arch/x86/lguest/boot.c        |    9 +++++----
 arch/x86/xen/enlighten.c      |    8 ++++----
 include/asm-x86/desc_32.h     |   10 ++++++++--
 include/asm-x86/paravirt.h    |    9 +++++----
 6 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/paravirt_32.c b/arch/x86/kernel/paravirt_32.c
index f4e3a8e..13bbc99 100644
--- a/arch/x86/kernel/paravirt_32.c
+++ b/arch/x86/kernel/paravirt_32.c
@@ -381,7 +381,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.load_tls = native_load_tls,
 	.write_ldt_entry = write_dt_entry,
 	.write_gdt_entry = write_dt_entry,
-	.write_idt_entry = write_dt_entry,
+	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
 	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 4cfda7d..a635b22 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -62,6 +62,7 @@ static struct {
 	void (*cpuid)(void /* non-c */);
 	void (*_set_ldt)(u32 selector);
 	void (*set_tr)(u32 selector);
+	void (*write_idt_entry)(struct desc_struct *, int, u32, u32);
 	void (*set_kernel_stack)(u32 selector, u32 sp0);
 	void (*allocate_page)(u32, u32, u32, u32, u32);
 	void (*release_page)(u32, u32);
@@ -214,6 +215,12 @@ static void vmi_set_tr(void)
 	vmi_ops.set_tr(GDT_ENTRY_TSS*sizeof(struct desc_struct));
 }
 
+static void vmi_write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
+{
+	u32 *idt_entry = (u32 *)g;
+	vmi_ops.write_idt_entry(dt, entry, idt_entry[0], idt_entry[2]);
+}
+
 static void vmi_load_sp0(struct tss_struct *tss,
 				   struct thread_struct *thread)
 {
@@ -792,7 +799,8 @@ static inline int __init activate_vmi(void)
 	pv_cpu_ops.load_tls = vmi_load_tls;
 	para_fill(pv_cpu_ops.write_ldt_entry, WriteLDTEntry);
 	para_fill(pv_cpu_ops.write_gdt_entry, WriteGDTEntry);
-	para_fill(pv_cpu_ops.write_idt_entry, WriteIDTEntry);
+	para_wrap(pv_cpu_ops.write_idt_entry, vmi_write_idt_entry,
+		  write_idt_entry, WriteIDTEntry);
 	para_wrap(pv_cpu_ops.load_sp0, vmi_load_sp0, set_kernel_stack, UpdateKernelStack);
 	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
 	para_fill(pv_cpu_ops.io_delay, IODelay);
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index aa0bdd5..b50c8ad 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -217,13 +217,14 @@ static void irq_enable(void)
  * address of the handler, and... well, who cares?  The Guest just asks the
  * Host to make the change anyway, because the Host controls the real IDT.
  */
-static void lguest_write_idt_entry(struct desc_struct *dt,
-				   int entrynum, u32 low, u32 high)
+static void lguest_write_idt_entry(gate_desc *dt,
+				   int entrynum, const gate_desc *g)
 {
+	u32 *desc = (u32 *)g;
 	/* Keep the local copy up to date. */
-	write_dt_entry(dt, entrynum, low, high);
+	native_write_idt_entry(dt, entrynum, g);
 	/* Tell Host about this new entry. */
-	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
+	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, desc[0], desc[1]);
 }
 
 /* Changing to a different IDT is very rare: we keep the IDT up-to-date every
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 8215ea6..6dd349e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -399,8 +399,7 @@ static DEFINE_PER_CPU(struct desc_ptr, idt_desc);
 
 /* Set an IDT entry.  If the entry is part of the current IDT, then
    also update Xen. */
-static void xen_write_idt_entry(struct desc_struct *dt, int entrynum,
-				u32 low, u32 high)
+static void xen_write_idt_entry(gate_desc *dt, int entrynum, const gate_desc *g)
 {
 	unsigned long p = (unsigned long)&dt[entrynum];
 	unsigned long start, end;
@@ -412,14 +411,15 @@ static void xen_write_idt_entry(struct desc_struct *dt, int entrynum,
 
 	xen_mc_flush();
 
-	write_dt_entry(dt, entrynum, low, high);
+	native_write_idt_entry(dt, entrynum, g);
 
 	if (p >= start && (p + 8) <= end) {
 		struct trap_info info[2];
+		u32 *desc = (u32 *)g;
 
 		info[1].address = 0;
 
-		if (cvt_gate_to_trap(entrynum, low, high, &info[0]))
+		if (cvt_gate_to_trap(entrynum, desc[0], desc[1], &info[0]))
 			if (HYPERVISOR_set_trap_table(info))
 				BUG();
 	}
diff --git a/include/asm-x86/desc_32.h b/include/asm-x86/desc_32.h
index 77f1e5a..54b2314 100644
--- a/include/asm-x86/desc_32.h
+++ b/include/asm-x86/desc_32.h
@@ -70,9 +70,15 @@ static inline void pack_gate(gate_desc *gate,
 
 #define write_ldt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
 #define write_gdt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
-#define write_idt_entry(dt, entry, a, b) write_dt_entry(dt, entry, a, b)
+#define write_idt_entry(dt, entry, g) native_write_idt_entry(dt, entry, g)
 #endif
 
+static inline void native_write_idt_entry(gate_desc *idt, int entry,
+					  const gate_desc *gate)
+{
+	memcpy(&idt[entry], gate, sizeof(*gate));
+}
+
 static inline void write_dt_entry(struct desc_struct *dt,
 				  int entry, u32 entry_low, u32 entry_high)
 {
@@ -142,7 +148,7 @@ static inline void _set_gate(int gate, unsigned int type, void *addr, unsigned s
 {
 	gate_desc g;
 	pack_gate(&g, (unsigned long)addr, seg, type, 0);
-	write_idt_entry(idt_table, gate, g.a, g.b);
+	write_idt_entry(idt_table, gate, &g);
 }
 
 static inline void __set_tss_desc(unsigned int cpu, unsigned int entry, const void *addr)
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 0333fb6..86a9d7b 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/cpumask.h>
 #include <asm/kmap_types.h>
+#include <asm/desc_defs.h>
 
 struct page;
 struct thread_struct;
@@ -99,8 +100,8 @@ struct pv_cpu_ops {
 				int entrynum, u32 low, u32 high);
 	void (*write_gdt_entry)(struct desc_struct *,
 				int entrynum, u32 low, u32 high);
-	void (*write_idt_entry)(struct desc_struct *,
-				int entrynum, u32 low, u32 high);
+	void (*write_idt_entry)(gate_desc *,
+				int entrynum, const gate_desc *gate);
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
@@ -667,9 +668,9 @@ static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
 {
 	PVOP_VCALL4(pv_cpu_ops.write_gdt_entry, dt, entry, low, high);
 }
-static inline void write_idt_entry(void *dt, int entry, u32 low, u32 high)
+static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 {
-	PVOP_VCALL4(pv_cpu_ops.write_idt_entry, dt, entry, low, high);
+	PVOP_VCALL3(pv_cpu_ops.write_idt_entry, dt, entry, g);
 }
 static inline void set_iopl_mask(unsigned mask)
 {
-- 
1.5.0.6

