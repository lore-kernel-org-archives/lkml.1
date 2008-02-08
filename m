Return-Path: <linux-kernel-owner+w=401wt.eu-S934413AbYBHKIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413AbYBHKIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbYBHKH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:07:57 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59767 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbYBHKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:07:56 -0500
Message-ID: <47AC29AC.6050502@bull.net>
Date: Fri, 08 Feb 2008 11:06:36 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.24-mm1] fix build error in arch/x86/mm/pgtable_32.c
Content-Type: multipart/mixed;
 boundary="------------090804050203090803060008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090804050203090803060008
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

2.6.24-mm1 won't build if CONFIG_X86_PAE is defined:


/home/lkernel/src/linux-2.6.24-mm1/arch/x86/mm/pgtable_32.c: In function 
‘pgd_mop_up_pmds’:
/home/lkernel/src/linux-2.6.24-mm1/arch/x86/mm/pgtable_32.c:302: 
warning: passing argument 1 of ‘pmd_free’ from incompatible pointer type
/home/lkernel/src/linux-2.6.24-mm1/arch/x86/mm/pgtable_32.c:302: error: 
too few arguments to function ‘pmd_free’
make[2]: *** [arch/x86/mm/pgtable_32.o] Error 1
make[1]: *** [arch/x86/mm] Error 2
make: *** [sub-make] Error 2


You'll find the proposed patch in attachment.

Regards,
Nadia

--------------090804050203090803060008
Content-Type: text/x-patch;
 name="x86_pmd_free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_pmd_free.patch"

Add the mm missing argument to pmd_free() calls.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 arch/x86/mm/pgtable_32.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.24-mm1/arch/x86/mm/pgtable_32.c
===================================================================
--- linux-2.6.24-mm1.orig/arch/x86/mm/pgtable_32.c	2008-02-07 13:40:42.000000000 +0100
+++ linux-2.6.24-mm1/arch/x86/mm/pgtable_32.c	2008-02-08 11:40:00.000000000 +0100
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
+static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgd)
 {
 }
 #endif	/* CONFIG_X86_PAE */
@@ -368,7 +368,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	pgd_mop_up_pmds(pgd);
+	pgd_mop_up_pmds(mm, pgd);
 	quicklist_free(0, pgd_dtor, pgd);
 }
 

--------------090804050203090803060008--
