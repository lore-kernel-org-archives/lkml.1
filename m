Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYGWVVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYGWVVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYGWVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:21:23 -0400
Received: from gw.goop.org ([64.81.55.164]:39356 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYGWVVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:21:22 -0400
Message-ID: <4887A0CE.1090200@goop.org>
Date: Wed, 23 Jul 2008 14:21:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/paravirt/xen: properly fill out the ldt ops
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTP testing showed that Xen does not properly implement
sys_modify_ldt().  This patch does the final little bits needed to
make the ldt work properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/ldt.c      |    9 ++++++++-
 arch/x86/kernel/paravirt.c |    4 ++++
 arch/x86/xen/enlighten.c   |   23 +++++++++++++++++++++++
 include/asm-x86/desc.h     |   10 +++++++++-
 include/asm-x86/paravirt.h |   13 +++++++++++++
 5 files changed, 57 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -52,6 +52,8 @@
 	memset(newldt + oldsize * LDT_ENTRY_SIZE, 0,
 	       (mincount - oldsize) * LDT_ENTRY_SIZE);
 
+	paravirt_alloc_ldt(newldt, mincount);
+
 #ifdef CONFIG_X86_64
 	/* CHECKME: Do we really need this ? */
 	wmb();
@@ -76,6 +78,7 @@
 #endif
 	}
 	if (oldsize) {
+		paravirt_free_ldt(oldldt, oldsize);
 		if (oldsize * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(oldldt);
 		else
@@ -87,10 +90,13 @@
 static inline int copy_ldt(mm_context_t *new, mm_context_t *old)
 {
 	int err = alloc_ldt(new, old->size, 0);
+	int i;
 
 	if (err < 0)
 		return err;
-	memcpy(new->ldt, old->ldt, old->size * LDT_ENTRY_SIZE);
+
+	for(i = 0; i < old->size; i++)
+		write_ldt_entry(new->ldt, i, old->ldt + i * LDT_ENTRY_SIZE);
 	return 0;
 }
 
@@ -127,6 +133,7 @@
 		if (mm == current->active_mm)
 			clear_LDT();
 #endif
+		paravirt_free_ldt(mm->context.ldt, mm->context.size);
 		if (mm->context.size * LDT_ENTRY_SIZE > PAGE_SIZE)
 			vfree(mm->context.ldt);
 		else
===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -350,6 +350,10 @@
 	.write_ldt_entry = native_write_ldt_entry,
 	.write_gdt_entry = native_write_gdt_entry,
 	.write_idt_entry = native_write_idt_entry,
+
+	.alloc_ldt = paravirt_nop,
+	.free_ldt = paravirt_nop,
+
 	.load_sp0 = native_load_sp0,
 
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -327,6 +327,26 @@
 static unsigned long xen_store_tr(void)
 {
 	return 0;
+}
+
+static void xen_alloc_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	unsigned pages = roundup(entries * LDT_ENTRY_SIZE, PAGE_SIZE);
+	void *v = ldt;
+	int i;
+
+	for(i = 0; i < pages; i += PAGE_SIZE)
+		make_lowmem_page_readonly(v + i);
+}
+
+static void xen_free_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	unsigned pages = roundup(entries * LDT_ENTRY_SIZE, PAGE_SIZE);
+	void *v = ldt;
+	int i;
+
+	for(i = 0; i < pages; i += PAGE_SIZE)
+		make_lowmem_page_readwrite(v + i);
 }
 
 static void xen_set_ldt(const void *addr, unsigned entries)
@@ -1269,6 +1289,9 @@
 	.load_gs_index = xen_load_gs_index,
 #endif
 
+	.alloc_ldt = xen_alloc_ldt,
+	.free_ldt = xen_free_ldt,
+
 	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = xen_store_tr,
===================================================================
--- a/include/asm-x86/desc.h
+++ b/include/asm-x86/desc.h
@@ -97,7 +97,15 @@
 	native_write_gdt_entry(dt, entry, desc, type)
 #define write_idt_entry(dt, entry, g)		\
 	native_write_idt_entry(dt, entry, g)
-#endif
+
+static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
+{
+}
+
+static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
+{
+}
+#endif	/* CONFIG_PARAVIRT */
 
 static inline void native_write_idt_entry(gate_desc *idt, int entry,
 					  const gate_desc *gate)
===================================================================
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -124,6 +124,9 @@
 				int entrynum, const void *desc, int size);
 	void (*write_idt_entry)(gate_desc *,
 				int entrynum, const gate_desc *gate);
+	void (*alloc_ldt)(struct desc_struct *ldt, unsigned entries);
+	void (*free_ldt)(struct desc_struct *ldt, unsigned entries);
+
 	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
 
 	void (*set_iopl_mask)(unsigned mask);
@@ -819,6 +822,16 @@
 	(aux) = __aux;					\
 } while (0)
 
+static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	PVOP_VCALL2(pv_cpu_ops.alloc_ldt, ldt, entries);
+}
+
+static inline void paravirt_free_ldt(struct desc_struct *ldt, unsigned entries)
+{
+	PVOP_VCALL2(pv_cpu_ops.free_ldt, ldt, entries);
+}
+
 static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);


