Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbYBEUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbYBEUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbYBEUnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:43:22 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:21269 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073AbYBEUnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jACgLReZtSlBTyy0eNLkV/m0gTnU2Z7qGAZ/xsUFWz59TFsCZ3PFndqnUCdJRoLt5ueEEuUyZLcPFU9Z+1Dna5oc76Lg5DPKIdTMrSUWHpkKgCVto9MOPkzliBDPObt2rV4m30e/8F5mYRujsRyNUX5JXUZH76t2ClKiwpQdJ1M=
Subject: [PATCH 6/8] x86: sparse warnings in pageattr.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 12:42:46 -0800
Message-Id: <1202244172.18081.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the definition of lookup_address to take an unsigned long
level argument.  Adjust callers in xen/mmu.c that pass in a
dummy variable.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/pageattr.c    |    8 +++++---
 arch/x86/xen/mmu.c        |    6 +++---
 include/asm-x86/pgtable.h |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb55a78..5d6c8cd 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -194,7 +194,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
  * or when the present bit is not set. Otherwise we would return a
  * pointer to a nonexisting mapping.
  */
-pte_t *lookup_address(unsigned long address, int *level)
+pte_t *lookup_address(unsigned long address, unsigned int *level)
 {
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
@@ -259,7 +259,8 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	unsigned long nextpage_addr, numpages, pmask, psize, flags;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot;
-	int level, do_split = 1;
+	int do_split = 1;
+	unsigned int level;
 
 	/*
 	 * An Athlon 64 X2 showed hard hangs if we tried to preserve
@@ -421,7 +422,8 @@ out_unlock:
 
 static int __change_page_attr(unsigned long address, struct cpa_data *cpa)
 {
-	int level, do_split, err;
+	int do_split, err;
+	unsigned int level;
 	struct page *kpte_page;
 	pte_t *kpte;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 45aa771..0144395 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -58,7 +58,7 @@
 
 xmaddr_t arbitrary_virt_to_machine(unsigned long address)
 {
-	int level;
+	unsigned int level;
 	pte_t *pte = lookup_address(address, &level);
 	unsigned offset = address & PAGE_MASK;
 
@@ -71,7 +71,7 @@ void make_lowmem_page_readonly(void *vaddr)
 {
 	pte_t *pte, ptev;
 	unsigned long address = (unsigned long)vaddr;
-	int level;
+	unsigned int level;
 
 	pte = lookup_address(address, &level);
 	BUG_ON(pte == NULL);
@@ -86,7 +86,7 @@ void make_lowmem_page_readwrite(void *vaddr)
 {
 	pte_t *pte, ptev;
 	unsigned long address = (unsigned long)vaddr;
-	int level;
+	unsigned int level;
 
 	pte = lookup_address(address, &level);
 	BUG_ON(pte == NULL);
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 44c0a4f..174b877 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -255,7 +255,7 @@ enum {
  * NOTE: the return type is pte_t but if the pmd is PSE then we return it
  * as a pte too.
  */
-extern pte_t *lookup_address(unsigned long address, int *level);
+extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-- 
1.5.4.rc5.1138.g2602


