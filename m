Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZCJH44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZCJH44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZCJH4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:56855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZCJH4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] percpu: more flexibility for @dyn_size of pcpu_setup_first_chunk()
Date: Tue, 10 Mar 2009 16:53:49 +0900
Message-Id: <1236671631-9305-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:53:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, more flexibility for first chunk init

Non-negative @dyn_size used to be allowed iff @unit_size wasn't auto.
This restriction stemmed from implementation detail and made things a
bit less intuitive.  This patch allows @dyn_size to be specified
regardless of @unit_size and swaps the positions of @dyn_size and
@unit_size so that the parameter order makes more sense (static,
reserved and dyn sizes followed by enclosing unit_size).

While at it, add @unit_size >= PCPU_MIN_UNIT_SIZE sanity check.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   13 ++++++-------
 include/linux/percpu.h         |    2 +-
 mm/percpu.c                    |   28 ++++++++++++++--------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index efa615f..e41c51f 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -233,8 +233,8 @@ proceed:
 		"%zu bytes\n", vm.addr, static_size);
 
 	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
-				     PERCPU_FIRST_CHUNK_RESERVE,
-				     PMD_SIZE, dyn_size, vm.addr, NULL);
+				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
+				     PMD_SIZE, vm.addr, NULL);
 	goto out_free_ar;
 
 enomem:
@@ -315,9 +315,8 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
 
 	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
-				      PERCPU_FIRST_CHUNK_RESERVE,
-				      pcpue_unit_size, dyn_size,
-				      pcpue_ptr, NULL);
+				      PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
+				      pcpue_unit_size, pcpue_ptr, NULL);
 }
 
 /*
@@ -375,8 +374,8 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 		pcpu4k_nr_static_pages, static_size);
 
 	ret = pcpu_setup_first_chunk(pcpu4k_get_page, static_size,
-				     PERCPU_FIRST_CHUNK_RESERVE, -1, -1, NULL,
-				     pcpu4k_populate_pte);
+				     PERCPU_FIRST_CHUNK_RESERVE, -1,
+				     -1, NULL, pcpu4k_populate_pte);
 	goto out_free_ar;
 
 enomem:
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 54a968b..fb455dc 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -107,7 +107,7 @@ typedef void (*pcpu_populate_pte_fn_t)(unsigned long addr);
 
 extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				size_t static_size, size_t reserved_size,
-				ssize_t unit_size, ssize_t dyn_size,
+				ssize_t dyn_size, ssize_t unit_size,
 				void *base_addr,
 				pcpu_populate_pte_fn_t populate_pte_fn);
 
diff --git a/mm/percpu.c b/mm/percpu.c
index c6f38a2..2f94661 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1027,8 +1027,8 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * @get_page_fn: callback to fetch page pointer
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
- * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
  * @base_addr: mapped address, NULL for auto
  * @populate_pte_fn: callback to allocate pagetable, NULL if unnecessary
  *
@@ -1053,14 +1053,14 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * limited offset range for symbol relocations to guarantee module
  * percpu symbols fall inside the relocatable range.
  *
+ * @dyn_size, if non-negative, determines the number of bytes
+ * available for dynamic allocation in the first chunk.  Specifying
+ * non-negative value makes percpu leave alone the area beyond
+ * @static_size + @reserved_size + @dyn_size.
+ *
  * @unit_size, if non-negative, specifies unit size and must be
  * aligned to PAGE_SIZE and equal to or larger than @static_size +
- * @reserved_size + @dyn_size.
- *
- * @dyn_size, if non-negative, limits the number of bytes available
- * for dynamic allocation in the first chunk.  Specifying non-negative
- * value make percpu leave alone the area beyond @static_size +
- * @reserved_size + @dyn_size.
+ * @reserved_size + if non-negative, @dyn_size.
  *
  * Non-null @base_addr means that the caller already allocated virtual
  * region for the first chunk and mapped it.  percpu must not mess
@@ -1083,12 +1083,14 @@ EXPORT_SYMBOL_GPL(free_percpu);
  */
 size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				     size_t static_size, size_t reserved_size,
-				     ssize_t unit_size, ssize_t dyn_size,
+				     ssize_t dyn_size, ssize_t unit_size,
 				     void *base_addr,
 				     pcpu_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
+	size_t size_sum = static_size + reserved_size +
+			  (dyn_size >= 0 ? dyn_size : 0);
 	struct pcpu_chunk *schunk, *dchunk = NULL;
 	unsigned int cpu;
 	int nr_pages;
@@ -1099,20 +1101,18 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
 	BUG_ON(!static_size);
 	if (unit_size >= 0) {
-		BUG_ON(unit_size < static_size + reserved_size +
-				   (dyn_size >= 0 ? dyn_size : 0));
+		BUG_ON(unit_size < size_sum);
 		BUG_ON(unit_size & ~PAGE_MASK);
-	} else {
-		BUG_ON(dyn_size >= 0);
+		BUG_ON(unit_size < PCPU_MIN_UNIT_SIZE);
+	} else
 		BUG_ON(base_addr);
-	}
 	BUG_ON(base_addr && populate_pte_fn);
 
 	if (unit_size >= 0)
 		pcpu_unit_pages = unit_size >> PAGE_SHIFT;
 	else
 		pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_SIZE >> PAGE_SHIFT,
-					PFN_UP(static_size + reserved_size));
+					PFN_UP(size_sum));
 
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
-- 
1.6.0.2

