Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbYEMRVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbYEMRVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYEMRVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:21:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46255 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYEMRVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:21:15 -0400
Message-ID: <4829CE0C.80800@us.ibm.com>
Date: Tue, 13 May 2008 12:21:16 -0500
From: Jon Tollefson <kniht@us.ibm.com>
Reply-To: kniht@linux.vnet.ibm.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Paul Mackerras <paulus@samba.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Adam Litke <agl@us.ibm.com>
Subject: [PATCH 2/6 v2] powerpc: function for allocating gigantic pages
References: <4829CAC3.30900@us.ibm.com>
In-Reply-To: <4829CAC3.30900@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 16G page locations have been saved during early boot in an array.
The alloc_bm_huge_page() function adds a page from here to the
huge_boot_pages list.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 arch/powerpc/mm/hugetlbpage.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 26f212f..383b3b2 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -29,6 +29,12 @@
 
 #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
 #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
+#define MAX_NUMBER_GPAGES	1024
+
+/* Tracks the 16G pages after the device tree is scanned and before the
+ *  huge_boot_pages list is ready.  */
+static unsigned long gpage_freearray[MAX_NUMBER_GPAGES];
+static unsigned nr_gpages;
 
 unsigned int hugepte_shift;
 #define PTRS_PER_HUGEPTE	(1 << hugepte_shift)
@@ -104,6 +110,22 @@ pmd_t *hpmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long addr)
 }
 #endif
 
+/* Moves the gigantic page addresses from the temporary list to the
+  * huge_boot_pages list.
+ */
+int alloc_bm_huge_page(struct hstate *h)
+{
+	struct huge_bm_page *m;
+	if (nr_gpages == 0)
+		return 0;
+	m = phys_to_virt(gpage_freearray[--nr_gpages]);
+	gpage_freearray[nr_gpages] = 0;
+	list_add(&m->list, &huge_boot_pages);
+	m->hstate = h;
+	return 1;
+}
+
+
 /* Modelled after find_linux_pte() */
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
 {




