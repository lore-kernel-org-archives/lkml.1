Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbZIXMeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbZIXMeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZIXMeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27287 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZIXMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:17 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz936eMa4a4kzz1202hzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6WE-04-3WB-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Keith Mannthey <kmannth@us.ibm.com>
Subject: [PATCH 08/10] amd64_edac: fix chip select handling
Date: Thu, 24 Sep 2009 14:32:46 +0200
Message-ID: <1253795568-9877-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0319 (UTC) FILETIME=[3EF1D6F0:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different processor families support a different number of chip selects.
Handle this in a family-dependent way with the proper values assigned at
init time (see amd64_set_dct_base_and_mask).

Remove _DCSM_COUNT defines since they're used at one place and originate
from public documentation.

CC: Keith Mannthey <kmannth@us.ibm.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   57 ++++++++++++++++++++------------------------
 drivers/edac/amd64_edac.h |   15 ++++-------
 2 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cb3bbf2..c2c7def 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -189,7 +189,10 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 /* Map from a CSROW entry to the mask entry that operates on it */
 static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
 {
-	return csrow >> (pvt->num_dcsm >> 3);
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_F)
+		return csrow;
+	else
+		return csrow >> 1;
 }
 
 /* return the 'base' address the i'th CS entry of the 'dct' DRAM controller */
@@ -374,7 +377,7 @@ static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
 	 * base/mask register pair, test the condition shown near the start of
 	 * section 3.5.4 (p. 84, BKDG #26094, K8, revA-E).
 	 */
-	for (csrow = 0; csrow < CHIPSELECT_COUNT; csrow++) {
+	for (csrow = 0; csrow < pvt->cs_count; csrow++) {
 
 		/* This DRAM chip select is disabled on this node */
 		if ((pvt->dcsb0[csrow] & K8_DCSB_CS_ENABLE) == 0)
@@ -731,7 +734,7 @@ static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
 	u64 base, mask;
 
 	pvt = mci->pvt_info;
-	BUG_ON((csrow < 0) || (csrow >= CHIPSELECT_COUNT));
+	BUG_ON((csrow < 0) || (csrow >= pvt->cs_count));
 
 	base = base_from_dct_base(pvt, csrow);
 	mask = mask_from_dct_mask(pvt, csrow);
@@ -959,35 +962,27 @@ err_reg:
  */
 static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
 {
-	if (pvt->ext_model >= OPTERON_CPU_REV_F) {
+
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_F) {
+		pvt->dcsb_base		= REV_E_DCSB_BASE_BITS;
+		pvt->dcsm_mask		= REV_E_DCSM_MASK_BITS;
+		pvt->dcs_mask_notused	= REV_E_DCS_NOTUSED_BITS;
+		pvt->dcs_shift		= REV_E_DCS_SHIFT;
+		pvt->cs_count		= 8;
+		pvt->num_dcsm		= 8;
+	} else {
 		pvt->dcsb_base		= REV_F_F1Xh_DCSB_BASE_BITS;
 		pvt->dcsm_mask		= REV_F_F1Xh_DCSM_MASK_BITS;
 		pvt->dcs_mask_notused	= REV_F_F1Xh_DCS_NOTUSED_BITS;
 		pvt->dcs_shift		= REV_F_F1Xh_DCS_SHIFT;
 
-		switch (boot_cpu_data.x86) {
-		case 0xf:
-			pvt->num_dcsm = REV_F_DCSM_COUNT;
-			break;
-
-		case 0x10:
-			pvt->num_dcsm = F10_DCSM_COUNT;
-			break;
-
-		case 0x11:
-			pvt->num_dcsm = F11_DCSM_COUNT;
-			break;
-
-		default:
-			amd64_printk(KERN_ERR, "Unsupported family!\n");
-			break;
+		if (boot_cpu_data.x86 == 0x11) {
+			pvt->cs_count = 4;
+			pvt->num_dcsm = 2;
+		} else {
+			pvt->cs_count = 8;
+			pvt->num_dcsm = 4;
 		}
-	} else {
-		pvt->dcsb_base		= REV_E_DCSB_BASE_BITS;
-		pvt->dcsm_mask		= REV_E_DCSM_MASK_BITS;
-		pvt->dcs_mask_notused	= REV_E_DCS_NOTUSED_BITS;
-		pvt->dcs_shift		= REV_E_DCS_SHIFT;
-		pvt->num_dcsm		= REV_E_DCSM_COUNT;
 	}
 }
 
@@ -1000,7 +995,7 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
 
 	amd64_set_dct_base_and_mask(pvt);
 
-	for (cs = 0; cs < CHIPSELECT_COUNT; cs++) {
+	for (cs = 0; cs < pvt->cs_count; cs++) {
 		reg = K8_DCSB0 + (cs * 4);
 		err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
 						&pvt->dcsb0[cs]);
@@ -1563,7 +1558,7 @@ static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
 
 	debugf1("InputAddr=0x%x  channelselect=%d\n", in_addr, cs);
 
-	for (csrow = 0; csrow < CHIPSELECT_COUNT; csrow++) {
+	for (csrow = 0; csrow < pvt->cs_count; csrow++) {
 
 		cs_base = amd64_get_dct_base(pvt, cs, csrow);
 		if (!(cs_base & K8_DCSB_CS_ENABLE))
@@ -2494,7 +2489,7 @@ err_reg:
  * NOTE: CPU Revision Dependent code
  *
  * Input:
- *	@csrow_nr ChipSelect Row Number (0..CHIPSELECT_COUNT-1)
+ *	@csrow_nr ChipSelect Row Number (0..pvt->cs_count-1)
  *	k8 private pointer to -->
  *			DRAM Bank Address mapping register
  *			node_id
@@ -2574,7 +2569,7 @@ static int amd64_init_csrows(struct mem_ctl_info *mci)
 		(pvt->nbcfg & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled"
 		);
 
-	for (i = 0; i < CHIPSELECT_COUNT; i++) {
+	for (i = 0; i < pvt->cs_count; i++) {
 		csrow = &mci->csrows[i];
 
 		if ((pvt->dcsb0[i] & K8_DCSB_CS_ENABLE) == 0) {
@@ -3000,7 +2995,7 @@ static int amd64_init_2nd_stage(struct amd64_pvt *pvt)
 		goto err_exit;
 
 	ret = -ENOMEM;
-	mci = edac_mc_alloc(0, CHIPSELECT_COUNT, pvt->channel_count, node_id);
+	mci = edac_mc_alloc(0, pvt->cs_count, pvt->channel_count, node_id);
 	if (!mci)
 		goto err_exit;
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index ea96f5a..6a22b1e 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -147,7 +147,7 @@
 #define OPTERON_CPU_REV_FA		5
 
 /* Hardware limit on ChipSelect rows per MC and processors per system */
-#define CHIPSELECT_COUNT		8
+#define MAX_CS_COUNT			8
 #define DRAM_REG_COUNT			8
 
 
@@ -198,7 +198,6 @@
  */
 #define REV_E_DCSB_BASE_BITS		(0xFFE0FE00ULL)
 #define REV_E_DCS_SHIFT			4
-#define REV_E_DCSM_COUNT		8
 
 #define REV_F_F1Xh_DCSB_BASE_BITS	(0x1FF83FE0ULL)
 #define REV_F_F1Xh_DCS_SHIFT		8
@@ -209,9 +208,6 @@
  */
 #define REV_F_DCSB_BASE_BITS		(0x1FF83FE0ULL)
 #define REV_F_DCS_SHIFT			8
-#define REV_F_DCSM_COUNT		4
-#define F10_DCSM_COUNT			4
-#define F11_DCSM_COUNT			2
 
 /* DRAM CS Mask Registers */
 #define K8_DCSM0			0x60
@@ -447,12 +443,12 @@ struct amd64_pvt {
 	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
 
 	/* DRAM CS Base Address Registers F2x[1,0][5C:40] */
-	u32 dcsb0[CHIPSELECT_COUNT];
-	u32 dcsb1[CHIPSELECT_COUNT];
+	u32 dcsb0[MAX_CS_COUNT];
+	u32 dcsb1[MAX_CS_COUNT];
 
 	/* DRAM CS Mask Registers F2x[1,0][6C:60] */
-	u32 dcsm0[CHIPSELECT_COUNT];
-	u32 dcsm1[CHIPSELECT_COUNT];
+	u32 dcsm0[MAX_CS_COUNT];
+	u32 dcsm1[MAX_CS_COUNT];
 
 	/*
 	 * Decoded parts of DRAM BASE and LIMIT Registers
@@ -472,6 +468,7 @@ struct amd64_pvt {
 	 */
 	u32 dcsb_base;		/* DCSB base bits */
 	u32 dcsm_mask;		/* DCSM mask bits */
+	u32 cs_count;		/* num chip selects (== num DCSB registers) */
 	u32 num_dcsm;		/* Number of DCSM registers */
 	u32 dcs_mask_notused;	/* DCSM notused mask bits */
 	u32 dcs_shift;		/* DCSB and DCSM shift value */
-- 
1.6.3.3


