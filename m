Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZD2Q7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZD2Q7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757839AbZD2Qzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32680 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZD2Qzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:36 -0400
X-BigFish: VPS-1(zz1fa4Lzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KIVGC2-01-3UW-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Date: Wed, 29 Apr 2009 18:54:59 +0200
Message-ID: <1241024107-14535-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 16:55:19.0835 (UTC) FILETIME=[4772DEB0:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  318 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 318 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index fe2342c..84075c0 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2726,4 +2726,322 @@ static int f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32 ChannelSelect)
 	return CSFound;
 }
 
+/*
+ * f10_match_to_this_node
+ *
+ * For a given 'DramRange' value, check if 'SystemAddr' fall within this value
+ */
+static int f10_match_to_this_node(struct amd64_pvt *pvt, int DramRange,
+				u64 SystemAddr,
+				int *node_id,
+				int *channel_select)
+{
+	int CSFound = -1;
+	int NodeID;
+	int HiRangeSelected;
+	u32 IntlvEn, IntlvSel;
+	u32 DramEn;
+	u32 Ilog;
+	u32 HoleOffset, HoleEn;
+	u32 InputAddr, Temp;
+	u32 DctSelBaseAddr, DctSelIntLvAddr;
+	u32 DctSelHi;
+	u32 ChannelSelect;
+	u64 DramBaseLong, DramLimitLong;
+	u64 DctSelBaseOffsetLong, ChannelAddrLong;
+
+	/* DRAM Base value for this DRAM instance */
+	DramBaseLong = pvt->dram_base[DramRange];
+	DramEn = pvt->dram_rw_en[DramRange];
+	IntlvEn = pvt->dram_IntlvEn[DramRange];
+
+	/* DRAM Limit value for this DRAM instance */
+	DramLimitLong = pvt->dram_limit[DramRange];
+	NodeID = pvt->dram_DstNode[DramRange];
+	IntlvSel = pvt->dram_IntlvSel[DramRange];
+
+	debugf1("%s(dram=%d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
+		__func__, DramRange, DramBaseLong, SystemAddr, DramLimitLong);
+
+	/* This assumes that one node's DHAR is the same as
+	 * all the other node's DHARs
+	 */
+	HoleEn = pvt->dhar;
+	HoleOffset = (HoleEn & 0x0000FF80);
+	HoleEn = (HoleEn & 0x00000003);
+
+	debugf1("   HoleOffset=0x%x  HoleEn=0x%x IntlvSel=0x%x\n",
+			HoleOffset, HoleEn, IntlvSel);
+
+	if ((IntlvEn == 0) || IntlvSel == ((SystemAddr >> 12) & IntlvEn)) {
+
+		Ilog = f10_map_IntlvEn_to_shift(IntlvEn);
+
+		Temp = pvt->dram_ctl_select_low;
+		DctSelBaseOffsetLong = pvt->dram_ctl_select_high << 16;
+
+		DctSelHi = (Temp >> 1) & 1;
+		DctSelIntLvAddr = dct_sel_interleave_addr(pvt);
+		DctSelBaseAddr = dct_sel_baseaddr(pvt);
+
+		if (dct_high_range_enabled(pvt) &&
+		   !dct_ganging_enabled(pvt) &&
+		   ((SystemAddr >> 27) >= (DctSelBaseAddr >> 11)))
+			HiRangeSelected = 1;
+		else
+			HiRangeSelected = 0;
+
+		ChannelSelect = f10_determine_channel(pvt, SystemAddr,
+						HiRangeSelected, IntlvEn);
+
+		ChannelAddrLong = f10_determine_base_addr_offset(
+						SystemAddr,
+						HiRangeSelected,
+						DctSelBaseAddr,
+						DctSelBaseOffsetLong,
+						HoleEn,
+						HoleOffset,
+						DramBaseLong);
+
+		/* Remove Node ID (in case of processor interleaving) */
+		Temp = ChannelAddrLong & 0xFC0;
+
+		ChannelAddrLong = ((ChannelAddrLong >> Ilog) &
+					0xFFFFFFFFF000ULL) | Temp;
+
+		/* Remove Channel interleave and hash */
+		if (dct_interleave_enabled(pvt) &&
+		   !dct_high_range_enabled(pvt) &&
+		   !dct_ganging_enabled(pvt)) {
+			if (DctSelIntLvAddr != 1)
+				ChannelAddrLong =
+					(ChannelAddrLong >> 1) &
+					0xFFFFFFFFFFFFFFC0ULL;
+			else {
+				Temp = ChannelAddrLong & 0xFC0;
+				ChannelAddrLong =
+					((ChannelAddrLong &
+					0xFFFFFFFFFFFFC000ULL)
+					>> 1) | Temp;
+			}
+		}
+
+		/* Form a normalize InputAddr (Move bits 36:8 down to 28:0
+		 * which will set it up to match the DCT Base register
+		 */
+		InputAddr = ChannelAddrLong >> 8;
+
+		debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes "
+			"InputAddr=0x%x\n", ChannelAddrLong, InputAddr);
+
+		/* Iterate over the DRAM DCTs looking for a
+		 * match for InputAddr on the selected NodeID
+		 */
+		CSFound = f10_lookup_addr_in_dct(InputAddr,
+						NodeID, ChannelSelect);
+
+		if (CSFound >= 0) {
+			*node_id = NodeID;
+			*channel_select = ChannelSelect;
+		}
+	}
+
+	return CSFound;
+}
+
+static int f10_translate_sysaddr_to_CS(struct amd64_pvt *pvt,
+			u64 SysAddr,
+			int *node,
+			int *chanSel)
+{
+	int DramRange;
+	int CSFound = -1;
+	u64 DramBaseLong, DramLimitLong;
+
+	for (DramRange = 0; DramRange < DRAM_REG_COUNT; DramRange++) {
+
+		if (!pvt->dram_rw_en[DramRange])
+			continue;
+
+		DramBaseLong = pvt->dram_base[DramRange];
+		DramLimitLong = pvt->dram_limit[DramRange];
+
+		if ((DramBaseLong <= SysAddr) && (SysAddr <= DramLimitLong)) {
+
+			CSFound = f10_match_to_this_node(pvt,
+							DramRange, SysAddr,
+							node, chanSel);
+			if (CSFound >= 0)
+				break;
+		}
+	}
+	return CSFound;
+}
+
+/*
+ * f10_map_sysaddr_to_csrow
+ *
+ *	This the F10 reference code from AMD to
+ *	map a SystemAddress to NodeID, CSROW, Channel
+ *
+ *	See the Family 10h BKDG (with bug fixes in the code from AMD)
+ *
+ *	The SystemAddress is usually an error address received from the
+ *	hardware error detector.
+ */
+static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
+					struct amd64_error_info_regs *info,
+					u64 SystemAddress)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 page, offset;
+	unsigned short syndrome;
+	int chan = 0;
+	int node_id;
+	int csrow;
+
+	csrow = f10_translate_sysaddr_to_CS(pvt,
+					SystemAddress,
+					&node_id,
+					&chan);
+
+	if (csrow >= 0) {
+		error_address_to_page_and_offset(SystemAddress, &page, &offset);
+
+		syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
+		syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+
+		/* Is CHIPKILL ON?
+		 * If so, then we can attempt to use the 'syndrome' to isolate
+		 * which channel the error was on
+		 */
+		if (pvt->nbcfg & K8_NBCFG_CHIPKILL)
+			chan = get_channel_from_ecc_syndrome(syndrome);
+
+		if (chan >= 0) {
+			edac_mc_handle_ce(mci, page, offset, syndrome,
+					csrow, chan, EDAC_MOD_STR);
+		} else {
+			/* Channel is not known,
+			 * report all channels on this CSROW as failed.
+			 */
+			for (chan = 0; chan < mci->csrows[csrow].nr_channels;
+								chan++) {
+					edac_mc_handle_ce(mci, page, offset,
+							syndrome,
+							csrow, chan,
+							EDAC_MOD_STR);
+			}
+		}
+
+	} else {
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+	}
+}
+
+/* map_dbam_to_csrow_size
+ *
+ * Input (index) is the DBAM DIMM value (1 of 4) used as an index into a
+ * shift table (revf_quad_ddr2_shift) which starts at 128MB DIMM size.
+ *
+ * Index of 0 indicates an empty DIMM slot, as reported by Hardware on
+ * empty slots.
+ *
+ * Normalize to 128MB by subracting 27 bit shift
+ */
+static int map_dbam_to_csrow_size(int index)
+{
+	int mega_bytes = 0;
+
+	if (index > 0 && index <= DBAM_MAX_VALUE)
+		mega_bytes = ((128 << (revf_quad_ddr2_shift[index]-27)));
+
+	return mega_bytes;
+}
+
+/*
+ * f10_debug_display_dimm_sizes
+ *
+ *	debug routine to display the memory sizes of a DIMM
+ *	(ganged or not) and it CSROWs as well
+ */
+static void f10_debug_display_dimm_sizes(int ctrl,
+					struct amd64_pvt *pvt, int ganged)
+{
+	int dimm;
+	int size0;
+	int size1;
+	u32 dbam;
+	u32 *dcsb;
+
+	debugf1("  dbam%d: 0x%8.08x  CSROW is %s\n", ctrl,
+			ctrl ? pvt->dbam1 : pvt->dbam0,
+			ganged ? "GANGED - dbam1 not used" : "NON-GANGED");
+
+	dbam = ctrl ? pvt->dbam1 : pvt->dbam0;
+	dcsb = ctrl ? pvt->dcsb1 : pvt->dcsb0;
+
+	/* Dump memory sizes for DIMM and its CSROWs */
+	for (dimm = 0; dimm < 4; dimm++) {
+
+		size0 = 0;
+		if (dcsb[dimm*2] & K8_DCSB_CS_ENABLE)
+			size0 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
+
+		size1 = 0;
+		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
+			size1 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
+
+		debugf1("     CTRL-%d DIMM-%d=%5dMB   CSROW-%d=%5dMB "
+				"CSROW-%d=%5dMB\n",
+				ctrl,
+				dimm,
+				size0 + size1,
+				dimm * 2,
+				size0,
+				dimm * 2 + 1,
+				size1);
+	}
+}
+
+/*
+ * f10_probe_valid_hardware
+ *
+ * Very early hardware probe on pci_probe thread to determine if this module can
+ * support the hardware.
+ *
+ * Return:
+ *      0 for OK
+ *      1 for error
+ */
+static int f10_probe_valid_hardware(struct amd64_pvt *pvt)
+{
+	int rc = 0;
+
+	/*
+	 * If we are on a DDR3 machine, we don't know yet if
+	 * we support that properly at this time
+	 */
+	if ((pvt->dchr0 & F10_DCHR_Ddr3Mode) ||
+	    (pvt->dchr1 & F10_DCHR_Ddr3Mode)) {
+
+		amd64_printk(KERN_WARNING,
+			"%s() This machine is running with DDR3 memory. "
+			"This is not currently supported. "
+			"DCHR0=0x%x DCHR1=0x%x\n",
+			__func__, pvt->dchr0, pvt->dchr1);
+
+		amd64_printk(KERN_WARNING,
+			"   Contact '%s' module MAINTAINER to help add"
+			" support.\n",
+			EDAC_MOD_STR);
+
+		rc = 1;
+
+	} else {
+		debugf0("%s() DDR2 Memory Installed\n", __func__);
+	}
+
+	return rc;
+}
 
-- 
1.6.2.4


