Return-Path: <linux-kernel-owner+w=401wt.eu-S2992929AbXCIDUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992929AbXCIDUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992927AbXCIDUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:20:09 -0500
Received: from ozlabs.org ([203.10.76.45]:45495 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992923AbXCIDUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:20:06 -0500
Subject: [PATCH 6/9] lguest: pin stack page optimization
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173410264.32234.78.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
	 <1173409939.32234.73.camel@localhost.localdomain>
	 <1173410210.32234.76.camel@localhost.localdomain>
	 <1173410264.32234.78.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:19:08 +1100
Message-Id: <1173410348.32234.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We make sure that the stack is always mapped in pin_stack_pages by
simply calling demand_page, but that calls get_user_pages() to find
the pfn, which is way overkill since the page is almost certainly
already mapped.  So don't call pin_stack_pages every context switch
(unless genuinely a completely clean context, all the kernel mappings
are kept in sync), and when we do call it, have it check if it needs
to call demand_page().

This speeds guest context switch by 25%:

Before:
Time for one context switch via pipe: 10606 nsec
After:
Time for one context switch via pipe: 7805 nsec
Native:
Time for one context switch via pipe: 4701 nsec

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 06b3a533da77 arch/i386/lguest/page_tables.c
--- a/arch/i386/lguest/page_tables.c	Wed Feb 21 12:20:20 2007 +1100
+++ b/arch/i386/lguest/page_tables.c	Wed Feb 21 18:13:00 2007 +1100
@@ -155,14 +158,29 @@ int demand_page(struct lguest *lg, u32 v
 	return page_in(lg, vaddr, (write ? _PAGE_DIRTY : 0)|_PAGE_ACCESSED);
 }
 
+/* This is much faster than the full demand_page logic. */
+static int page_writable(struct lguest *lg, unsigned long vaddr)
+{
+	u32 *top, *pte;
+
+	top = toplev(lg, lg->pgdidx, vaddr);
+	if (!(*top & _PAGE_PRESENT))
+		return 0;
+
+	pte = pteof(lg, *top, vaddr);
+	return (*pte & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
+}
+
 void pin_stack_pages(struct lguest *lg)
 {
 	unsigned int i;
 	u32 stack = lg->state->tss.esp1;
 
-	for (i = 0; i < lg->stack_pages; i++)
-		if (!demand_page(lg, stack - i*PAGE_SIZE, 1))
+	for (i = 0; i < lg->stack_pages; i++) {
+		if (!page_writable(lg, stack - i * PAGE_SIZE)
+		    && !demand_page(lg, stack - i * PAGE_SIZE, 1))
 			kill_guest(lg, "bad stack page %i@%#x", i, stack);
+	}
 }
 
 static unsigned int find_pgdir(struct lguest *lg, u32 pgtable)
@@ -198,7 +216,7 @@ void guest_pagetable_flush_user(struct l
 	flush_user_mappings(lg, lg->pgdidx);
 }
 
-static unsigned int new_pgdir(struct lguest *lg, u32 cr3)
+static unsigned int new_pgdir(struct lguest *lg, u32 cr3, int *blank_pgdir)
 {
 	unsigned int next;
 
@@ -207,6 +225,9 @@ static unsigned int new_pgdir(struct lgu
 		lg->pgdirs[next].pgdir = (u32 *)get_zeroed_page(GFP_KERNEL);
 		if (!lg->pgdirs[next].pgdir)
 			next = lg->pgdidx;
+		else
+			/* There are no mappings: you'll need to re-pin */
+			*blank_pgdir = 1;
 	}
 	lg->pgdirs[next].cr3 = cr3;
 	/* Release all the non-kernel mappings. */
@@ -217,14 +238,15 @@ static unsigned int new_pgdir(struct lgu
 
 void guest_new_pagetable(struct lguest *lg, u32 pgtable)
 {
-	int newpgdir;
+	int newpgdir, repin = 0;
 
 	newpgdir = find_pgdir(lg, pgtable);
 	if (newpgdir == ARRAY_SIZE(lg->pgdirs))
-		newpgdir = new_pgdir(lg, pgtable);
+		newpgdir = new_pgdir(lg, pgtable, &repin);
 	lg->pgdidx = newpgdir;
 	lg->cr3 = __pa(lg->pgdirs[lg->pgdidx].pgdir);
-	pin_stack_pages(lg);
+	if (repin)
+		pin_stack_pages(lg);
 }
 
 static void release_all_pagetables(struct lguest *lg)


