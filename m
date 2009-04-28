Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbZD1PX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbZD1PX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbZD1PVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:21:45 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:9911 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761888AbZD1PVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:21:43 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 11:21:42 EDT
X-BigFish: VPS1(zzzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KITGMP-01-UAK-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/21] amd64_edac: add f10-and-later methods-p2
Date: Tue, 28 Apr 2009 17:06:03 +0200
Message-ID: <1240931173-17477-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:21.0677 (UTC) FILETIME=[E3FD61D0:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  245 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 241 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 9357c62..06315ee 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1752,9 +1752,7 @@ static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
 	return csrow;
 }
 
-static int get_channel_from_x4_syndrome(unsigned short syndrome);
-static int get_channel_from_x8_syndrome(unsigned short syndrome);
-
+static int get_channel_from_ecc_syndrome(unsigned short syndrome);
 
 static void amd64_cpu_display_info(struct amd64_pvt *pvt)
 {
@@ -2174,7 +2172,7 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	/* CHIPKILL enabled */
 	if (info->nbcfg & K8_NBCFG_CHIPKILL) {
 		/* x4 chipkill ecc mode - determine channel */
-		channel = get_channel_from_x4_syndrome(syndrome);
+		channel = get_channel_from_ecc_syndrome(syndrome);
 		if (channel < 0) {
 			/* Syndrome didn't map, so we don't know which of
 			 * the 2 DIMMs is in error. So we need to ID 'both'
@@ -2491,3 +2489,242 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	pvt->dram_limit[dram] =
 		((((u64) high_limit << 32) + (u64) low_limit) << 8) | (0xFF);
 }
+
+/*
+ * f10_read_dram_ctl_register
+ *	Read DRAM Controller Select registers for the F10 that are NOT
+ *	in the K8 series
+ */
+static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
+{
+	int err;
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl,
+				F10_DCTL_SEL_LOW,
+				&pvt->dram_ctl_select_low);
+	if (err != 0) {
+		debugf0("%s() Reading F10_DCTL_SEL_LOW failed\n", __func__);
+	} else {
+		debugf0("%s() DRAM_DCTL_SEL_LOW=0x%x  DctSelBaseAddr=0x%x\n",
+				__func__,
+				pvt->dram_ctl_select_low,
+				dct_sel_baseaddr(pvt));
+
+		debugf0("  DRAM DCTs are=%s DRAM Is=%s DRAM-Ctl-"
+				"sel-hi-range=%s\n",
+				(dct_ganging_enabled(pvt) ? "GANGED "
+							: "NOT GANGED "),
+				(dct_dram_enabled(pvt) ? "Enabled "
+							: "Disabled "),
+				(dct_high_range_enabled(pvt) ? "Enabled "
+							: "Disabled "));
+
+		debugf0("  DctDatIntLv=%s  MemCleared=%s "
+				"DctSelIntLvAddr=0x%x\n",
+				(dct_data_interleave_enabled(pvt) ? "Enabled "
+							: "Disabled"),
+				(dct_memory_cleared(pvt) ? "True " : "False "),
+				dct_sel_interleave_addr(pvt));
+	}
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl,
+				F10_DCTL_SEL_HIGH,
+				&pvt->dram_ctl_select_high);
+	if (err != 0)
+		debugf0("%s() Reading F10_DCTL_SEL_HIGH failed\n",
+			__func__);
+	debugf0("%s() DRAM_CTL_SELECT_HIGH=0x%x\n", __func__,
+			pvt->dram_ctl_select_high);
+}
+
+static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 SystemAddr,
+				int HiRangeSelected, u32 IntlvEn)
+{
+	u32 ChannelSelect;
+	u32 temp = pvt->dram_ctl_select_low;
+	u32 DctSelIntLvAddr, interleave;
+	u32 DctSelHi;
+
+	interleave = dct_interleave_enabled(pvt);
+	DctSelIntLvAddr = dct_sel_interleave_addr(pvt);
+	DctSelHi = (temp >> 1) & 1;
+
+	if (dct_ganging_enabled(pvt))
+		ChannelSelect = 0;
+	else if (HiRangeSelected)
+		ChannelSelect = DctSelHi;
+	else if (interleave) {
+		if (DctSelIntLvAddr == 0)
+			ChannelSelect = SystemAddr >> 6 & 1;
+		else if ((DctSelIntLvAddr >> 1) & 1) {
+			temp = popcnt((u32) ((SystemAddr >> 16) & 0x1F)) % 2;
+
+			if (DctSelIntLvAddr & 1)
+				ChannelSelect = (SystemAddr >> 9 & 1) ^ temp;
+			else
+				ChannelSelect = (SystemAddr >> 6 & 1) ^ temp;
+		} else if (IntlvEn & 4)
+			ChannelSelect = SystemAddr >> 15 & 1;
+		else if (IntlvEn & 2)
+			ChannelSelect = SystemAddr >> 14 & 1;
+		else if (IntlvEn & 1)
+			ChannelSelect = SystemAddr >> 13 & 1;
+		else
+			ChannelSelect = SystemAddr >> 12 & 1;
+	} else if (dct_high_range_enabled(pvt) && !dct_ganging_enabled(pvt))
+		ChannelSelect = ~DctSelHi & 1;
+	else
+		ChannelSelect = 0;
+
+	return ChannelSelect;
+}
+
+static inline u32 f10_map_IntlvEn_to_shift(u32 IntlvEn)
+{
+	u32 shift;
+
+	if (IntlvEn == 1)
+		shift = 1;
+	else if (IntlvEn == 3)
+		shift = 2;
+	else if (IntlvEn == 7)
+		shift = 3;
+	else
+		shift = 0;
+
+	return shift;
+}
+
+static inline u64 f10_determine_base_addr_offset(
+						u64 SystemAddr,
+						int HiRangeSelected,
+						u32 DctSelBaseAddr,
+						u64 DctSelBaseOffsetLong,
+						u32 HoleEn,
+						u32 HoleOffset,
+						u64 DramBaseLong)
+{
+	u64 ChannelAddrLong;
+	u64 ChannelOffsetLong;
+
+	if (HiRangeSelected) {
+		if ((!DctSelBaseAddr & 0xFFFF0000) &&
+		   (HoleEn & 1) && (SystemAddr >= 0x100000000ULL))
+			ChannelOffsetLong = HoleOffset << 16;
+		else
+			ChannelOffsetLong = DctSelBaseOffsetLong;
+	} else {
+		if ((HoleEn & 1) && (SystemAddr >= 0x100000000ULL))
+			ChannelOffsetLong = HoleOffset << 16;
+		else
+			ChannelOffsetLong = DramBaseLong & 0xFFFFF8000000ULL;
+	}
+
+	ChannelAddrLong = (SystemAddr & 0x0000FFFFFFFFFFC0ULL) -
+			(ChannelOffsetLong & 0x0000FFFFFF800000ULL);
+
+	return ChannelAddrLong;
+}
+
+/* Hack for the time being - Can we get this from BIOS?? */
+#define	CH0SPARE_RANK	0
+#define	CH1SPARE_RANK	1
+
+/*
+ * f10_process_possible_spare
+ *
+ *	checks if the csrow passed in is marked as SPARED, if so
+ *	returns the new spare row
+ */
+static inline int f10_process_possible_spare(int csrow,
+				u32 ChannelSelect, struct amd64_pvt *pvt)
+{
+	u32 SwapDone;
+	u32 BadDramCs;
+	u32 OnLineSpareCTL;
+
+	OnLineSpareCTL = pvt->online_spare;
+
+	/* Depending on channel, isolate respective SPARING info */
+	if (ChannelSelect) {
+		SwapDone = F10_ONLINE_SPARE_SWAPDONE1(OnLineSpareCTL);
+		BadDramCs = F10_ONLINE_SPARE_BADDRAM_CS1(OnLineSpareCTL);
+		if (SwapDone && (csrow == BadDramCs))
+			csrow = CH1SPARE_RANK;
+	} else {
+		SwapDone = F10_ONLINE_SPARE_SWAPDONE0(OnLineSpareCTL);
+		BadDramCs = F10_ONLINE_SPARE_BADDRAM_CS0(OnLineSpareCTL);
+		if (SwapDone && (csrow == BadDramCs))
+			csrow = CH0SPARE_RANK;
+	}
+	return csrow;
+}
+
+/*
+ * f10_lookup_addr_in_dct
+ *
+ *	Iterate over the DRAM DCT "base" and "mask" register looking for
+ *	a SystemAddr match on the specified 'ChannelSelect' and 'NodeID'
+ *
+ * Return:
+ *	-1  NOT FOUND
+ *	0..csrow = Chip-Select Row
+ */
+static int f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32 ChannelSelect)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+	u32 CSBase, CSMask;
+	int CSFound = -1;
+	int csrow;
+
+	mci = mci_lookup[NodeID];
+	if (!mci)
+		return CSFound;
+
+	pvt = mci->pvt_info;
+
+	debugf1("%s() InputAddr=0x%x  channelselect=%d\n",
+			__func__, InputAddr, ChannelSelect);
+
+	for (csrow = 0; csrow < CHIPSELECT_COUNT; csrow++) {
+
+		CSBase = amd64_get_dct_base(pvt, ChannelSelect, csrow);
+		if (!(CSBase & K8_DCSB_CS_ENABLE))
+			continue;
+
+		/* We have an ENABLED CSROW, Isolate just the MASK
+		 * bits of the target: 28:19 and 13:5, which map to
+		 * 36:27 and 21:13 of the actual address
+		 */
+		CSBase &= REV_F_F1Xh_DCSB_BASE_BITS;
+
+		/* Get the DCT Mask, and ENABLE the reserved bits:
+		 * 18:16 and 4:0 to become ON. Then mask off bits
+		 * 28:0 (36:8)
+		 */
+		CSMask = amd64_get_dct_mask(pvt, ChannelSelect, csrow);
+
+		debugf1("    CSROW=%d CSBase=0x%x RAW CSMask=0x%x\n",
+				csrow, CSBase, CSMask);
+
+		CSMask = (CSMask | 0x0007C01F) & 0x1FFFFFFF;
+
+		debugf1("              Final CSMask=0x%x\n", CSMask);
+		debugf1("    (InputAddr & ~CSMask)=0x%x "
+				"(CSBase & ~CSMask)=0x%x\n",
+				(InputAddr & ~CSMask), (CSBase & ~CSMask));
+
+		/* Perform the lookup MATCH operation */
+		if ((InputAddr & ~CSMask) == (CSBase & ~CSMask)) {
+			CSFound = f10_process_possible_spare(csrow,
+							ChannelSelect, pvt);
+
+			debugf1(" MATCH csrow=%d\n", CSFound);
+			break;
+		}
+	}
+	return CSFound;
+}
+
+
-- 
1.6.2.4


