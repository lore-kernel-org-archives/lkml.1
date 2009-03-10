Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZCJH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZCJH5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZCJH42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:56886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZCJH4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:24 -0400
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
Subject: [PATCH 4/5] percpu: generalize embedding first chunk setup helper
Date: Tue, 10 Mar 2009 16:53:50 +0900
Message-Id: <1236671631-9305-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:53:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization

Separate out embedding first chunk setup helper from x86 embedding
first chunk allocator and put it in mm/percpu.c.  This will be used by
the default percpu first chunk allocator and possibly by other archs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   54 +++----------------------
 include/linux/percpu.h         |    4 ++
 mm/percpu.c                    |   86 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index e41c51f..400331b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -257,31 +257,13 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
  * Embedding allocator
  *
  * The first chunk is sized to just contain the static area plus
- * module and dynamic reserves, and allocated as a contiguous area
- * using bootmem allocator and used as-is without being mapped into
- * vmalloc area.  This enables the first chunk to piggy back on the
- * linear physical PMD mapping and doesn't add any additional pressure
- * to TLB.  Note that if the needed size is smaller than the minimum
- * unit size, the leftover is returned to the bootmem allocator.
+ * module and dynamic reserves and embedded into linear physical
+ * mapping so that it can use PMD mapping without additional TLB
+ * pressure.
  */
-static void *pcpue_ptr __initdata;
-static size_t pcpue_size __initdata;
-static size_t pcpue_unit_size __initdata;
-
-static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
-{
-	size_t off = (size_t)pageno << PAGE_SHIFT;
-
-	if (off >= pcpue_size)
-		return NULL;
-
-	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size + off);
-}
-
 static ssize_t __init setup_pcpu_embed(size_t static_size)
 {
-	unsigned int cpu;
-	size_t dyn_size;
+	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
 	/*
 	 * If large page isn't supported, there's no benefit in doing
@@ -291,32 +273,8 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	if (!cpu_has_pse || pcpu_need_numa())
 		return -EINVAL;
 
-	/* allocate and copy */
-	pcpue_size = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
-			       PERCPU_DYNAMIC_RESERVE);
-	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
-	dyn_size = pcpue_size - static_size - PERCPU_FIRST_CHUNK_RESERVE;
-
-	pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
-				       PAGE_SIZE);
-	if (!pcpue_ptr)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;
-
-		free_bootmem(__pa(ptr + pcpue_size),
-			     pcpue_unit_size - pcpue_size);
-		memcpy(ptr, __per_cpu_load, static_size);
-	}
-
-	/* we're ready, commit */
-	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
-		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
-
-	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
-				      PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				      pcpue_unit_size, pcpue_ptr, NULL);
+	return pcpu_embed_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+				      reserve - PERCPU_FIRST_CHUNK_RESERVE, -1);
 }
 
 /*
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index fb455dc..ee5615d 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -111,6 +111,10 @@ extern size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 				void *base_addr,
 				pcpu_populate_pte_fn_t populate_pte_fn);
 
+extern ssize_t __init pcpu_embed_first_chunk(
+				size_t static_size, size_t reserved_size,
+				ssize_t dyn_size, ssize_t unit_size);
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
diff --git a/mm/percpu.c b/mm/percpu.c
index 2f94661..1aa5d8f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1238,3 +1238,89 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
 	return pcpu_unit_size;
 }
+
+/*
+ * Embedding first chunk setup helper.
+ */
+static void *pcpue_ptr __initdata;
+static size_t pcpue_size __initdata;
+static size_t pcpue_unit_size __initdata;
+
+static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
+{
+	size_t off = (size_t)pageno << PAGE_SHIFT;
+
+	if (off >= pcpue_size)
+		return NULL;
+
+	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size + off);
+}
+
+/**
+ * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
+ * @static_size: the size of static percpu area in bytes
+ * @reserved_size: the size of reserved percpu area in bytes
+ * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE, -1 for auto
+ *
+ * This is a helper to ease setting up embedded first percpu chunk and
+ * can be called where pcpu_setup_first_chunk() is expected.
+ *
+ * If this function is used to setup the first chunk, it is allocated
+ * as a contiguous area using bootmem allocator and used as-is without
+ * being mapped into vmalloc area.  This enables the first chunk to
+ * piggy back on the linear physical mapping which often uses larger
+ * page size.
+ *
+ * When @dyn_size is positive, dynamic area might be larger than
+ * specified to fill page alignment.  Also, when @dyn_size is auto,
+ * @dyn_size does not fill the whole first chunk but only what's
+ * necessary for page alignment after static and reserved areas.
+ *
+ * If the needed size is smaller than the minimum or specified unit
+ * size, the leftover is returned to the bootmem allocator.
+ *
+ * RETURNS:
+ * The determined pcpu_unit_size which can be used to initialize
+ * percpu access on success, -errno on failure.
+ */
+ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
+				      ssize_t dyn_size, ssize_t unit_size)
+{
+	unsigned int cpu;
+
+	/* determine parameters and allocate */
+	pcpue_size = PFN_ALIGN(static_size + reserved_size +
+			       (dyn_size >= 0 ? dyn_size : 0));
+	if (dyn_size != 0)
+		dyn_size = pcpue_size - static_size - reserved_size;
+
+	if (unit_size >= 0) {
+		BUG_ON(unit_size < pcpue_size);
+		pcpue_unit_size = unit_size;
+	} else
+		pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
+
+	pcpue_ptr = __alloc_bootmem_nopanic(
+					num_possible_cpus() * pcpue_unit_size,
+					PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	if (!pcpue_ptr)
+		return -ENOMEM;
+
+	/* return the leftover and copy */
+	for_each_possible_cpu(cpu) {
+		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;
+
+		free_bootmem(__pa(ptr + pcpue_size),
+			     pcpue_unit_size - pcpue_size);
+		memcpy(ptr, __per_cpu_load, static_size);
+	}
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
+		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
+
+	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
+				      reserved_size, dyn_size,
+				      pcpue_unit_size, pcpue_ptr, NULL);
+}
-- 
1.6.0.2

