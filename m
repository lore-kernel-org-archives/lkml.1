Return-Path: <linux-kernel-owner+w=401wt.eu-S1761792AbZEGN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792AbZEGN5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbZEGNun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54963 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbZEGNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:13 -0400
X-BigFish: VPS-2(zz14c3Mzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KJA134-02-CLG-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 19/21] amd64_edac: add EDAC core-related initializers
Date: Thu, 7 May 2009 15:49:41 +0200
Message-ID: <1241704183-29223-20-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:58.0141 (UTC) FILETIME=[B5B50AD0:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  336 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 336 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2934e80..8e14fdd 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2689,4 +2689,340 @@ int amd64_process_error_info(struct mem_ctl_info *mci,
 }
 EXPORT_SYMBOL_GPL(amd64_process_error_info);
 
+/*
+ * amd64_check
+ *
+ * The main polling 'check' function, called FROM the edac core to perform the
+ * error checking and if an error is encountered, error processing.
+ */
+static void amd64_check(struct mem_ctl_info *mci)
+{
+	struct amd64_error_info_regs info;
+
+	debugf3("%s()\n", __func__);
+	if (amd64_get_error_info(mci, &info))
+		amd64_process_error_info(mci, &info, 1);
+}
+
+/*
+ * amd64_reserve_mc_sibling_devices
+ *
+ * Input:
+ *	1) struct amd64_pvt which contains pvt->dram_f2_ctl pointer
+ *	2) AMD Family index value
+ *
+ * Ouput:
+ *	Upon return of 0, the following filled in:
+ *
+ *		struct pvt->addr_f1_ctl
+ *		struct pvt->misc_f3_ctl
+ *
+ *	Filled in with related device funcitions of 'dram_f2_ctl'
+ *	These devices are "reserved" via the pci_get_device()
+ *
+ *	Upon return of 1 (error status):
+ *
+ *		Nothing reserved
+ */
+static int amd64_reserve_mc_sibling_devices(struct amd64_pvt *pvt,
+					 int mc_type_index)
+{
+	const struct amd64_family_type
+		*amd64_dev = &amd64_family_types[mc_type_index];
+
+	/* Reserve the ADDRESS MAP Device */
+	pvt->addr_f1_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
+						amd64_dev->addr_f1_ctl,
+						pvt->dram_f2_ctl);
+	if (pvt->addr_f1_ctl == NULL) {
+		amd64_printk(KERN_ERR, "error address map device not found: "
+			  "vendor %x device 0x%x (broken BIOS?)\n",
+			  PCI_VENDOR_ID_AMD, amd64_dev->addr_f1_ctl);
+		return 1;
+	}
+
+	/* Reserve the MISC Device */
+	pvt->misc_f3_ctl = pci_get_related_function(pvt->dram_f2_ctl->vendor,
+						amd64_dev->misc_f3_ctl,
+						pvt->dram_f2_ctl);
+	if (pvt->misc_f3_ctl == NULL) {
+		pci_dev_put(pvt->addr_f1_ctl);
+		pvt->addr_f1_ctl = NULL;
+
+		amd64_printk(KERN_ERR, "error miscellaneous device not found: "
+			  "vendor %x device 0x%x (broken BIOS?)\n",
+			  PCI_VENDOR_ID_AMD, amd64_dev->misc_f3_ctl);
+		return 1;
+	}
+
+	debugf1("    Addr Map device PCI Bus ID:\t%s\n",
+		pci_name(pvt->addr_f1_ctl));
+	debugf1("    DRAM MEM-CTL PCI Bus ID:\t%s\n",
+		pci_name(pvt->dram_f2_ctl));
+	debugf1("    Misc device PCI Bus ID:\t\t%s\n",
+		pci_name(pvt->misc_f3_ctl));
+
+	return 0;
+}
+
+/*
+ * amd64_read_mc_registers
+ *
+ * Retrieve the hardware registers of the memory controller (this includes the
+ * 'Address Map' and 'Misc' device regs)
+ */
+static void amd64_read_mc_registers(struct amd64_pvt *pvt)
+{
+	u64 msr_val;
+	int dram;
+	int err;
+
+	debugf0("%s(MC node-id=%d): (ExtModel=%d)\n",
+		__func__, pvt->mc_node_id, pvt->ext_model);
+
+	/*
+	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved
+	 * bits since those are Read-As-Zero
+	 */
+	rdmsrl(MSR_K8_TOP_MEM1, msr_val);
+	pvt->top_mem = msr_val >> 23;
+	debugf0("  TOP_MEM=0x%08llx\n", pvt->top_mem);
+
+	/* check first whether TOP_MEM2 is enabled */
+	rdmsrl(MSR_K8_SYSCFG, msr_val);
+	if (msr_val & (1U << 21)) {
+		rdmsrl(MSR_K8_TOP_MEM2, msr_val);
+		pvt->top_mem2 = msr_val >> 23;
+		debugf0("  TOP_MEM2=0x%08llx\n", pvt->top_mem2);
+	} else
+		debugf0("  TOP_MEM2 disabled.\n");
+
+	amd64_cpu_display_info(pvt);
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCAP, &pvt->nbcap);
+	if (err != 0)
+		debugf0("%s() Reading K8_NBCAP failed\n", __func__);
+
+	if (pvt->ops->read_dram_ctl_register)
+		pvt->ops->read_dram_ctl_register(pvt);
+
+	for (dram = 0; dram < DRAM_REG_COUNT; dram++) {
+		/*
+		 * Call CPU specific READ function to get the DRAM Base and
+		 * Limit values from the DCT.
+		 */
+		pvt->ops->read_dram_base_limit(pvt, dram);
+
+		/* Only print out debug info on rows with both R and W
+		 * Enabled.  Normal processing, compiler should optimize
+		 * this whole 'if' debug output block away
+		 */
+		if (pvt->dram_rw_en[dram] != 0) {
+			debugf1("  DRAM_BASE[%d]: 0x%8.08x-%8.08x "
+				"DRAM_LIMIT:  0x%8.08x-%8.08x\n",
+				dram,
+				(u32)(pvt->dram_base[dram] >> 32),
+				(u32)(pvt->dram_base[dram] & 0xFFFFFFFF),
+				(u32)(pvt->dram_limit[dram] >> 32),
+				(u32)(pvt->dram_limit[dram] & 0xFFFFFFFF));
+			debugf1("        IntlvEn=%s %s %s "
+				"IntlvSel=%d DstNode=%d\n",
+				pvt->dram_IntlvEn[dram] ?
+					"Enabled" : "Disabled",
+				(pvt->dram_rw_en[dram] & 0x2) ? "W" : "!W",
+				(pvt->dram_rw_en[dram] & 0x1) ? "R" : "!R",
+				pvt->dram_IntlvSel[dram],
+				pvt->dram_DstNode[dram]);
+		}
+	}
+
+	amd64_read_dct_base_mask(pvt);
+
+	err = pci_read_config_dword(pvt->addr_f1_ctl, K8_DHAR, &pvt->dhar);
+	if (err != 0)
+		debugf0("%s() Reading K8_DHAR failed\n", __func__);
+
+	amd64_read_dbam_reg(pvt);
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl,
+				F10_ONLINE_SPARE, &pvt->online_spare);
+	if (err != 0)
+		debugf0("%s() Reading ONLINE_SPARE failed\n", __func__);
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	if (err != 0)
+		debugf0("%s() Reading F10_DCLR_0 failed\n", __func__);
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCHR_0, &pvt->dchr0);
+	if (err != 0)
+		debugf0("%s() Reading F10_DCHR_0 failed\n", __func__);
+
+	if (!dct_ganging_enabled(pvt)) {
+		err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_1,
+						&pvt->dclr1);
+		if (err != 0)
+			debugf0("%s() Reading F10_DCLR_1 failed\n", __func__);
+		err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCHR_1,
+						&pvt->dchr1);
+		if (err != 0)
+			debugf0("%s() Reading F10_DCHR_1 failed\n", __func__);
+	}
+
+	amd64_dump_misc_regs(pvt);
+}
+
+/*
+ * amd64_csrow_nr_pages
+ *
+ *	NOTE: CPU Revision Dependent code
+ *
+ *	Input:
+ *		csrow_nr  ChipSelect Row Number (0..CHIPSELECT_COUNT-1)
+ *		k8 private pointer to -->
+ *			DRAM Bank Address mapping register
+ *			node_id
+ *			DCL register where dual_channel_active is
+ *
+ *	The DBAM register consists of 4 sets of 4 bits each definitions:
+ *
+ *	Bits:		CSROWs
+ *	0-3		CSROWs 0 and 1
+ *	4-7		CSROWs 2 and 3
+ *	8-11		CSROWs 4 and 5
+ *	12-15		CSROWs 6 and 7
+ *
+ *	Values range from: 0 to 15
+ *	The meanings of the values depends on CPU REV and dual-channel state
+ *
+ *	Various CPU revisions have different size definitions for this
+ *	4 bit values.
+ *	Therefore, we need to examine which CPU we are running on to
+ *	extract meaning for these bits:
+ *
+ *	REV CG and earlier have a given DIMM size definition
+ *	REV D & REV E share another set of size definitions
+ *
+ *	REV CG, D and E all have a common beginning set of size definitions,
+ *	but change the meanings midway into the table.
+ *
+ *	REV F has yet another set of size definitions, which has a totally
+ *	different starting point.
+ *
+ *	REV ? future revs? We won't know till we get the specs
+ *
+ *	The memory controller provides for total of only 8 CSROWs in its
+ *	current architecture. Each "pair" of CSROWs normally represents
+ *	just one (1) *	DIMM in single channel or just two (2) DIMMs
+ *	in dual channel mode.
+ *
+ *	The following code logic collapses the various tables for CSROW
+ *	based on CPU Rev number.
+ *	See the tables/algorithms in the respective BKDG manuals.
+ *
+ *	return:
+ *		The number of PAGE_SIZE pages on the specified CSROW number
+ *		it encompasses
+ *
+ */
+static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
+{
+	u32 dram_map;
+	u32 nr_pages;
+
+	/* The math on this doesn't look right on the surface because x/2*4
+	 * can be simplified to x*2 but this expression makes use of the fact
+	 * that it is integral math where 1/2=0. This intermediate value
+	 * becomes the number of bits to shift the DBAM register to extract
+	 * the proper CSROW field.
+	 */
+	dram_map = (pvt->dbam0 >> ((csrow_nr / 2) * 4)) & 0xF;	/* PG88 */
+
+	nr_pages = pvt->ops->dbam_map_to_pages(pvt, dram_map);
+
+	/* If dual channel then double the memory size of single channel */
+	/* channel count is 1 or 2 */
+	nr_pages <<= (pvt->channel_count - 1);
+
+	debugf0("  %s(csrow=%d) DBAM map index= %d\n", __func__,
+		csrow_nr, dram_map);
+	debugf0("    nr_pages= %u  channel-count = %d\n",
+		nr_pages, pvt->channel_count);
+
+	return nr_pages;
+}
+
+/*
+ * amd64_init_csrows
+ *
+ *	perform initialization on the array of csrow attribute instances,
+ *	based on the values from pci config hardware registers
+ */
+static int amd64_init_csrows(struct mem_ctl_info *mci)
+{
+	struct csrow_info *csrow;
+	struct amd64_pvt *pvt;
+	int i;
+	int empty = 1;
+	u64 input_addr_min, input_addr_max, sys_addr;
+	int err;
+
+	pvt = mci->pvt_info;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_NBCFG, &pvt->nbcfg);
+	if (err != 0)
+		debugf0("%s() Reading K8_NBCFG failed\n", __func__);
+
+	debugf0("%s() NBCFG= 0x%x  CHIPKILL= %s DRAM ECC= %s\n",
+		__func__, pvt->nbcfg,
+		(pvt->nbcfg & K8_NBCFG_CHIPKILL) ? "Enabled" : "Disabled",
+		(pvt->nbcfg & K8_NBCFG_ECC_ENABLE) ? "Enabled" : "Disabled"
+		);
+
+	for (i = 0; i < CHIPSELECT_COUNT; i++) {
+		csrow = &mci->csrows[i];
+
+		if ((pvt->dcsb0[i] & K8_DCSB_CS_ENABLE) == 0) {
+			debugf1("----CSROW %d EMPTY for node %d\n", i,
+				pvt->mc_node_id);
+			continue;
+		}
+
+		debugf1("----CSROW %d VALID for MC node %d\n",
+			i, pvt->mc_node_id);
+
+		empty = 0;
+		csrow->nr_pages = amd64_csrow_nr_pages(i, pvt);
+		find_csrow_limits(mci, i, &input_addr_min, &input_addr_max);
+		sys_addr = input_addr_to_sys_addr(mci, input_addr_min);
+		csrow->first_page = (u32) (sys_addr >> PAGE_SHIFT);
+		sys_addr = input_addr_to_sys_addr(mci, input_addr_max);
+		csrow->last_page = (u32) (sys_addr >> PAGE_SHIFT);
+		csrow->page_mask = ~mask_from_dct_mask(pvt, i);
+		/* 8 bytes of resolution */
+
+		csrow->mtype = amd64_determine_memory_type(pvt);
+
+		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
+		debugf1("    input_addr_min: 0x%lx input_addr_max: 0x%lx\n",
+			(unsigned long)input_addr_min,
+			(unsigned long)input_addr_max);
+		debugf1("    sys_addr: 0x%lx  page_mask: 0x%lx\n",
+			(unsigned long)sys_addr, csrow->page_mask);
+		debugf1("    nr_pages: %u  first_page: 0x%lx "
+			"last_page: 0x%lx\n",
+			(unsigned)csrow->nr_pages,
+			csrow->first_page, csrow->last_page);
+
+		/*
+		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
+		 */
+		if (pvt->nbcfg & K8_NBCFG_ECC_ENABLE)
+			csrow->edac_mode =
+			    (pvt->nbcfg & K8_NBCFG_CHIPKILL) ?
+			    EDAC_S4ECD4ED : EDAC_SECDED;
+		else
+			csrow->edac_mode = EDAC_NONE;
+	}
+
+	return empty;
+}
 
-- 
1.6.2.4


