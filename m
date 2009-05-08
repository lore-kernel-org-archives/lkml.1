Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbZEHSrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbZEHSrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZEHSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:47:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbZEHSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:47:13 -0400
Date: Fri, 8 May 2009 20:46:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090508184638.GA5178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      x86, srat: do not register nodes beyond e820 map

Hidetoshi Seto (1):
      x86: MCE: make cmci_discover_lock irq-safe

Huang Ying (1):
      x86, kexec: fix crashdump panic with CONFIG_KEXEC_JUMP

Jan Beulich (2):
      x86: fix boot hang in early_reserve_e820()
      x86-64: finish cleanup_highmaps()'s job wrt. _brk_end

Jeremy Fitzhardinge (1):
      x86: xen, i386: reserve Xen pagetables

Nikanth Karthikesan (1):
      x86: Fix a typo in a printk message


 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   10 ++++++----
 arch/x86/kernel/e820.c                    |   11 ++++++-----
 arch/x86/kernel/machine_kexec_32.c        |    4 ++--
 arch/x86/kernel/machine_kexec_64.c        |    4 ++--
 arch/x86/mm/init.c                        |   18 +++++++++++++++++-
 arch/x86/mm/srat_32.c                     |    2 +-
 arch/x86/mm/srat_64.c                     |    1 +
 arch/x86/xen/mmu.c                        |    5 +++++
 8 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..cef3ee3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -151,10 +151,11 @@ static void print_update(char *type, int *hdr, int num)
 static void cmci_discover(int banks, int boot)
 {
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long flags;
 	int hdr = 0;
 	int i;
 
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -184,7 +185,7 @@ static void cmci_discover(int banks, int boot)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
 }
@@ -211,13 +212,14 @@ void cmci_recheck(void)
  */
 void cmci_clear(void)
 {
+	unsigned long flags;
 	int i;
 	int banks;
 	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
 			continue;
@@ -227,7 +229,7 @@ void cmci_clear(void)
 		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index ef2c356..0062813 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1074,12 +1074,13 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	u64 addr;
 	u64 start;
 
-	start = startt;
-	while (size < sizet && (start + 1))
+	for (start = startt; ; start += size) {
 		start = find_e820_area_size(start, &size, align);
-
-	if (size < sizet)
-		return 0;
+		if (!(start + 1))
+			return 0;
+		if (size >= sizet)
+			break;
+	}
 
 #ifdef CONFIG_X86_32
 	if (start >= MAXMEM)
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index e7368c1..c1c429d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -194,7 +194,7 @@ void machine_kexec(struct kimage *image)
 				       unsigned int preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -253,7 +253,7 @@ void machine_kexec(struct kimage *image)
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 89cea4d..84c3bf2 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -274,7 +274,7 @@ void machine_kexec(struct kimage *image)
 	int save_ftrace_enabled;
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -333,7 +333,7 @@ void machine_kexec(struct kimage *image)
 				       image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fd3da1d..ae4f7b5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -7,6 +7,7 @@
 #include <asm/page.h>
 #include <asm/page_types.h>
 #include <asm/sections.h>
+#include <asm/setup.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
 
@@ -304,8 +305,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 #endif
 
 #ifdef CONFIG_X86_64
-	if (!after_bootmem)
+	if (!after_bootmem && !start) {
+		pud_t *pud;
+		pmd_t *pmd;
+
 		mmu_cr4_features = read_cr4();
+
+		/*
+		 * _brk_end cannot change anymore, but it and _end may be
+		 * located on different 2M pages. cleanup_highmap(), however,
+		 * can only consider _end when it runs, so destroy any
+		 * mappings beyond _brk_end here.
+		 */
+		pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
+		pmd = pmd_offset(pud, _brk_end - 1);
+		while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
+			pmd_clear(pmd);
+	}
 #endif
 	__flush_tlb_all();
 
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 16ae70f..29a0e37 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -216,7 +216,7 @@ int __init get_memcfg_from_srat(void)
 
 	if (num_memory_chunks == 0) {
 		printk(KERN_WARNING
-			 "could not finy any ACPI SRAT memory areas.\n");
+			 "could not find any ACPI SRAT memory areas.\n");
 		goto out_fail;
 	}
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 33c5fa5..0176595 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -361,6 +361,7 @@ static void __init unparse_node(int node)
 {
 	int i;
 	node_clear(node, nodes_parsed);
+	node_clear(node, cpu_nodes_parsed);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9842b12..e25a78e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1794,6 +1794,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
