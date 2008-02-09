Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYBIMFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYBIMFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYBIMDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:03:20 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:26159 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbYBIMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:03:12 -0500
Message-Id: <20080209120308.269844869@de.ibm.com>
References: <20080209120157.885371603@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Sat, 09 Feb 2008 13:02:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/11] VMEM_MAX_PHYS overflow on 31 bit.
Content-Disposition: inline; filename=005-overflow.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

With the new space saving spinlock_t and a non-debug configuration
the struct page only has 32 bytes for 31 bit s390. The causes an
overflow in the calculation of VMEM_MAX_PHYS which renders the
kernel unbootable.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/pgtable.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: quilt-2.6/include/asm-s390/pgtable.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/pgtable.h
+++ quilt-2.6/include/asm-s390/pgtable.h
@@ -127,8 +127,9 @@ extern char empty_zero_page[PAGE_SIZE];
  * mapping. This needs to be calculated at compile time since the size of the
  * VMEM_MAP is static but the size of struct page can change.
  */
-#define VMEM_MAX_PHYS	min(VMALLOC_START, ((VMEM_MAP_END - VMALLOC_END) / \
-			  sizeof(struct page) * PAGE_SIZE) & ~((16 << 20) - 1))
+#define VMEM_MAX_PAGES	((VMEM_MAP_END - VMALLOC_END) / sizeof(struct page))
+#define VMEM_MAX_PFN	min(VMALLOC_START >> PAGE_SHIFT, VMEM_MAX_PAGES)
+#define VMEM_MAX_PHYS	((VMEM_MAX_PFN << PAGE_SHIFT) & ~((16 << 20) - 1))
 #define VMEM_MAP	((struct page *) VMALLOC_END)
 
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

