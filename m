Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZAZGQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZAZGQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZAZGPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:41 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:41676 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZAZGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PQ0MT3eaYIJThdFril7iqywk0i+JeNGpqVO1aFF069VVLdq0V2KNLg2vYiPYATJRWh
         r0tZKlAoZFP4+SJtSq8nM36Nrpr8k5HIZtKIhvwWZAVC9Sge8B/xlzVuCSnIektaVKti
         G1HDq6+pPRjsx+SrgUmAe8yUzrWcPcVRXUeHQ=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] x86: Always page-align per-cpu area start and size
Date: Mon, 26 Jan 2009 01:15:24 -0500
Message-Id: <1232950532-22923-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The way the code is written, align is always PAGE_SIZE.  Simplify
the code by removing the align variable.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/setup_percpu.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7bebdba..5d4a496 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -69,15 +69,12 @@ EXPORT_SYMBOL(__per_cpu_offset);
  */
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t size, old_size;
+	ssize_t size;
 	char *ptr;
 	int cpu;
-	unsigned long align = 1;
 
 	/* Copy section for each CPU (we discard the original) */
-	old_size = PERCPU_ENOUGH_ROOM;
-	align = max_t(unsigned long, PAGE_SIZE, align);
-	size = roundup(old_size, align);
+	size = roundup(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
 
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
@@ -86,20 +83,17 @@ void __init setup_per_cpu_areas(void)
 
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = __alloc_bootmem(size, align,
-				 __pa(MAX_DMA_ADDRESS));
+		ptr = alloc_bootmem_pages(size);
 #else
 		int node = early_cpu_to_node(cpu);
 		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = __alloc_bootmem(size, align,
-					 __pa(MAX_DMA_ADDRESS));
+			ptr = alloc_bootmem_pages(size);
 			pr_info("cpu %d has no node %d or node-local memory\n",
 				cpu, node);
 			pr_debug("per cpu data for cpu%d at %016lx\n",
 				 cpu, __pa(ptr));
 		} else {
-			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
-							__pa(MAX_DMA_ADDRESS));
+			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
 			pr_debug("per cpu data for cpu%d on node%d at %016lx\n",
 				cpu, node, __pa(ptr));
 		}
-- 
1.6.1

