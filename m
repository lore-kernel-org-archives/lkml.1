Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbYBAHZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbYBAHZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYBAHZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:25:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:13440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYBAHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:25:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iPLJOhCcQBwy1q9qRw03BNOzlgn78NcAVVjb03FfkRVqh4OschGQTD3TFYXYl974JhWbIgf5SvVhYVozqsFOkigzSoupcw4H2xzgB06KnZ/GHw2hEFc3wuQPqUEbsBzC0yWu5WN3WWyFmLuaV0ODpCVlTXMuKC2h9bISWpQV/R4=
Subject: [PATCH] x86: sparse warnings in pageattr.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 23:25:24 -0800
Message-Id: <1201850724.23523.95.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the definition of lookup_address to take an unsigned long
level argument.  Adjust callers in xen/mmu.c that pass in a
dummy variable.

arch/x86/mm/pageattr.c:99:38: warning: incorrect type in argument 2 (different signedness)
arch/x86/mm/pageattr.c:99:38:    expected int *level
arch/x86/mm/pageattr.c:99:38:    got unsigned int *<noident>
arch/x86/mm/pageattr.c:215:33: warning: incorrect type in argument 2 (different signedness)
arch/x86/mm/pageattr.c:215:33:    expected int *level
arch/x86/mm/pageattr.c:215:33:    got unsigned int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/pageattr.c    |    5 +++--
 arch/x86/xen/mmu.c        |    6 +++---
 include/asm-x86/pgtable.h |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e297bd6..d29cb9a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -142,7 +142,7 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
 	return prot;
 }
 
-pte_t *lookup_address(unsigned long address, int *level)
+pte_t *lookup_address(unsigned long address, unsigned int *level)
 {
 	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
@@ -254,7 +254,8 @@ __change_page_attr(unsigned long address, unsigned long pfn,
 		   pgprot_t mask_set, pgprot_t mask_clr)
 {
 	struct page *kpte_page;
-	int level, err = 0;
+	unsigned int level;
+	int err = 0;
 	pte_t *kpte;
 
 #ifdef CONFIG_X86_32
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
index cd2524f..de27abf 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -251,7 +251,7 @@ enum {
  * NOTE: the return type is pte_t but if the pmd is PSE then we return it
  * as a pte too.
  */
-extern pte_t *lookup_address(unsigned long address, int *level);
+extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-- 
1.5.4.rc4.1142.gf5a97



