Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbZD1PNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbZD1PNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbZD1PHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:07:05 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36237 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761694AbZD1PHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:07:01 -0400
X-BigFish: VPS1(zzzz1202hzzz32i)
X-FB-SS: 5,
X-WSS-ID: 0KITGMT-01-UAW-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 18/21] amd64_edac: add ECC reporting initializers
Date: Tue, 28 Apr 2009 17:06:10 +0200
Message-ID: <1240931173-17477-19-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:24.0396 (UTC) FILETIME=[E59C44C0:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  230 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 230 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index f6cfff0..5484c11 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4208,3 +4208,233 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 	return empty;
 }
 
+/*
+ * amd64_enable_ecc_error_reporting
+ *
+ *	Only if 'ecc_enable_override' is set AND BIOS had ECC disabled,
+ *	do "we" enable it.
+ *
+ *	On each NB we need to enable the hardware to
+ *	generate and detect error events
+ *
+ *	1) NB Control Register
+ *	2) Global MCE Reporting Control Reg (MCGCTL)
+ */
+static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 mcgctl_l, mcgctl_h;
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	int err;
+
+	if (!ecc_enable_override)
+		return;
+
+	amd64_printk(KERN_WARNING,
+		"'ecc_enable_override' parameter is active, "
+		"Enabling AMD ECC hardware now: CAUTION\n");
+
+	/* 1) read the NB Control register, and save old Enable bits */
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	if (err != 0)
+		debugf0("%s() Reading K8_NBCTL failed\n", __func__);
+
+	/* save old value and then turn on UECCn and CECCEn bits
+	 * and write it back out, thus turning ON ECC for sure
+	 */
+	pvt->old_nbctl = value & mask;
+	pvt->nbctl_mcgctl_saved = 1;	/* Mark 'old' ECC values valid */
+
+	value |= mask;
+	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
+
+	debugf0("%s() Old NBCTL 0x%x New NBCTL= 0x%x\n",
+		__func__, pvt->old_nbctl, value);
+
+	/* 2) Read and save the NB Enable bit at entry. Enable the bit
+	 * then write the enabled value back to hardware
+	 */
+	do_rdmsr(pvt->mc_node_id, K8_MSR_MCGCTL, &mcgctl_l, &mcgctl_h);
+	pvt->old_mcgctl = mcgctl_l & K8_MSR_MCGCTL_NBE;
+	mcgctl_l |= K8_MSR_MCGCTL_NBE;
+
+	debugf0("%s() Old MCGCTL= 0x%x New MCGCTL=0x%x\n",
+		__func__, (unsigned int) mcgctl_l,
+		(unsigned int) pvt->old_mcgctl);
+
+	/* Ensure NBE is on and write it back out */
+	do_wrmsr(pvt->mc_node_id, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
+	do_rdmsr(pvt->mc_node_id, K8_MSR_MCGCTL, &mcgctl_l, &mcgctl_h);
+
+	/* 3) Read the NB CFG to ensure DRAM ECC is on and then
+	 * keep a copy of the hw register in the control structure
+	 */
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	if (err != 0)
+		debugf0("%s() Reading K8_NBCFG failed\n", __func__);
+
+	debugf0("%s() NBCFG(1)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n",
+		__func__, value,
+		value & (K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
+		value & (K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled"
+		);
+
+	if (!(value & K8_NBCFG_ECC_ENABLE)) {
+		amd64_printk(KERN_WARNING,
+			"This node reports that DRAM ECC is "
+			"currently Disabled; ENABLING now\n");
+
+		/* Attempt to turn on DRAM ECC Enable */
+		value |= K8_NBCFG_ECC_ENABLE;
+		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
+
+		err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
+		if (err != 0)
+			debugf0("%s() Reading K8_NBCFG failed\n", __func__);
+
+		if (!(value & K8_NBCFG_ECC_ENABLE)) {
+			amd64_printk(KERN_WARNING,
+				"Hardware rejects Enabling DRAM ECC checking\n"
+				"Check memory DIMM configuration\n");
+		} else {
+			amd64_printk(KERN_DEBUG,
+				"Hardware accepted DRAM ECC Enable\n");
+		}
+	}
+	debugf0("%s() NBCFG(2)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n",
+		__func__, value,
+		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
+		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled"
+		);
+
+	pvt->ctl_error_info.nbcfg = value;
+}
+
+/*
+ * amd64_restore_ecc_error_reporting
+ *
+ *	restore the hardware registers to their initial condition
+ *	prior to when amd64_enable_ecc_error_reporting was called
+ */
+static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
+{
+	u32 mcgctl_l, mcgctl_h;
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	int err;
+
+	if (!pvt->nbctl_mcgctl_saved)
+		return;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	if (err != 0)
+		debugf0("%s() Reading K8_NBCTL failed\n", __func__);
+	value &= ~mask;
+	value |= pvt->old_nbctl;
+
+	/* restore the NB Enable MCGCTL bit */
+	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
+
+	do_rdmsr(pvt->mc_node_id, K8_MSR_MCGCTL, &mcgctl_l, &mcgctl_h);
+	mcgctl_l &= ~K8_MSR_MCGCTL_NBE;
+	mcgctl_l |= pvt->old_mcgctl;
+	do_wrmsr(pvt->mc_node_id, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
+}
+
+static void check_mcg_ctl(void *ret)
+{
+	u64 msr_val = 0;
+	u8 nbe;
+
+	rdmsrl(MSR_IA32_MCG_CTL, msr_val);
+	nbe = msr_val & K8_MSR_MCGCTL_NBE;
+
+	debugf0("%s: core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
+		__func__, raw_smp_processor_id(), msr_val,
+		(nbe ? "enabled" : "disabled"));
+
+	if (!nbe)
+		*(int *)ret = 0;
+}
+
+static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
+{
+	int rc = 1;
+	preempt_disable();
+	smp_call_function_many(mask, check_mcg_ctl, &rc, 1);
+	preempt_enable();
+
+	return rc;
+}
+
+/*
+ * amd64_check_ecc_enabled
+ *
+ *	EDAC requires that the BIOS have ECC enabled before taking over the
+ *	processing of ECC errors. This is because the BIOS can properly
+ *	initialize the memory system completely.
+ *
+ *	For development and other purposes, there is a command line option
+ *	which allows for overriding this contraint. If supplied on the kernrel
+ *	command line, hardware ECC is force-enabled later in
+ *	amd64_enable_ecc_error_reporting().
+ */
+static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
+{
+	u32 value;
+	int tmp;
+	int rc = 0;
+
+	tmp = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	if (tmp != 0)
+		debugf0("%s() Reading K8_NBCTL failed\n", __func__);
+
+	/* check MCG_CTL on all the cpus on this node */
+	rc = amd64_mcg_ctl_enabled_on_cpus(cpumask_of_node(pvt->mc_node_id));
+
+	debugf0("%s() K8_NBCFG=0x%x,  DRAM ECC is %s\n",
+		__func__, value, (value & K8_NBCFG_ECC_ENABLE ? "enabled"
+					: "disabled"));
+	if (!tmp || !rc) {
+		if (!tmp) {
+			amd64_printk(KERN_WARNING, "This node reports that "
+						   "Memory ECC is currently "
+						   "disabled.\n");
+
+			amd64_printk(KERN_WARNING, "bit 0x%lx in register "
+				"F3x%x of the MISC_CONTROL device (%s) "
+				"should be enabled\n", K8_NBCFG_ECC_ENABLE,
+				K8_NBCFG, pci_name(pvt->misc_f3_ctl));
+		}
+		if (!rc) {
+			amd64_printk(KERN_WARNING, "bit 0x%016lx in MSR 0x%08x "
+					"of node %d should be enabled\n",
+					K8_MSR_MCGCTL_NBE, MSR_IA32_MCG_CTL,
+					pvt->mc_node_id);
+		}
+		if (!ecc_enable_override) {
+			amd64_printk(KERN_WARNING, "WARNING: ECC is NOT "
+				"currently enabled by the BIOS. Module "
+				"will NOT be loaded.\n"
+				"    Either Enable ECC in the BIOS, "
+				"or use the 'ecc_enable_override' "
+				"parameter.\n"
+				"    Might be a BIOS bug, if BIOS says "
+				"ECC is enabled\n"
+				"    Use of the override can cause "
+				"unknown side effects.\n");
+			rc = -ENODEV;
+		}
+	} else {
+		amd64_printk(KERN_INFO,
+			"ECC is enabled by BIOS, Proceeding "
+			"with EDAC module initialization\n");
+
+		/* CLEAR the override, since BIOS controlled it */
+		ecc_enable_override = 0;
+	}
+
+	return rc;
+}
+
-- 
1.6.2.4


