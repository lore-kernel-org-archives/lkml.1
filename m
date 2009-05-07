Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbZEGN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbZEGN4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZEGNuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:40 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:54226 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755963AbZEGNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:12 -0400
X-BigFish: VPS1(zzzz1202hzzz32i)
X-FB-SS: 5,
X-WSS-ID: 0KJA131-02-CLB-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/21] amd64_edac: add F10h-and-later methods-p1
Date: Thu, 7 May 2009 15:49:35 +0200
Message-ID: <1241704183-29223-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:54.0531 (UTC) FILETIME=[B38E3330:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  233 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 233 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4b0b25b..2aa3065 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1272,4 +1272,237 @@ static int k8_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
 	return nr_pages;
 }
 
+/*
+ * f10_early_channel_count
+ *
+ * Get the number of DCT channels in use
+ *
+ * Return:
+ *	number of Memory Channels in operation
+ * Pass back:
+ *	contents of the DCL0_LOW register
+ */
+static int f10_early_channel_count(struct amd64_pvt *pvt)
+{
+	int err;
+	int channels = 0;
+	u32 dbam;
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	if (err != 0)
+		debugf0("%s() Reading F10_DCLR_0 failed\n", __func__);
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_1, &pvt->dclr1);
+	if (err != 0)
+		debugf0("%s() Reading F10_DCLR_0 failed\n", __func__);
+
+	/* If we are in 128 bit mode, then we are using 2 channels */
+	if (pvt->dclr0 & F10_WIDTH_128) {
+		debugf0("%s() Data WIDTH is 128 bits - 2 channels\n",
+			__func__);
+		channels = 2;
+		return channels;
+	}
+
+	/* Need to check if in UN-ganged mode: In such, there are 2
+	 * channels, but they are NOT in 128 bit mode and thus the above
+	 * 'dcl0' status bit will be OFF, but there still are 2 channels
+	 *
+	 * Need to check DCT0[0] and DCT1[0] to see if only one of them
+	 * has their CSEnable bit on. If so, then SINGLE DIMM case.
+	 */
+	debugf0("%s() Data WIDTH is NOT 128 bits - need more decoding\n",
+		__func__);
+
+	/* Check DRAM Bank Address Mapping values for each DIMM
+	 * to see if there is more than just one DIMM present in an
+	 * unganged mode. Need to check both controllers sinc DIMMs
+	 * can be placed in either one
+	 */
+	channels = 0;
+	err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM0, &dbam);
+	if (err != 0)
+		debugf0("%s() Reading DBAM0 failed\n", __func__);
+
+	if (DBAM_DIMM(0, dbam) > 0)
+		channels++;
+	if (DBAM_DIMM(1, dbam) > 0)
+		channels++;
+	if (DBAM_DIMM(2, dbam) > 0)
+		channels++;
+	if (DBAM_DIMM(3, dbam) > 0)
+		channels++;
+
+	/* If more than 2 DIMMs are present, then we have 2 channels */
+	if (channels > 2)
+		channels = 2;
+	else if (channels == 0) {
+		/* No DIMMs on DCT0, so look at DCT1 */
+		err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM0, &dbam);
+		if (err != 0)
+			debugf0("%s() Reading DBAM1 failed\n", __func__);
+
+		if (DBAM_DIMM(0, dbam) > 0)
+			channels++;
+		if (DBAM_DIMM(1, dbam) > 0)
+			channels++;
+		if (DBAM_DIMM(2, dbam) > 0)
+			channels++;
+		if (DBAM_DIMM(3, dbam) > 0)
+			channels++;
+
+		if (channels > 2)
+			channels = 2;
+	}
+
+	/* If we found ALL 0 values, then assume just ONE DIMM-ONE Channel */
+	if (channels == 0)
+		channels = 1;
+
+	debugf0("%s() DIMM count= %d\n", __func__, channels);
+
+	return channels;
+}
+
+/*
+ * f10_dbam_map_to_pages
+ */
+static int f10_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
+{
+	return 1 << (revf_quad_ddr2_shift[dram_map] - PAGE_SHIFT);
+}
+
+/*
+ * amd64_setup
+ *
+ *	Perform needed operations on this NB thare are needed
+ *	for the duration of time that the module is operating
+ *
+ *	1) Enable "extended configuration access via 0xCF8" feature
+ */
+static void amd64_setup(struct amd64_pvt *pvt)
+{
+	u32 reg;
+	int err;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	if (err != 0)
+		debugf0("%s() Reading F10_NB_CFG_HIGH failed\n",
+			__func__);
+
+	pvt->flags.cf8_extcfg = !!(reg & F10_NB_CFG_LOW_ENABLE_EXT_CFG);
+	reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, reg);
+}
+
+/*
+ * amd64_teardown
+ *
+ *	teardown any items that were 'setup' in the setup func
+ *
+ *	1) Restore the "extended configuration access via 0xCF8" feature
+ */
+static void amd64_teardown(struct amd64_pvt *pvt)
+{
+	u32 reg;
+	int err;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, &reg);
+	if (err != 0)
+		debugf0("%s() Reading F10_NB_CFG_HIGH failed\n",
+			__func__);
+
+	reg &= ~F10_NB_CFG_LOW_ENABLE_EXT_CFG;
+	if (pvt->flags.cf8_extcfg)
+		reg |= F10_NB_CFG_LOW_ENABLE_EXT_CFG;
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_CFG_HIGH, reg);
+}
+
+/*
+ * f10_get_error_address
+ *	extract from the hardware copies of the error register
+ *	the ERROR ADDRESS for Family 10h CPUs
+ */
+static u64 f10_get_error_address(struct mem_ctl_info *mci,
+			struct amd64_error_info_regs *info)
+{
+	return (((u64) (info->nbeah & 0xffff)) << 32) +
+			(info->nbeal & ~0x01);
+}
+
+/*
+ * f10_read_dram_base_limit
+ *
+ *	Read the Base and Limit registers for F10 based Memory controllers
+ *	Extract fields from the 'raw' reg into separate data fields
+ *
+ *		Isolates: BASE, LIMIT, IntlvEn, IntlvSel, RW_EN
+ */
+static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
+{
+	u32 high_offset;
+	u32 low_offset;
+	u32 high_base;
+	u32 low_base;
+	u32 high_limit;
+	u32 low_limit;
+	int err;
+
+	low_offset = K8_DRAM_BASE_LOW + (dram << 3);
+	high_offset = F10_DRAM_BASE_HIGH + (dram << 3);
+
+	/* read the 'raw' DRAM BASE Address register */
+	err = pci_read_config_dword(pvt->addr_f1_ctl, low_offset, &low_base);
+	if (err != 0)
+		debugf0("%s() Reading low_offset= 0x%x failed\n", __func__,
+			low_offset);
+
+	/* Read from the ECS data register */
+	err = pci_read_config_dword(pvt->addr_f1_ctl,
+					high_offset, &high_base);
+	if (err != 0)
+		debugf0("%s() Reading high_offset= 0x%x failed. Default=0\n",
+			__func__, high_offset);
+
+	/* Extract parts into separate data entries */
+	pvt->dram_rw_en[dram] = (low_base & 0x3);
+
+	if (pvt->dram_rw_en[dram] == 0)
+		return;
+
+	pvt->dram_IntlvEn[dram] = (low_base >> 8) & 0x7;
+
+	pvt->dram_base[dram] = (((((u64) high_base & 0x000000FF) << 32) |
+				((u64) low_base & 0xFFFF0000))) << 8;
 
+	low_offset = K8_DRAM_LIMIT_LOW + (dram << 3);
+	high_offset = F10_DRAM_LIMIT_HIGH + (dram << 3);
+
+	/* read the 'raw' LIMIT registers */
+	err = pci_read_config_dword(pvt->addr_f1_ctl, low_offset, &low_limit);
+	if (err != 0)
+		debugf0("%s() Reading low_offset= 0x%x failed\n", __func__,
+			low_offset);
+
+	/* Read from the ECS data register for the HIGH portion */
+	err = pci_read_config_dword(pvt->addr_f1_ctl,
+			high_offset, &high_limit);
+	if (err != 0)
+		debugf0("%s() Reading high_ofset= 0x%x failed\n", __func__,
+			high_offset);
+
+	debugf0("%s() on dram=%d\n", __func__, dram);
+	debugf0("  HW Regs: BASE=0x%08x-%08x      LIMIT=  0x%08x-%08x\n",
+		high_base, low_base, high_limit, low_limit);
+
+	pvt->dram_DstNode[dram] = (low_limit & 0x7);
+	pvt->dram_IntlvSel[dram] = (low_limit >> 8) & 0x7;
+
+	/* Extract address values and form a LIMIT address
+	 * Limit is the HIGHEST memory location of the region, so lower
+	 * 24-bit needs to be all ones
+	 */
+	low_limit |= 0x0000FFFF;
+	pvt->dram_limit[dram] =
+		((((u64) high_limit << 32) + (u64) low_limit) << 8) | (0xFF);
+}
-- 
1.6.2.4


