Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbZLKVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbZLKVbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbZLKVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:31:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:41774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440AbZLKVbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:31:14 -0500
Date: Fri, 11 Dec 2009 21:30:51 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dougthompson@xmission.com, randy.dunlap@oracle.com, mchehab@redhat.com,
       aris@redhat.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dougthompson@xmission.com, randy.dunlap@oracle.com, mchehab@redhat.com,
       aris@redhat.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <20091211171440.GD31998@aftab>
References: <20091211171440.GD31998@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, msr: Add support for non-contiguous cpumasks
Message-ID: <tip-505422517d3f126bb939439e9d15dece94e11d2c@git.kernel.org>
Git-Commit-ID: 505422517d3f126bb939439e9d15dece94e11d2c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  505422517d3f126bb939439e9d15dece94e11d2c
Gitweb:     http://git.kernel.org/tip/505422517d3f126bb939439e9d15dece94e11d2c
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 11 Dec 2009 18:14:40 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 11 Dec 2009 10:59:21 -0800

x86, msr: Add support for non-contiguous cpumasks

The current rd/wrmsr_on_cpus helpers assume that the supplied
cpumasks are contiguous. However, there are machines out there
like some K8 multinode Opterons which have a non-contiguous core
enumeration on each node (e.g. cores 0,2 on node 0 instead of 0,1), see
http://www.gossamer-threads.com/lists/linux/kernel/1160268.

This patch fixes out-of-bounds writes (see URL above) by adding per-CPU
msr structs which are used on the respective cores.

Additionally, two helpers, msrs_{alloc,free}, are provided for use by
the callers of the MSR accessors.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20091211171440.GD31998@aftab>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/msr.h |    3 ++
 arch/x86/lib/msr.c         |   26 +++++++++++++++++++++---
 drivers/edac/amd64_edac.c  |   46 ++++++++++++++++---------------------------
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 5bef931..2d228fc 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -244,6 +244,9 @@ do {                                                            \
 
 #define write_rdtscp_aux(val) wrmsr(0xc0000103, (val), 0)
 
+struct msr *msrs_alloc(void);
+void msrs_free(struct msr *msrs);
+
 #ifdef CONFIG_SMP
 int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 41628b1..8728341 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -7,7 +7,6 @@ struct msr_info {
 	u32 msr_no;
 	struct msr reg;
 	struct msr *msrs;
-	int off;
 	int err;
 };
 
@@ -18,7 +17,7 @@ static void __rdmsr_on_cpu(void *info)
 	int this_cpu = raw_smp_processor_id();
 
 	if (rv->msrs)
-		reg = &rv->msrs[this_cpu - rv->off];
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
 	else
 		reg = &rv->reg;
 
@@ -32,7 +31,7 @@ static void __wrmsr_on_cpu(void *info)
 	int this_cpu = raw_smp_processor_id();
 
 	if (rv->msrs)
-		reg = &rv->msrs[this_cpu - rv->off];
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
 	else
 		reg = &rv->reg;
 
@@ -80,7 +79,6 @@ static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
 
 	memset(&rv, 0, sizeof(rv));
 
-	rv.off    = cpumask_first(mask);
 	rv.msrs	  = msrs;
 	rv.msr_no = msr_no;
 
@@ -120,6 +118,26 @@ void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
+struct msr *msrs_alloc(void)
+{
+	struct msr *msrs = NULL;
+
+	msrs = alloc_percpu(struct msr);
+	if (!msrs) {
+		pr_warning("%s: error allocating msrs\n", __func__);
+		return NULL;
+	}
+
+	return msrs;
+}
+EXPORT_SYMBOL(msrs_alloc);
+
+void msrs_free(struct msr *msrs)
+{
+	free_percpu(msrs);
+}
+EXPORT_SYMBOL(msrs_free);
+
 /* These "safe" variants are slower and should be used when the target MSR
    may not actually exist. */
 static void __rdmsr_safe_on_cpu(void *info)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5fdd6da..df5b684 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -13,6 +13,8 @@ module_param(report_gart_errors, int, 0644);
 static int ecc_enable_override;
 module_param(ecc_enable_override, int, 0644);
 
+static struct msr *msrs;
+
 /* Lookup table for all possible MC control instances */
 struct amd64_pvt;
 static struct mem_ctl_info *mci_lookup[EDAC_MAX_NUMNODES];
@@ -2495,8 +2497,7 @@ static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
 static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 {
 	cpumask_var_t mask;
-	struct msr *msrs;
-	int cpu, nbe, idx = 0;
+	int cpu, nbe;
 	bool ret = false;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
@@ -2507,32 +2508,22 @@ static bool amd64_nb_mce_bank_enabled_on_node(int nid)
 
 	get_cpus_on_this_dct_cpumask(mask, nid);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(mask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			      __func__);
-		free_cpumask_var(mask);
-		 return false;
-	}
-
 	rdmsr_on_cpus(mask, MSR_IA32_MCG_CTL, msrs);
 
 	for_each_cpu(cpu, mask) {
-		nbe = msrs[idx].l & K8_MSR_MCGCTL_NBE;
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+		nbe = reg->l & K8_MSR_MCGCTL_NBE;
 
 		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
-			cpu, msrs[idx].q,
+			cpu, reg->q,
 			(nbe ? "enabled" : "disabled"));
 
 		if (!nbe)
 			goto out;
-
-		idx++;
 	}
 	ret = true;
 
 out:
-	kfree(msrs);
 	free_cpumask_var(mask);
 	return ret;
 }
@@ -2540,8 +2531,7 @@ out:
 static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 {
 	cpumask_var_t cmask;
-	struct msr *msrs = NULL;
-	int cpu, idx = 0;
+	int cpu;
 
 	if (!zalloc_cpumask_var(&cmask, GFP_KERNEL)) {
 		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
@@ -2551,34 +2541,27 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 
 	get_cpus_on_this_dct_cpumask(cmask, pvt->mc_node_id);
 
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(cmask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			     __func__);
-		return -ENOMEM;
-	}
-
 	rdmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
 
 	for_each_cpu(cpu, cmask) {
 
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+
 		if (on) {
-			if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
+			if (reg->l & K8_MSR_MCGCTL_NBE)
 				pvt->flags.ecc_report = 1;
 
-			msrs[idx].l |= K8_MSR_MCGCTL_NBE;
+			reg->l |= K8_MSR_MCGCTL_NBE;
 		} else {
 			/*
 			 * Turn off ECC reporting only when it was off before
 			 */
 			if (!pvt->flags.ecc_report)
-				msrs[idx].l &= ~K8_MSR_MCGCTL_NBE;
+				reg->l &= ~K8_MSR_MCGCTL_NBE;
 		}
-		idx++;
 	}
 	wrmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
 
-	kfree(msrs);
 	free_cpumask_var(cmask);
 
 	return 0;
@@ -3036,6 +3019,8 @@ static int __init amd64_edac_init(void)
 	if (cache_k8_northbridges() < 0)
 		return err;
 
+	msrs = msrs_alloc();
+
 	err = pci_register_driver(&amd64_pci_driver);
 	if (err)
 		return err;
@@ -3071,6 +3056,9 @@ static void __exit amd64_edac_exit(void)
 		edac_pci_release_generic_ctl(amd64_ctl_pci);
 
 	pci_unregister_driver(&amd64_pci_driver);
+
+	msrs_free(msrs);
+	msrs = NULL;
 }
 
 module_init(amd64_edac_init);
