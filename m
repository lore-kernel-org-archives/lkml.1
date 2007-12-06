Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbXLFRIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbXLFRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXLFRHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:07:05 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:32910 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXLFRHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:07:03 -0500
Date: Thu, 6 Dec 2007 12:06:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/6] UML - 64-bit tlb fixes
Message-ID: <20071206170643.GA7445@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some 64-bit tlb fixes -
	moved pmd_page_vaddr to pgtable.h since it's the same for both
2-level and 3-level page tables
	fixed a bogus cast on pud_page_vaddr
	made the address checking in update_*_range more careful

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/tlb.c            |    8 ++++----
 include/asm-um/pgtable-2level.h |    3 ---
 include/asm-um/pgtable-3level.h |    3 +--
 include/asm-um/pgtable.h        |    3 +++
 4 files changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6-git/arch/um/kernel/tlb.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/tlb.c	2007-12-06 10:34:41.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/tlb.c	2007-12-06 11:26:20.000000000 -0500
@@ -207,7 +207,7 @@ static inline int update_pte_range(pmd_t
 		} else if (pte_newprot(*pte))
 			ret = add_mprotect(addr, PAGE_SIZE, prot, hvc);
 		*pte = pte_mkuptodate(*pte);
-	} while (pte++, addr += PAGE_SIZE, ((addr != end) && !ret));
+	} while (pte++, addr += PAGE_SIZE, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -229,7 +229,7 @@ static inline int update_pmd_range(pud_t
 			}
 		}
 		else ret = update_pte_range(pmd, addr, next, hvc);
-	} while (pmd++, addr = next, ((addr != end) && !ret));
+	} while (pmd++, addr = next, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -251,7 +251,7 @@ static inline int update_pud_range(pgd_t
 			}
 		}
 		else ret = update_pmd_range(pud, addr, next, hvc);
-	} while (pud++, addr = next, ((addr != end) && !ret));
+	} while (pud++, addr = next, ((addr < end) && !ret));
 	return ret;
 }
 
@@ -274,7 +274,7 @@ void fix_range_common(struct mm_struct *
 			}
 		}
 		else ret = update_pud_range(pgd, addr, next, &hvc);
-	} while (pgd++, addr = next, ((addr != end_addr) && !ret));
+	} while (pgd++, addr = next, ((addr < end_addr) && !ret));
 
 	if (!ret)
 		ret = do_ops(&hvc, hvc.index, 1);
Index: linux-2.6-git/include/asm-um/pgtable-2level.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/pgtable-2level.h	2007-12-03 23:57:24.000000000 -0500
+++ linux-2.6-git/include/asm-um/pgtable-2level.h	2007-12-06 11:26:20.000000000 -0500
@@ -41,9 +41,6 @@ static inline void pgd_mkuptodate(pgd_t 
 #define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
-#define pmd_page_vaddr(pmd) \
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
 /*
  * Bits 0 through 4 are taken
  */
Index: linux-2.6-git/include/asm-um/pgtable-3level.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/pgtable-3level.h	2007-12-06 10:32:12.000000000 -0500
+++ linux-2.6-git/include/asm-um/pgtable-3level.h	2007-12-06 11:26:20.000000000 -0500
@@ -87,8 +87,7 @@ static inline void pud_clear (pud_t *pud
 }
 
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
-#define pud_page_vaddr(pud) \
-	((struct page *) __va(pud_val(pud) & PAGE_MASK))
+#define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PAGE_MASK))
 
 /* Find an entry in the second-level page table.. */
 #define pmd_offset(pud, address) ((pmd_t *) pud_page_vaddr(*(pud)) + \
Index: linux-2.6-git/include/asm-um/pgtable.h
===================================================================
--- linux-2.6-git.orig/include/asm-um/pgtable.h	2007-12-06 10:32:12.000000000 -0500
+++ linux-2.6-git/include/asm-um/pgtable.h	2007-12-06 11:26:20.000000000 -0500
@@ -307,6 +307,9 @@ static inline pte_t pte_modify(pte_t pte
  */
 #define pmd_index(address) (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
 
+#define pmd_page_vaddr(pmd) \
+	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
 /*
  * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
  *
