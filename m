Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZCFGrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZCFGrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZCFGrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:47:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:56768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbZCFGrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:47:01 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, efault@gmx.de,
       jaswinder@kernel.org, cooloney@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] x86: make embedding percpu allocator return excessive free space
Date: Fri,  6 Mar 2009 15:46:25 +0900
Message-Id: <1236321988-19457-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236321988-19457-1-git-send-email-tj@kernel.org>
References: <1236321988-19457-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 06:46:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce unnecessary memory usage on certain configurations

Embedding percpu allocator allocates unit_size *
smp_num_possible_cpus() bytes consecutively and use it for the first
chunk.  However, if the static area is small, this can result in
excessive prellocated free space in the first chunk due to
PCPU_MIN_UNIT_SIZE restriction.

This patch makes embedding percpu allocator preallocate only what's
necessary as described by PERPCU_DYNAMIC_RESERVE and return the
leftover to the bootmem allocator.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   44 +++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef3a2cd..38e2b2a 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -241,24 +241,31 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
  * Embedding allocator
  *
  * The first chunk is sized to just contain the static area plus
- * PERCPU_DYNAMIC_RESERVE and allocated as a contiguous area using
- * bootmem allocator and used as-is without being mapped into vmalloc
- * area.  This enables the first chunk to piggy back on the linear
- * physical PMD mapping and doesn't add any additional pressure to
- * TLB.
+ * module and dynamic reserves, and allocated as a contiguous area
+ * using bootmem allocator and used as-is without being mapped into
+ * vmalloc area.  This enables the first chunk to piggy back on the
+ * linear physical PMD mapping and doesn't add any additional pressure
+ * to TLB.  Note that if the needed size is smaller than the minimum
+ * unit size, the leftover is returned to the bootmem allocator.
  */
 static void *pcpue_ptr __initdata;
+static size_t pcpue_size __initdata;
 static size_t pcpue_unit_size __initdata;
 
 static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
 {
-	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size
-			    + ((size_t)pageno << PAGE_SHIFT));
+	size_t off = (size_t)pageno << PAGE_SHIFT;
+
+	if (off >= pcpue_size)
+		return NULL;
+
+	return virt_to_page(pcpue_ptr + cpu * pcpue_unit_size + off);
 }
 
 static ssize_t __init setup_pcpu_embed(size_t static_size)
 {
 	unsigned int cpu;
+	size_t dyn_size;
 
 	/*
 	 * If large page isn't supported, there's no benefit in doing
@@ -269,25 +276,30 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 		return -EINVAL;
 
 	/* allocate and copy */
-	pcpue_unit_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
-	pcpue_unit_size = max_t(size_t, pcpue_unit_size, PCPU_MIN_UNIT_SIZE);
+	pcpue_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
+	pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
+	dyn_size = pcpue_size - static_size;
+
 	pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
 				       PAGE_SIZE);
 	if (!pcpue_ptr)
 		return -ENOMEM;
 
-	for_each_possible_cpu(cpu)
-		memcpy(pcpue_ptr + cpu * pcpue_unit_size, __per_cpu_load,
-		       static_size);
+	for_each_possible_cpu(cpu) {
+		void *ptr = pcpue_ptr + cpu * pcpue_unit_size;
+
+		free_bootmem(__pa(ptr + pcpue_size),
+			     pcpue_unit_size - pcpue_size);
+		memcpy(ptr, __per_cpu_load, static_size);
+	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
-		pcpue_unit_size >> PAGE_SHIFT, pcpue_ptr, static_size);
+		pcpue_size >> PAGE_SHIFT, pcpue_ptr, static_size);
 
 	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
-				      pcpue_unit_size,
-				      pcpue_unit_size - static_size, pcpue_ptr,
-				      NULL);
+				      pcpue_unit_size, dyn_size,
+				      pcpue_ptr, NULL);
 }
 
 /*
-- 
1.6.0.2

