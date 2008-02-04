Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYBDDz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYBDDz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 22:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYBDDzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 22:55:46 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:39385 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYBDDzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 22:55:45 -0500
Date: Mon, 4 Feb 2008 09:25:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: 2.6.24-mm1 Build Faliure on pgtable_32.c
Message-ID: <20080204035543.GA8186@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203171634.58ab668b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.24-mm1 kernel build fails with 

arch/x86/mm/pgtable_32.c: In function `pgd_mop_up_pmds':
arch/x86/mm/pgtable_32.c:302: warning: passing arg 1 of `pmd_free' from incompatible pointer type
arch/x86/mm/pgtable_32.c:302: error: too few arguments to function `pmd_free'

I have tested the patch for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24/arch/x86/mm/pgtable_32.c	2008-02-04 07:36:36.000000000 +0000
+++ linux-2.6.24/arch/x86/mm/~pgtable_32.c	2008-02-04 07:38:02.000000000 +0000
@@ -286,7 +286,7 @@ static void pgd_dtor(void *pgd)
  * preallocate which never got a corresponding vma will need to be
  * freed manually.
  */
-static void pgd_mop_up_pmds(pgd_t *pgdp)
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 {
 	int i;
 
@@ -299,7 +299,7 @@ static void pgd_mop_up_pmds(pgd_t *pgdp)
 			pgdp[i] = native_make_pgd(0);
 
 			paravirt_release_pd(pgd_val(pgd) >> PAGE_SHIFT);
-			pmd_free(pmd);
+			pmd_free(mm, pmd);
 		}
 	}
 }
@@ -327,7 +327,7 @@ static int pgd_prepopulate_pmd(struct mm
 		pmd_t *pmd = pmd_alloc_one(mm, addr);
 
 		if (!pmd) {
-			pgd_mop_up_pmds(pgd);
+			pgd_mop_up_pmds(mm, pgd);
 			return 0;
 		}
 
@@ -347,7 +347,7 @@ static int pgd_prepopulate_pmd(struct mm
 	return 1;
 }
 
-static void pgd_mop_up_pmds(pgd_t *pgd)
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 {
 }
 #endif	/* CONFIG_X86_PAE */
@@ -368,7 +368,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pgd_mop_up_pmds(pgd);
+	pgd_mop_up_pmds(mm,pgd);
 	quicklist_free(0, pgd_dtor, pgd);
 }
 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
