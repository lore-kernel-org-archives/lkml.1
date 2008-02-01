Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYBAQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYBAQla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYBAQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:40:08 -0500
Received: from gw.goop.org ([64.81.55.164]:59583 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbYBAQkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:40:02 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] x86: revert "defer cr3 reload when doing pud_clear()"
X-Mercurial-Node: 2e879b9dff47da4ff58ef277580f15e503724847
Message-Id: <2e879b9dff47da4ff58e.1201883962@localhost>
In-Reply-To: <patchbomb.1201883960@localhost>
Date: Fri, 01 Feb 2008 08:39:22 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert "defer cr3 reload when doing pud_clear()" since I'm going to
replace it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable_32.c         |    7 -------
 include/asm-x86/pgtable-3level.h |   21 ++++++---------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -373,13 +373,6 @@
 
 void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
-	/* This is called just after the pmd has been detached from
-	   the pgd, which requires a full tlb flush to be recognized
-	   by the CPU.  Rather than incurring multiple tlb flushes
-	   while the address space is being pulled down, make the tlb
-	   gathering machinery do a full flush when we're done. */
-	tlb->fullmm = 1;
-
 	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -96,23 +96,14 @@
 	set_pud(pudp, __pud(0));
 
 	/*
-	 * In principle we need to do a cr3 reload here to make sure
-	 * the processor recognizes the changed pgd.  In practice, all
-	 * the places where pud_clear() gets called are followed by
-	 * full tlb flushes anyway, so we can defer the cost here.
+	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
+	 * the TLB via cr3 if the top-level pgd is changed...
 	 *
-	 * Specifically:
-	 *
-	 * mm/memory.c:free_pmd_range() - immediately after the
-	 * pud_clear() it does a pmd_free_tlb().  We change the
-	 * mmu_gather structure to do a full tlb flush (which has the
-	 * effect of reloading cr3) when the pagetable free is
-	 * complete.
-	 *
-	 * arch/x86/mm/hugetlbpage.c:huge_pmd_unshare() - the call to
-	 * this is followed by a flush_tlb_range, which on x86 does a
-	 * full tlb flush.
+	 * XXX I don't think we need to worry about this here, since
+	 * when clearing the pud, the calling code needs to flush the
+	 * tlb anyway.  But do it now for safety's sake. - jsgf
 	 */
+	write_cr3(read_cr3());
 }
 
 #define pud_page(pud) \


