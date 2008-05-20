Return-Path: <linux-kernel-owner+w=401wt.eu-S1765826AbYETNCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765826AbYETNCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 09:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYETNB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 09:01:56 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54258 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYETNBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 09:01:55 -0400
Date: Tue, 20 May 2008 13:59:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] x86: strengthen 64-bit p?d_bad()
In-Reply-To: <Pine.LNX.4.64.0805201346120.24102@blonde.site>
Message-ID: <Pine.LNX.4.64.0805201357360.24102@blonde.site>
References: <patchbomb.1211268376@localhost> <Pine.LNX.4.64.0805201346120.24102@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86_64 pgd_bad(), pud_bad(), pmd_bad() inlines have differed from
their x86_32 counterparts in a couple of ways: they've been unnecessarily
weak (e.g. letting 0 or 1 count as good), and were typed as unsigned long.
Strengthen them and return int.

The PAE pmd_bad was too weak before, allowing any junk in the upper half;
but got strengthened by the patch correcting its ~PAGE_MASK to ~PTE_MASK.
The PAE pud_bad already said ~PTE_MASK; and since it folds into pgd_bad,
and we don't set the protection bits at that level, it'll do as is.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
This could either go in along with Jeremy's PTE_MASK patches, or be
held back for next release - it's independent of them, and not vital.

 include/asm-x86/pgtable_64.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -151,19 +151,19 @@ static inline void native_pgd_clear(pgd_
 
 #ifndef __ASSEMBLY__
 
-static inline unsigned long pgd_bad(pgd_t pgd)
+static inline int pgd_bad(pgd_t pgd)
 {
-	return pgd_val(pgd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return (pgd_val(pgd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
-static inline unsigned long pud_bad(pud_t pud)
+static inline int pud_bad(pud_t pud)
 {
-	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return (pud_val(pud) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
-static inline unsigned long pmd_bad(pmd_t pmd)
+static inline int pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return (pmd_val(pmd) & ~(PTE_MASK | _PAGE_USER)) != _KERNPG_TABLE;
 }
 
 #define pte_none(x)	(!pte_val((x)))
