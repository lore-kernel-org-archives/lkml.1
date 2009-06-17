Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZFQEFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZFQEFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZFQEFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:05:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZFQEFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:05:39 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] percpu: drop @unit_size from embed first chunk allocator
Date: Wed, 17 Jun 2009 13:04:32 +0900
Message-Id: <1245211476-27015-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245211476-27015-1-git-send-email-tj@kernel.org>
References: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only extra feature @unit_size provides is making dead space at the
end of the first chunk which doesn't have any valid usecase.  Drop the
parameter.  This will increase consistency with generalized 4k
allocator.

[ Impact: drop unused code path ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    2 +-
 include/linux/percpu.h         |    2 +-
 mm/percpu.c                    |   16 +++++-----------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 29a3eef..1472820 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -342,7 +342,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 		return -EINVAL;
 
 	return pcpu_embed_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
-				      reserve - PERCPU_FIRST_CHUNK_RESERVE, -1);
+				      reserve - PERCPU_FIRST_CHUNK_RESERVE);
 }
 
 /*
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e500034..83bff05 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -69,7 +69,7 @@ extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 
 extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size, ssize_t unit_size);
+				ssize_t dyn_size);
 
 /*
  * Use this to get to a cpu's version of the per-cpu object
diff --git a/mm/percpu.c b/mm/percpu.c
index 19dd83b..fe34b6b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1207,7 +1207,6 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
  * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
- * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
  *
  * This is a helper to ease setting up embedded first percpu chunk and
  * can be called where pcpu_setup_first_chunk() is expected.
@@ -1219,9 +1218,9 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
  * page size.
  *
  * When @dyn_size is positive, dynamic area might be larger than
- * specified to fill page alignment.  Also, when @dyn_size is auto,
- * @dyn_size does not fill the whole first chunk but only what's
- * necessary for page alignment after static and reserved areas.
+ * specified to fill page alignment.  When @dyn_size is auto,
+ * @dyn_size is just big enough to fill page alignment after static
+ * and reserved areas.
  *
  * If the needed size is smaller than the minimum or specified unit
  * size, the leftover is returned to the bootmem allocator.
@@ -1231,7 +1230,7 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
  * percpu access on success, -errno on failure.
  */
 ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
-				      ssize_t dyn_size, ssize_t unit_size)
+				      ssize_t dyn_size)
 {
 	size_t chunk_size;
 	unsigned int cpu;
@@ -1242,12 +1241,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	if (dyn_size != 0)
 		dyn_size = pcpue_size - static_size - reserved_size;
 
-	if (unit_size >= 0) {
-		BUG_ON(unit_size < pcpue_size);
-		pcpue_unit_size = unit_size;
-	} else
-		pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
-
+	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
 	chunk_size = pcpue_unit_size * num_possible_cpus();
 
 	pcpue_ptr = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
-- 
1.6.0.2

