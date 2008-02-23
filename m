Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYBWGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYBWGP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 01:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYBWGPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 01:15:50 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:55462 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYBWGPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 01:15:49 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/4] alpha: IOMMU had better access to the free space bitmap at only one place
Date: Sat, 23 Feb 2008 15:13:13 +0900
Message-Id: <1203747195-7952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1203747195-7952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1203747195-7952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1203747195-7952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_arena_find_pages duplicates the code to access to the bitmap for
free space management. This patch convert the IOMMU code to have only
one place to access the bitmap, in the popular way that other IOMMUs
(e.g. POWER and SPARC) do.

This patch is preparation for modifications to fix the IOMMU segment
boundary problem.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/kernel/pci_iommu.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index bbf9990..e54f829 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -132,12 +132,15 @@ iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
 {
 	unsigned long *ptes;
 	long i, p, nent;
+	int pass = 0;
 
 	/* Search forward for the first mask-aligned sequence of N free ptes */
 	ptes = arena->ptes;
 	nent = arena->size >> PAGE_SHIFT;
 	p = ALIGN(arena->next_entry, mask + 1);
 	i = 0;
+
+again:
 	while (i < n && p+i < nent) {
 		if (ptes[p+i])
 			p = ALIGN(p + i + 1, mask + 1), i = 0;
@@ -146,19 +149,18 @@ iommu_arena_find_pages(struct pci_iommu_arena *arena, long n, long mask)
 	}
 
 	if (i < n) {
-                /* Reached the end.  Flush the TLB and restart the
-                   search from the beginning.  */
-		alpha_mv.mv_pci_tbi(arena->hose, 0, -1);
-
-		p = 0, i = 0;
-		while (i < n && p+i < nent) {
-			if (ptes[p+i])
-				p = ALIGN(p + i + 1, mask + 1), i = 0;
-			else
-				i = i + 1;
-		}
-
-		if (i < n)
+		if (pass < 1) {
+			/*
+			 * Reached the end.  Flush the TLB and restart
+			 * the search from the beginning.
+			*/
+			alpha_mv.mv_pci_tbi(arena->hose, 0, -1);
+
+			pass++;
+			p = 0;
+			i = 0;
+			goto again;
+		} else
 			return -1;
 	}
 
-- 
1.5.3.4

