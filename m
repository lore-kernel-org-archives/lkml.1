Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZGUKbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZGUKbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZGUK2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:37003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbZGUK1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:54 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/20] powerpc64: convert to dynamic percpu allocator
Date: Tue, 21 Jul 2009 19:26:19 +0900
Message-Id: <1248171979-29166-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:27:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that percpu allows arbitrary embedding of the first chunk,
powerpc64 can easily be converted to dynamic percpu allocator.
Convert it.  powerpc supports several large page sizes.  Cap atom_size
at 1M.  There isn't much to gain by going above that anyway.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig           |    4 +-
 arch/powerpc/kernel/setup_64.c |   61 +++++++++++++++++++++++++++++----------
 2 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 61bbffa..2c42e15 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -46,10 +46,10 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default y
 
-config HAVE_LEGACY_PER_CPU_AREA
+config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
-config HAVE_SETUP_PER_CPU_AREA
+config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool PPC64
 
 config IRQ_PER_CPU
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 1f68160..aa6e450 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -57,6 +57,7 @@
 #include <asm/cache.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
+#include <asm/mmu-hash64.h>
 #include <asm/firmware.h>
 #include <asm/xmon.h>
 #include <asm/udbg.h>
@@ -569,25 +570,53 @@ void cpu_die(void)
 }
 
 #ifdef CONFIG_SMP
-void __init setup_per_cpu_areas(void)
+#define PCPU_DYN_SIZE		()
+
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
 {
-	int i;
-	unsigned long size;
-	char *ptr;
-
-	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
-#ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
-#endif
+	return __alloc_bootmem_node(NODE_DATA(cpu_to_node(cpu)), size, align,
+				    __pa(MAX_DMA_ADDRESS));
+}
 
-	for_each_possible_cpu(i) {
-		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
+static void __init pcpu_fc_free(void *ptr, size_t size)
+{
+	free_bootmem(__pa(ptr), size);
+}
 
-		paca[i].data_offset = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-	}
+static int pcpu_cpu_distance(unsigned int from, unsigned int to)
+{
+	if (cpu_to_node(from) == cpu_to_node(to))
+		return LOCAL_DISTANCE;
+	else
+		return REMOTE_DISTANCE;
+}
+
+void __init setup_per_cpu_areas(void)
+{
+	const size_t dyn_size = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
+	size_t atom_size;
+	unsigned long delta;
+	unsigned int cpu;
+	int rc;
+
+	/*
+	 * Linear mapping is one of 4K, 1M and 16M.  For 4K, no need
+	 * to group units.  For larger mappings, use 1M atom which
+	 * should be large enough to contain a number of units.
+	 */
+	if (mmu_linear_psize == MMU_PAGE_4K)
+		atom_size = PAGE_SIZE;
+	else
+		atom_size = 1 << 20;
+
+	rc = pcpu_embed_first_chunk(0, dyn_size, atom_size, pcpu_cpu_distance,
+				    pcpu_fc_alloc, pcpu_fc_free);
+	if (rc < 0)
+		panic("cannot initialize percpu area (err=%d)", rc);
+
+	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
+	for_each_possible_cpu(cpu)
+		paca[cpu].data_offset = delta + pcpu_unit_offsets[cpu];
 }
 #endif
 
-- 
1.6.0.2

