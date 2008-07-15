Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYGOWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYGOWtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYGOWtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:49:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56313 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbYGOWtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:49:14 -0400
Message-ID: <487D2982.90109@linux.vnet.ibm.com>
Date: Tue, 15 Jul 2008 17:49:38 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: npiggin@suse.de, adobriyan@gmail.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org
Subject: [patch v2] powerpc: hugetlb pgtable cache access cleanup
References: <20080604112939.789444496@amd.local0.net> <20080604113113.648031825@amd.local0.net> <487B7F96.70305@linux.vnet.ibm.com> <20080714155659.b4fab697.akpm@linux-foundation.org>
In-Reply-To: <20080714155659.b4fab697.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 Jul 2008 11:32:22 -0500
> Jon Tollefson <kniht@linux.vnet.ibm.com> wrote:
>
>   
>> Cleaned up use of macro.  We now reference the pgtable_cache array directly instead of using a macro.
>>     
>
> This clashes rather a lot with all the other hugetlb things which we
> have queued.
>
>   
oops.  new version below here should be based on mmotm.
---


Cleaned up use of macro.  We now reference the pgtable_cache array directly instead of using a macro.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 arch/powerpc/mm/hugetlbpage.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)


--- a/arch/powerpc/mm/hugetlbpage.c	2008-07-15 17:17:42.741035616 -0500
+++ b/arch/powerpc/mm/hugetlbpage.c	2008-07-15 17:36:48.959015872 -0500
@@ -53,8 +53,7 @@
 
 /* Subtract one from array size because we don't need a cache for 4K since
  * is not a huge page size */
-#define huge_pgtable_cache(psize)	(pgtable_cache[HUGEPTE_CACHE_NUM \
-							+ psize-1])
+#define HUGE_PGTABLE_INDEX(psize)	(HUGEPTE_CACHE_NUM + psize - 1)
 #define HUGEPTE_CACHE_NAME(psize)	(huge_pgtable_cache_name[psize])
 
 static const char *huge_pgtable_cache_name[MMU_PAGE_COUNT] = {
@@ -113,7 +112,7 @@
 static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
 			   unsigned long address, unsigned int psize)
 {
-	pte_t *new = kmem_cache_zalloc(huge_pgtable_cache(psize),
+	pte_t *new = kmem_cache_zalloc(pgtable_cache[HUGE_PGTABLE_INDEX(psize)],
 				      GFP_KERNEL|__GFP_REPEAT);
 
 	if (! new)
@@ -121,7 +120,7 @@
 
 	spin_lock(&mm->page_table_lock);
 	if (!hugepd_none(*hpdp))
-		kmem_cache_free(huge_pgtable_cache(psize), new);
+		kmem_cache_free(pgtable_cache[HUGE_PGTABLE_INDEX(psize)], new);
 	else
 		hpdp->pd = (unsigned long)new | HUGEPD_OK;
 	spin_unlock(&mm->page_table_lock);
@@ -746,13 +745,14 @@
 
 	for (psize = 0; psize < MMU_PAGE_COUNT; ++psize) {
 		if (mmu_huge_psizes[psize]) {
-			huge_pgtable_cache(psize) = kmem_cache_create(
-						HUGEPTE_CACHE_NAME(psize),
-						HUGEPTE_TABLE_SIZE(psize),
-						HUGEPTE_TABLE_SIZE(psize),
-						0,
-						NULL);
-			if (!huge_pgtable_cache(psize))
+			pgtable_cache[HUGE_PGTABLE_INDEX(psize)] =
+				kmem_cache_create(
+					HUGEPTE_CACHE_NAME(psize),
+					HUGEPTE_TABLE_SIZE(psize),
+					HUGEPTE_TABLE_SIZE(psize),
+					0,
+					NULL);
+			if (!pgtable_cache[HUGE_PGTABLE_INDEX(psize)])
 				panic("hugetlbpage_init(): could not create %s"\
 				      "\n", HUGEPTE_CACHE_NAME(psize));
 		}


