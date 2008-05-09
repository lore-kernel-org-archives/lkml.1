Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYEILKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYEILKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYEILJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:34 -0400
Received: from gw.goop.org ([64.81.55.164]:47560 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYEILJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 8] x86: define PTE_MASK in a universally useful way
X-Mercurial-Node: 0c9cbd37a02fd55046c94537cbb364cf5fcad873
Message-Id: <0c9cbd37a02fd55046c9.1210330959@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:39 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define PTE_MASK so that it contains a meaningful value for all x86
pagetable configurations.  Previously it was defined as a "long" which
means that it was too short to cover a 32-bit PAE pte entry.

It is now defined as a pteval_t, which is an integer type long enough
to contain a full pte (or pmd, pud, pgd).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/page.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -10,8 +10,13 @@
 
 #ifdef __KERNEL__
 
-#define PHYSICAL_PAGE_MASK	(PAGE_MASK & __PHYSICAL_MASK)
-#define PTE_MASK		(_AT(long, PHYSICAL_PAGE_MASK))
+/* Cast PAGE_MASK to a signed type so that it is sign-extended if
+   virtual addresses are 32-bits but physical addresses are larger
+   (ie, 32-bit PAE). */
+#define PHYSICAL_PAGE_MASK	(((signed long)PAGE_MASK) & __PHYSICAL_MASK)
+
+/* PTE_MASK extracts the PFN from a (pte|pmd|pud|pgd)val_t */
+#define PTE_MASK		((pteval_t)PHYSICAL_PAGE_MASK)
 
 #define PMD_PAGE_SIZE		(_AC(1, UL) << PMD_SHIFT)
 #define PMD_PAGE_MASK		(~(PMD_PAGE_SIZE-1))
@@ -24,8 +29,8 @@
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
-#define __PHYSICAL_MASK		_AT(phys_addr_t, (_AC(1,ULL) << __PHYSICAL_MASK_SHIFT) - 1)
-#define __VIRTUAL_MASK		((_AC(1,UL) << __VIRTUAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((((phys_addr_t)1) << __PHYSICAL_MASK_SHIFT) - 1)
+#define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>


