Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZIXMfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZIXMfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZIXMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:35:05 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:2557 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZIXMeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:31 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz1417L936eMzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6X2-01-HCB-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/10] amd64_edac: unify MCGCTL ECC switching
Date: Thu, 24 Sep 2009 14:32:40 +0200
Message-ID: <1253795568-9877-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:34.0678 (UTC) FILETIME=[3B951760:01CA3D13]
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
 drivers/edac/amd64_edac.c |  185 ++++++++++++++++++++++++---------------------
 drivers/edac/amd64_edac.h |   10 +-
 2 files changed, 105 insertions(+), 90 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 53e617f..ebb5a96 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2626,6 +2626,96 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
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
+	struct cpumask mask;
+	struct msr *msrs;
+	int cpu, nbe, idx = 0;
+	bool ret = false;
+
+	cpumask_clear(&mask);
+
+	get_cpus_on_this_dct_cpumask(&mask, nid);
+
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			      __func__);
+		 return false;
+	}
+
+	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
+
+	for_each_cpu(cpu, &mask) {
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
+	return ret;
+}
+
+static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
+{
+	struct cpumask cmask;
+	struct msr *msrs = NULL;
+	int cpu, idx = 0;
+
+	cpumask_clear(&cmask);
+	get_cpus_on_this_dct_cpumask(&cmask, pvt->mc_node_id);
+
+	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&cmask), GFP_KERNEL);
+	if (!msrs) {
+		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
+			     __func__);
+		return -ENOMEM;
+	}
+
+	rdmsr_on_cpus(&cmask, MSR_IA32_MCG_CTL, msrs);
+	for_each_cpu(cpu, &cmask) {
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
+	wrmsr_on_cpus(&cmask, MSR_IA32_MCG_CTL, msrs);
+
+	kfree(msrs);
+
+	return 0;
+}
+
 /*
  * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "we"
  * enable it.
@@ -2633,17 +2723,12 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
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
@@ -2659,16 +2744,9 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
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
@@ -2709,17 +2787,12 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
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
@@ -2729,66 +2802,9 @@ static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
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
-	struct cpumask mask;
-	struct msr *msrs;
-	int cpu, nbe, idx = 0;
-	bool ret = false;
-
-	cpumask_clear(&mask);
-
-	get_cpus_on_this_dct_cpumask(&mask, nid);
-
-	msrs = kzalloc(sizeof(struct msr) * cpumask_weight(&mask), GFP_KERNEL);
-	if (!msrs) {
-		amd64_printk(KERN_WARNING, "%s: error allocating msrs\n",
-			      __func__);
-		 return false;
-	}
-
-	rdmsr_on_cpus(&mask, MSR_IA32_MCG_CTL, msrs);
-
-	for_each_cpu(cpu, &mask) {
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
-	return ret;
+	if (amd64_toggle_ecc_err_reporting(pvt, OFF))
+		amd64_printk(KERN_WARNING, "Error restoring ECC reporting over "
+					   "MCGCTL!\n");
 }
 
 /*
@@ -2917,7 +2933,6 @@ static int amd64_probe_one_instance(struct pci_dev *dram_f2_ctl,
 	pvt->ext_model		= boot_cpu_data.x86_model >> 4;
 	pvt->mc_type_index	= mc_type_index;
 	pvt->ops		= family_ops(mc_type_index);
-	pvt->old_mcgctl		= 0;
 
 	/*
 	 * We have the dram_f2_ctl device as an argument, now go reserve its
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8ea07e2..ec08870 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -129,6 +129,9 @@
  *         sections 3.5.4 and 3.5.5 for more information.
  */
 
+#define ON true
+#define OFF false
+
 #define EDAC_AMD64_VERSION		" Ver: 3.2.0 " __DATE__
 #define EDAC_MOD_STR			"amd64_edac"
 
@@ -390,10 +393,7 @@ enum {
 #define K8_NBCAP_DUAL_NODE		BIT(1)
 #define K8_NBCAP_DCT_DUAL		BIT(0)
 
-/*
- * MSR Regs
- */
-#define K8_MSR_MCGCTL			0x017b
+/* MSR Regs */
 #define K8_MSR_MCGCTL_NBE		BIT(4)
 
 #define K8_MSR_MC4CTL			0x0410
@@ -490,7 +490,6 @@ struct amd64_pvt {
 	/* Save old hw registers' values before we modified them */
 	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
 	u32 old_nbctl;
-	unsigned long old_mcgctl;	/* per core on this node */
 
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
@@ -498,6 +497,7 @@ struct amd64_pvt {
 	/* misc settings */
 	struct flags {
 		unsigned long cf8_extcfg:1;
+		unsigned long ecc_report:1;
 	} flags;
 };
 
-- 
1.6.3.3


