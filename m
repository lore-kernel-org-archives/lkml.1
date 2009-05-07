Return-Path: <linux-kernel-owner+w=401wt.eu-S1759826AbZEGNvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826AbZEGNvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbZEGNuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:13 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:51520
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754292AbZEGNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:03 -0400
X-BigFish: VPS-13(zz14c3M936eQzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KJA130-01-QXO-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
Date: Thu, 7 May 2009 15:49:33 +0200
Message-ID: <1241704183-29223-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:53.0515 (UTC) FILETIME=[B2F32BB0:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  154 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 154 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 91f414e..0e6a44c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -923,4 +923,158 @@ static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 	}
 }
 
+/*
+ * amd64_set_dct_base_and_mask(pvt)
+ *
+ *	NOTE: CPU Revision Dependent code: Rev E and Rev F
+ *
+ *	Set the DCSB and DCSM mask values depending on the CPU revision value.
+ *	Also set the shift factor for the DCSB and DCSM values.
+ *
+ *	->dcs_mask_notused, REV E:
+ *
+ *	To find the max InputAddr for the csrow, start with the base
+ *	address and set all bits that are "don't care" bits in the test at
+ *	the start of section 3.5.4 (p. 84).
+ *
+ *	The "don't care" bits are all set bits in the mask and
+ *	all bits in the gaps between bit ranges [35-25] and [19-13].
+ *	The value REV_E_DCS_NOTUSED_BITS represents bits [24-20] and [12-0],
+ *	which are all bits in the above-mentioned gaps.
+ *
+ *	->dcs_mask_notused, REV F and later:
+ *
+ *	To find the max InputAddr for the csrow, start with the base
+ *	address and set all bits that are "don't care" bits in the test at
+ *	the start of NPT section 4.5.4 (p. 87).
+ *
+ *	The "don't care" bits are all set bits in the mask and
+ *	all bits in the gaps between bit ranges [36-27] and [21-13].
+ *
+ *	The value REV_F_F1Xh_DCS_NOTUSED_BITS represents bits [26-22] and
+ *	[12-0], which are all bits in the above-mentioned gaps.
+ */
+static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
+{
+	if (pvt->ext_model >= OPTERON_CPU_REV_F) {
+		pvt->dcsb_base        = REV_F_F1Xh_DCSB_BASE_BITS;
+		pvt->dcsm_mask        = REV_F_F1Xh_DCSM_MASK_BITS;
+		pvt->dcs_mask_notused    = REV_F_F1Xh_DCS_NOTUSED_BITS;
+		pvt->dcs_shift        = REV_F_F1Xh_DCS_SHIFT;
+
+		switch (boot_cpu_data.x86) {
+		case 0xf:
+			pvt->num_dcsm = REV_F_DCSM_COUNT;
+			break;
+
+		case 0x10:
+			pvt->num_dcsm = F10_DCSM_COUNT;
+			break;
+
+		case 0x11:
+			pvt->num_dcsm = F11_DCSM_COUNT;
+			break;
+
+		default:
+			amd64_printk(KERN_ERR, "Unsupported family!\n");
+			break;
+		}
+	} else {
+		pvt->dcsb_base        = REV_E_DCSB_BASE_BITS;
+		pvt->dcsm_mask        = REV_E_DCSM_MASK_BITS;
+		pvt->dcs_mask_notused    = REV_E_DCS_NOTUSED_BITS;
+		pvt->dcs_shift        = REV_E_DCS_SHIFT;
+		pvt->num_dcsm        = REV_E_DCSM_COUNT;
+	}
+}
+
+/*
+ * amd64_read_dct_base_mask
+ *
+ *	Function 2 Offset F10_DCSB0
+ *	Read in the DCS Base and DCS Mask hw registers
+ */
+static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
+{
+	int cs;
+	int err;
+	int reg;
+
+	debugf0("%s()\n", __func__);
+
+	amd64_set_dct_base_and_mask(pvt);
+
+	for (cs = 0; cs < CHIPSELECT_COUNT; cs++) {
+		reg = K8_DCSB0 + (cs * 4);
+		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
+						&pvt->dcsb0[cs]);
+		if (unlikely(err))
+			debugf0("%s() Reading K8_DCSB0[%d] failed\n",
+				__func__, cs);
+		else
+			debugf0("  DCSB0[%d]=0x%08x reg: F2x%x\n",
+				cs, pvt->dcsb0[cs], reg);
+
+		/* If DCT are NOT ganged, then read in DCT1's base */
+		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
+			reg = F10_DCSB1 + (cs * 4);
+			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
+							&pvt->dcsb1[cs]);
+			if (err != 0)
+				debugf0("%s() Reading F10_DCSB1[%d] failed\n",
+					__func__, cs);
+			else
+				debugf0("  DCSB1[%d]=0x%08x reg: F2x%x\n",
+					cs, pvt->dcsb1[cs], reg);
+		} else {
+			pvt->dcsb1[cs] = 0;
+		}
+	}
+
+	for (cs = 0; cs < pvt->num_dcsm; cs++) {
+		reg = K8_DCSB0 + (cs * 4);
+		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
+					&pvt->dcsm0[cs]);
+		if (unlikely(err))
+			debugf0("%s() Reading K8_DCSM0 failed\n", __func__);
+		else
+			debugf0("    DCSM0[%d]=0x%08x reg: F2x%x\n",
+				cs, pvt->dcsm0[cs], reg);
+
+		/* If DCT are NOT ganged, then read in DCT1's mask */
+		if (boot_cpu_data.x86 >= 0x10 && !dct_ganging_enabled(pvt)) {
+			reg = F10_DCSM1 + (cs * 4);
+			err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
+					&pvt->dcsm1[cs]);
+			if (unlikely(err))
+				debugf0("%s() Reading F10_DCSM1[%d] failed\n",
+					__func__, cs);
+			else
+				debugf0("    DCSM1[%d]=0x%08x reg: F2x%x\n",
+					cs, pvt->dcsm1[cs], reg);
+		} else
+			pvt->dcsm1[cs] = 0;
+	}
+}
+
+static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
+{
+	enum mem_type type;
+
+	if (boot_cpu_data.x86 >= 0x10 || pvt->ext_model >= OPTERON_CPU_REV_F) {
+		/* Rev F and later */
+		type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
+	} else {
+		/* Rev E and earlier */
+		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
+	}
+
+	debugf1("  Memory type is: %s\n",
+		(type == MEM_DDR2) ? "MEM_DDR2" :
+		(type == MEM_RDDR2) ? "MEM_RDDR2" :
+		(type == MEM_DDR) ? "MEM_DDR" : "MEM_RDDR");
+
+	return type;
+}
+
 
-- 
1.6.2.4


