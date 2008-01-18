Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYARAgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYARAgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbYARAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:35:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650AbYARAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:44 -0200
Message-Id: <12006165571406-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1200616550283-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spte_addrdoes not depend on any guest information, so we
wipeout the lg parameter completely.

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/page_tables.c |    8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)

diff--git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
indexfb66561..c4b8eaf 100644
---a/drivers/lguest/page_tables.c
+++b/drivers/lguest/page_tables.c
@@-84,7 +84,7 @@ static pgd_t *spgd_addr(struct lguest *lg, u32 i, unsigned long vaddr)
/* This routine then takes the page directory entry returned above, which
 * contains the address of the page table entry (PTE) page.  It then returns a
 * pointer to the PTE entry for the given address. */
-staticpte_t *spte_addr(struct lguest *lg, pgd_t spgd, unsigned long vaddr)
+staticpte_t *spte_addr(pgd_t spgd, unsigned long vaddr)
{
	pte_t *page = __va(pgd_pfn(spgd) << PAGE_SHIFT);
	/* You should never call this if the PGD entry wasn't valid */
@@-261,7 +261,7 @@ int demand_page(struct lg_cpu *cpu, unsigned long vaddr, int errcode)
		gpte = pte_mkdirty(gpte);

	/* Get the pointer to the shadow PTE entry we're going to set. */
-	spte= spte_addr(lg, *spgd, vaddr);
+	spte= spte_addr(*spgd, vaddr);
	/* If there was a valid shadow PTE entry here before, we release it.
	 * This can happen with a write to a previously read-only entry. */
	release_pte(*spte);
@@-310,7 +310,7 @@ static int page_writable(struct lg_cpu *cpu, unsigned long vaddr)

	/* Check the flags on the pte entry itself: it must be present and
	 * writable. */
-	flags= pte_flags(*(spte_addr(cpu->lg, *spgd, vaddr)));
+	flags= pte_flags(*(spte_addr(*spgd, vaddr)));

	return (flags & (_PAGE_PRESENT|_PAGE_RW)) == (_PAGE_PRESENT|_PAGE_RW);
}
@@-509,7 +509,7 @@ static void do_set_pte(struct lguest *lg, int idx,
	/* If the top level isn't present, there's no entry to update. */
	if (pgd_flags(*spgd) & _PAGE_PRESENT) {
		/* Otherwise, we start by releasing the existing entry. */
-		pte_t*spte = spte_addr(lg, *spgd, vaddr);
+		pte_t*spte = spte_addr(*spgd, vaddr);
		release_pte(*spte);

		/* If they're setting this entry as dirty or accessed, we might
--
1.5.0.6

