Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0CITfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:35:09 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:55259 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0CITfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:35:02 -0500
Date: Tue, 9 Mar 2010 12:35:00 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] PPC32: Fixup pmd_page to work when ARCH_PFN_OFFSET is
	non-zero
Message-ID: <20100309193500.GE30462@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of referencing mem_map directly, use pfn_to_page. Otherwise
the kernel crashes when trying to start userspace if ARCH_PFN_OFFSET is
non-zero and CONFIG_BOOKE is not defined

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 arch/powerpc/include/asm/pgtable-ppc32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

For reference, on powerpc 32 with CONFIG_FLATMEM:

#define pfn_to_page __pfn_to_page
#define __pfn_to_page(pfn)      (mem_map + ((pfn) - ARCH_PFN_OFFSET))

So the below patch has no effect if ARCH_PFN_OFFEST is 0.

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 55646ad..a7db96f 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -287,7 +287,7 @@ static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
 #define pmd_page_vaddr(pmd)	\
 	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
 #define pmd_page(pmd)		\
-	(mem_map + (pmd_val(pmd) >> PAGE_SHIFT))
+	pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT)
 #else
 #define pmd_page_vaddr(pmd)	\
 	((unsigned long) (pmd_val(pmd) & PAGE_MASK))
-- 
1.5.4.2

