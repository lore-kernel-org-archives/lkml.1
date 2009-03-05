Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZCENKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZCENKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZCENIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:41 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39601 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZCENIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:37 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 11/17] x86: ifdef 32-bit and 64-bit pfn setup in init_memory_mapping()
Date: Thu,  5 Mar 2009 14:55:02 +0200
Message-Id: <1236257708-27269-11-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

To reduce the diff between the 32-bit and 64-bit versions of
init_memory_mapping(), ifdef configuration specific pfn setup code in the
function.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |   42 +++++++++++++++++++++++++++++++++++++++---
 arch/x86/mm/init_64.c |   21 +++++++++++++++++++++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3f91bdc..34760e4 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -975,20 +975,25 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	memset(mr, 0, sizeof(mr));
 	nr_range = 0;
 
+	/* head if not big page alignment ? */
+	start_pfn = start >> PAGE_SHIFT;
+	pos = start_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
 	/*
 	 * Don't use a large page for the first 2/4MB of memory
 	 * because there are often fixed size MTRRs in there
 	 * and overlapping MTRRs into large pages can cause
 	 * slowdowns.
 	 */
-	/* head if not big page alignment ? */
-	start_pfn = start >> PAGE_SHIFT;
-	pos = start_pfn << PAGE_SHIFT;
 	if (pos == 0)
 		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
 	else
 		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 				 << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
+			<< (PMD_SHIFT - PAGE_SHIFT);
+#endif
 	if (end_pfn > (end >> PAGE_SHIFT))
 		end_pfn = end >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
@@ -999,12 +1004,43 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	/* big page (2M) range */
 	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
+#ifdef CONFIG_X86_32
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
+	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+#endif
+
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+#ifdef CONFIG_X86_64
+	/* big page (1G) range */
+	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask &
+				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
+		pos = end_pfn << PAGE_SHIFT;
+	}
+
+	/* tail is not big page (1G) alignment */
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
 		pos = end_pfn << PAGE_SHIFT;
 	}
+#endif
 
 	/* tail is not big page (2M) alignment */
 	start_pfn = pos>>PAGE_SHIFT;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5ecb23a..d99bc6a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -741,8 +741,22 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	/* head if not big page alignment ? */
 	start_pfn = start >> PAGE_SHIFT;
 	pos = start_pfn << PAGE_SHIFT;
+#ifdef CONFIG_X86_32
+	/*
+	 * Don't use a large page for the first 2/4MB of memory
+	 * because there are often fixed size MTRRs in there
+	 * and overlapping MTRRs into large pages can cause
+	 * slowdowns.
+	 */
+	if (pos == 0)
+		end_pfn = 1<<(PMD_SHIFT - PAGE_SHIFT);
+	else
+		end_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+				 << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
+#endif
 	if (end_pfn > (end >> PAGE_SHIFT))
 		end_pfn = end >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
@@ -753,16 +767,22 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	/* big page (2M) range */
 	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
+#ifdef CONFIG_X86_32
+	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+#else /* CONFIG_X86_64 */
 	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
 			 << (PUD_SHIFT - PAGE_SHIFT);
 	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
 		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+#endif
+
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask & (1<<PG_LEVEL_2M));
 		pos = end_pfn << PAGE_SHIFT;
 	}
 
+#ifdef CONFIG_X86_64
 	/* big page (1G) range */
 	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
 			 << (PUD_SHIFT - PAGE_SHIFT);
@@ -783,6 +803,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 				page_size_mask & (1<<PG_LEVEL_2M));
 		pos = end_pfn << PAGE_SHIFT;
 	}
+#endif
 
 	/* tail is not big page (2M) alignment */
 	start_pfn = pos>>PAGE_SHIFT;
-- 
1.5.4.3

