Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZEGNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZEGNvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbZEGNuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:10 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:1980 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757380AbZEGNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:03 -0400
X-BigFish: VPS-8(zz936eQzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJA12Z-02-CL7-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/21] amd64_edac: add DRAM address type conversion facilities
Date: Thu, 7 May 2009 15:49:31 +0200
Message-ID: <1241704183-29223-10-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:52.0437 (UTC) FILETIME=[B24EAE50:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  300 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 300 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8ef1c2e..118b838 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -468,4 +468,304 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 }
 EXPORT_SYMBOL_GPL(amd64_get_dram_hole_info);
 
+/* Return the DramAddr that the SysAddr given by sys_addr maps to.  It is
+ * assumed that sys_addr maps to the node given by mci.
+ */
+static u64 sys_addr_to_dram_addr(struct mem_ctl_info *mci, u64 sys_addr)
+{
+	u64 dram_base, hole_base, hole_offset, hole_size, dram_addr;
+	int rc;
+
+	/* The first part of section 3.4.4 (p. 70) shows how the DRAM Base
+	 * (section 3.4.4.1) and DRAM Limit (section 3.4.4.2) registers are
+	 * used to translate a SysAddr to a DramAddr.  If the DRAM Hole
+	 * Address Register (DHAR) is enabled, then it is also involved in
+	 * translating a SysAddr to a DramAddr.  Sections 3.4.8 and 3.5.8.2
+	 * describe the DHAR and how it is used for memory hoisting.  These
+	 * parts of the documentation are unclear.  I interpret them as
+	 * follows:
+	 *
+	 *     When node n receives a SysAddr, it processes the SysAddr as
+	 *     follows:
+	 *
+	 *         1.  It extracts the DRAMBase and DRAMLimit values from the
+	 *             DRAM Base and DRAM Limit registers for node n.  If the
+	 *             SysAddr is not within the range specified by the base
+	 *             and limit values, then node n ignores the Sysaddr
+	 *             (since it does not map to node n).  Otherwise continue
+	 *             to step 2 below.
+	 *
+	 *         2.  If the DramHoleValid bit of the DHAR for node n is
+	 *             clear, the DHAR is disabled so skip to step 3 below.
+	 *             Otherwise see if the SysAddr is within the range of
+	 *             relocated addresses (starting at 0x100000000) from the
+	 *             DRAM hole.  If not, skip to step 3 below.  Else get the
+	 *             value of the DramHoleOffset field from the DHAR.  To
+	 *             obtain the DramAddr, subtract the offset defined by
+	 *             this value from the SysAddr.
+	 *
+	 *         3.  Obtain the base address for node n from the DRAMBase
+	 *             field of the DRAM Base register for node n.  To obtain
+	 *             the DramAddr, subtract the base address from the
+	 *             SysAddr, as shown near the start of section 3.4.4
+	 *             (p. 70).
+	 */
+
+	dram_base = get_dram_base(mci);
+
+	rc = amd64_get_dram_hole_info(mci, &hole_base, &hole_offset,
+				      &hole_size);
+	if (!rc) {
+		if ((sys_addr >= (1ull << 32)) &&
+		    (sys_addr < ((1ull << 32) + hole_size))) {
+			/* use DHAR to translate SysAddr to DramAddr */
+			dram_addr = sys_addr - hole_offset;
+			debugf2("using DHAR to translate SysAddr 0x%lx to "
+				"DramAddr 0x%lx\n",
+				(unsigned long)sys_addr,
+				(unsigned long)dram_addr);
+			return dram_addr;
+		}
+	}
+
+	/* Translate the SysAddr to a DramAddr as shown near the start of
+	 * section 3.4.4 (p. 70).  Although sys_addr is a 64-bit value, the k8
+	 * only deals with 40-bit values.  Therefore we discard bits 63-40 of
+	 * sys_addr below.  If bit 39 of sys_addr is 1 then the bits we
+	 * discard are all 1s.  Otherwise the bits we discard are all 0s.  See
+	 * section 3.4.2 of AMD publication 24592: AMD x86-64 Architecture
+	 * Programmer's Manual Volume 1 Application Programming.
+	 */
+	dram_addr = (sys_addr & 0xffffffffffull) - dram_base;
+
+	debugf2("using DRAM Base register to translate SysAddr 0x%lx to "
+		"DramAddr 0x%lx\n", (unsigned long)sys_addr,
+		(unsigned long)dram_addr);
+	return dram_addr;
+}
+
+/* Parameter intlv_en is the value of the IntlvEn field from a DRAM Base
+ * register (section 3.4.4.1).  Return the number of bits from a SysAddr that
+ * are used for node interleaving.
+ */
+static int num_node_interleave_bits(unsigned intlv_en)
+{
+	static const int intlv_shift_table[] = { 0, 1, 0, 2, 0, 0, 0, 3 };
+	int n;
+
+	BUG_ON(intlv_en > 7);
+	n = intlv_shift_table[intlv_en];
+	return n;
+}
+
+/* Translate the DramAddr given by dram_addr to an InputAddr and return the
+ * result.
+ */
+static u64 dram_addr_to_input_addr(struct mem_ctl_info *mci, u64 dram_addr)
+{
+	struct amd64_pvt *pvt;
+	int intlv_shift;
+	u64 input_addr;
+
+	pvt = mci->pvt_info;
+
+	/* See the start of section 3.4.4 (p. 70) in the k8 documentation
+	 * concerning translating a DramAddr to an InputAddr.
+	 */
+	intlv_shift = num_node_interleave_bits(pvt->dram_IntlvEn[0]);
+	input_addr = ((dram_addr >> intlv_shift) & 0xffffff000ull) +
+	    (dram_addr & 0xfff);
+
+	debugf2("  Intlv Shift=%d DramAddr=0x%lx maps to InputAddr=0x%lx\n",
+		intlv_shift,
+		(unsigned long)dram_addr, (unsigned long)input_addr);
+	return input_addr;
+}
+
+/* Translate the SysAddr represented by sys_addr to an InputAddr and return
+ * the result.  It is assumed that sys_addr maps to the node given by mci.
+ */
+static u64 sys_addr_to_input_addr(struct mem_ctl_info *mci, u64 sys_addr)
+{
+	u64 input_addr;
+
+	input_addr =
+	    dram_addr_to_input_addr(mci, sys_addr_to_dram_addr(mci, sys_addr));
+	debugf2("%s(): SysAdddr 0x%lx translates to InputAddr 0x%lx\n",
+		__func__, (unsigned long)sys_addr, (unsigned long)input_addr);
+	return input_addr;
+}
+
+
+/* input_addr is an InputAddr associated with the node represented by mci.
+ * Translate input_addr to a DramAddr and return the result.
+ */
+static u64 input_addr_to_dram_addr(struct mem_ctl_info *mci, u64 input_addr)
+{
+	struct amd64_pvt *pvt;
+	int node_id, intlv_shift;
+	u64 bits, dram_addr;
+	u32 intlv_sel;
+
+	/* Near the start of section 3.4.4 (p. 70), the k8 documentation shows
+	 * how to translate a DramAddr to an InputAddr.  Here we reverse this
+	 * procedure.  When translating from a DramAddr to an InputAddr, the
+	 * bits used for node interleaving are discarded.  Here we recover
+	 * these bits from the IntlvSel field of the DRAM Limit register
+	 * (section 3.4.4.2) for the node that input_addr is associated with.
+	 */
+
+	pvt = mci->pvt_info;
+	node_id = pvt->mc_node_id;
+	BUG_ON((node_id < 0) || (node_id > 7));
+
+	intlv_shift = num_node_interleave_bits(pvt->dram_IntlvEn[0]);
+
+	if (intlv_shift == 0) {
+		debugf1("  node interleaving disabled:\n");
+		debugf1("    InputAddr 0x%lx translates "
+			"to DramAddr of same value\n",
+			(unsigned long)input_addr);
+		return input_addr;
+	}
+
+	bits = ((input_addr & 0xffffff000ull) << intlv_shift) +
+	    (input_addr & 0xfff);
+
+	intlv_sel = pvt->dram_IntlvSel[node_id] & ((1 << intlv_shift) - 1);
+	dram_addr = bits + (intlv_sel << 12);
+
+	debugf1("InputAddr 0x%lx translates to DramAddr 0x%lx "
+		"(%d node interleave bits)\n", (unsigned long)input_addr,
+		(unsigned long)dram_addr, intlv_shift);
+	return dram_addr;
+}
+
+/* dram_addr is a DramAddr that maps to the node represented by mci.  Convert
+ * dram_addr to a SysAddr and return the result.
+ */
+static u64 dram_addr_to_sys_addr(struct mem_ctl_info *mci, u64 dram_addr)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u64 hole_base, hole_offset, hole_size, base, limit, sys_addr;
+	int rc;
+
+	rc = amd64_get_dram_hole_info(mci, &hole_base, &hole_offset,
+				      &hole_size);
+	if (!rc) {
+		if ((dram_addr >= hole_base) &&
+		    (dram_addr < (hole_base + hole_size))) {
+			/* use DHAR to translate DramAddr to SysAddr */
+			sys_addr = dram_addr + hole_offset;
+			debugf1("using DHAR to translate DramAddr 0x%lx to "
+				"SysAddr 0x%lx\n", (unsigned long)dram_addr,
+				(unsigned long)sys_addr);
+			return sys_addr;
+		}
+	}
+
+	amd64_get_base_and_limit(pvt, pvt->mc_node_id, &base, &limit);
+	sys_addr = dram_addr + base;
+
+	/* The sys_addr we have computed up to this point is a 40-bit value
+	 * because the k8 deals with 40-bit values.  However, the value we are
+	 * supposed to return is a full 64-bit physical address.  The AMD
+	 * x86-64 architecture specifies that the most significant implemented
+	 * address bit through bit 63 of a physical address must be either all
+	 * 0s or all 1s.  Therefore we sign-extend the 40-bit sys_addr to a
+	 * 64-bit value below.  See section 3.4.2 of AMD publication 24592:
+	 * AMD x86-64 Architecture Programmer's Manual Volume 1 Application
+	 * Programming.
+	 */
+	sys_addr |= ~((sys_addr & (1ull << 39)) - 1);
+
+	debugf1("  Using DRAM Base reg on node %d to translate\n",
+		pvt->mc_node_id);
+	debugf1("    DramAddr 0x%lx to SysAddr 0x%lx\n",
+		(unsigned long)dram_addr, (unsigned long)sys_addr);
+	return sys_addr;
+}
+
+/* input_addr is an InputAddr associated with the node given by mci.
+ * Translate input_addr to a SysAddr and return the result.
+ */
+static inline u64 input_addr_to_sys_addr(struct mem_ctl_info *mci,
+					 u64 input_addr)
+{
+	return dram_addr_to_sys_addr(mci,
+				     input_addr_to_dram_addr(mci, input_addr));
+}
+
+/*
+ * Find the minimum and maximum InputAddr values that map to the given csrow.
+ * Pass back these values in *input_addr_min and *input_addr_max.
+ */
+static void find_csrow_limits(struct mem_ctl_info *mci, int csrow,
+			      u64 *input_addr_min, u64 *input_addr_max)
+{
+	struct amd64_pvt *pvt;
+	u64 base, mask;
+
+	pvt = mci->pvt_info;
+	BUG_ON((csrow < 0) || (csrow >= CHIPSELECT_COUNT));
+
+	base = base_from_dct_base(pvt, csrow);
+	mask = mask_from_dct_mask(pvt, csrow);
+
+	*input_addr_min = base & ~mask;
+	*input_addr_max = base | mask | pvt->dcs_mask_notused;
+}
+
+
+
+/*
+ * static u64 extract_error_address
+ *	Extract error address from MCA NB Address Low (section 3.6.4.5) and
+ *	MCA NB Address High (section 3.6.4.6) register values and return the
+ *	result. Address is located in the info structure (nbeah and nbeal)
+ *	the encoding is device specific.
+ */
+static u64 extract_error_address(struct mem_ctl_info *mci,
+			struct amd64_error_info_regs *info)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return pvt->ops->get_error_address(mci, info);
+}
+
+
+/*
+ * error_address_to_page_and_offset
+ *
+ *	Map the Error address to a PAGE and PAGE OFFSET
+ */
+static inline void error_address_to_page_and_offset(u64 error_address,
+						    u32 *page, u32 *offset)
+{
+	*page = (u32) (error_address >> PAGE_SHIFT);
+	*offset = ((u32) error_address) & ~PAGE_MASK;
+}
+
+/*
+ * sys_addr_to_csrow
+ *
+ * 'sys_addr' is an error address (a SysAddr) extracted from the MCA NB Address
+ * Low (section 3.6.4.5) and MCA NB Address High (section 3.6.4.6) registers
+ * of a node that detected an ECC memory error.  mci represents the node that
+ * the error address maps to (possibly different from the node that detected
+ * the error).  Return the number of the csrow that sys_addr maps to, or -1 on
+ * error.
+ */
+static int sys_addr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr)
+{
+	int csrow;
+
+	csrow = input_addr_to_csrow(mci, sys_addr_to_input_addr(mci, sys_addr));
+
+	if (csrow == -1)
+		amd64_mc_printk(mci, KERN_ERR,
+			     "Failed to translate InputAddr to csrow for "
+			     "address 0x%lx\n", (unsigned long)sys_addr);
+	return csrow;
+}
 
-- 
1.6.2.4


