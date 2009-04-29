Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZD2Q6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZD2Q6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZD2Qzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32673 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbZD2Qzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:32 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KIVGC0-01-3UP-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/21] amd64_edac: add helper to dump relevant registers
Date: Wed, 29 Apr 2009 18:54:54 +0200
Message-ID: <1241024107-14535-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 16:55:17.0117 (UTC) FILETIME=[45D422D0:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  157 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 157 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 7c2f5fc..4e84ccf 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1751,3 +1751,160 @@ static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
 	return csrow;
 }
 
+static int get_channel_from_x4_syndrome(unsigned short syndrome);
+static int get_channel_from_x8_syndrome(unsigned short syndrome);
+
+
+static void amd64_cpu_display_info(struct amd64_pvt *pvt)
+{
+	if (boot_cpu_data.x86 == 0x11)
+		edac_printk(KERN_DEBUG, EDAC_MC, "F11h CPU detected\n");
+	else if (boot_cpu_data.x86 == 0x10)
+		edac_printk(KERN_DEBUG, EDAC_MC, "F10h CPU detected\n");
+	else if (boot_cpu_data.x86 == 0xf)
+		edac_printk(KERN_DEBUG, EDAC_MC, "%s detected\n",
+			(pvt->ext_model >= OPTERON_CPU_REV_F) ?
+			"Rev F or later" : "Rev E or earlier");
+	else
+		/* we'll hardly ever ever get here */
+		edac_printk(KERN_ERR, EDAC_MC, "Unknown cpu!\n");
+}
+
+/*
+ * amd64_determine_edac_cap
+ *
+ *	Determine if the DIMMs have ECC enabled. ECC is enabled ONLY if all the
+ *	DIMMs are ECC capable.
+ */
+static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
+{
+	int bit;
+	enum dev_type edac_cap = EDAC_NONE;
+
+	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= OPTERON_CPU_REV_F)
+		? 19
+		: 17;
+
+	if (pvt->dclr0 >> BIT(bit)) {
+		debugf1("  edac_type is: EDAC_FLAG_SECDED\n");
+		edac_cap = EDAC_FLAG_SECDED;
+	}
+
+	return edac_cap;
+}
+
+
+static void f10_debug_display_dimm_sizes(int ctrl,
+					struct amd64_pvt *pvt, int ganged);
+
+/*
+ * amd64_dump_misc_regs
+ *
+ *	for debug purposes, display and decode various NB registers that
+ *	are for the f10 family.
+ *
+ *	This function become a no-op when DEBUG is disabled
+ */
+static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
+{
+	int ganged;
+
+	debugf1("  nbcap:0x%8.08x DctDualCap=%s DualNode=%s 8-Node=%s\n",
+		pvt->nbcap,
+		(pvt->nbcap & K8_NBCAP_DCT_DUAL) ? "True" : "False",
+		(pvt->nbcap & K8_NBCAP_DUAL_NODE) ? "True" : "False",
+		(pvt->nbcap & K8_NBCAP_8_NODE) ? "True" : "False");
+	debugf1("    ECC Capable=%s   ChipKill Capable=%s\n",
+		(pvt->nbcap & K8_NBCAP_SECDED) ? "True" : "False",
+		(pvt->nbcap & K8_NBCAP_CHIPKILL) ? "True" : "False");
+	debugf1("  DramCfg0-low=0x%08x DIMM-ECC=%s Parity=%s Width=%s\n",
+		pvt->dclr0,
+		(pvt->dclr0 & BIT(19)) ?  "Enabled" : "Disabled",
+		(pvt->dclr0 & BIT(8)) ?  "Enabled" : "Disabled",
+		(pvt->dclr0 & BIT(11)) ?  "128b" : "64b");
+	debugf1("    DIMM x4 Present: L0=%s L1=%s L2=%s L3=%s  DIMM Type=%s\n",
+		(pvt->dclr0 & BIT(12)) ?  "Y" : "N",
+		(pvt->dclr0 & BIT(13)) ?  "Y" : "N",
+		(pvt->dclr0 & BIT(14)) ?  "Y" : "N",
+		(pvt->dclr0 & BIT(15)) ?  "Y" : "N",
+		(pvt->dclr0 & BIT(16)) ?  "UN-Buffered" : "Buffered");
+
+
+	debugf1("  online-spare: 0x%8.08x\n", pvt->online_spare);
+
+	if (boot_cpu_data.x86 == 0xf) {
+		/* K8 DHAR regiseter */
+		debugf1("  dhar: 0x%8.08x Base=0x%08x Offset=0x%08x\n",
+			pvt->dhar, dhar_base(pvt->dhar),
+			k8_dhar_offset(pvt->dhar));
+		debugf1("      DramHoleValid=%s\n",
+			(pvt->dhar & DHAR_VALID) ?  "True" : "False");
+
+		debugf1("  dbam-dkt: 0x%8.08x\n", pvt->dbam0);
+
+		/* everything below this point is Fam10h and above */
+		return;
+
+	} else {
+		/* F10 DHAR register */
+		debugf1("  dhar: 0x%8.08x Base=0x%08x Offset=0x%08x\n",
+			pvt->dhar, dhar_base(pvt->dhar),
+			f10_dhar_offset(pvt->dhar));
+		debugf1("    DramMemHoistValid=%s DramHoleValid=%s\n",
+			(pvt->dhar & F10_DRAM_MEM_HOIST_VALID) ?
+			"True" : "False",
+			(pvt->dhar & DHAR_VALID) ?
+			"True" : "False");
+	}
+
+	/* Only if NOT ganged does dcl1 have valid info */
+	if (!dct_ganging_enabled(pvt)) {
+		debugf1("  DramCfg1-low=0x%08x DIMM-ECC=%s Parity=%s "
+			"Width=%s\n", pvt->dclr1,
+			(pvt->dclr1 & BIT(19)) ?  "Enabled" : "Disabled",
+			(pvt->dclr1 & BIT(8)) ?  "Enabled" : "Disabled",
+			(pvt->dclr1 & BIT(11)) ?  "128b" : "64b");
+		debugf1("    DIMM x4 Present: L0=%s L1=%s L2=%s L3=%s  "
+			"DIMM Type=%s\n",
+			(pvt->dclr1 & BIT(12)) ?  "Y" : "N",
+			(pvt->dclr1 & BIT(13)) ?  "Y" : "N",
+			(pvt->dclr1 & BIT(14)) ?  "Y" : "N",
+			(pvt->dclr1 & BIT(15)) ?  "Y" : "N",
+			(pvt->dclr1 & BIT(16)) ?  "UN-Buffered" : "Buffered");
+	}
+
+	/*
+	 * Determine if ganged and then dump memory sizes for first controller,
+	 * and if NOT ganged dump info for 2nd controller.
+	 */
+	ganged = dct_ganging_enabled(pvt);
+
+	f10_debug_display_dimm_sizes(0, pvt, ganged);
+
+	if (!ganged)
+		f10_debug_display_dimm_sizes(1, pvt, ganged);
+}
+
+/*
+ * amd64_read_dbam_reg
+ *
+ * Read in both of DBAM registers
+ */
+static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
+{
+	int err;
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM0, &pvt->dbam0);
+	if (err != 0)
+		debugf0("%s() Reading DBAM0 failed\n", __func__);
+
+	if (boot_cpu_data.x86 >= 0x10) {
+		err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1,
+					&pvt->dbam1);
+
+		if (err != 0)
+			debugf0("%s() Reading DBAM1 failed\n", __func__);
+	}
+}
+
+
-- 
1.6.2.4


