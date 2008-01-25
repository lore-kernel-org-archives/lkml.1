Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYAYVyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYAYVyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYAYVw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:26 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37921 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757518AbYAYVwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:23 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 10 of 11] x86: allocate and initialize unshared pmds
X-Mercurial-Node: dca57ec03705ca9b92591274314754bfccb8bba5
Message-Id: <dca57ec03705ca9b9259.1201296199@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SHARED_KERNEL_PMD is false, then we need to allocate and initialize
the kernel pmd.  We can easily piggy-back this onto the existing pmd
prepopulation code.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pgtable_32.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -269,7 +269,7 @@ static void pgd_mop_up_pmds(pgd_t *pgdp)
 {
 	int i;
 
-	for(i = 0; i < USER_PTRS_PER_PGD; i++) {
+	for(i = 0; i < UNSHARED_PTRS_PER_PGD; i++) {
 		pgd_t pgd = pgdp[i];
 
 		if (pgd_val(pgd) != 0) {
@@ -289,6 +289,10 @@ static void pgd_mop_up_pmds(pgd_t *pgdp)
  * processor notices the update.  Since this is expensive, and
  * all 4 top-level entries are used almost immediately in a
  * new process's life, we just pre-populate them here.
+ *
+ * Also, if we're in a paravirt environment where the kernel pmd is
+ * not shared between pagetables (!SHARED_KERNEL_PMDS), we allocate
+ * and initialize the kernel pmds here.
  */
 static int pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd)
 {
@@ -297,13 +301,18 @@ static int pgd_prepopulate_pmd(struct mm
 	int i;
 
 	pud = pud_offset(pgd, 0);
- 	for (addr = i = 0; i < USER_PTRS_PER_PGD; i++, pud++, addr += PUD_SIZE) {
+ 	for (addr = i = 0; i < UNSHARED_PTRS_PER_PGD;
+	     i++, pud++, addr += PUD_SIZE) {
 		pmd_t *pmd = pmd_alloc_one(mm, addr);
 
 		if (!pmd) {
 			pgd_mop_up_pmds(pgd);
 			return 0;
 		}
+
+		if (i >= USER_PTRS_PER_PGD)
+			memcpy(pmd, (pmd_t *)pgd_page_vaddr(swapper_pg_dir[i]),
+			       sizeof(pmd_t) * PTRS_PER_PMD);
 
 		pud_populate(mm, pud, pmd);
 	}
@@ -346,4 +355,3 @@ void check_pgt_cache(void)
 {
 	quicklist_trim(0, pgd_dtor, 25, 16);
 }
-


