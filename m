Return-Path: <linux-kernel-owner+w=401wt.eu-S1761034AbZCMRGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034AbZCMRGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759913AbZCMRB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:28 -0400
Received: from gw.goop.org ([64.81.55.164]:57425 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759814AbZCMRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 25/27] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP on VM_IO vmas
Date: Fri, 13 Mar 2009 10:00:10 -0700
Message-Id: <1236963612-14287-26-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Set _PAGE_IOMAP in ptes mapping a VM_IO vma.  This says that the mapping
is of a real piece of physical hardware, and not just system memory.

Xen, in particular, uses to this to inhibit the normal pfn->mfn conversion
that would normally happen - in other words, treat the address directly
as a machine physical address without converting it from pseudo-physical.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: David Airlie <airlied@linux.ie>
---
 arch/x86/include/asm/pgtable.h |    3 +++
 arch/x86/mm/pgtable.c          |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d37e55e..d7cbfaa 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -391,6 +391,9 @@ static inline unsigned long pages_to_mb(unsigned long npg)
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
+#define arch_vm_get_page_prot arch_vm_get_page_prot
+extern pgprot_t arch_vm_get_page_prot(unsigned vm_flags);
+
 #if PAGETABLE_LEVELS > 2
 static inline int pud_none(pud_t pud)
 {
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 7a4d6ee..d9da313 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -6,6 +6,16 @@
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
+pgprot_t arch_vm_get_page_prot(unsigned vm_flags)
+{
+	pgprot_t ret = __pgprot(0);
+
+	if (vm_flags & VM_IO)
+		ret = __pgprot(_PAGE_IOMAP);
+
+	return ret;
+}
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(PGALLOC_GFP);
-- 
1.6.0.6

