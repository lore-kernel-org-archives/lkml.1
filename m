Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbZEOM15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbZEOM15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762458AbZEOMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:23:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58665 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761273AbZEOMXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:23:04 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-WSS-ID: 0KJOQE1-01-0C7-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 21/22] amd64_edac: add ECC reporting initializers
Date: Fri, 15 May 2009 14:22:32 +0200
Message-ID: <1242390153-24493-22-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:51.0946 (UTC) FILETIME=[DDF4F8A0:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:
- convert to the new {rd|wr}msr_on_cpus interfaces.
- convert pvt->old_mcgctl to a bitmask thus saving some bytes
- fix/cleanup comments
- fix function return value patterns
- add a proper bugfix found by Doug to amd64_check_ecc_enabled where we
  missed checking for the ECC enabled bit in NB CFG.
- cleanup debug calls

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  207 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |    3 +-
 2 files changed, 209 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ed3bb88..6a9d763 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2770,3 +2770,210 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 	return empty;
 }
 
+/*
+ * Only if 'ecc_enable_override' is set AND BIOS had ECC disabled, do "we"
+ * enable it.
+ */
+static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	int cpu, idx = 0, err = 0;
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
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	if (err)
+		debugf0("Reading K8_NBCTL failed\n");
+
+	/* turn on UECCn and CECCEn bits */
+	pvt->old_nbctl = value & mask;
+	pvt->nbctl_mcgctl_saved = 1;
+
+	value |= mask;
+	pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCTL, value);
+
+	rdmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+
+	for_each_cpu(cpu, cpumask) {
+		if (msrs[idx].l & K8_MSR_MCGCTL_NBE)
+			set_bit(idx, &pvt->old_mcgctl);
+
+		msrs[idx].l |= K8_MSR_MCGCTL_NBE;
+		idx++;
+	}
+	wrmsr_on_cpus(cpumask, K8_MSR_MCGCTL, msrs);
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	if (err)
+		debugf0("Reading K8_NBCFG failed\n");
+
+	debugf0("NBCFG(1)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
+		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
+		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
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
+		if (err)
+			debugf0("Reading K8_NBCFG failed\n");
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
+	debugf0("NBCFG(2)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
+		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
+		(value & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled");
+
+	pvt->ctl_error_info.nbcfg = value;
+}
+
+static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
+{
+	const cpumask_t *cpumask = cpumask_of_node(pvt->mc_node_id);
+	int cpu, idx = 0, err = 0;
+	struct msr msrs[cpumask_weight(cpumask)];
+	u32 value;
+	u32 mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
+
+	if (!pvt->nbctl_mcgctl_saved)
+		return;
+
+	memset(msrs, 0, sizeof(msrs));
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
+	if (err)
+		debugf0("Reading K8_NBCTL failed\n");
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
+		msrs[idx].l |=
+			test_bit(idx, &pvt->old_mcgctl) << K8_MSR_MCGCTL_NBE;
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
+	debugf0("core: %u, MCG_CTL: 0x%llx, NB MSR is %s\n",
+		raw_smp_processor_id(), msr_val,
+		(nbe ? "enabled" : "disabled"));
+
+	if (!nbe)
+		*(int *)ret = 0;
+}
+
+/* check MCG_CTL on all the cpus on this node */
+static int amd64_mcg_ctl_enabled_on_cpus(const cpumask_t *mask)
+{
+	int ret = 1;
+	preempt_disable();
+	smp_call_function_many(mask, check_mcg_ctl, &ret, 1);
+	preempt_enable();
+
+	return ret;
+}
+
+/*
+ * EDAC requires that the BIOS have ECC enabled before taking over the
+ * processing of ECC errors. This is because the BIOS can properly initialize
+ * the memory system completely. A command line option allows to force-enable
+ * hardware ECC later in amd64_enable_ecc_error_reporting().
+ */
+static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
+{
+	u32 value;
+	int err = 0, ret = 0;
+	u8 ecc_enabled = 0;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
+	if (err)
+		debugf0("Reading K8_NBCTL failed\n");
+
+	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
+
+	ret = amd64_mcg_ctl_enabled_on_cpus(cpumask_of_node(pvt->mc_node_id));
+
+	debugf0("K8_NBCFG=0x%x,  DRAM ECC is %s\n", value,
+			(value & K8_NBCFG_ECC_ENABLE ? "enabled" : "disabled"));
+
+	if (!ecc_enabled || !ret) {
+		if (!ecc_enabled) {
+			amd64_printk(KERN_WARNING, "This node reports that "
+						   "Memory ECC is currently "
+						   "disabled.\n");
+
+			amd64_printk(KERN_WARNING, "bit 0x%lx in register "
+				"F3x%x of the MISC_CONTROL device (%s) "
+				"should be enabled\n", K8_NBCFG_ECC_ENABLE,
+				K8_NBCFG, pci_name(pvt->misc_f3_ctl));
+		}
+		if (!ret) {
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
+			ret = -ENODEV;
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
+	return ret;
+}
+
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 0406e97..1a3e62d 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -70,6 +70,7 @@
 #include <linux/slab.h>
 #include <linux/mmzone.h>
 #include <linux/edac.h>
+#include <asm/msr.h>
 #include "edac_core.h"
 
 #define amd64_printk(level, fmt, arg...) \
@@ -562,7 +563,7 @@ struct amd64_pvt {
 	/* Save old hw registers' values before we modified them */
 	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
 	u32 old_nbctl;
-	u32 *old_mcgctl;		/* per core on this node */
+	unsigned long old_mcgctl;	/* per core on this node */
 
 	/* MC Type Index value: socket F vs Family 10h */
 	u32 mc_type_index;
-- 
1.6.2.4


