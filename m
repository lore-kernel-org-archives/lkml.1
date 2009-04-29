Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZD2RBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZD2RBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbZD2Qzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:48 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:6507 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZD2Qzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:41 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KIVGC4-01-3V0-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 18/21] amd64_edac: add ECC reporting initializers
Date: Wed, 29 Apr 2009 18:55:04 +0200
Message-ID: <1241024107-14535-19-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 16:55:22.0585 (UTC) FILETIME=[49167C90:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  242 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 242 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8cf8060..43f236d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -70,6 +70,7 @@
 #include <linux/slab.h>
 #include <linux/mmzone.h>
 #include <linux/edac.h>
+#include <asm/msr.h>
 #include "edac_core.h"
 
 #define amd64_printk(level, fmt, arg...) \
@@ -4165,3 +4166,244 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
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
+	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	int idx = 0, cpu, err;
+	int cpus_on_node = cpumask_weight(cpumask);
+	u32 mcgctl_l[cpus_on_node], mcgctl_h[cpus_on_node];
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
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
+	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
+
+	for_each_cpu(cpu, cpumask) {
+		pvt->old_mcgctl[idx] = mcgctl_l[idx] & K8_MSR_MCGCTL_NBE;
+		mcgctl_l[idx] |= K8_MSR_MCGCTL_NBE;
+
+		debugf0("%s(), cpu %d, Old MCGCTL[NBE] = 0x%x New MCGCTL=0x%x\n",
+			__func__, cpu, (unsigned int) pvt->old_mcgctl[idx],
+			(unsigned int) mcgctl_l[idx]);
+
+		idx++;
+	}
+	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
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
+	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	int cpus_on_node = cpumask_weight(cpumask), idx = 0, cpu;
+	u32 mcgctl_l[cpus_on_node], mcgctl_h[cpus_on_node];
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
+	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
+
+	for_each_cpu(cpu, cpumask) {
+		mcgctl_l[idx] &= ~K8_MSR_MCGCTL_NBE;
+		mcgctl_l[idx] |= pvt->old_mcgctl[idx];
+		idx++;
+	}
+
+	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, mcgctl_l, mcgctl_h);
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


