Return-Path: <linux-kernel-owner+w=401wt.eu-S932072AbYCZV0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbYCZV0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbYCZV0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:26:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32995 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763226AbYCZV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:26:04 -0400
Message-ID: <47EABF75.9090605@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2008 16:26:13 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Adam Litke <agl@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] powerpc: function for allocating gigantic pages
References: <47EABE2D.7080400@linux.vnet.ibm.com>
In-Reply-To: <47EABE2D.7080400@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 16G page locations have been saved during early boot in an array.  The
alloc_bm_huge_page() function adds a page from here to the huge_boot_pages list.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---


 hugetlbpage.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 94625db..31d977b 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -29,6 +29,10 @@
 
 #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
 #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
+#define MAX_NUMBER_GPAGES	1024
+
+static void *gpage_freearray[MAX_NUMBER_GPAGES];
+static unsigned nr_gpages;
 
 unsigned int hugepte_shift;
 #define PTRS_PER_HUGEPTE	(1 << hugepte_shift)
@@ -104,6 +108,21 @@ pmd_t *hpmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long addr)
 }
 #endif
 
+/* Put 16G page address into temporary huge page list because the mem_map
+ * is not up yet.
+ */
+int alloc_bm_huge_page(struct hstate *h)
+{
+	struct huge_bm_page *m;
+	if (nr_gpages == 0)
+		return 0;
+	m = gpage_freearray[--nr_gpages];
+	list_add(&m->list, &huge_boot_pages);
+	m->hstate = h;
+	return 1;
+}
+
+
 /* Modelled after find_linux_pte() */
 pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
 {



