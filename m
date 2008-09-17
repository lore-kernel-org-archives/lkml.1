Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYIQPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYIQPru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYIQPrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:47:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37077 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYIQPrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:47:41 -0400
Message-Id: <48D142E1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Wed, 17 Sep 2008 16:48:17 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make mm/gup.c more virtualization friendly
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pte_flags() is much cheaper than pte_val() in some virtualized
environments (namely, Xen), use the former whereever possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 arch/x86/mm/gup.c         |   10 +++++-----
 include/asm-x86/pgtable.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.27-rc6/arch/x86/mm/gup.c	2008-08-21 14:37:29.000000000 +0200
+++ 2.6.27-rc6-x86-gup-virt/arch/x86/mm/gup.c	2008-09-02 13:33:42.000000000 +0200
@@ -82,7 +82,7 @@ static noinline int gup_pte_range(pmd_t 
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
-		if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask) {
+		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
 		}
@@ -116,10 +116,10 @@ static noinline int gup_huge_pmd(pmd_t p
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
@@ -173,10 +173,10 @@ static noinline int gup_huge_pud(pud_t p
 	mask = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		mask |= _PAGE_RW;
-	if ((pte_val(pte) & mask) != mask)
+	if ((pte_flags(pte) & mask) != mask)
 		return 0;
 	/* hugepages are never "special" */
-	VM_BUG_ON(pte_val(pte) & _PAGE_SPECIAL);
+	VM_BUG_ON(pte_flags(pte) & _PAGE_SPECIAL);
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 
 	refs = 0;
--- linux-2.6.27-rc6/include/asm-x86/pgtable.h	2008-08-21 14:37:34.000000000 +0200
+++ 2.6.27-rc6-x86-gup-virt/include/asm-x86/pgtable.h	2008-09-02 13:31:50.000000000 +0200
@@ -183,7 +183,7 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return pte_val(pte) & _PAGE_SPECIAL;
+	return pte_flags(pte) & _PAGE_SPECIAL;
 }
 
 static inline int pmd_large(pmd_t pte)



