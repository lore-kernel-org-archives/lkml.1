Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbZG3MFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbZG3MFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZG3MFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:05:40 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38049 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZG3MFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:05:39 -0400
Date: Thu, 30 Jul 2009 17:35:33 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: rusty@rustcorp.com.au
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lguest@ozlabs.org, sfr@canb.auug.org.au
Subject: [PATCH] next-20090730 lguest build breaks with pfn_pmd()
Message-ID: <20090730120533.GB4955@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090729173611.b82478cd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090729173611.b82478cd.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

	next-20090729 allmodconfig build breaks at

drivers/lguest/page_tables.c: In function 'setup_pagetables':
drivers/lguest/page_tables.c:987: error: incompatible type for argument 2 of 'pfn_pmd'
drivers/lguest/page_tables.c:994: error: expected ';' before ')' token
drivers/lguest/page_tables.c:994: error: expected statement before ')' token
make[2]: *** [drivers/lguest/page_tables.o] Error 1

build failure is introduced by commit e07dd6220a4bf81a2549e7e37523a2557547d9d7
I have tested the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 drivers/lguest/page_tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 8c86446..c610b82 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -984,14 +984,14 @@ static unsigned long setup_pagetables(struct lguest *lg,
 	for (i = j = 0; i < mapped_pages && j < PTRS_PER_PMD;
 	     i += PTRS_PER_PTE, j++) {
 		pmd = pfn_pmd(((unsigned long)&linear[i] - mem_base)/PAGE_SIZE,
-			      _PAGE_PRESENT | _PAGE_RW | _PAGE_USER);
+			      __pgrot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER));
 
 		if (copy_to_user(&pmds[j], &pmd, sizeof(pmd)) != 0)
 			return -EFAULT;
 	}
 
 	/* One PGD entry, pointing to that PMD page. */
-	pgd = __pgd(((unsigned long)pmds - mem_base) | _PAGE_PRESENT));
+	pgd = __pgd(((unsigned long)pmds - mem_base) | _PAGE_PRESENT);
 	/* Copy it in as the first PGD entry (ie. addresses 0-1G). */
 	if (copy_to_user(&pgdir[0], &pgd, sizeof(pgd)) != 0)
 		return -EFAULT;

			
					Kamalesh
