Return-Path: <linux-kernel-owner+w=401wt.eu-S1763929AbZEOM2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763929AbZEOM2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbZEOMX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:23:26 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:5412 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762546AbZEOMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:23:24 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KJOQDT-02-5LJ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/22] amd64_edac: add helper to dump relevant registers
Date: Fri, 15 May 2009 14:22:22 +0200
Message-ID: <1242390153-24493-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:45.0087 (UTC) FILETIME=[D9DE5EF0:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:

- cleanup/fix comments
- fix function return value patterns
- cleanup dbg calls

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  142 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 28f85c9..3d6d000 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -729,3 +729,145 @@ static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
 	return csrow;
 }
 
+static int get_channel_from_ecc_syndrome(unsigned short syndrome);
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
+ * Determine if the DIMMs have ECC enabled. ECC is enabled ONLY if all the DIMMs
+ * are ECC capable.
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
+	if (pvt->dclr0 >> BIT(bit))
+		edac_cap = EDAC_FLAG_SECDED;
+
+	return edac_cap;
+}
+
+
+static void f10_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt,
+					 int ganged);
+
+/* Display and decode various NB registers for debug purposes. */
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
+/* Read in both of DBAM registers */
+static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
+{
+	int err = 0;
+	unsigned int reg;
+
+	reg = DBAM0;
+	err = pci_read_config_dword(pvt->dram_f2_ctl, reg, &pvt->dbam0);
+	if (err)
+		goto err_reg;
+
+	if (boot_cpu_data.x86 >= 0x10) {
+		reg = DBAM1;
+		err = pci_read_config_dword(pvt->dram_f2_ctl, reg, &pvt->dbam1);
+
+		if (err)
+			goto err_reg;
+	}
+
+err_reg:
+	debugf0("Error reading F2x%03x.\n", reg);
+}
+
-- 
1.6.2.4


