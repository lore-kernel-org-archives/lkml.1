Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZEGNz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZEGNz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZEGNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:35 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:5112 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755991AbZEGNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:11 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KJA137-02-CLK-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 20/21] amd64_edac: add ECC reporting initializers
Date: Thu, 7 May 2009 15:49:42 +0200
Message-ID: <1241704183-29223-21-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:58.0719 (UTC) FILETIME=[B60D3CF0:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:
- convert to the new {rd|wr}msr_on_cpus interfaces.
- convert pvt->old_mcgctl to a bitmask thus saving some bytes

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  246 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |    3 +-
 2 files changed, 248 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8e14fdd..af6eafd 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3026,3 +3026,249 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
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
+	struct msr msrs[cpumask_weight(cpumask)];
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+
+	if (!ecc_enable_override)
+		return;
+
+	memset(msrs, 0, sizeof(msrs));
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
+	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+
+	for_each_cpu(cpu, cpumask) {
+		if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
+			set_bit(idx, &pvt->old_mcgctl);
+
+		msrs[idx].l |= K8_MSR_MCGCTL_NBE;
+
+		debugf0("%s(), cpu%d, Old MCGCTL[NBE]=0x%x New MCGCTL=0x%x\n",
+			__func__, cpu, test_bit(idx, &pvt->old_mcgctl),
+			(unsigned int) msrs[idx].l);
+
+		idx++;
+	}
+	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
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
+	int idx = 0, cpu;
+	struct msr msrs[cpumask_weight(cpumask)];
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+	int err;
+
+	if (!pvt->nbctl_mcgctl_saved)
+		return;
+
+	memset(msrs, 0, sizeof(msrs));
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
+	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+
+	for_each_cpu(cpu, cpumask) {
+		msrs[idx].l &= ~K8_MSR_MCGCTL_NBE;
+		msrs[idx].l |= test_bit(idx, &pvt->old_mcgctl) << K8_MSR_MCGCTL_NBE;
+		idx++;
+	}
+
+	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
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
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 5a6126c..d435ace 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -70,6 +70,7 @@
 #include <linux/slab.h>
 #include <linux/mmzone.h>
 #include <linux/edac.h>
+#include <asm/msr.h>
 #include "edac_core.h"
 
 #define amd64_printk(level, fmt, arg...) \
@@ -863,7 +864,7 @@ struct amd64_pvt {
 	/* Save old hw registers' values before we modified them */
 	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
 	u32 old_nbctl;
-	u32 *old_mcgctl;		/* per core on this node */
+	unsigned long old_mcgctl;	/* per core on this node */
 
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
-- 
1.6.2.4


