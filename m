Return-Path: <linux-kernel-owner+w=401wt.eu-S1946506AbXBIQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946506AbXBIQmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946659AbXBIQjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:48 -0500
Received: from styx.suse.cz ([82.119.242.94]:60793 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946657AbXBIQj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:27 -0500
Date: Fri, 9 Feb 2007 17:39:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <starvik@axis.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS: TLB handling - turn local_save_flags() + local_irq_disable()
 into local_irq_save()
Message-ID: <Pine.LNX.4.64.0702091735560.22290@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

some time ago I sent you a bunch of patches that fixed local_irq_save(), 
local_save_flags() and local_irq_disable() all over the tree. You merged 
most of them, but seems to me that two of them went unattended (can't see 
it in your patchset), so I resend.

CRIS: TLB handling - turn local_save_flags() + local_irq_disable() into local_irq_save()

TLB handling for CRIS contains local_irq_disable() after local_save_flags().
Turn this into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 arch/cris/arch-v10/mm/tlb.c |    9 +++------
 arch/cris/arch-v32/mm/tlb.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/cris/arch-v10/mm/tlb.c b/arch/cris/arch-v10/mm/tlb.c
index 70a5523..7d9fec8 100644
--- a/arch/cris/arch-v10/mm/tlb.c
+++ b/arch/cris/arch-v10/mm/tlb.c
@@ -42,8 +42,7 @@ flush_tlb_all(void)
 	 * in the same 4-way entry group. details.. 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		*R_TLB_SELECT = ( IO_FIELD(R_TLB_SELECT, index, i) );
 		*R_TLB_HI = ( IO_FIELD(R_TLB_HI, page_id, INVALID_PAGEID ) |
@@ -78,8 +77,7 @@ flush_tlb_mm(struct mm_struct *mm)
 	 * global pages. is it worth the extra I/O ? 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		*R_TLB_SELECT = IO_FIELD(R_TLB_SELECT, index, i);
 		if (IO_EXTRACT(R_TLB_HI, page_id, *R_TLB_HI) == page_id) {
@@ -118,8 +116,7 @@ flush_tlb_page(struct vm_area_struct *vma,
 	 * and the virtual address requested 
 	 */
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	for(i = 0; i < NUM_TLB_ENTRIES; i++) {
 		unsigned long tlb_hi;
 		*R_TLB_SELECT = IO_FIELD(R_TLB_SELECT, index, i);
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index 9d75d76..c2d12e9 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -54,8 +54,7 @@ __flush_tlb_all(void)
 	 * Mask with 0xf so similar TLB entries aren't written in the same 4-way
 	 * entry group.
 	 */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu); /* Select the MMU */
@@ -92,8 +91,7 @@ __flush_tlb_mm(struct mm_struct *mm)
 		return;
 
 	/* Mark the TLB entries that match the page_id as invalid. */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu);
@@ -140,8 +138,7 @@ __flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	 * Invalidate those TLB entries that match both the mm context and the
 	 * requested virtual address.
 	 */
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 
 	for (mmu = 1; mmu <= 2; mmu++) {
 		SUPP_BANK_SEL(mmu);

