Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYLTNoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYLTNoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLTNoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:44:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYLTNoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:44:05 -0500
Date: Sat, 20 Dec 2008 14:43:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081220134353.GA16399@elte.hu>
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
Andi Kleen (1):
      x86: re-enable MCE on secondary CPUS after suspend/resume

Bjorn Helgaas (1):
      x86 gart: don't complain if no AMD GART found

Dmitry Adamushko (1):
      x86: fix resume (S2R) broken by Intel microcode module, on A110L

Joerg Roedel (3):
      AMD IOMMU: allocate rlookup_table with __GFP_ZERO
      AMD IOMMU: set cmd buffer pointers to zero manually
      AMD IOMMU: panic if completion wait loop fails


 arch/x86/kernel/amd_iommu.c         |    5 +++--
 arch/x86/kernel/amd_iommu_init.c    |    7 ++++++-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 ---
 arch/x86/kernel/microcode_core.c    |   19 ++++++++++++++-----
 arch/x86/kernel/microcode_intel.c   |    6 ++++++
 arch/x86/kernel/pci-gart_64.c       |    4 +---
 6 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a7b6dec..0a60d60 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -235,8 +235,9 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
 	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
-		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
+	if (unlikely(i == EXIT_LOOP_COUNT))
+		panic("AMD IOMMU: Completion wait loop failed\n");
+
 out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 30ae270..c6cc228 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -427,6 +427,10 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
 			&entry, sizeof(entry));
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
+
 	iommu_feature_enable(iommu, CONTROL_CMDBUF_EN);
 
 	return cmd_buf;
@@ -1074,7 +1078,8 @@ int __init amd_iommu_init(void)
 		goto free;
 
 	/* IOMMU rlookup table - find the IOMMU for a specific device */
-	amd_iommu_rlookup_table = (void *)__get_free_pages(GFP_KERNEL,
+	amd_iommu_rlookup_table = (void *)__get_free_pages(
+			GFP_KERNEL | __GFP_ZERO,
 			get_order(rlookup_table_size));
 	if (amd_iommu_rlookup_table == NULL)
 		goto free;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 4b031a4..1c83803 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -510,12 +510,9 @@ static void __cpuinit mce_cpu_features(struct cpuinfo_x86 *c)
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
-	static cpumask_t mce_cpus = CPU_MASK_NONE;
-
 	mce_cpu_quirks(c);
 
 	if (mce_dont_init ||
-	    cpu_test_and_set(smp_processor_id(), mce_cpus) ||
 	    !mce_available(c))
 		return;
 
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 82fb280..c4b5b24 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -272,13 +272,18 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static void microcode_fini_cpu(int cpu)
+static void __microcode_fini_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	mutex_lock(&microcode_mutex);
 	microcode_ops->microcode_fini_cpu(cpu);
 	uci->valid = 0;
+}
+
+static void microcode_fini_cpu(int cpu)
+{
+	mutex_lock(&microcode_mutex);
+	__microcode_fini_cpu(cpu);
 	mutex_unlock(&microcode_mutex);
 }
 
@@ -306,12 +311,16 @@ static int microcode_resume_cpu(int cpu)
 	 * to this cpu (a bit of paranoia):
 	 */
 	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
-		microcode_fini_cpu(cpu);
+		__microcode_fini_cpu(cpu);
+		printk(KERN_ERR "failed to collect_cpu_info for resuming cpu #%d\n",
+				cpu);
 		return -1;
 	}
 
-	if (memcmp(&nsig, &uci->cpu_sig, sizeof(nsig))) {
-		microcode_fini_cpu(cpu);
+	if ((nsig.sig != uci->cpu_sig.sig) || (nsig.pf != uci->cpu_sig.pf)) {
+		__microcode_fini_cpu(cpu);
+		printk(KERN_ERR "cached ucode doesn't match the resuming cpu #%d\n",
+				cpu);
 		/* Should we look for a new ucode here? */
 		return 1;
 	}
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 622dc4a..a8e6279 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -155,6 +155,7 @@ static DEFINE_SPINLOCK(microcode_update_lock);
 static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
+	unsigned long flags;
 	unsigned int val[2];
 
 	memset(csig, 0, sizeof(*csig));
@@ -174,11 +175,16 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
+	/* serialize access to the physical write to MSR 0x79 */
+	spin_lock_irqsave(&microcode_update_lock, flags);
+
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 	/* see notes above for revision 1.07.  Apparent chip bug */
 	sync_core();
 	/* get the current revision from MSR 0x8B */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
+	spin_unlock_irqrestore(&microcode_update_lock, flags);
+
 	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
 			csig->sig, csig->pf, csig->rev);
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba7ad83..a35eaa3 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -745,10 +745,8 @@ void __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
-		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
+	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
 		return;
-	}
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
