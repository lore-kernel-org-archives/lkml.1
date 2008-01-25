Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbYAYV4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbYAYV4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760928AbYAYVwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:31 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37926 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758853AbYAYVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:29 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
X-Mercurial-Node: c084def0f6afb2b2ef47fd297dd6c833f7c88d36
Message-Id: <c084def0f6afb2b2ef47.1201296200@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PAE mode requires that we reload cr3 in order to guarantee that
changes to the pgd will be noticed by the processor.  This means that
in principle pud_clear needs to reload cr3 every time.  However,
because reloading cr3 implies a tlb flush, we want to avoid it where
possible.

pud_clear() is only used in a couple of places:
 - in free_pmd_range(), when pulling down a range of process address space, and
 - huge_pmd_unshare()

In both cases, the calling code will do a a tlb flush anyway, so
there's no need to do it within pud_clear().

In free_pmd_range(), the pud_clear is immediately followed by
pmd_free_tlb(); we can hook that to make the mmu_gather do an
unconditional full flush to make sure cr3 gets reloaded.

In huge_pmd_unshare, it is followed by flush_tlb_range, which always
results in a full cr3-reload tlb flush.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: William Irwin <wli@holomorphy.com>
---
 include/asm-x86/pgalloc_32.h     |    7 +++++++
 include/asm-x86/pgtable-3level.h |   21 +++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/pgalloc_32.h b/include/asm-x86/pgalloc_32.h
--- a/include/asm-x86/pgalloc_32.h
+++ b/include/asm-x86/pgalloc_32.h
@@ -74,6 +74,13 @@ static inline void pmd_free(pmd_t *pmd)
 
 static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
+	/* This is called just after the pmd has been detached from
+	   the pgd, which requires a full tlb flush to be recognized
+	   by the CPU.  Rather than incurring multiple tlb flushes
+	   while the address space is being pulled down, make the tlb
+	   gathering machinery do a full flush when we're done. */
+	tlb->fullmm = 1;
+
 	paravirt_release_pd(__pa(pmd) >> PAGE_SHIFT);
 	tlb_remove_page(tlb, virt_to_page(pmd));
 }
diff --git a/include/asm-x86/pgtable-3level.h b/include/asm-x86/pgtable-3level.h
--- a/include/asm-x86/pgtable-3level.h
+++ b/include/asm-x86/pgtable-3level.h
@@ -96,14 +96,23 @@ static inline void pud_clear(pud_t *pudp
 	set_pud(pudp, __pud(0));
 
 	/*
-	 * Pentium-II erratum A13: in PAE mode we explicitly have to flush
-	 * the TLB via cr3 if the top-level pgd is changed...
+	 * In principle we need to do a cr3 reload here to make sure
+	 * the processor recognizes the changed pgd.  In practice, all
+	 * the places where pud_clear() gets called are followed by
+	 * full tlb flushes anyway, so we can defer the cost here.
 	 *
-	 * XXX I don't think we need to worry about this here, since
-	 * when clearing the pud, the calling code needs to flush the
-	 * tlb anyway.  But do it now for safety's sake. - jsgf
+	 * Specifically:
+	 *
+	 * mm/memory.c:free_pmd_range() - immediately after the
+	 * pud_clear() it does a pmd_free_tlb().  We change the
+	 * mmu_gather structure to do a full tlb flush (which has the
+	 * effect of reloading cr3) when the pagetable free is
+	 * complete.
+	 *
+	 * arch/x86/mm/hugetlbpage.c:huge_pmd_unshare() - the call to
+	 * this is followed by a flush_tlb_range, which on x86 does a
+	 * full tlb flush.
 	 */
-	write_cr3(read_cr3());
 }
 
 #define pud_page(pud) \


