Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbZDIRaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbZDIRaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZDIRan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:30:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:35073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbZDIRan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:30:43 -0400
Subject: [PATCH -tip] x86: mm/init.c declare direct_gbpages and
 free_initrd_mem before they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 22:59:42 +0530
Message-Id: <1239298182.3296.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix sparse warnings:
  arch/x86/mm/init.c:19:5: warning: symbol 'direct_gbpages' was not declared. Should it be static?
  arch/x86/mm/init.c:390:6: warning: symbol 'free_initrd_mem' was not declared. Should it be static?

direct_gbpages is required for both 32 and 64 bit, so move direct_gbpages declaration from pgtable_64.h to pgtable.h

Also fixed extra ifndef __ASSEMBLY__ in pgtable_64.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/pgtable.h    |    2 ++
 arch/x86/include/asm/pgtable_64.h |    6 ------
 arch/x86/mm/init.c                |    1 +
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 205f6a9..577485b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -510,6 +510,8 @@ static inline int pte_hidden(pte_t pte)
 
 #ifndef __ASSEMBLY__
 
+extern int direct_gbpages;
+
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 6b87bc6..abde308 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -25,10 +25,6 @@ extern pgd_t init_level4_pgt[];
 
 extern void paging_init(void);
 
-#endif /* !__ASSEMBLY__ */
-
-#ifndef __ASSEMBLY__
-
 #define pte_ERROR(e)					\
 	printk("%s:%d: bad pte %p(%016lx).\n",		\
 	       __FILE__, __LINE__, &(e), pte_val(e))
@@ -135,8 +131,6 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
-extern int direct_gbpages;
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 51ae5ea..688c008 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1,3 +1,4 @@
+#include <linux/initrd.h>	/* free_initrd_mem */
 #include <linux/ioport.h>
 #include <linux/swap.h>
 
-- 
1.6.0.6



