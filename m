Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYJYDde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYJYDde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 23:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYJYDbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 23:31:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:55405 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJYDbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 23:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e+UXcVi9szl01z729r88GbWV+3E1+kjtQMDZd9DOsUZyqzdl/3CDFPo0ryIH+NFlhr
         ciQy+sBtZ+PKEF91E+MgWZRy4IZ8sQLUNenPtLC8/oftFipj2JN2KzBqQMHetcY/YkMU
         QXF9GuhW3GbzK+m9VZcwWx6WDbCxA26BcGs14=
From: Joe Damato <ice799@gmail.com>
To: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Damato <ice799@gmail.com>
Subject: [PATCH 11/12] x86: Use macros for getting/setting descriptors
Date: Fri, 24 Oct 2008 20:15:31 -0700
Message-Id: <0df5b7f8e2bee4a3599d6b80ea344b69d4bb4dc6.1224903713.git.ice799@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <63f6f0d8b3da967e88094b6cd4b23f2ba78abbdc.1224903712.git.ice799@gmail.com>
References: <>
 <1224904532-9586-1-git-send-email-ice799@gmail.com>
 <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
 <03269a2e8f455b431612a32e8cce048e98c75b27.1224903712.git.ice799@gmail.com>
 <4810cc08c12cd78612b53f9b52d7ba93a9b03fd0.1224903712.git.ice799@gmail.com>
 <a9cabc5cabdb5a10631e2a6dc330c54826f2b210.1224903712.git.ice799@gmail.com>
 <a4c806abcf7a46c78aaff4e338fdbc1a06a56c88.1224903712.git.ice799@gmail.com>
 <8834ad1ab5a5ab9b4902ab708160b23f078f3758.1224903712.git.ice799@gmail.com>
 <4d0ab6d642a4edc3ecc7367df7043ecc8f0a7f98.1224903712.git.ice799@gmail.com>
 <c53b3a54b3215187055dfe5673e1351d1bd3957a.1224903712.git.ice799@gmail.com>
 <e1bbf5a92bbf8fcf36dcbb650ee5f22d48d4b0f4.1224903712.git.ice799@gmail.com>
 <63f6f0d8b3da967e88094b6cd4b23f2ba78abbdc.1224903712.git.ice799@gmail.com>
In-Reply-To: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
References: <52f8491fb5d55c0171840b01638ea6db0a98f3be.1224903712.git.ice799@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macros for getting/setting the hi and lo 32bits of descriptors since 'a' and 'b' were removed.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/kernel/tls.c                 |    2 +-
 arch/x86/kernel/vmi_32.c              |    3 ++-
 arch/x86/lguest/boot.c                |    2 +-
 arch/x86/math-emu/fpu_system.h        |   19 +++++++++----------
 drivers/lguest/interrupts_and_traps.c |   18 +++++++++---------
 drivers/lguest/segments.c             |   14 +++++++-------
 drivers/pnp/pnpbios/bioscalls.c       |    4 ++--
 include/asm-x86/xen/hypercall.h       |    4 ++--
 8 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..653c995 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -42,7 +42,7 @@ static void set_tls_desc(struct task_struct *p, int idx,
 
 	while (n-- > 0) {
 		if (LDT_empty(info))
-			desc->a = desc->b = 0;
+			desc_hi(desc) = desc_lo(desc) = 0;
 		else
 			fill_ldt(desc, info);
 		++info;
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 8c87b9b..939363b 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -189,7 +189,8 @@ static void vmi_cpuid(unsigned int *ax, unsigned int *bx,
 
 static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
 {
-	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
+	if (desc_hi(gdt[nr]) != desc_hi(*new) ||
+	    desc_lo(gdt[nr]) != desc_lo(*new))
 		write_gdt_entry(gdt, nr, new, 0);
 }
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 48ee4f9..a2391d8 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -236,7 +236,7 @@ static void lguest_load_idt(const struct desc_ptr *desc)
 	struct desc_struct *idt = (void *)desc->address;
 
 	for (i = 0; i < (desc->size+1)/8; i++)
-		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, desc_lo(idt[i]), desc_hi(idt[i]));
 }
 
 /*
diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index 13488fa..3fb2237 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -23,16 +23,15 @@
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
+#define SEG_D_SIZE(x)		(desc_hi(x) & (3 << 21))
+#define SEG_G_BIT(x)		(desc_hi(x) & (1 << 23))
+#define SEG_GRANULARITY(x)	((desc_hi(x) & (1 << 23)) ? 4096 : 1)
+#define SEG_286_MODE(x)		(desc_hi(x) & ( 0xff000000 | 0xf0000 | (1 << 23)))
+#define SEG_BASE_ADDR(s)	(ldttss_offset(s))
+#define SEG_LIMIT(s)		(ldttss_limit(s))
+#define SEG_EXECUTE_ONLY(s)	((desc_hi(s) & ((1 << 11) | (1 << 9))) == (1 << 11))
+#define SEG_WRITE_PERM(s)	((desc_hi(s) & ((1 << 11) | (1 << 9))) == (1 << 9))
+#define SEG_EXPAND_DOWN(s)	((desc_hi(s) & ((1 << 11) | (1 << 10))) \
 				 == (1 << 10))
 
 #define I387			(current->thread.xstate)
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 48aa15b..bfb24d9 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -184,7 +184,7 @@ void maybe_do_interrupt(struct lg_cpu *cpu)
 		/* set_guest_interrupt() takes the interrupt descriptor and a
 		 * flag to say whether this interrupt pushes an error code onto
 		 * the stack as well: virtual interrupts never do. */
-		set_guest_interrupt(cpu, idt->a, idt->b, 0);
+		set_guest_interrupt(cpu, desc_lo(idt), desc_hi(idt), 0);
 	}
 
 	/* Every time we deliver an interrupt, we update the timestamp in the
@@ -256,8 +256,8 @@ int deliver_trap(struct lg_cpu *cpu, unsigned int num)
 	 * bogus one in): if we fail here, the Guest will be killed. */
 	if (!idt_present(cpu->arch.idt[num].a, cpu->arch.idt[num].b))
 		return 0;
-	set_guest_interrupt(cpu, cpu->arch.idt[num].a,
-			    cpu->arch.idt[num].b, has_err(num));
+	set_guest_interrupt(cpu, desc_lo(cpu->arch.idt[num]),
+			    desc_hi(cpu->arch.idt[num]), has_err(num));
 	return 1;
 }
 
@@ -360,7 +360,7 @@ static void set_trap(struct lg_cpu *cpu, gate_desc *trap,
 
 	/* We zero-out a not-present entry */
 	if (!idt_present(lo, hi)) {
-		trap->a = trap->b = 0;
+		desc_hi(trap) = desc_lo(trap) = 0;
 		return;
 	}
 
@@ -372,8 +372,8 @@ static void set_trap(struct lg_cpu *cpu, gate_desc *trap,
 	 * type.  The privilege level controls where the trap can be triggered
 	 * manually with an "int" instruction.  This is usually GUEST_PL,
 	 * except for system calls which userspace can use. */
-	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
-	trap->b = (hi&0xFFFFEF00);
+	desc_lo(trap) = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
+	desc_hi(trap) = (hi&0xFFFFEF00);
 }
 
 /*H:230 While we're here, dealing with delivering traps and interrupts to the
@@ -419,11 +419,11 @@ static void default_idt_entry(gate_desc *idt,
 	else if (base)
 		/* Copy priv. level from what Guest asked for.  This allows
 		 * debug (int 3) traps from Guest userspace, for example. */
-		flags |= (base->b & 0x6000);
+		flags |= (desc_hi(base) & 0x6000);
 
 	/* Now pack it into the IDT entry in its weird format. */
-	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
-	idt->b = (handler&0xFFFF0000) | flags;
+	desc_lo(idt) = (LGUEST_CS<<16) | (handler&0x0000FFFF);
+	desc_hi(idt) = (handler&0xFFFF0000) | flags;
 }
 
 /* When the Guest first starts, we put default entries into the IDT. */
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index ec6aa3f..8506880 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -71,14 +71,14 @@ static void fixup_gdt_table(struct lg_cpu *cpu, unsigned start, unsigned end)
 		/* Segment descriptors contain a privilege level: the Guest is
 		 * sometimes careless and leaves this as 0, even though it's
 		 * running at privilege level 1.  If so, we fix it here. */
-		if ((cpu->arch.gdt[i].b & 0x00006000) == 0)
-			cpu->arch.gdt[i].b |= (GUEST_PL << 13);
+		if ((desc_hi(cpu->arch.gdt[i]) & 0x00006000) == 0)
+			desc_hi(cpu->arch.gdt[i]) |= (GUEST_PL << 13);
 
 		/* Each descriptor has an "accessed" bit.  If we don't set it
 		 * now, the CPU will try to set it when the Guest first loads
 		 * that entry into a segment register.  But the GDT isn't
 		 * writable by the Guest, so bad things can happen. */
-		cpu->arch.gdt[i].b |= 0x00000100;
+		desc_hi(cpu->arch.gdt[i]) |= 0x00000100;
 	}
 }
 
@@ -102,8 +102,8 @@ void setup_default_gdt_entries(struct lguest_ro_state *state)
 	 * Forgive the magic flags: the 0x8900 means the entry is Present, it's
 	 * privilege level 0 Available 386 TSS system segment, and the 0x67
 	 * means Saturn is eclipsed by Mercury in the twelfth house. */
-	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
-	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
+	desc_lo(gdt[GDT_ENTRY_TSS]) = 0x00000067 | (tss << 16);
+	desc_hi(gdt[GDT_ENTRY_TSS]) = 0x00008900 | (tss & 0xFF000000)
 		| ((tss >> 16) & 0x000000FF);
 }
 
@@ -116,8 +116,8 @@ void setup_guest_gdt(struct lg_cpu *cpu)
 	cpu->arch.gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
 	/* ...except the Guest is allowed to use them, so set the privilege
 	 * level appropriately in the flags. */
-	cpu->arch.gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
-	cpu->arch.gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+	desc_hi(cpu->arch.gdt[GDT_ENTRY_KERNEL_CS]) |= (GUEST_PL << 13);
+	desc_hi(cpu->arch.gdt[GDT_ENTRY_KERNEL_DS]) |= (GUEST_PL << 13);
 }
 
 /*H:650 An optimization of copy_gdt(), for just the three "thead-local storage"
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 7ff8244..2b9bb7c 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -476,8 +476,8 @@ void pnpbios_calls_init(union pnp_bios_install_struct *header)
 	pnp_bios_callpoint.offset = header->fields.pm16offset;
 	pnp_bios_callpoint.segment = PNP_CS16;
 
-	bad_bios_desc.a = 0;
-	bad_bios_desc.b = 0x00409200;
+	desc_lo(bad_bios_desc) = 0;
+	desc_hi(bad_bios_desc) = 0x00409200;
 
 	set_base(bad_bios_desc, __va((unsigned long)0x40 << 4));
 	_set_limit((char *)&bad_bios_desc, 4095 - (0x40 << 4));
diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
index 44f4259..6e36e20 100644
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -472,8 +472,8 @@ MULTI_update_descriptor(struct multicall_entry *mcl, u64 maddr,
 	} else {
 		mcl->args[0] = maddr;
 		mcl->args[1] = maddr >> 32;
-		mcl->args[2] = desc.a;
-		mcl->args[3] = desc.b;
+		mcl->args[2] = desc_lo(desc);
+		mcl->args[3] = desc_hi(desc);
 	}
 }
 
-- 
1.5.4.3

