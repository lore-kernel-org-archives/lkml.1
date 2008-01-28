Return-Path: <linux-kernel-owner+w=401wt.eu-S1764714AbYA2AeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764714AbYA2AeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYA2AdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:33:22 -0500
Received: from zrnetservice.com ([209.133.52.163]:50315 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757348AbYA2AdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:33:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 4] x86: revert "defer cr3 reload when doing pud_clear()"
X-Mercurial-Node: d7a81a4e06370bcc1118cda27e0dcb7536b264d7
Message-Id: <d7a81a4e06370bcc1118.1201564122@localhost>
In-Reply-To: <patchbomb.1201564120@localhost>
Date: Mon, 28 Jan 2008 15:48:42 -0800
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
 include/asm-x86/pgalloc_32.h     |    7 -------
 include/asm-x86/pgtable-3level.h |   21 ++++++---------------
 2 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -74,13 +74,6 @@ static inline void pmd_free(pmd_t *pmd)
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
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
@@ -96,23 +96,14 @@ static inline void pud_clear(pud_t *pudp
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


