Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYKQN0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYKQN0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYKQN0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:32 -0500
Received: from ozlabs.org ([203.10.76.45]:39438 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYKQN0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:31 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:26 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 1/7] Improve alloc_percpu: make the per cpu reserve configurable and larger.
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132630.33F09DDDF5@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is based on Christoph Lameter's "cpualloc: make the per cpu
reserve configurable" patch, and his "Increase default reserve percpu
area" patch.

Christoph did the hard work of figuring out what the number should be
(based on convering the slub allocator).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 include/linux/percpu.h              |   10 ++--------
 init/main.c                         |    2 ++
 mm/allocpercpu.c                    |    5 +++++
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1704,6 +1704,13 @@
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
+	percpu=		[SMP] Configure the number of percpu bytes that can be
+			dynamically allocated. This is used for per cpu
+			variables of modules and other dynamic per cpu data
+			structures. Creation of per cpu structures after boot
+			may fail if this is set too low.
+			Default is 10k/20k for 32 or 64-bit systems.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -41,16 +41,10 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
-/* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE	8192
-#else
-#define PERCPU_MODULE_RESERVE	0
-#endif
+extern unsigned int percpu_reserve;
 
-#define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+#define PERCPU_ENOUGH_ROOM (__per_cpu_end - __per_cpu_start + percpu_reserve)
 #endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -401,6 +401,8 @@
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
 	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
+	printk(KERN_INFO "percpu area: %d bytes total, %d available.\n",
+		size, size - (__per_cpu_end - __per_cpu_start));
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -141,3 +141,8 @@
 	kfree(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(percpu_free);
+
+/* A heuristic based on observation.  May need to increase. */
+unsigned int percpu_reserve = (sizeof(unsigned long) * 2500);
+
+core_param(percpu, percpu_reserve, uint, 0644);

