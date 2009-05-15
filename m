Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbZEOMyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbZEOMyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbZEOMyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:54:44 -0400
Received: from mail-sin.bigfish.com ([207.46.51.102]:38057 "EHLO
	mail105-sin-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756960AbZEOMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:54:43 -0400
X-BigFish: VPS1(zzzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0KJOQDV-02-5LK-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
Cc: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 15/22] amd64_edac: add F10h-and-later methods-p2
Date: Fri, 15 May 2009 14:22:26 +0200
Message-Id: <1242390153-24493-16-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:48.0102 (UTC) FILETIME=[DBAA6C60:01C9D557]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:

- remove StinkyIdentifiers, trivially simplify code.
- fix/cleanup comments
- fix function return value patterns

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  196 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 196 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index b4ef2c7..dbb4c18 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1367,3 +1367,199 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	pvt->dram_limit[dram] =
 		((((u64) high_limit << 32) + (u64) low_limit) << 8) | (0xFF);
 }
+
+static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
+{
+	int err = 0;
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_LOW,
+				    &pvt->dram_ctl_select_low);
+	if (err) {
+		debugf0("Reading F10_DCTL_SEL_LOW failed\n");
+	} else {
+		debugf0("DRAM_DCTL_SEL_LOW=0x%x  DctSelBaseAddr=0x%x\n",
+			pvt->dram_ctl_select_low, dct_sel_baseaddr(pvt));
+
+		debugf0("  DRAM DCTs are=%s DRAM Is=%s DRAM-Ctl-"
+				"sel-hi-range=%s\n",
+			(dct_ganging_enabled(pvt) ? "GANGED" : "NOT GANGED"),
+			(dct_dram_enabled(pvt) ? "Enabled"   : "Disabled"),
+			(dct_high_range_enabled(pvt) ? "Enabled" : "Disabled"));
+
+		debugf0("  DctDatIntLv=%s MemCleared=%s DctSelIntLvAddr=0x%x\n",
+			(dct_data_intlv_enabled(pvt) ? "Enabled" : "Disabled"),
+			(dct_memory_cleared(pvt) ? "True " : "False "),
+			dct_sel_interleave_addr(pvt));
+	}
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCTL_SEL_HIGH,
+				    &pvt->dram_ctl_select_high);
+	if (err)
+		debugf0("Reading F10_DCTL_SEL_HIGH failed\n");
+}
+
+static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
+				int hi_range_sel, u32 intlv_en)
+{
+	u32 cs, temp, dct_sel_high = (pvt->dram_ctl_select_low >> 1) & 1;
+
+	if (dct_ganging_enabled(pvt))
+		cs = 0;
+	else if (hi_range_sel)
+		cs = dct_sel_high;
+	else if (dct_interleave_enabled(pvt)) {
+		if (dct_sel_interleave_addr(pvt) == 0)
+			cs = sys_addr >> 6 & 1;
+		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
+			temp = popcnt((u32) ((sys_addr >> 16) & 0x1F)) % 2;
+
+			if (dct_sel_interleave_addr(pvt) & 1)
+				cs = (sys_addr >> 9 & 1) ^ temp;
+			else
+				cs = (sys_addr >> 6 & 1) ^ temp;
+		} else if (intlv_en & 4)
+			cs = sys_addr >> 15 & 1;
+		else if (intlv_en & 2)
+			cs = sys_addr >> 14 & 1;
+		else if (intlv_en & 1)
+			cs = sys_addr >> 13 & 1;
+		else
+			cs = sys_addr >> 12 & 1;
+	} else if (dct_high_range_enabled(pvt) && !dct_ganging_enabled(pvt))
+		cs = ~dct_sel_high & 1;
+	else
+		cs = 0;
+
+	return cs;
+}
+
+static inline u32 f10_map_intlv_en_to_shift(u32 intlv_en)
+{
+	if (intlv_en == 1)
+		return 1;
+	else if (intlv_en == 3)
+		return 2;
+	else if (intlv_en == 7)
+		return 3;
+
+	return 0;
+}
+
+static inline u64 f10_determine_base_addr_offset(u64 sys_addr, int hi_range_sel,
+						 u32 dct_sel_base_addr,
+						 u64 dct_sel_base_off,
+						 u32 hole_en, u32 hole_off,
+						 u64 dram_base)
+{
+	u64 chan_off;
+
+	if (hi_range_sel) {
+		if ((!dct_sel_base_addr & 0xFFFF0000) &&
+		   (hole_en & 1) && (sys_addr >= 0x100000000ULL))
+			chan_off = hole_off << 16;
+		else
+			chan_off = dct_sel_base_off;
+	} else {
+		if ((hole_en & 1) && (sys_addr >= 0x100000000ULL))
+			chan_off = hole_off << 16;
+		else
+			chan_off = dram_base & 0xFFFFF8000000ULL;
+	}
+
+	return (sys_addr & 0x0000FFFFFFFFFFC0ULL) -
+			(chan_off & 0x0000FFFFFF800000ULL);
+}
+
+/* Hack for the time being - Can we get this from BIOS?? */
+#define	CH0SPARE_RANK	0
+#define	CH1SPARE_RANK	1
+
+/*
+ * checks if the csrow passed in is marked as SPARED, if so returns the new
+ * spare row
+ */
+static inline int f10_process_possible_spare(int csrow,
+				u32 cs, struct amd64_pvt *pvt)
+{
+	u32 swap_done;
+	u32 bad_dram_cs;
+
+	/* Depending on channel, isolate respective SPARING info */
+	if (cs) {
+		swap_done = F10_ONLINE_SPARE_SWAPDONE1(pvt->online_spare);
+		bad_dram_cs = F10_ONLINE_SPARE_BADDRAM_CS1(pvt->online_spare);
+		if (swap_done && (csrow == bad_dram_cs))
+			csrow = CH1SPARE_RANK;
+	} else {
+		swap_done = F10_ONLINE_SPARE_SWAPDONE0(pvt->online_spare);
+		bad_dram_cs = F10_ONLINE_SPARE_BADDRAM_CS0(pvt->online_spare);
+		if (swap_done && (csrow == bad_dram_cs))
+			csrow = CH0SPARE_RANK;
+	}
+	return csrow;
+}
+
+/*
+ * Iterate over the DRAM DCT "base" and "mask" registers looking for a
+ * SystemAddr match on the specified 'ChannelSelect' and 'NodeID'
+ *
+ * Return:
+ *	-EINVAL:  NOT FOUND
+ *	0..csrow = Chip-Select Row
+ */
+static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+	u32 cs_base, cs_mask;
+	int cs_found = -EINVAL;
+	int csrow;
+
+	mci = mci_lookup[nid];
+	if (!mci)
+		return cs_found;
+
+	pvt = mci->pvt_info;
+
+	debugf1("InputAddr=0x%x  channelselect=%d\n", in_addr, cs);
+
+	for (csrow = 0; csrow < CHIPSELECT_COUNT; csrow++) {
+
+		cs_base = amd64_get_dct_base(pvt, cs, csrow);
+		if (!(cs_base & K8_DCSB_CS_ENABLE))
+			continue;
+
+		/*
+		 * We have an ENABLED CSROW, Isolate just the MASK bits of the
+		 * target: [28:19] and [13:5], which map to [36:27] and [21:13]
+		 * of the actual address.
+		 */
+		cs_base &= REV_F_F1Xh_DCSB_BASE_BITS;
+
+		/*
+		 * Get the DCT Mask, and ENABLE the reserved bits: [18:16] and
+		 * [4:0] to become ON. Then mask off bits [28:0] ([36:8])
+		 */
+		cs_mask = amd64_get_dct_mask(pvt, cs, csrow);
+
+		debugf1("    CSROW=%d CSBase=0x%x RAW CSMask=0x%x\n",
+				csrow, cs_base, cs_mask);
+
+		cs_mask = (cs_mask | 0x0007C01F) & 0x1FFFFFFF;
+
+		debugf1("              Final CSMask=0x%x\n", cs_mask);
+		debugf1("    (InputAddr & ~CSMask)=0x%x "
+				"(CSBase & ~CSMask)=0x%x\n",
+				(in_addr & ~cs_mask), (cs_base & ~cs_mask));
+
+		if ((in_addr & ~cs_mask) == (cs_base & ~cs_mask)) {
+			cs_found = f10_process_possible_spare(csrow, cs, pvt);
+
+			debugf1(" MATCH csrow=%d\n", cs_found);
+			break;
+		}
+	}
+	return cs_found;
+}
+
+
-- 
1.6.2.4


