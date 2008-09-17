Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYIQJ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYIQJ61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbYIQJ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:58:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYIQJ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:58:18 -0400
Date: Wed, 17 Sep 2008 11:58:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080917095800.GA9359@elte.hu>
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
Alex Nixon (1):
      x86/paravirt: Remove duplicate paravirt_pagetable_setup_{start, done}()

H. Peter Anvin (1):
      x86: completely disable NOPL on 32 bits

Jeremy Fitzhardinge (2):
      x86: fix possible x86_64 and EFI regression
      xen: fix for xen guest with mem > 3.7G

Julia Lawall (1):
      arch/x86/kernel/kdebugfs.c: introduce missing kfree


 arch/x86/kernel/cpu/common.c |   24 ++++--------------------
 arch/x86/kernel/kdebugfs.c   |    1 +
 arch/x86/kernel/setup.c      |    5 ++++-
 arch/x86/mm/init_32.c        |    4 ----
 arch/x86/xen/setup.c         |    2 +-
 5 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8aab851..4e456bd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -344,31 +344,15 @@ static void __init early_cpu_detect(void)
 
 /*
  * The NOPL instruction is supposed to exist on all CPUs with
- * family >= 6, unfortunately, that's not true in practice because
+ * family >= 6; unfortunately, that's not true in practice because
  * of early VIA chips and (more importantly) broken virtualizers that
- * are not easy to detect.  Hence, probe for it based on first
- * principles.
+ * are not easy to detect.  In the latter case it doesn't even *fail*
+ * reliably, so probing for it doesn't even work.  Disable it completely
+ * unless we can find a reliable way to detect all the broken cases.
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
-	const u32 nopl_signature = 0x888c53b1; /* Random number */
-	u32 has_nopl = nopl_signature;
-
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
-	if (c->x86 >= 6) {
-		asm volatile("\n"
-			     "1:      .byte 0x0f,0x1f,0xc0\n" /* nopl %eax */
-			     "2:\n"
-			     "        .section .fixup,\"ax\"\n"
-			     "3:      xor %0,%0\n"
-			     "        jmp 2b\n"
-			     "        .previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : "+a" (has_nopl));
-
-		if (has_nopl == nopl_signature)
-			set_cpu_cap(c, X86_FEATURE_NOPL);
-	}
 }
 
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index f2d43bc..ff7d3b0 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -139,6 +139,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		if (PageHighMem(pg)) {
 			data = ioremap_cache(pa_data, sizeof(*data));
 			if (!data) {
+				kfree(node);
 				error = -ENXIO;
 				goto err_dir;
 			}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 362d4e7..9838f25 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -670,6 +670,10 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+#ifdef CONFIG_X86_64
+	check_efer();
+#endif
+
 #if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
 	/*
 	 * Must be before kernel pagetables are setup
@@ -738,7 +742,6 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
-	check_efer();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index d37f293..60ec1d0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -458,11 +458,7 @@ static void __init pagetable_init(void)
 {
 	pgd_t *pgd_base = swapper_pg_dir;
 
-	paravirt_pagetable_setup_start(pgd_base);
-
 	permanent_kmaps_init(pgd_base);
-
-	paravirt_pagetable_setup_done(pgd_base);
 }
 
 #ifdef CONFIG_ACPI_SLEEP
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b6acc3a..d679010 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -42,7 +42,7 @@ char * __init xen_memory_setup(void)
 
 	e820.nr_map = 0;
 
-	e820_add_region(0, PFN_PHYS(max_pfn), E820_RAM);
+	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
 
 	/*
 	 * Even though this is normal, usable memory under Xen, reserve
