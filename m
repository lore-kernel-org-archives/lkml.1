Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZBXDQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZBXDQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZBXDNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:58494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbZBXDNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:30 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] x86: add embedding percpu first chunk allocator
Date: Tue, 24 Feb 2009 12:11:40 +0900
Message-Id: <1235445101-7882-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add better first percpu allocation for !NUMA

On !NUMA, we can simply allocate contiguous memory and use it for the
first chunk without mapping it into vmalloc area.  As the memory area
is covered by the large page physical memory mapping, it allows the
dynamic perpcu allocator to not add any TLB overhead for the static
percpu area and whatever falls into the first chunk and the
implementation is very simple too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   86 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 85 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 4a17c96..fd4c399 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -43,6 +43,35 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
 EXPORT_SYMBOL(__per_cpu_offset);
 
 /**
+ * pcpu_need_numa - determine percpu allocation needs to consider NUMA
+ *
+ * If NUMA is not configured or there is only one NUMA node available,
+ * there is no reason to consider NUMA.  This function determines
+ * whether percpu allocation should consider NUMA or not.
+ *
+ * RETURNS:
+ * true if NUMA should be considered; otherwise, false.
+ */
+static bool __init pcpu_need_numa(void)
+{
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+	pg_data_t *last = NULL;
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		int node = early_cpu_to_node(cpu);
+
+		if (node_online(node) && NODE_DATA(node) &&
+		    last && last != NODE_DATA(node))
+			return true;
+
+		last = NODE_DATA(node);
+	}
+#endif
+	return false;
+}
+
+/**
  * pcpu_alloc_bootmem - NUMA friendly alloc_bootmem wrapper for percpu
  * @cpu: cpu to allocate for
  * @size: size allocation in bytes
@@ -82,6 +111,59 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 }
 
 /*
+ * Embedding allocator
+ *
+ * The first chunk is sized to just contain the static area plus
+ * PERCPU_DYNAMIC_RESERVE and allocated as a contiguous area using
+ * bootmem allocator and used as-is without being mapped into vmalloc
+ * area.  This enables the first chunk to piggy back on the linear
+ * physical PMD mapping and doesn't add any additional pressure to
+ * TLB.
+ */
+static void *pcpue_ptr __initdata;
+static size_t pcpue_unit_size __initdata;
+
+static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
+{
+	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size
+			    + ((size_t)pageno << PAGE_SHIFT));
+}
+
+static ssize_t __init setup_pcpu_embed(size_t static_size)
+{
+	unsigned int cpu;
+
+	/*
+	 * If large page isn't supported, there's no benefit in doing
+	 * this.  Also, embedding allocation doesn't play well with
+	 * NUMA.
+	 */
+	if (!cpu_has_pse || pcpu_need_numa())
+		return -EINVAL;
+
+	/* allocate and copy */
+	pcpue_unit_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
+	pcpue_unit_size = max(pcpue_unit_size, PCPU_MIN_UNIT_SIZE);
+	pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
+				       PAGE_SIZE);
+	if (!pcpue_ptr)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		memcpy(pcpue_ptr + cpu * pcpue_unit_size, __per_cpu_load,
+		       static_size);
+
+	/* we're ready, commit */
+	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
+		pcpue_unit_size >> PAGE_SHIFT, pcpue_ptr, static_size);
+
+	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
+				      pcpue_unit_size,
+				      pcpue_unit_size - static_size, pcpue_ptr,
+				      NULL);
+}
+
+/*
  * 4k page allocator
  *
  * This is the basic allocator.  Static percpu area is allocated
@@ -178,7 +260,9 @@ void __init setup_per_cpu_areas(void)
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
 	/* allocate percpu area */
-	ret = setup_pcpu_4k(static_size);
+	ret = setup_pcpu_embed(static_size);
+	if (ret < 0)
+		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)
 		panic("cannot allocate static percpu area (%zu bytes, err=%zd)",
 		      static_size, ret);
-- 
1.6.0.2

