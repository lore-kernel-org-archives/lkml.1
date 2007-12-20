Return-Path: <linux-kernel-owner+w=401wt.eu-S1763212AbXLTNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763212AbXLTNid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbXLTNfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762514AbXLTNfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:02 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 12/16] replace lguest_arch with lguest_vcpu_arch.
Date: Thu, 20 Dec 2007 11:33:52 -0200
Message-Id: <11981576972655-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198157692575-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com> <1198157692575-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fields found in lguest_arch are not really per-guest,
but per-cpu (gdt, idt, etc). So this patch turns lguest_arch
into lguest_vcpu_arch.

It makes sense to have a per-guest per-arch struct, but this
can be addressed later, when the need arrives.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/interrupts_and_traps.c |   29 +++++++++++----------
 drivers/lguest/lg.h                   |   19 +++++++-------
 drivers/lguest/segments.c             |   43 +++++++++++++++++---------------
 drivers/lguest/x86/core.c             |   24 ++++++++----------
 include/asm-x86/lguest.h              |    2 +-
 5 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 1ceff5f..b3d444a 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -180,7 +180,7 @@ void maybe_do_interrupt(struct lguest_vcpu *vcpu)
 	/* Look at the IDT entry the Guest gave us for this interrupt.  The
 	 * first 32 (FIRST_EXTERNAL_VECTOR) entries are for traps, so we skip
 	 * over them. */
-	idt = &lg->arch.idt[FIRST_EXTERNAL_VECTOR+irq];
+	idt = &vcpu->arch.idt[FIRST_EXTERNAL_VECTOR+irq];
 	/* If they don't have a handler (yet?), we just ignore it */
 	if (idt_present(idt->a, idt->b)) {
 		/* OK, mark it no longer pending and deliver it. */
@@ -253,15 +253,15 @@ int deliver_trap(struct lguest_vcpu *vcpu, unsigned int num)
 {
 	/* Trap numbers are always 8 bit, but we set an impossible trap number
 	 * for traps inside the Switcher, so check that here. */
-	if (num >= ARRAY_SIZE(vcpu->lg->arch.idt))
+	if (num >= ARRAY_SIZE(vcpu->arch.idt))
 		return 0;
 
 	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
 	 * bogus one in): if we fail here, the Guest will be killed. */
-	if (!idt_present(vcpu->lg->arch.idt[num].a, vcpu->lg->arch.idt[num].b))
+	if (!idt_present(vcpu->arch.idt[num].a, vcpu->arch.idt[num].b))
 		return 0;
-	set_guest_interrupt(vcpu, vcpu->lg->arch.idt[num].a,
-			    vcpu->lg->arch.idt[num].b, has_err(num));
+	set_guest_interrupt(vcpu, vcpu->arch.idt[num].a,
+			    vcpu->arch.idt[num].b, has_err(num));
 	return 1;
 }
 
@@ -387,7 +387,8 @@ static void set_trap(struct lguest *lg, struct desc_struct *trap,
  *
  * We saw the Guest setting Interrupt Descriptor Table (IDT) entries with the
  * LHCALL_LOAD_IDT_ENTRY hypercall before: that comes here. */
-void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
+void load_guest_idt_entry(struct lguest_vcpu *vcpu,
+			  unsigned int num, u32 lo, u32 hi)
 {
 	/* Guest never handles: NMI, doublefault, spurious interrupt or
 	 * hypercall.  We ignore when it tries to set them. */
@@ -396,13 +397,13 @@ void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
 
 	/* Mark the IDT as changed: next time the Guest runs we'll know we have
 	 * to copy this again. */
-	lg->changed |= CHANGED_IDT;
+	vcpu->lg->changed |= CHANGED_IDT;
 
 	/* Check that the Guest doesn't try to step outside the bounds. */
-	if (num >= ARRAY_SIZE(lg->arch.idt))
-		kill_guest(lg, "Setting idt entry %u", num);
+	if (num >= ARRAY_SIZE(vcpu->arch.idt))
+		kill_guest(vcpu->lg, "Setting idt entry %u", num);
 	else
-		set_trap(lg, &lg->arch.idt[num], num, lo, hi);
+		set_trap(vcpu->lg, &vcpu->arch.idt[num], num, lo, hi);
 }
 
 /* The default entry for each interrupt points into the Switcher routines which
@@ -438,14 +439,14 @@ void setup_default_idt_entries(struct lguest_ro_state *state,
 /*H:240 We don't use the IDT entries in the "struct lguest" directly, instead
  * we copy them into the IDT which we've set up for Guests on this CPU, just
  * before we run the Guest.  This routine does that copy. */
-void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+void copy_traps(const struct lguest_vcpu *vcpu, struct desc_struct *idt,
 		const unsigned long *def)
 {
 	unsigned int i;
 
 	/* We can simply copy the direct traps, otherwise we use the default
 	 * ones in the Switcher: they will return to the Host. */
-	for (i = 0; i < ARRAY_SIZE(lg->arch.idt); i++) {
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.idt); i++) {
 		/* If no Guest can ever override this trap, leave it alone. */
 		if (!direct_trap(i))
 			continue;
@@ -454,8 +455,8 @@ void copy_traps(const struct lguest *lg, struct desc_struct *idt,
 		 * Interrupt gates (type 14) disable interrupts as they are
 		 * entered, which we never let the Guest do.  Not present
 		 * entries (type 0x0) also can't go direct, of course. */
-		if (idt_type(lg->arch.idt[i].a, lg->arch.idt[i].b) == 0xF)
-			idt[i] = lg->arch.idt[i];
+		if (idt_type(vcpu->arch.idt[i].a, vcpu->arch.idt[i].b) == 0xF)
+			idt[i] = vcpu->arch.idt[i];
 		else
 			/* Reset it to the default. */
 			default_idt_entry(&idt[i], i, def[i]);
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index d05fe38..f9429ff 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -57,6 +57,8 @@ struct lguest_vcpu {
 
 	/* Pending virtual interrupts */
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
+
+	struct lguest_vcpu_arch arch;
 };
 
 /* The private info the thread maintains about the guest. */
@@ -99,8 +101,6 @@ struct lguest
 
 	/* Dead? */
 	const char *dead;
-
-	struct lguest_arch arch;
 };
 
 static inline struct lguest *lg_of_vcpu(struct lguest_vcpu *vcpu)
@@ -144,12 +144,13 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user);
 /* interrupts_and_traps.c: */
 void maybe_do_interrupt(struct lguest_vcpu *vcpu);
 int deliver_trap(struct lguest_vcpu *vcpu, unsigned int num);
-void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
+void load_guest_idt_entry(struct lguest_vcpu *vcpu, unsigned int i,
+			  u32 low, u32 hi);
 void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
 void pin_stack_pages(struct lguest *lg);
 void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def);
-void copy_traps(const struct lguest *lg, struct desc_struct *idt,
+void copy_traps(const struct lguest_vcpu *vcpu, struct desc_struct *idt,
 		const unsigned long *def);
 void guest_set_clockevent(struct lguest_vcpu *vcpu, unsigned long delta);
 void init_clockdev(struct lguest_vcpu *vcpu);
@@ -159,11 +160,11 @@ void free_interrupts(void);
 
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
-void setup_guest_gdt(struct lguest *lg);
-void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num);
-void guest_load_tls(struct lguest *lg, unsigned long tls_array);
-void copy_gdt(const struct lguest *lg, struct desc_struct *gdt);
-void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt);
+void setup_guest_gdt(struct lguest_vcpu *vcpu);
+void load_guest_gdt(struct lguest_vcpu *vcpu, unsigned long table, u32 num);
+void guest_load_tls(struct lguest_vcpu *vcpu, unsigned long tls_array);
+void copy_gdt(const struct lguest_vcpu *vcpu, struct desc_struct *gdt);
+void copy_gdt_tls(const struct lguest_vcpu *vcpu, struct desc_struct *gdt);
 
 /* page_tables.c: */
 int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index 9e189cb..c9608bd 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -58,7 +58,8 @@ static int ignored_gdt(unsigned int num)
  * Protection Fault in the Switcher when it restores a Guest segment register
  * which tries to use that entry.  Then we kill the Guest for causing such a
  * mess: the message will be "unhandled trap 256". */
-static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
+static void fixup_gdt_table(struct lguest_vcpu *vcpu, unsigned start,
+			    unsigned end)
 {
 	unsigned int i;
 
@@ -71,14 +72,14 @@ static void fixup_gdt_table(struct lguest *lg, unsigned start, unsigned end)
 		/* Segment descriptors contain a privilege level: the Guest is
 		 * sometimes careless and leaves this as 0, even though it's
 		 * running at privilege level 1.  If so, we fix it here. */
-		if ((lg->arch.gdt[i].b & 0x00006000) == 0)
-			lg->arch.gdt[i].b |= (GUEST_PL << 13);
+		if ((vcpu->arch.gdt[i].b & 0x00006000) == 0)
+			vcpu->arch.gdt[i].b |= (GUEST_PL << 13);
 
 		/* Each descriptor has an "accessed" bit.  If we don't set it
 		 * now, the CPU will try to set it when the Guest first loads
 		 * that entry into a segment register.  But the GDT isn't
 		 * writable by the Guest, so bad things can happen. */
-		lg->arch.gdt[i].b |= 0x00000100;
+		vcpu->arch.gdt[i].b |= 0x00000100;
 	}
 }
 
@@ -109,31 +110,31 @@ void setup_default_gdt_entries(struct lguest_ro_state *state)
 
 /* This routine sets up the initial Guest GDT for booting.  All entries start
  * as 0 (unusable). */
-void setup_guest_gdt(struct lguest *lg)
+void setup_guest_gdt(struct lguest_vcpu *vcpu)
 {
 	/* Start with full 0-4G segments... */
-	lg->arch.gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
-	lg->arch.gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
+	vcpu->arch.gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
+	vcpu->arch.gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
 	/* ...except the Guest is allowed to use them, so set the privilege
 	 * level appropriately in the flags. */
-	lg->arch.gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
-	lg->arch.gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+	vcpu->arch.gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
+	vcpu->arch.gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
 }
 
 /*H:650 An optimization of copy_gdt(), for just the three "thead-local storage"
  * entries. */
-void copy_gdt_tls(const struct lguest *lg, struct desc_struct *gdt)
+void copy_gdt_tls(const struct lguest_vcpu *vcpu, struct desc_struct *gdt)
 {
 	unsigned int i;
 
 	for (i = GDT_ENTRY_TLS_MIN; i <= GDT_ENTRY_TLS_MAX; i++)
-		gdt[i] = lg->arch.gdt[i];
+		gdt[i] = vcpu->arch.gdt[i];
 }
 
 /*H:640 When the Guest is run on a different CPU, or the GDT entries have
  * changed, copy_gdt() is called to copy the Guest's GDT entries across to this
  * CPU's GDT. */
-void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
+void copy_gdt(const struct lguest_vcpu *vcpu, struct desc_struct *gdt)
 {
 	unsigned int i;
 
@@ -141,21 +142,22 @@ void copy_gdt(const struct lguest *lg, struct desc_struct *gdt)
 	 * replaced.  See ignored_gdt() above. */
 	for (i = 0; i < GDT_ENTRIES; i++)
 		if (!ignored_gdt(i))
-			gdt[i] = lg->arch.gdt[i];
+			gdt[i] = vcpu->arch.gdt[i];
 }
 
 /*H:620 This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT).
  * We copy it from the Guest and tweak the entries. */
-void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
+void load_guest_gdt(struct lguest_vcpu *vcpu, unsigned long table, u32 num)
 {
+	struct lguest *lg = vcpu->lg;
 	/* We assume the Guest has the same number of GDT entries as the
 	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
-	if (num > ARRAY_SIZE(lg->arch.gdt))
+	if (num > ARRAY_SIZE(vcpu->arch.gdt))
 		kill_guest(lg, "too many gdt entries %i", num);
 
 	/* We read the whole thing in, then fix it up. */
-	__lgread(lg, lg->arch.gdt, table, num * sizeof(lg->arch.gdt[0]));
-	fixup_gdt_table(lg, 0, ARRAY_SIZE(lg->arch.gdt));
+	__lgread(lg, vcpu->arch.gdt, table, num * sizeof(vcpu->arch.gdt[0]));
+	fixup_gdt_table(vcpu, 0, ARRAY_SIZE(vcpu->arch.gdt));
 	/* Mark that the GDT changed so the core knows it has to copy it again,
 	 * even if the Guest is run on the same CPU. */
 	lg->changed |= CHANGED_GDT;
@@ -165,12 +167,13 @@ void load_guest_gdt(struct lguest *lg, unsigned long table, u32 num)
  * Remember that this happens on every context switch, so it's worth
  * optimizing.  But wouldn't it be neater to have a single hypercall to cover
  * both cases? */
-void guest_load_tls(struct lguest *lg, unsigned long gtls)
+void guest_load_tls(struct lguest_vcpu *vcpu, unsigned long gtls)
 {
-	struct desc_struct *tls = &lg->arch.gdt[GDT_ENTRY_TLS_MIN];
+	struct desc_struct *tls = &vcpu->arch.gdt[GDT_ENTRY_TLS_MIN];
+	struct lguest *lg = vcpu->lg;
 
 	__lgread(lg, tls, gtls, sizeof(*tls)*GDT_ENTRY_TLS_ENTRIES);
-	fixup_gdt_table(lg, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
+	fixup_gdt_table(vcpu, GDT_ENTRY_TLS_MIN, GDT_ENTRY_TLS_MAX+1);
 	/* Note that just the TLS entries have changed. */
 	lg->changed |= CHANGED_GDT_TLS;
 }
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index a0d710e..177b9e5 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -101,14 +101,14 @@ static void copy_in_guest_info(struct lguest_vcpu *vcpu,
 
 	/* Copy direct-to-Guest trap entries. */
 	if (lg->changed & CHANGED_IDT)
-		copy_traps(lg, pages->state.guest_idt, default_idt_entries);
+		copy_traps(vcpu, pages->state.guest_idt, default_idt_entries);
 
 	/* Copy all GDT entries which the Guest can change. */
 	if (lg->changed & CHANGED_GDT)
-		copy_gdt(lg, pages->state.guest_gdt);
+		copy_gdt(vcpu, pages->state.guest_gdt);
 	/* If only the TLS entries have changed, copy them. */
 	else if (lg->changed & CHANGED_GDT_TLS)
-		copy_gdt_tls(lg, pages->state.guest_gdt);
+		copy_gdt_tls(vcpu, pages->state.guest_gdt);
 
 	/* Mark the Guest as unchanged for next time. */
 	lg->changed = 0;
@@ -198,7 +198,7 @@ void lguest_arch_run_guest(struct lguest_vcpu *vcpu)
 	 * re-enable interrupts an interrupt could fault and thus overwrite
 	 * cr2, or we could even move off to a different CPU. */
 	if (vcpu->regs->trapnum == 14)
-		lg->arch.last_pagefault = read_cr2();
+		vcpu->arch.last_pagefault = read_cr2();
 	/* Similarly, if we took a trap because the Guest used the FPU,
 	 * we have to restore the FPU it expects to see. */
 	else if (vcpu->regs->trapnum == 7)
@@ -309,7 +309,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		 *
 		 * The errcode tells whether this was a read or a write, and
 		 * whether kernel or userspace code. */
-		if (demand_page(lg, lg->arch.last_pagefault,
+		if (demand_page(lg, vcpu->arch.last_pagefault,
 				vcpu->regs->errcode))
 			return;
 
@@ -321,7 +321,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		 * happen before it's done the LHCALL_LGUEST_INIT hypercall, so
 		 * lg->lguest_data could be NULL */
 		if (lg->lguest_data &&
-		    put_user(lg->arch.last_pagefault, &lg->lguest_data->cr2))
+		    put_user(vcpu->arch.last_pagefault, &lg->lguest_data->cr2))
 			kill_guest(lg, "Writing cr2");
 		break;
 	case 7: /* We've intercepted a Device Not Available fault. */
@@ -352,7 +352,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 		 * it handle), it dies with a cryptic error message. */
 		kill_guest(lg, "unhandled trap %li at %#lx (%#lx)",
 			   vcpu->regs->trapnum, vcpu->regs->eip,
-			   vcpu->regs->trapnum == 14 ? lg->arch.last_pagefault
+			   vcpu->regs->trapnum == 14 ? vcpu->arch.last_pagefault
 			   : vcpu->regs->errcode);
 }
 
@@ -498,17 +498,15 @@ void __exit lguest_arch_host_fini(void)
 /*H:122 The i386-specific hypercalls simply farm out to the right functions. */
 int lguest_arch_do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 {
-	struct lguest *lg = vcpu->lg;
-
 	switch (args->arg0) {
 	case LHCALL_LOAD_GDT:
-		load_guest_gdt(lg, args->arg1, args->arg2);
+		load_guest_gdt(vcpu, args->arg1, args->arg2);
 		break;
 	case LHCALL_LOAD_IDT_ENTRY:
-		load_guest_idt_entry(lg, args->arg1, args->arg2, args->arg3);
+		load_guest_idt_entry(vcpu, args->arg1, args->arg2, args->arg3);
 		break;
 	case LHCALL_LOAD_TLS:
-		guest_load_tls(lg, args->arg1);
+		guest_load_tls(vcpu, args->arg1);
 		break;
 	default:
 		/* Bad Guest.  Bad! */
@@ -589,5 +587,5 @@ void lguest_arch_setup_regs(struct lguest_vcpu *vcpu, unsigned long start)
 
 	/* There are a couple of GDT entries the Guest expects when first
 	 * booting. */
-	setup_guest_gdt(vcpu->lg);
+	setup_guest_gdt(vcpu);
 }
diff --git a/include/asm-x86/lguest.h b/include/asm-x86/lguest.h
index ccd3384..4a10736 100644
--- a/include/asm-x86/lguest.h
+++ b/include/asm-x86/lguest.h
@@ -56,7 +56,7 @@ struct lguest_ro_state
 	struct desc_struct guest_gdt[GDT_ENTRIES];
 };
 
-struct lguest_arch
+struct lguest_vcpu_arch
 {
 	/* The GDT entries copied into lguest_ro_state when running. */
 	struct desc_struct gdt[GDT_ENTRIES];
-- 
1.5.0.6

