Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbZIXM4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbZIXM4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZIXM4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:56:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:49604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZIXM4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:56:47 -0400
Message-ID: <4ABB6C80.20109@kernel.org>
Date: Thu, 24 Sep 2009 21:56:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] sparc64: implement page mapping percpu first chunk allocator
References: <4ABB6C3A.8070109@kernel.org>
In-Reply-To: <4ABB6C3A.8070109@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:56:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement page mapping percpu first chunk allocator as a fallback to
the embedding allocator.  The next patch will make the embedding
allocator check distances between units to determine whether it fits
within the vmalloc area so that this fallback can be used on such
cases.

sparc64 currently has relatively small vmalloc area which makes it
impossible to create any dynamic chunks on certain configurations
leading to percpu allocation failures.  This and the next patch should
allow those configurations to keep working until proper solution is
found.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
David, can you please ack this after reviewing?

Thanks.

 arch/sparc/Kconfig         |    3 ++
 arch/sparc/kernel/smp_64.c |   51 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 8 deletions(-)

Index: work/arch/sparc/Kconfig
===================================================================
--- work.orig/arch/sparc/Kconfig
+++ work/arch/sparc/Kconfig
@@ -102,6 +102,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y if SPARC64

+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+	def_bool y if SPARC64
+
 config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	def_bool y if SPARC64
Index: work/arch/sparc/kernel/smp_64.c
===================================================================
--- work.orig/arch/sparc/kernel/smp_64.c
+++ work/arch/sparc/kernel/smp_64.c
@@ -1420,7 +1420,7 @@ static void __init pcpu_free_bootmem(voi
 	free_bootmem(__pa(ptr), size);
 }

-static int pcpu_cpu_distance(unsigned int from, unsigned int to)
+static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
 {
 	if (cpu_to_node(from) == cpu_to_node(to))
 		return LOCAL_DISTANCE;
@@ -1428,18 +1428,53 @@ static int pcpu_cpu_distance(unsigned in
 		return REMOTE_DISTANCE;
 }

+static void __init pcpu_populate_pte(unsigned long addr)
+{
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud;
+	pmd_t *pmd;
+
+	pud = pud_offset(pgd, addr);
+	if (pud_none(*pud)) {
+		pmd_t *new;
+
+		new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+		pud_populate(&init_mm, pud, new);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd)) {
+		pte_t *new;
+
+		new = __alloc_bootmem(PAGE_SIZE, PAGE_SIZE, PAGE_SIZE);
+		pmd_populate_kernel(&init_mm, pmd, new);
+	}
+}
+
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
 	unsigned int cpu;
-	int rc;
+	int rc = -EINVAL;

-	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-				    PERCPU_DYNAMIC_RESERVE, 4 << 20,
-				    pcpu_cpu_distance, pcpu_alloc_bootmem,
-				    pcpu_free_bootmem);
-	if (rc)
-		panic("failed to initialize first chunk (%d)", rc);
+	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+					    PERCPU_DYNAMIC_RESERVE, 4 << 20,
+					    pcpu_cpu_distance,
+					    pcpu_alloc_bootmem,
+					    pcpu_free_bootmem);
+		if (rc)
+			pr_warning("PERCPU: %s allocator failed (%d), "
+				   "falling back to page size\n",
+				   pcpu_fc_names[pcpu_chosen_fc], rc);
+	}
+	if (rc < 0)
+		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE,
+					   pcpu_alloc_bootmem,
+					   pcpu_free_bootmem,
+					   pcpu_populate_pte);
+	if (rc < 0)
+		panic("cannot initialize percpu area (err=%d)", rc);

 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
