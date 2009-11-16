Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZKPOQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZKPOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZKPOQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:16:26 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:20376
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753343AbZKPOQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:23 -0500
X-SpamScore: 2
X-BigFish: VPS2(z41a5izzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ2-01-9KJ-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 06/21] amd64_edac: wrap-up pci config read error handling
Date: Mon, 16 Nov 2009 15:16:33 +0100
Message-ID: <1258381008-18783-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:12.0829 (UTC) FILETIME=[5A051CD0:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pci config read wrapper for signaling pci config space access
errors instead of them being visible only on a debug build. This is
important on amd64_edac since it uses all those pci config register
values to access the DRAM/DIMM configuration of the nodes.

In addition, the wrapper makes a _lot_ (look at the diffstat!) of
error handling code superfluous and improves much of the overall code
readability by removing error handling details out of the way.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  213 ++++++++++++---------------------------------
 drivers/edac/amd64_edac.h |   16 ++++
 2 files changed, 70 insertions(+), 159 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 70c7d5f..3e5ece6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -164,11 +164,9 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
 	u32 scrubval = 0;
-	int status = -1, i, ret = 0;
+	int status = -1, i;
 
-	ret = pci_read_config_dword(pvt->misc_f3_ctl, K8_SCRCTRL, &scrubval);
-	if (ret)
-		debugf0("Reading K8_SCRCTRL failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_SCRCTRL, &scrubval);
 
 	scrubval = scrubval & 0x001F;
 
@@ -909,26 +907,10 @@ static void amd64_dump_misc_regs(struct amd64_pvt *pvt)
 /* Read in both of DBAM registers */
 static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 {
-	int err = 0;
-	unsigned int reg;
+	amd64_read_pci_cfg(pvt->dram_f2_ctl, DBAM0, &pvt->dbam0);
 
-	reg = DBAM0;
-	err = pci_read_config_dword(pvt->dram_f2_ctl, reg, &pvt->dbam0);
-	if (err)
-		goto err_reg;
-
-	if (boot_cpu_data.x86 >= 0x10) {
-		reg = DBAM1;
-		err = pci_read_config_dword(pvt->dram_f2_ctl, reg, &pvt->dbam1);
-
-		if (err)
-			goto err_reg;
-	}
-
-	return;
-
-err_reg:
-	debugf0("Error reading F2x%03x.\n", reg);
+	if (boot_cpu_data.x86 >= 0x10)
+		amd64_read_pci_cfg(pvt->dram_f2_ctl, DBAM1, &pvt->dbam1);
 }
 
 /*
@@ -991,28 +973,21 @@ static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
  */
 static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 {
-	int cs, reg, err = 0;
+	int cs, reg;
 
 	amd64_set_dct_base_and_mask(pvt);
 
 	for (cs = 0; cs < pvt->cs_count; cs++) {
 		reg = K8_DCSB0 + (cs * 4);
-		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
-						&pvt->dcsb0[cs]);
-		if (unlikely(err))
-			debugf0("Reading K8_DCSB0[%d] failed\n", cs);
-		else
+		if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg, &pvt->dcsb0[cs]))
 			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsb0[cs], reg);
 
 		/* If DCT are NOT ganged, then read in DCT1's base */
 		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
 			reg = F10_DCSB1 + (cs * 4);
-			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
-							&pvt->dcsb1[cs]);
-			if (unlikely(err))
-				debugf0("Reading F10_DCSB1[%d] failed\n", cs);
-			else
+			if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg,
+						&pvt->dcsb1[cs]))
 				debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsb1[cs], reg);
 		} else {
@@ -1022,26 +997,20 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 
 	for (cs = 0; cs < pvt->num_dcsm; cs++) {
 		reg = K8_DCSM0 + (cs * 4);
-		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
-					&pvt->dcsm0[cs]);
-		if (unlikely(err))
-			debugf0("Reading K8_DCSM0 failed\n");
-		else
+		if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg, &pvt->dcsm0[cs]))
 			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
 				cs, pvt->dcsm0[cs], reg);
 
 		/* If DCT are NOT ganged, then read in DCT1's mask */
 		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
 			reg = F10_DCSM1 + (cs * 4);
-			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
-					&pvt->dcsm1[cs]);
-			if (unlikely(err))
-				debugf0("Reading F10_DCSM1[%d] failed\n", cs);
-			else
+			if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, reg,
+						&pvt->dcsm1[cs]))
 				debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
 					cs, pvt->dcsm1[cs], reg);
-		} else
+		} else {
 			pvt->dcsm1[cs] = 0;
+		}
 	}
 }
 
@@ -1078,7 +1047,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 {
 	int flag, err = 0;
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	err = amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
 	if (err)
 		return err;
 
@@ -1114,22 +1083,15 @@ static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 {
 	u32 low;
 	u32 off = dram << 3;	/* 8 bytes between DRAM entries */
-	int err;
 
-	err = pci_read_config_dword(pvt->addr_f1_ctl,
-				    K8_DRAM_BASE_LOW + off, &low);
-	if (err)
-		debugf0("Reading K8_DRAM_BASE_LOW failed\n");
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DRAM_BASE_LOW + off, &low);
 
 	/* Extract parts into separate data entries */
 	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 8;
 	pvt->dram_IntlvEn[dram] = (low >> 8) & 0x7;
 	pvt->dram_rw_en[dram] = (low & 0x3);
 
-	err = pci_read_config_dword(pvt->addr_f1_ctl,
-				    K8_DRAM_LIMIT_LOW + off, &low);
-	if (err)
-		debugf0("Reading K8_DRAM_LIMIT_LOW failed\n");
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DRAM_LIMIT_LOW + off, &low);
 
 	/*
 	 * Extract parts into separate data entries. Limit is the HIGHEST memory
@@ -1248,16 +1210,13 @@ static int k8_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
 static int f10_early_channel_count(struct amd64_pvt *pvt)
 {
 	int dbams[] = { DBAM0, DBAM1 };
-	int err = 0, channels = 0;
-	int i, j;
+	int i, j, channels = 0;
 	u32 dbam;
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
-	if (err)
+	if (amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0))
 		goto err_reg;
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
-	if (err)
+	if (amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1))
 		goto err_reg;
 
 	/* If we are in 128 bit mode, then we are using 2 channels */
@@ -1283,8 +1242,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
 	 * both controllers since DIMMs can be placed in either one.
 	 */
 	for (i = 0; i < ARRAY_SIZE(dbams); i++) {
-		err = pci_read_config_dword(pvt->dram_f2_ctl, dbams[i], &dbam);
-		if (err)
+		if (amd64_read_pci_cfg(pvt->dram_f2_ctl, dbams[i], &dbam))
 			goto err_reg;
 
 		for (j = 0; j < 4; j++) {
@@ -1314,7 +1272,7 @@ static void amd64_setup(struct amd64_pvt *pvt)
 {
 	u32 reg;
 
-	pci_read_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
 
 	pvt->flags.cf8_extcfg = !!(reg & F10_NB_CFG_LOW_ENABLE_EXT_CFG);
 	reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
@@ -1326,7 +1284,7 @@ static void amd64_teardown(struct amd64_pvt *pvt)
 {
 	u32 reg;
 
-	pci_read_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
 
 	reg &= ~F10_NB_CFG_LOW_ENABLE_EXT_CFG;
 	if (pvt->flags.cf8_extcfg)
@@ -1355,10 +1313,10 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	high_offset = F10_DRAM_BASE_HIGH + (dram << 3);
 
 	/* read the 'raw' DRAM BASE Address register */
-	pci_read_config_dword(pvt->addr_f1_ctl, low_offset, &low_base);
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, low_offset, &low_base);
 
 	/* Read from the ECS data register */
-	pci_read_config_dword(pvt->addr_f1_ctl, high_offset, &high_base);
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, high_offset, &high_base);
 
 	/* Extract parts into separate data entries */
 	pvt->dram_rw_en[dram] = (low_base & 0x3);
@@ -1375,10 +1333,10 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	high_offset = F10_DRAM_LIMIT_HIGH + (dram << 3);
 
 	/* read the 'raw' LIMIT registers */
-	pci_read_config_dword(pvt->addr_f1_ctl, low_offset, &low_limit);
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, low_offset, &low_limit);
 
 	/* Read from the ECS data register for the HIGH portion */
-	pci_read_config_dword(pvt->addr_f1_ctl, high_offset, &high_limit);
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, high_offset, &high_limit);
 
 	debugf0("  HW Regs: BASE=0x%08x-%08x      LIMIT=  0x%08x-%08x\n",
 		high_base, low_base, high_limit, low_limit);
@@ -1397,13 +1355,9 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 {
-	int err = 0;
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_LOW,
-				    &pvt->dram_ctl_select_low);
-	if (err) {
-		debugf0("Reading F2x110 (DCTL Sel. Low) failed\n");
-	} else {
+	if (!amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCTL_SEL_LOW,
+				&pvt->dram_ctl_select_low)) {
 		debugf0("F2x110 (DCTL Sel. Low): 0x%08x, "
 			"High range addresses at: 0x%x\n",
 			pvt->dram_ctl_select_low,
@@ -1428,10 +1382,8 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
 			dct_sel_interleave_addr(pvt));
 	}
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_HIGH,
-				    &pvt->dram_ctl_select_high);
-	if (err)
-		debugf0("Reading F2x114 (DCT Sel. High) failed\n");
+	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCTL_SEL_HIGH,
+			   &pvt->dram_ctl_select_high);
 }
 
 /*
@@ -2082,40 +2034,24 @@ static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
 {
 	struct amd64_pvt *pvt;
 	struct pci_dev *misc_f3_ctl;
-	int err = 0;
 
 	pvt = mci->pvt_info;
 	misc_f3_ctl = pvt->misc_f3_ctl;
 
-	err = pci_read_config_dword(misc_f3_ctl, K8_NBSH, &regs->nbsh);
-	if (err)
-		goto err_reg;
+	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSH, &regs->nbsh))
+		return 0;
 
 	if (!(regs->nbsh & K8_NBSH_VALID_BIT))
 		return 0;
 
 	/* valid error, read remaining error information registers */
-	err = pci_read_config_dword(misc_f3_ctl, K8_NBSL, &regs->nbsl);
-	if (err)
-		goto err_reg;
-
-	err = pci_read_config_dword(misc_f3_ctl, K8_NBEAL, &regs->nbeal);
-	if (err)
-		goto err_reg;
-
-	err = pci_read_config_dword(misc_f3_ctl, K8_NBEAH, &regs->nbeah);
-	if (err)
-		goto err_reg;
-
-	err = pci_read_config_dword(misc_f3_ctl, K8_NBCFG, &regs->nbcfg);
-	if (err)
-		goto err_reg;
+	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSL, &regs->nbsl) ||
+	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAL, &regs->nbeal) ||
+	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAH, &regs->nbeah) ||
+	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBCFG, &regs->nbcfg))
+		return 0;
 
 	return 1;
-
-err_reg:
-	debugf0("Reading error info register failed\n");
-	return 0;
 }
 
 /*
@@ -2393,7 +2329,7 @@ static void amd64_free_mc_sibling_devices(struct amd64_pvt *pvt)
 static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 {
 	u64 msr_val;
-	int dram, err = 0;
+	int dram;
 
 	/*
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
@@ -2412,9 +2348,7 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 
 	amd64_cpu_display_info(pvt);
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCAP, &pvt->nbcap);
-	if (err)
-		goto err_reg;
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCAP, &pvt->nbcap);
 
 	if (pvt->ops->read_dram_ctl_register)
 		pvt->ops->read_dram_ctl_register(pvt);
@@ -2451,44 +2385,20 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
 
 	amd64_read_dct_base_mask(pvt);
 
-	err = pci_read_config_dword(pvt->addr_f1_ctl, K8_DHAR, &pvt->dhar);
-	if (err)
-		goto err_reg;
-
+	amd64_read_pci_cfg(pvt->addr_f1_ctl, K8_DHAR, &pvt->dhar);
 	amd64_read_dbam_reg(pvt);
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl,
-				F10_ONLINE_SPARE, &pvt->online_spare);
-	if (err)
-		goto err_reg;
+	amd64_read_pci_cfg(pvt->misc_f3_ctl,
+			   F10_ONLINE_SPARE, &pvt->online_spare);
 
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
-	if (err)
-		goto err_reg;
-
-	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCHR_0, &pvt->dchr0);
-	if (err)
-		goto err_reg;
+	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_0, &pvt->dchr0);
 
 	if (!dct_ganging_enabled(pvt)) {
-		err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_1,
-						&pvt->dclr1);
-		if (err)
-			goto err_reg;
-
-		err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCHR_1,
-						&pvt->dchr1);
-		if (err)
-			goto err_reg;
+		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
+		amd64_read_pci_cfg(pvt->dram_f2_ctl, F10_DCHR_1, &pvt->dchr1);
 	}
-
 	amd64_dump_misc_regs(pvt);
-
-	return;
-
-err_reg:
-	debugf0("Reading an MC register failed\n");
-
 }
 
 /*
@@ -2562,13 +2472,11 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 	struct amd64_pvt *pvt;
 	u64 input_addr_min, input_addr_max, sys_addr;
-	int i, err = 0, empty = 1;
+	int i, empty = 1;
 
 	pvt = mci->pvt_info;
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &pvt->nbcfg);
-	if (err)
-		debugf0("Reading K8_NBCFG failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &pvt->nbcfg);
 
 	debugf0("NBCFG= 0x%x  CHIPKILL= %s DRAM ECC= %s\n", pvt->nbcfg,
 		(pvt->nbcfg & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
@@ -2734,7 +2642,6 @@ static int amd64_toggle_ecc_err_reporting(struct amd64_pvt *pvt, bool on)
 static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	int err = 0;
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!ecc_enable_override)
@@ -2744,9 +2651,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		"'ecc_enable_override' parameter is active, "
 		"Enabling AMD ECC hardware now: CAUTION\n");
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
-	if (err)
-		debugf0("Reading K8_NBCTL failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCTL, &value);
 
 	/* turn on UECCn and CECCEn bits */
 	pvt->old_nbctl = value & mask;
@@ -2759,9 +2664,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		amd64_printk(KERN_WARNING, "Error enabling ECC reporting over "
 					   "MCGCTL!\n");
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
-	if (err)
-		debugf0("Reading K8_NBCFG failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
 
 	debugf0("NBCFG(1)= 0x%x  CHIPKILL= %s ECC_ENABLE= %s\n", value,
 		(value & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
@@ -2776,9 +2679,7 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 		value |= K8_NBCFG_ECC_ENABLE;
 		pci_write_config_dword(pvt->misc_f3_ctl, K8_NBCFG, value);
 
-		err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
-		if (err)
-			debugf0("Reading K8_NBCFG failed\n");
+		amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
 
 		if (!(value & K8_NBCFG_ECC_ENABLE)) {
 			amd64_printk(KERN_WARNING,
@@ -2798,15 +2699,12 @@ static void amd64_enable_ecc_error_reporting(struct mem_ctl_info *mci)
 
 static void amd64_restore_ecc_error_reporting(struct amd64_pvt *pvt)
 {
-	int err = 0;
 	u32 value, mask = K8_NBCTL_CECCEn | K8_NBCTL_UECCEn;
 
 	if (!pvt->nbctl_mcgctl_saved)
 		return;
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCTL, &value);
-	if (err)
-		debugf0("Reading K8_NBCTL failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCTL, &value);
 	value &= ~mask;
 	value |= pvt->old_nbctl;
 
@@ -2832,13 +2730,10 @@ static const char *ecc_warning =
 static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 {
 	u32 value;
-	int err = 0;
 	u8 ecc_enabled = 0;
 	bool nb_mce_en = false;
 
-	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &value);
-	if (err)
-		debugf0("Reading K8_NBCTL failed\n");
+	amd64_read_pci_cfg(pvt->misc_f3_ctl, K8_NBCFG, &value);
 
 	ecc_enabled = !!(value & K8_NBCFG_ECC_ENABLE);
 	if (!ecc_enabled)
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index bba6c94..16f2df4 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -565,6 +565,22 @@ static inline struct low_ops *family_ops(int index)
 	return &amd64_family_types[index].ops;
 }
 
+static inline int amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
+					   u32 *val, const char *func)
+{
+	int err = 0;
+
+	err = pci_read_config_dword(pdev, offset, val);
+	if (err)
+		amd64_printk(KERN_WARNING, "%s: error reading F%dx%x.\n",
+			     func, PCI_FUNC(pdev->devfn), offset);
+
+	return err;
+}
+
+#define amd64_read_pci_cfg(pdev, offset, val)	\
+	amd64_read_pci_cfg_dword(pdev, offset, val, __func__)
+
 /*
  * For future CPU versions, verify the following as new 'slow' rates appear and
  * modify the necessary skip values for the supported CPU.
-- 
1.6.4.3


