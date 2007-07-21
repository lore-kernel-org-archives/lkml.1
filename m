Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXGUBfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXGUBfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXGUBez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:34:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53937 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbXGUBex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:34:53 -0400
Date: Fri, 20 Jul 2007 18:33:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 3/3] i386: Replace struct Xgt_desc_struct with struct
	desc_ptr
Message-ID: <20070721013334.GB3673@sequoia.sous-sol.org>
References: <1184743355.10380.112.camel@localhost.localdomain> <1184743422.10380.114.camel@localhost.localdomain> <1184743812.10380.120.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184743812.10380.120.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> Remove i386's Xgt_desc_struct definition and use desc_def.h's desc_ptr.

plus this is needed now


Index: linus-2.6/drivers/lguest/lg.h
===================================================================
--- linus-2.6.orig/drivers/lguest/lg.h
+++ linus-2.6/drivers/lguest/lg.h
@@ -91,13 +91,13 @@ struct lguest_ro_state
 {
 	/* Host information we need to restore when we switch back. */
 	u32 host_cr3;
-	struct Xgt_desc_struct host_idt_desc;
-	struct Xgt_desc_struct host_gdt_desc;
+	struct desc_ptr host_idt_desc;
+	struct desc_ptr host_gdt_desc;
 	u32 host_sp;
 
 	/* Fields which are used when guest is running. */
-	struct Xgt_desc_struct guest_idt_desc;
-	struct Xgt_desc_struct guest_gdt_desc;
+	struct desc_ptr guest_idt_desc;
+	struct desc_ptr guest_gdt_desc;
 	struct i386_hw_tss guest_tss;
 	struct desc_struct guest_idt[IDT_ENTRIES];
 	struct desc_struct guest_gdt[GDT_ENTRIES];
Index: linus-2.6/arch/i386/xen/enlighten.c
===================================================================
--- linus-2.6.orig/arch/i386/xen/enlighten.c
+++ linus-2.6/arch/i386/xen/enlighten.c
@@ -301,7 +301,7 @@ static void xen_set_ldt(const void *addr
 	xen_mc_issue(PARAVIRT_LAZY_CPU);
 }
 
-static void xen_load_gdt(const struct Xgt_desc_struct *dtr)
+static void xen_load_gdt(const struct desc_ptr *dtr)
 {
 	unsigned long *frames;
 	unsigned long va = dtr->address;
@@ -401,7 +401,7 @@ static int cvt_gate_to_trap(int vector, 
 }
 
 /* Locations of each CPU's IDT */
-static DEFINE_PER_CPU(struct Xgt_desc_struct, idt_desc);
+static DEFINE_PER_CPU(struct desc_ptr, idt_desc);
 
 /* Set an IDT entry.  If the entry is part of the current IDT, then
    also update Xen. */
@@ -433,7 +433,7 @@ static void xen_write_idt_entry(struct d
 	preempt_enable();
 }
 
-static void xen_convert_trap_info(const struct Xgt_desc_struct *desc,
+static void xen_convert_trap_info(const struct desc_ptr *desc,
 				  struct trap_info *traps)
 {
 	unsigned in, out, count;
@@ -452,7 +452,7 @@ static void xen_convert_trap_info(const 
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
-	const struct Xgt_desc_struct *desc = &__get_cpu_var(idt_desc);
+	const struct desc_ptr *desc = &__get_cpu_var(idt_desc);
 
 	xen_convert_trap_info(desc, traps);
 }
@@ -460,7 +460,7 @@ void xen_copy_trap_info(struct trap_info
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
    hold a spinlock to protect the static traps[] array (static because
    it avoids allocation, and saves stack space). */
-static void xen_load_idt(const struct Xgt_desc_struct *desc)
+static void xen_load_idt(const struct desc_ptr *desc)
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
Index: linus-2.6/drivers/lguest/lguest.c
===================================================================
--- linus-2.6.orig/drivers/lguest/lguest.c
+++ linus-2.6/drivers/lguest/lguest.c
@@ -167,7 +167,7 @@ static void lguest_write_idt_entry(struc
 	hcall(LHCALL_LOAD_IDT_ENTRY, entrynum, low, high);
 }
 
-static void lguest_load_idt(const struct Xgt_desc_struct *desc)
+static void lguest_load_idt(const struct desc_ptr *desc)
 {
 	unsigned int i;
 	struct desc_struct *idt = (void *)desc->address;
@@ -176,7 +176,7 @@ static void lguest_load_idt(const struct
 		hcall(LHCALL_LOAD_IDT_ENTRY, i, idt[i].raw32.a, idt[i].raw32.b);
 }
 
-static void lguest_load_gdt(const struct Xgt_desc_struct *desc)
+static void lguest_load_gdt(const struct desc_ptr *desc)
 {
 	BUG_ON((desc->size+1)/8 != GDT_ENTRIES);
 	hcall(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES, 0);
