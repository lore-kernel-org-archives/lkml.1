Return-Path: <linux-kernel-owner+w=401wt.eu-S935285AbXGUBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbXGUBeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXGUBeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:34:23 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53930 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbXGUBeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:34:22 -0400
Date: Fri, 20 Jul 2007 18:32:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] i386: use x86_64's desc_def.h
Message-ID: <20070721013255.GA3673@sequoia.sous-sol.org>
References: <1184743355.10380.112.camel@localhost.localdomain> <1184743422.10380.114.camel@localhost.localdomain> <469E3DA1.3010600@vmware.com> <1184801261.10380.174.camel@localhost.localdomain> <1184801383.10380.176.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184801383.10380.176.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Thu, 2007-07-19 at 09:27 +1000, Rusty Russell wrote:
> > On Wed, 2007-07-18 at 09:19 -0700, Zachary Amsden wrote:
> > > > +#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
> > > > +#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
> > > 
> > > You got rid of the duplicate definitions here, but then added new 
> > > duplicates (GET_CONTENTS / WRITABLE).  Can you stick them in desc.h?
> > 
> > To be honest, I got sick of counting bits at this point, and didn't want
> > to introduce bugs.
> > 
> > Here's the updated version of PATCH 1/3:
> 
> And 2/3:
> ===
> i386: use x86_64's desc_def.h

plus this needed as well now

Index: linus-2.6/include/asm-i386/xen/hypercall.h
===================================================================
--- linus-2.6.orig/include/asm-i386/xen/hypercall.h
+++ linus-2.6/include/asm-i386/xen/hypercall.h
@@ -359,8 +359,8 @@ MULTI_update_descriptor(struct multicall
 	mcl->op = __HYPERVISOR_update_descriptor;
 	mcl->args[0] = maddr;
 	mcl->args[1] = maddr >> 32;
-	mcl->args[2] = desc.a;
-	mcl->args[3] = desc.b;
+	mcl->args[2] = desc.raw32.a;
+	mcl->args[3] = desc.raw32.b;
 }
 
 static inline void
Index: linus-2.6/drivers/lguest/interrupts_and_traps.c
===================================================================
--- linus-2.6.orig/drivers/lguest/interrupts_and_traps.c
+++ linus-2.6/drivers/lguest/interrupts_and_traps.c
@@ -103,9 +103,9 @@ void maybe_do_interrupt(struct lguest *l
 	}
 
 	idt = &lg->idt[FIRST_EXTERNAL_VECTOR+irq];
-	if (idt_present(idt->a, idt->b)) {
+	if (idt_present(idt->raw32.a, idt->raw32.b)) {
 		clear_bit(irq, lg->irqs_pending);
-		set_guest_interrupt(lg, idt->a, idt->b, 0);
+		set_guest_interrupt(lg, idt->raw32.a, idt->raw32.b, 0);
 	}
 }
 
@@ -116,7 +116,7 @@ static int has_err(unsigned int trap)
 
 int deliver_trap(struct lguest *lg, unsigned int num)
 {
-	u32 lo = lg->idt[num].a, hi = lg->idt[num].b;
+	u32 lo = lg->idt[num].raw32.a, hi = lg->idt[num].raw32.b;
 
 	if (!idt_present(lo, hi))
 		return 0;
@@ -139,7 +139,7 @@ static int direct_trap(const struct lgue
 		return 0;
 
 	/* Interrupt gates (0xE) or not present (0x0) can't go direct. */
-	return idt_type(trap->a, trap->b) == 0xF;
+	return idt_type(trap->raw32.a, trap->raw32.b) == 0xF;
 }
 
 void pin_stack_pages(struct lguest *lg)
@@ -170,15 +170,15 @@ static void set_trap(struct lguest *lg, 
 	u8 type = idt_type(lo, hi);
 
 	if (!idt_present(lo, hi)) {
-		trap->a = trap->b = 0;
+		trap->raw32.a = trap->raw32.b = 0;
 		return;
 	}
 
 	if (type != 0xE && type != 0xF)
 		kill_guest(lg, "bad IDT type %i", type);
 
-	trap->a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
-	trap->b = (hi&0xFFFFEF00);
+	trap->raw32.a = ((__KERNEL_CS|GUEST_PL)<<16) | (lo&0x0000FFFF);
+	trap->raw32.b = (hi&0xFFFFEF00);
 }
 
 void load_guest_idt_entry(struct lguest *lg, unsigned int num, u32 lo, u32 hi)
@@ -204,8 +204,8 @@ static void default_idt_entry(struct des
 	if (trap == LGUEST_TRAP_ENTRY)
 		flags |= (GUEST_PL << 13);
 
-	idt->a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
-	idt->b = (handler&0xFFFF0000) | flags;
+	idt->raw32.a = (LGUEST_CS<<16) | (handler&0x0000FFFF);
+	idt->raw32.b = (handler&0xFFFF0000) | flags;
 }
 
 void setup_default_idt_entries(struct lguest_ro_state *state,
Index: linus-2.6/drivers/lguest/lg.h
===================================================================
--- linus-2.6.orig/drivers/lguest/lg.h
+++ linus-2.6/drivers/lguest/lg.h
@@ -44,8 +44,8 @@ void free_pagetables(void);
 int init_pagetables(struct page **switcher_page, unsigned int pages);
 
 /* Full 4G segment descriptors, suitable for CS and DS. */
-#define FULL_EXEC_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9b00})
-#define FULL_SEGMENT ((struct desc_struct){0x0000ffff, 0x00cf9300})
+#define FULL_EXEC_SEGMENT ((struct desc_struct){ {0x00cf9b000000ffffULL} })
+#define FULL_SEGMENT ((struct desc_struct){ {0x00cf93000000ffffULL} })
 
 struct lguest_dma_info
 {
Index: linus-2.6/drivers/lguest/lguest.c
===================================================================
--- linus-2.6.orig/drivers/lguest/lguest.c
+++ linus-2.6/drivers/lguest/lguest.c
@@ -173,7 +173,7 @@ static void lguest_load_idt(const struct
 	struct desc_struct *idt = (void *)desc->address;
 
 	for (i = 0; i < (desc->size+1)/8; i++)
-		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].a, idt[i].b);
+		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].raw32.a, idt[i].raw32.b);
 }
 
 static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
Index: linus-2.6/drivers/lguest/segments.c
===================================================================
--- linus-2.6.orig/drivers/lguest/segments.c
+++ linus-2.6/drivers/lguest/segments.c
@@ -3,12 +3,12 @@
 static int desc_ok(const struct desc_struct *gdt)
 {
 	/* MBZ=0, P=1, DT=1  */
-	return ((gdt->b & 0x00209000) == 0x00009000);
+	return ((gdt->raw32.b & 0x00209000) == 0x00009000);
 }
 
 static int segment_present(const struct desc_struct *gdt)
 {
-	return gdt->b & 0x8000;
+	return gdt->raw32.b & 0x8000;
 }
 
 static int ignored_gdt(unsigned int num)
@@ -54,11 +54,11 @@ static void fixup_gdt_table(struct lgues
 			kill_guest(lg, "Bad GDT descriptor %i", i);
 
 		/* DPL 0 presumably means "for use by guest". */
-		if ((lg->gdt[i].b & 0x00006000) == 0)
-			lg->gdt[i].b |= (GUEST_PL << 13);
+		if ((lg->gdt[i].raw32.b & 0x00006000) == 0)
+			lg->gdt[i].raw32.b |= (GUEST_PL << 13);
 
 		/* Set accessed bit, since gdt isn't writable. */
-		lg->gdt[i].b |= 0x00000100;
+		lg->gdt[i].raw32.b |= 0x00000100;
 	}
 }
 
@@ -73,8 +73,8 @@ void setup_default_gdt_entries(struct lg
 
 	/* This is the one which we *cannot* copy from guest, since tss
 	   is depended on this lguest_ro_state, ie. this cpu. */
-	gdt[GDT_ENTRY_TSS].a = 0x00000067 | (tss << 16);
-	gdt[GDT_ENTRY_TSS].b = 0x00008900 | (tss & 0xFF000000)
+	gdt[GDT_ENTRY_TSS].raw32.a = 0x00000067 | (tss << 16);
+	gdt[GDT_ENTRY_TSS].raw32.b = 0x00008900 | (tss & 0xFF000000)
 		| ((tss >> 16) & 0x000000FF);
 }
 
@@ -82,8 +82,8 @@ void setup_guest_gdt(struct lguest *lg)
 {
 	lg->gdt[GDT_ENTRY_KERNEL_CS] = FULL_EXEC_SEGMENT;
 	lg->gdt[GDT_ENTRY_KERNEL_DS] = FULL_SEGMENT;
-	lg->gdt[GDT_ENTRY_KERNEL_CS].b |= (GUEST_PL << 13);
-	lg->gdt[GDT_ENTRY_KERNEL_DS].b |= (GUEST_PL << 13);
+	lg->gdt[GDT_ENTRY_KERNEL_CS].raw32.b |= (GUEST_PL << 13);
+	lg->gdt[GDT_ENTRY_KERNEL_DS].raw32.b |= (GUEST_PL << 13);
 }
 
 /* This is a fast version for the common case where only the three TLS entries
