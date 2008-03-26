Return-Path: <linux-kernel-owner+w=401wt.eu-S1762571AbYCZV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbYCZV3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYCZV3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:29:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60743 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbYCZV3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:29:31 -0400
Message-ID: <47EAC048.30006@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2008 16:29:44 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Adam Litke <agl@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] powerpc: define page support for 16G pages
References: <47EABE2D.7080400@linux.vnet.ibm.com>
In-Reply-To: <47EABE2D.7080400@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The huge page size is setup for 16G pages if that size is specified at boot-time.  The support for
multiple huge page sizes is not being utilized yet.  That will be in a future patch.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 hugetlbpage.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)


diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 44d3d55..b6a02b7 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -26,6 +26,7 @@
 
 #define HPAGE_SHIFT_64K	16
 #define HPAGE_SHIFT_16M	24
+#define HPAGE_SHIFT_16G	34
 
 #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
 #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
@@ -589,9 +590,11 @@ void set_huge_psize(int psize)
 {
 	/* Check that it is a page size supported by the hardware and
 	 * that it fits within pagetable limits. */
-	if (mmu_psize_defs[psize].shift && mmu_psize_defs[psize].shift < SID_SHIFT &&
+	if (mmu_psize_defs[psize].shift &&
+		mmu_psize_defs[psize].shift < SID_SHIFT_1T &&
 		(mmu_psize_defs[psize].shift > MIN_HUGEPTE_SHIFT ||
-			mmu_psize_defs[psize].shift == HPAGE_SHIFT_64K)) {
+		 mmu_psize_defs[psize].shift == HPAGE_SHIFT_64K ||
+		 mmu_psize_defs[psize].shift == HPAGE_SHIFT_16G)) {
 		HPAGE_SHIFT = mmu_psize_defs[psize].shift;
 		mmu_huge_psize = psize;
 #ifdef CONFIG_PPC_64K_PAGES
@@ -599,6 +602,8 @@ void set_huge_psize(int psize)
 #else
 		if (HPAGE_SHIFT == HPAGE_SHIFT_64K)
 			hugepte_shift = (PMD_SHIFT-HPAGE_SHIFT);
+		else if (HPAGE_SHIFT == HPAGE_SHIFT_16G)
+			hugepte_shift = (PGDIR_SHIFT-HPAGE_SHIFT);
 		else
 			hugepte_shift = (PUD_SHIFT-HPAGE_SHIFT);
 #endif
@@ -625,6 +630,9 @@ static int __init hugepage_setup_sz(char *str)
 	case HPAGE_SHIFT_16M:
 		mmu_psize = MMU_PAGE_16M;
 		break;
+	case HPAGE_SHIFT_16G:
+		mmu_psize = MMU_PAGE_16G;
+		break;
 	}
 
 	if (mmu_psize >=0 && mmu_psize_defs[mmu_psize].shift)



