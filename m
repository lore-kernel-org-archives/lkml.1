Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbZC2VWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbZC2VWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbZC2VWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:22:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:62907 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZC2VV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YHKd/aBMc2bMX+Tcn3PY3/1kVmqbefQ1d3ggkGEgubLTjEh+pbBqhGCE0RqJ/YiqzO
         mww9nE0F9n8jtYw5tsRYW1s8pntxGVk6IWr1h9sS3SMGihuKy6aSdUkPisWe4Gjg83qs
         XFqJfzKxSPyMPQrswPCfWYDZL0ACCBxDaSCaM=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, w@1wt.eu, mingo@elte.hu, hpa@zytor.com,
       jeremy@goop.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 2/2] x86: Replace direct access to descriptor fields with getter/setters
Date: Sun, 29 Mar 2009 14:21:42 -0700
Message-Id: <8b04de3a7bdbde205de05c80044652a8949dc23c.1238361502.git.ice799@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
References: <cover.1238361501.git.ice799@gmail.com>
 <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
In-Reply-To: <cover.1238361501.git.ice799@gmail.com>
References: <cover.1238361501.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the getters/setters for 32bit x86 descriptors instead of touching the internal fields directly.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/include/asm/desc.h           |   12 ++++++------
 arch/x86/include/asm/xen/hypercall.h  |    5 +++--
 arch/x86/kernel/tls.c                 |    6 ++++--
 arch/x86/kernel/vmi_32.c              |    3 ++-
 arch/x86/lguest/boot.c                |    2 +-
 arch/x86/math-emu/fpu_system.h        |   20 ++++++++++----------
 drivers/lguest/interrupts_and_traps.c |   25 +++++++++++++------------
 drivers/lguest/segments.c             |   20 ++++++++++++--------
 drivers/pnp/pnpbios/bioscalls.c       |    4 ++--
 9 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c62cf93..9d3bb3f 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -86,9 +86,9 @@ static inline void pack_gate(gate_desc *gate, unsigned char type,
 			     unsigned long base, unsigned dpl, unsigned flags,
 			     unsigned short seg)
 {
-	gate->a = (seg << 16) | (base & 0xffff);
-	gate->b = (base & 0xffff0000) |
-		  (((0x80 | type | (dpl << 5)) & 0xff) << 8);
+	desc_set_lo(gate, (seg << 16) | (base & 0xffff));
+	desc_set_hi(gate, (base & 0xffff0000) |
+		  (((0x80 | type | (dpl << 5)) & 0xff) << 8));
 }
 
 #endif
@@ -166,10 +166,10 @@ static inline void pack_descriptor(struct desc_struct *desc, unsigned long base,
 				   unsigned long limit, unsigned char type,
 				   unsigned char flags)
 {
-	desc->a = ((base & 0xffff) << 16) | (limit & 0xffff);
-	desc->b = (base & 0xff000000) | ((base & 0xff0000) >> 16) |
+	desc_set_lo(desc, ((base & 0xffff) << 16) | (limit & 0xffff));
+	desc_set_hi(desc, (base & 0xff000000) | ((base & 0xff0000) >> 16) |
 		(limit & 0x000f0000) | ((type & 0xff) << 8) |
-		((flags & 0xf) << 20);
+		((flags & 0xf) << 20));
 	desc->p = 1;
 }
 
diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 5e79ca6..4401632 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -39,6 +39,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <asm/desc.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
@@ -478,8 +479,8 @@ MULTI_update_descriptor(struct multicall_entry *mcl, u64 maddr,
 	} else {
 		mcl->args[0] = maddr;
 		mcl->args[1] = maddr >> 32;
-		mcl->args[2] = desc.a;
-		mcl->args[3] = desc.b;
+		mcl->args[2] = desc_get_lo(&desc);
+		mcl->args[3] = desc_get_hi(&desc);
 	}
 }
 
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..4f2ca6d 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -41,8 +41,10 @@ static void set_tls_desc(struct task_struct *p, int idx,
 	cpu = get_cpu();
 
 	while (n-- > 0) {
-		if (LDT_empty(info))
-			desc->a = desc->b = 0;
+		if (LDT_empty(info)) {
+			desc_set_lo(desc, 0);
+			desc_set_hi(desc, 0);
+		}
 		else
 			fill_ldt(desc, info);
 		++info;
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index bef58b4..9ef53f0 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -189,7 +189,8 @@ static void vmi_cpuid(unsigned int *ax, unsigned int *bx,
 
 static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
 {
-	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
+	if (desc_get_lo(gdt + nr) != desc_get_lo(new) ||
+	    desc_get_hi(gdt + nr) != desc_get_hi(new))
 		write_gdt_entry(gdt, nr, new, 0);
 }
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 960a8d9..b5787d5 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -236,7 +236,7 @@ static void lguest_load_idt(const struct desc_ptr *desc)
 	struct desc_struct *idt = (void *)desc->address;
 
 	for (i = 0; i < (desc->size+1)/8; i++)
-		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, desc_get_lo(idt + i), desc_get_hi(idt + i));
 }
 
 /*
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 50fa0ec..0fc7512 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -19,16 +19,16 @@
 /* s is always from a cpu register, and the cpu does bounds checking
  * during register load --> no further bounds checks needed */
 #define LDT_DESCRIPTOR(s)	(((struct desc_struct *)current->mm->context.ldt)[(s) >> 3])
-#define SEG_D_SIZE(x)		((x).b & (3 << 21))
-#define SEG_G_BIT(x)		((x).b & (1 << 23))
-#define SEG_GRANULARITY(x)	(((x).b & (1 << 23)) ? 4096 : 1)
-#define SEG_286_MODE(x)		((x).b & ( 0xff000000 | 0xf0000 | (1 << 23)))
-#define SEG_BASE_ADDR(s)	(((s).b & 0xff000000) \
-				 | (((s).b & 0xff) << 16) | ((s).a >> 16))
-#define SEG_LIMIT(s)		(((s).b & 0xff0000) | ((s).a & 0xffff))
-#define SEG_EXECUTE_ONLY(s)	(((s).b & ((1 << 11) | (1 << 9))) == (1 << 11))
-#define SEG_WRITE_PERM(s)	(((s).b & ((1 << 11) | (1 << 9))) == (1 << 9))
-#define SEG_EXPAND_DOWN(s)	(((s).b & ((1 << 11) | (1 << 10))) \
+#define SEG_D_SIZE(x)		(desc_get_hi(&x) & (3 << 21))
+#define SEG_G_BIT(x)		(desc_get_hi(&x) & (1 << 23))
+#define SEG_GRANULARITY(x)	((desc_get_hi(&x) & (1 << 23)) ? 4096 : 1)
+#define SEG_286_MODE(x)		(desc_get_hi(&x) & (0xff000000 | 0xf0000 | (1 << 23)))
+#define SEG_BASE_ADDR(s)	((desc_get_hi(&s) & 0xff000000) \
+				 | ((desc_get_hi(&s) & 0xff) << 16) | (desc_get_lo(&s) >> 16))
+#define SEG_LIMIT(s)		((desc_get_hi(&s) & 0xff0000) | (desc_get_lo(&s) & 0xffff))
+#define SEG_EXECUTE_ONLY(s)	((desc_get_hi(&s) & ((1 << 11) | (1 << 9))) == (1 << 11))
+#define SEG_WRITE_PERM(s)	((desc_get_hi(&s) & ((1 << 11) | (1 << 9))) == (1 << 9))
+#define SEG_EXPAND_DOWN(s)	((desc_get_hi(&s) & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
 #define I387			(current->thread.xstate)
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 415fab0..7394b23 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -178,13 +178,13 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
 	 * over them. */
 	idt = &cpu->arch.idt[FIRST_EXTERNAL_VECTOR+irq];
 	/* If they don't have a handler (yet?), we just ignore it */
-	if (idt_present(idt->a, idt->b)) {
+	if (idt_present(desc_get_lo(idt), desc_get_hi(idt))) {
 		/* OK, mark it no longer pending and deliver it. */
 		clear_bit(irq, cpu->irqs_pending);
 		/* set_guest_interrupt() takes the interrupt descriptor and a
 		 * flag to say whether this interrupt pushes an error code onto
 		 * the stack as well: virtual interrupts never do. */
-		set_guest_interrupt(cpu, idt->a, idt->b, 0);
+		set_guest_interrupt(cpu, desc_get_lo(idt), desc_get_hi(idt), 0);
 	}
 
 	/* Every time we deliver an interrupt, we update the timestamp in the
@@ -259,10 +259,10 @@ int deliver_trap(struct lg_cpu *cpu, unsigned int num)
 
 	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
 	 * bogus one in): if we fail here, the Guest will be killed. */
-	if (!idt_present(cpu->arch.idt[num].a, cpu->arch.idt[num].b))
+	if (!idt_present(desc_get_lo(cpu->arch.idt + num), desc_get_hi(cpu->arch.idt + num)))
 		return 0;
-	set_guest_interrupt(cpu, cpu->arch.idt[num].a,
-			    cpu->arch.idt[num].b, has_err(num));
+	set_guest_interrupt(cpu, desc_get_lo(cpu->arch.idt + num),
+			    desc_get_hi(cpu->arch.idt + num), has_err(num));
 	return 1;
 }
 
@@ -365,7 +365,8 @@ static void set_trap(struct lg_cpu *cpu, struct desc_struct *trap,
 
 	/* We zero-out a not-present entry */
 	if (!idt_present(lo, hi)) {
-		trap->a = trap->b = 0;
+		desc_set_lo(trap, 0);
+		desc_set_hi(trap, 0);
 		return;
 	}
 
@@ -377,8 +378,8 @@ static void set_trap(struct lg_cpu *cpu, struct desc_struct *trap,
 	 * type.  The privilege level controls where the trap can be triggered
 	 * manually with an "int" instruction.  This is usually GUEST_PL,
 	 * except for system calls which userspace can use. */
-	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
-	trap->b = (hi&0xFFFFEF00);
+	desc_set_lo(trap, ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF));
+	desc_set_hi(trap, (hi&0xFFFFEF00));
 }
 
 /*H:230 While we're here, dealing with delivering traps and interrupts to the
@@ -424,11 +425,11 @@ static void default_idt_entry(struct desc_struct *idt,
 	else if (base)
 		/* Copy priv. level from what Guest asked for.  This allows
 		 * debug (int 3) traps from Guest userspace, for example. */
-		flags |= (base->b & 0x6000);
+		flags |= (desc_get_hi(base) & 0x6000);
 
 	/* Now pack it into the IDT entry in its weird format. */
-	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
-	idt->b = (handler&0xFFFF0000) | flags;
+	desc_set_lo(idt, (LGUEST_CS<<16) | (handler&0x0000FFFF));
+	desc_set_hi(idt, (handler&0xFFFF0000) | flags);
 }
 
 /* When the Guest first starts, we put default entries into the IDT. */
@@ -466,7 +467,7 @@ void copy_traps(const struct lg_cpu *cpu, struct desc_struct *idt,
 		 * If it can't go direct, we still need to copy the priv. level:
 		 * they might want to give userspace access to a software
 		 * interrupt. */
-		if (idt_type(gidt->a, gidt->b) == 0xF)
+		if (idt_type(desc_get_lo(gidt), desc_get_hi(gidt)) == 0xF)
 			idt[i] = *gidt;
 		else
 			default_idt_entry(&idt[i], i, def[i], gidt);
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index ec6aa3f..9646195 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -61,6 +61,7 @@ static int ignored_gdt(unsigned int num)
 static void fixup_gdt_table(struct lg_cpu *cpu, unsigned start, unsigned end)
 {
 	unsigned int i;
+	struct desc_struct *tmp = NULL;
 
 	for (i = start; i < end; i++) {
 		/* We never copy these ones to real GDT, so we don't care what
@@ -71,14 +72,15 @@ static void fixup_gdt_table(struct lg_cpu *cpu, unsigned start, unsigned end)
 		/* Segment descriptors contain a privilege level: the Guest is
 		 * sometimes careless and leaves this as 0, even though it's
 		 * running at privilege level 1.  If so, we fix it here. */
-		if ((cpu->arch.gdt[i].b & 0x00006000) == 0)
-			cpu->arch.gdt[i].b |= (GUEST_PL << 13);
+		tmp = &cpu->arch.gdt[i];
+		if ((desc_get_hi(tmp) & 0x00006000) == 0)
+			desc_set_hi(tmp, desc_get_hi(tmp) | (GUEST_PL << 13));
 
 		/* Each descriptor has an "accessed" bit.  If we don't set it
 		 * now, the CPU will try to set it when the Guest first loads
 		 * that entry into a segment register.  But the GDT isn't
 		 * writable by the Guest, so bad things can happen. */
-		cpu->arch.gdt[i].b |= 0x00000100;
+		desc_set_hi(tmp,  desc_get_hi(tmp) | 0x00000100);
 	}
 }
 
@@ -102,9 +104,9 @@ void setup_default_gdt_entries(struct lguest_ro_state *state)
 	 * Forgive the magic flags: the 0x8900 means the entry is Present, it's
 	 * privilege level 0 Available 386 TSS system segment, and the 0x67
 	 * means Saturn is eclipsed by Mercury in the twelfth house. */
-	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
-	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
-		| ((tss >> 16) & 0x000000FF);
+	desc_set_lo(gdt + GDT_ENTRY_TSS, 0x00000067 | (tss << 16));
+	desc_set_hi(gdt + GDT_ENTRY_TSS, 0x00008900 | (tss & 0xFF000000)
+		| ((tss >> 16) & 0x000000FF));
 }
 
 /* This routine sets up the initial Guest GDT for booting.  All entries start
@@ -116,8 +118,10 @@ void setup_guest_gdt(struct lg_cpu *cpu)
 	cpu->arch.gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
 	/* ...except the Guest is allowed to use them, so set the privilege
 	 * level appropriately in the flags. */
-	cpu->arch.gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
-	cpu->arch.gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+	desc_set_hi(cpu->arch.gdt + GDT_ENTRY_KERNEL_CS,
+		desc_get_hi(cpu->arch.gdt + GDT_ENTRY_KERNEL_CS) | (GUEST_PL << 13));
+	desc_set_hi(cpu->arch.gdt + GDT_ENTRY_KERNEL_DS,
+		desc_get_hi(cpu->arch.gdt + GDT_ENTRY_KERNEL_DS) | (GUEST_PL << 13));
 }
 
 /*H:650 An optimization of copy_gdt(), for just the three "thead-local storage"
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 7e6b5a3..d6a5368 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -476,8 +476,8 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	bad_bios_desc.a = 0;
-	bad_bios_desc.b = 0x00409200;
+	desc_set_lo(&bad_bios_desc, 0);
+	desc_set_hi(&bad_bios_desc, 0x00409200);
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
-- 
1.6.2

