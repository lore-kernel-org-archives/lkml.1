Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYBDD4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYBDD4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 22:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYBDD4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 22:56:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:33419 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbYBDD4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 22:56:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZhK7AJycyDWewy+ujfdVl66torJ3SFSKzpSUlsA92BZOxyHuyMoOUrjd00L/ZOpOT7D0HBrKMXH+MTDxcpz/iR+ffH3ClCfdqPnUIw+0Vd1K+Ai8CCDfZtRJ3X1SIiXbQZ1iP9z9PQZmN42IC3I2c6RQ4IDxi1Hs8YFO/u0NeF4=
Subject: [PATCH] x86: sparse warnings in pageattr.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 19:56:42 -0800
Message-Id: <1202097402.1844.64.camel@brick>
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
Ingo, sorry for missing this hunk in my previous signedness fixes for
lookup_address.

 arch/x86/mm/pageattr.c    |    8 +++++---
 arch/x86/xen/mmu.c        |    6 +++---
 include/asm-x86/pgtable.h |    2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d4401a0..7aa4cd3 100644
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
 
 	spin_lock_irqsave(&pgd_lock, flags);
 	/*
@@ -410,7 +411,8 @@ out_unlock:
 
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



