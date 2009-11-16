Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKPOTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKPOTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZKPOTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:48 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31636 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZKPOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:21 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KT7GZ1-01-9KG-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 05/21] amd64_edac: unify MCGCTL ECC switching
Date: Mon, 16 Nov 2009 15:16:32 +0100
Message-ID: <1258381008-18783-6-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0735 (UTC) FILETIME=[59F6C4F0:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unify almost identical code into one function and remove NUMA-specific
usage (specifically cpumask_of_node()) in favor of generic topology
methods.

Remove unused defines, while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  204 +++++++++++++++++++++++++--------------------
 drivers/edac/amd64_edac.h |    9 +-
 2 files changed, 117 insertions(+), 96 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 67541e7..70c7d5f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2624,6 +2624,109 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 	return empty;
 }
 
+/* get all cores on this DCT */
+static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		if (amd_get_nb_id(cpu) == nid)
+			cpumask_set_cpu(cpu, mask);
+}
+
+/* check MCG_CTL on all the cpus on this node */
+static bool amd64_nb_mce_bank_enabled_on_node(int nid)
+{
+	cpumask_var_t mask;
+	struct msr *msrs;
+	int cpu, nbe, idx = 0;
+	bool ret = false;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
+			     __func__);
+		return false;
+	}
+
+	get_cpus_on_this_dct_cpumask(mask, nid);
+
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(mask), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			      __func__);
+		free_cpumask_var(mask);
+		 return false;
+	}
+
+	rdmsr_on_cpus(mask, MSR_IA32_MCG_CTL, msrs);
+
+	for_each_cpu(cpu, mask) {
+		nbe = msrs[idx].l & K8_MSR_MCGCTL_NBE;
+
+		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
+			cpu, msrs[idx].q,
+			(nbe ? "enabled" : "disabled"));
+
+		if (!nbe)
+			goto out;
+
+		idx++;
+	}
+	ret = true;
+
+out:
+	kfree(msrs);
+	free_cpumask_var(mask);
+	return ret;
+}
+
+static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
+{
+	cpumask_var_t cmask;
+	struct msr *msrs = NULL;
+	int cpu, idx = 0;
+
+	if (!zalloc_cpumask_var(&cmask, GFP_KERNEL)) {
+		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
+			     __func__);
+		return false;
+	}
+
+	get_cpus_on_this_dct_cpumask(cmask, pvt->mc_node_id);
+
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(cmask), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			     __func__);
+		return -ENOMEM;
+	}
+
+	rdmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
+
+	for_each_cpu(cpu, cmask) {
+
+		if (on) {
+			if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
+				pvt->flags.ecc_report = 1;
+
+			msrs[idx].l |= K8_MSR_MCGCTL_NBE;
+		} else {
+			/*
+			 * Turn off ECC reporting only when it was off before
+			 */
+			if (!pvt->flags.ecc_report)
+				msrs[idx].l &= ~K8_MSR_MCGCTL_NBE;
+		}
+		idx++;
+	}
+	wrmsr_on_cpus(cmask, MSR_IA32_MCG_CTL, msrs);
+
+	kfree(msrs);
+	free_cpumask_var(cmask);
+
+	return 0;
+}
+
 /*
  * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "we"
  * enable it.
@@ -2631,17 +2734,12 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
-	int cpu, idx = 0, err = 0;
-	struct msr msrs[cpumask_weight(cpumask)];
-	u32 value;
-	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	int err = 0;
+	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!ecc_enable_override)
 		return;
 
-	memset(msrs, 0, sizeof(msrs));
-
 	amd64_printk(KERN_WARNING,
 		"'ecc_enable_override' parameter is active, "
 		"Enabling AMD ECC hardware now: CAUTION\n");
@@ -2657,16 +2755,9 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 	value |= mask;
 	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
 
-	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
-
-	for_each_cpu(cpu, cpumask) {
-		if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
-			set_bit(idx, &pvt->old_mcgctl);
-
-		msrs[idx].l |= K8_MSR_MCGCTL_NBE;
-		idx++;
-	}
-	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+	if (amd64_toggle_ecc_err_reporting(pvt, ON))
+		amd64_printk(KERN_WARNING, "Error enabling ECC reporting over "
+					   "MCGCTL!\n");
 
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
 	if (err)
@@ -2707,17 +2798,12 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	const struct cpumask *cpumask = cpumask_of_node(pvt->mc_node_id);
-	int cpu, idx = 0, err = 0;
-	struct msr msrs[cpumask_weight(cpumask)];
-	u32 value;
-	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	int err = 0;
+	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!pvt->nbctl_mcgctl_saved)
 		return;
 
-	memset(msrs, 0, sizeof(msrs));
-
 	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
 	if (err)
 		debugf0("Reading K8_NBCTL failed\n");
@@ -2727,72 +2813,9 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 	/* restore the NB Enable MCGCTL bit */
 	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
 
-	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
-
-	for_each_cpu(cpu, cpumask) {
-		msrs[idx].l &= ~K8_MSR_MCGCTL_NBE;
-		msrs[idx].l |=
-			test_bit(idx, &pvt->old_mcgctl) << K8_MSR_MCGCTL_NBE;
-		idx++;
-	}
-
-	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
-}
-
-/* get all cores on this DCT */
-static void get_cpus_on_this_dct_cpumask(struct cpumask *mask, int nid)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		if (amd_get_nb_id(cpu) == nid)
-			cpumask_set_cpu(cpu, mask);
-}
-
-/* check MCG_CTL on all the cpus on this node */
-static bool amd64_nb_mce_bank_enabled_on_node(int nid)
-{
-	cpumask_var_t mask;
-	struct msr *msrs;
-	int cpu, nbe, idx = 0;
-	bool ret = false;
-
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
-		amd64_printk(KERN_WARNING, "%s: error allocating mask\n",
-			     __func__);
-		return false;
-	}
-
-	get_cpus_on_this_dct_cpumask(mask, nid);
-
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(mask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			      __func__);
-		free_cpumask_var(mask);
-		 return false;
-	}
-
-	rdmsr_on_cpus(mask, MSR_IA32_MCG_CTL, msrs);
-
-	for_each_cpu(cpu, mask) {
-		nbe = msrs[idx].l & K8_MSR_MCGCTL_NBE;
-
-		debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
-			cpu, msrs[idx].q,
-			(nbe ? "enabled" : "disabled"));
-
-		if (!nbe)
-			goto out;
-
-		idx++;
-	}
-	ret = true;
-
-out:
-	kfree(msrs);
-	free_cpumask_var(mask);
-	return ret;
+	if (amd64_toggle_ecc_err_reporting(pvt, OFF))
+		amd64_printk(KERN_WARNING, "Error restoring ECC reporting over "
+					   "MCGCTL!\n");
 }
 
 /*
@@ -2921,7 +2944,6 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	pvt->ext_model		= boot_cpu_data.x86_model >> 4;
 	pvt->mc_type_index	= mc_type_index;
 	pvt->ops		= family_ops(mc_type_index);
-	pvt->old_mcgctl		= 0;
 
 	/*
 	 * We have the dram_f2_ctl device as an argument, now go reserve its
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index c6f359a..bba6c94 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -147,6 +147,8 @@
 #define MAX_CS_COUNT			8
 #define DRAM_REG_COUNT			8
 
+#define ON true
+#define OFF false
 
 /*
  * PCI-defined configuration space registers
@@ -386,10 +388,7 @@ enum {
 #define K8_NBCAP_DUAL_NODE		BIT(1)
 #define K8_NBCAP_DCT_DUAL		BIT(0)
 
-/*
- * MSR Regs
- */
-#define K8_MSR_MCGCTL			0x017b
+/* MSRs */
 #define K8_MSR_MCGCTL_NBE		BIT(4)
 
 #define K8_MSR_MC4CTL			0x0410
@@ -487,7 +486,6 @@ struct amd64_pvt {
 	/* Save old hw registers' values before we modified them */
 	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
 	u32 old_nbctl;
-	unsigned long old_mcgctl;	/* per core on this node */
 
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
@@ -495,6 +493,7 @@ struct amd64_pvt {
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
+		unsigned long ecc_report:1;
 	} flags;
 };
 
-- 
1.6.4.3


