Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYCBGNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYCBGNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 01:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYCBGMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 01:12:51 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:36331 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYCBGMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 01:12:51 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org, tomof@acm.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/3] export iommu_is_span_boundary helper function
Date: Sun,  2 Mar 2008 15:10:26 +0900
Message-Id: <1204438228-4564-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_is_span_boundary is used internally in the IOMMU helper
(lib/iommu-helper.c), a primitive function that judges whether a
memory area spans LLD's segment boundary or not.

It's difficult to convert some IOMMUs to use the IOMMU helper but
iommu_is_span_boundary is still useful for them. So this patch exports
it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/iommu-helper.h |    3 +++
 lib/iommu-helper.c           |   10 ++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 4dd4c04..c975caf 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -1,3 +1,6 @@
+extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
+				  unsigned long shift,
+				  unsigned long boundary_size);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index 495575a..a3b8d4c 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -40,10 +40,12 @@ static inline void set_bit_area(unsigned long *map, unsigned long i,
 	}
 }
 
-static inline int is_span_boundary(unsigned int index, unsigned int nr,
-				   unsigned long shift,
-				   unsigned long boundary_size)
+int iommu_is_span_boundary(unsigned int index, unsigned int nr,
+			   unsigned long shift,
+			   unsigned long boundary_size)
 {
+	BUG_ON(!is_power_of_2(boundary_size));
+
 	shift = (shift + index) & (boundary_size - 1);
 	return shift + nr > boundary_size;
 }
@@ -57,7 +59,7 @@ unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 again:
 	index = find_next_zero_area(map, size, start, nr, align_mask);
 	if (index != -1) {
-		if (is_span_boundary(index, nr, shift, boundary_size)) {
+		if (iommu_is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
 			goto again;
-- 
1.5.3.7

