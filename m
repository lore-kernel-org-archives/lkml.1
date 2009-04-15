Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZDOOl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZDOOl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZDOOlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:41:18 -0400
Received: from ozlabs.org ([203.10.76.45]:42593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbZDOOlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:41:17 -0400
Cc: lguest@ozlabs.org, Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 16 Apr 2009 00:11:14 +0930
Subject: [PATCH 3/3] lguest: don't expect linear addresses in gdt pvops
Cc: lguest@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904160011.14645.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix guest crash 'lguest: bad read address 0x4800000 len 256'

The new per-cpu allocator ends up handing a non-linear address to
write_gdt_entry.  We do __pa() on it, and hand it to the host, which
kills us.

I've long wanted to make the hypercall "LOAD_GDT_ENTRY" to match the IDT
code, but had no pressing reason until now.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org
---
 arch/x86/include/asm/lguest_hcall.h |    2 +-
 arch/x86/lguest/boot.c              |   16 +++++++++-------
 drivers/lguest/lg.h                 |    3 ++-
 drivers/lguest/segments.c           |   13 +++++++------
 drivers/lguest/x86/core.c           |    4 ++--
 5 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/lguest_hcall.h b/arch/x86/include/asm/lguest_hcall.h
--- a/arch/x86/include/asm/lguest_hcall.h
+++ b/arch/x86/include/asm/lguest_hcall.h
@@ -5,7 +5,6 @@
 #define LHCALL_FLUSH_ASYNC	0
 #define LHCALL_LGUEST_INIT	1
 #define LHCALL_SHUTDOWN		2
-#define LHCALL_LOAD_GDT		3
 #define LHCALL_NEW_PGTABLE	4
 #define LHCALL_FLUSH_TLB	5
 #define LHCALL_LOAD_IDT_ENTRY	6
@@ -17,6 +16,7 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 #define LHCALL_NOTIFY		17
+#define LHCALL_LOAD_GDT_ENTRY	18
 
 #define LGUEST_TRAP_ENTRY 0x1F
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -273,15 +273,15 @@ static void lguest_load_idt(const struct
  * controls the entire thing and the Guest asks it to make changes using the
  * LOAD_GDT hypercall.
  *
- * This is the opposite of the IDT code where we have a LOAD_IDT_ENTRY
- * hypercall and use that repeatedly to load a new IDT.  I don't think it
- * really matters, but wouldn't it be nice if they were the same?  Wouldn't
- * it be even better if you were the one to send the patch to fix it?
+ * This is the exactly like the IDT code.
  */
 static void lguest_load_gdt(const struct desc_ptr *desc)
 {
-	BUG_ON((desc->size + 1) / 8 != GDT_ENTRIES);
-	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES);
+	unsigned int i;
+	struct desc_struct *gdt = (void *)desc->address;
+
+	for (i = 0; i < (desc->size+1)/8; i++)
+		kvm_hypercall3(LHCALL_LOAD_GDT_ENTRY, i, gdt[i].a, gdt[i].b);
 }
 
 /* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
@@ -291,7 +291,9 @@ static void lguest_write_gdt_entry(struc
 				   const void *desc, int type)
 {
 	native_write_gdt_entry(dt, entrynum, desc, type);
-	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES);
+	/* Tell Host about this new entry. */
+	kvm_hypercall3(LHCALL_LOAD_GDT_ENTRY, entrynum,
+		       dt[entrynum].a, dt[entrynum].b);
 }
 
 /* OK, I lied.  There are three "thread local storage" GDT entries which change
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -158,7 +158,8 @@ void free_interrupts(void);
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
 void setup_guest_gdt(struct lg_cpu *cpu);
-void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num);
+void load_guest_gdt_entry(struct lg_cpu *cpu, unsigned int i,
+			  u32 low, u32 hi);
 void guest_load_tls(struct lg_cpu *cpu, unsigned long tls_array);
 void copy_gdt(const struct lg_cpu *cpu, struct desc_struct *gdt);
 void copy_gdt_tls(const struct lg_cpu *cpu, struct desc_struct *gdt);
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -144,18 +144,19 @@ void copy_gdt(const struct lg_cpu *cpu, 
 			gdt[i] = cpu->arch.gdt[i];
 }
 
-/*H:620 This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT).
- * We copy it from the Guest and tweak the entries. */
-void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num)
+/*H:620 This is where the Guest asks us to load a new GDT entry
+ * (LHCALL_LOAD_GDT_ENTRY).  We tweak the entry and copy it in. */
+void load_guest_gdt_entry(struct lg_cpu *cpu, u32 num, u32 lo, u32 hi)
 {
 	/* We assume the Guest has the same number of GDT entries as the
 	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
 	if (num > ARRAY_SIZE(cpu->arch.gdt))
 		kill_guest(cpu, "too many gdt entries %i", num);
 
-	/* We read the whole thing in, then fix it up. */
-	__lgread(cpu, cpu->arch.gdt, table, num * sizeof(cpu->arch.gdt[0]));
-	fixup_gdt_table(cpu, 0, ARRAY_SIZE(cpu->arch.gdt));
+	/* Set it up, then fix it. */
+	cpu->arch.gdt[num].a = lo;
+	cpu->arch.gdt[num].b = hi;
+	fixup_gdt_table(cpu, num, num+1);
 	/* Mark that the GDT changed so the core knows it has to copy it again,
 	 * even if the Guest is run on the same CPU. */
 	cpu->changed |= CHANGED_GDT;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -564,8 +564,8 @@ void __exit lguest_arch_host_fini(void)
 int lguest_arch_do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
 {
 	switch (args->arg0) {
-	case LHCALL_LOAD_GDT:
-		load_guest_gdt(cpu, args->arg1, args->arg2);
+	case LHCALL_LOAD_GDT_ENTRY:
+		load_guest_gdt_entry(cpu, args->arg1, args->arg2, args->arg3);
 		break;
 	case LHCALL_LOAD_IDT_ENTRY:
 		load_guest_idt_entry(cpu, args->arg1, args->arg2, args->arg3);

