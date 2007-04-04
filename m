Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXDDTHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXDDTHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993039AbXDDTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:07:19 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:44081 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbXDDTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:07:16 -0400
Subject: [PATCH] Lguest32, use guest page tables to find paddr for emulated
	instructions
From: Steven Rostedt <rostedt@goodmis.org>
To: virtualization@lists.osdl.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 15:07:06 -0400
Message-Id: <1175713626.9371.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Bug that was found by my previous patch]

This patch allows things like modules, which don't have a direct
__pa(EIP) mapping to do emulated instructions.

Sure, the emulated instruction probably should be a paravirt_op, but
this patch lets you at least boot a kernel that has modules needing
emulated instructions.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rc5-mm2/drivers/lguest/core.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/drivers/lguest/core.c
+++ linux-2.6.21-rc5-mm2/drivers/lguest/core.c
@@ -160,11 +160,14 @@ static int emulate_insn(struct lguest *l
 {
 	u8 insn;
 	unsigned int insnlen = 0, in = 0, shift = 0;
-	unsigned long physaddr = guest_pa(lg, lg->regs->eip);
+	unsigned long physaddr = lguest_find_guest_paddr(lg, lg->regs->eip);
 
-	/* This only works for addresses in linear mapping... */
-	if (lg->regs->eip < lg->page_offset)
+	/* FIXME: Handle physaddr's that crosses pages (modules are in VM) */
+
+	/* did we actually find the physaddr? */
+	if (physaddr == (unsigned long)-1UL)
 		return 0;
+
 	lgread(lg, &insn, physaddr, 1);
 
 	/* Operand size prefix means it's actually for ax. */
Index: linux-2.6.21-rc5-mm2/drivers/lguest/lg.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/drivers/lguest/lg.h
+++ linux-2.6.21-rc5-mm2/drivers/lguest/lg.h
@@ -218,6 +218,7 @@ void guest_set_pte(struct lguest *lg, un
 void map_hypervisor_in_guest(struct lguest *lg, struct lguest_pages *pages);
 int demand_page(struct lguest *info, unsigned long cr2, int write);
 void pin_page(struct lguest *lg, unsigned long vaddr);
+unsigned long lguest_find_guest_paddr(struct lguest *lg, unsigned long vaddr);
 
 /* lguest_user.c: */
 int lguest_device_init(void);
Index: linux-2.6.21-rc5-mm2/drivers/lguest/page_tables.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/drivers/lguest/page_tables.c
+++ linux-2.6.21-rc5-mm2/drivers/lguest/page_tables.c
@@ -105,6 +105,25 @@ static spte_t gpte_to_spte(struct lguest
 	return spte;
 }
 
+unsigned long lguest_find_guest_paddr(struct lguest *lg, unsigned long vaddr)
+{
+	gpgd_t gpgd;
+	gpte_t gpte;
+	unsigned long gpte_ptr;
+
+	gpgd = mkgpgd(lgread_u32(lg, gpgd_addr(lg, vaddr)));
+	if (!(gpgd.flags & _PAGE_PRESENT))
+		return -1;
+
+	gpte_ptr = gpte_addr(lg, gpgd, vaddr);
+	gpte = mkgpte(lgread_u32(lg, gpte_ptr));
+
+	if (!(gpte.flags & _PAGE_PRESENT))
+		return -1;
+
+	return (gpte.pfn << PAGE_SHIFT) | (vaddr & (PAGE_SIZE-1));
+}
+
 /* FIXME: We hold reference to pages, which prevents them from being
    swapped.  It'd be nice to have a callback when Linux wants to swap out. */
 


