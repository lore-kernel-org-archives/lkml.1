Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbZEGN5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbZEGN5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZEGNup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:45 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:41145 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757644AbZEGNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:15 -0400
X-BigFish: VPS-6(zz936eQzz1202hzzz32i43j)
X-WSS-ID: 0KJA12Y-02-CL3-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 08/21] amd64_edac: add functionality to compute the DRAM hole
Date: Thu, 7 May 2009 15:49:30 +0200
Message-ID: <1241704183-29223-9-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:51.0812 (UTC) FILETIME=[B1EF5040:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  173 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 44aa102..8ef1c2e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -296,3 +296,176 @@ found:
 
 	return edac_mc_find(node_id);
 }
+
+/*
+ * base_from_dct_base
+ *
+ *	Extract the DRAM CS base address from selected csrow register
+ */
+static u64 base_from_dct_base(struct amd64_pvt *pvt, int csrow)
+{
+	return ((u64) (amd64_get_dct_base(pvt, 0, csrow) & pvt->dcsb_base)) <<
+				pvt->dcs_shift;
+}
+
+/*
+ * mask_from_dct_mask
+ *
+ *	Extract the Mask from the dcsb0[csrow] entry
+ *	Depends on CPU Revision on how to extract this information
+ */
+static u64 mask_from_dct_mask(struct amd64_pvt *pvt, int csrow)
+{
+	u64 dcsm_bits, other_bits;
+	u64 mask;
+
+	/* Extract bits bits 29-21 and 15-9 from DCSM (section 3.5.5). */
+	dcsm_bits = amd64_get_dct_mask(pvt, 0, csrow) & pvt->dcsm_mask;
+
+	/* Set all bits except bits 33-25 and 19-13. */
+	other_bits = pvt->dcsm_mask;
+	other_bits = ~(other_bits << pvt->dcs_shift);
+
+	/* The extracted bits from DCSM belong in the spaces represented by
+	 * the cleared bits in other_bits.
+	 */
+	mask = (dcsm_bits << pvt->dcs_shift) | other_bits;
+
+	return mask;
+}
+
+/*
+ * input_addr_to_csrow
+ *
+ * input_addr is an InputAddr associated with the node given by mci.  Return
+ * the csrow that input_addr maps to, or -1 on failure (no csrow claims
+ * input_addr).
+ */
+static int input_addr_to_csrow(struct mem_ctl_info *mci, u64 input_addr)
+{
+	struct amd64_pvt *pvt;
+	int csrow;
+	u64 base, mask;
+
+	pvt = mci->pvt_info;
+
+	/* Here we use the DRAM CS Base (section 3.5.4) and DRAM CS Mask
+	 * (section 3.5.5) registers.  For each CS base/mask register pair,
+	 * test the condition shown near the start of section 3.5.4 (p. 84).
+	 */
+	for (csrow = 0; csrow < CHIPSELECT_COUNT; csrow++) {
+
+		if ((pvt->dcsb0[csrow] & K8_DCSB_CS_ENABLE) == 0) {
+			debugf2("input_addr_to_csrow: CSBE bit is cleared "
+				"for csrow %d (node %d)\n",
+				csrow, pvt->mc_node_id);
+			continue;
+		}
+
+		base = base_from_dct_base(pvt, csrow);
+		mask = ~mask_from_dct_mask(pvt, csrow);
+
+		if ((input_addr & mask) == (base & mask)) {
+			debugf2("InputAddr 0x%lx matches csrow %d "
+				"(MC node %d)\n",
+				(unsigned long)input_addr,
+				csrow, pvt->mc_node_id);
+			return csrow;
+		}
+	}
+
+	debugf2("no matching csrow for InputAddr 0x%lx (MC node %d)\n",
+		(unsigned long)input_addr, pvt->mc_node_id);
+	return -1;
+}
+
+/* Return the base value defined by the DRAM Base register for the node
+ * represented by mci.  This function returns the full 40-bit value despite
+ * the fact that the register only stores bits 39-24 of the value.  See
+ * section 3.4.4.1.
+ */
+static inline u64 get_dram_base(struct mem_ctl_info *mci)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return pvt->dram_base[pvt->mc_node_id];
+}
+
+/*
+ * Obtain info from the DRAM Hole Address Register (section 3.4.8, pub #26094)
+ * for the node represented by mci.  Info is passed back in *hole_base,
+ * *hole_offset, and *hole_size.  Function returns 0 if info is valid or 1 if
+ * info is invalid. Info may be invalid for either of the following reasons:
+ *
+ *     - The revision of the node is not E or greater.  In this case, the DRAM
+ *       Hole Address Register does not exist.
+ *     - The DramHoleValid bit is cleared in the DRAM Hole Address Register,
+ *       indicating that its contents are not valid.
+ *
+ * The values passed back in *hole_base, *hole_offset, and *hole_size are
+ * complete 32-bit values despite the fact that the bitfields in the DHAR
+ * only represent bits 31-24 of the base and offset values.
+ */
+int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
+			     u64 *hole_offset, u64 *hole_size)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u64 base;
+
+	/* only revE and later have the DRAM Hole Address Register */
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_E) {
+		debugf1("  revision %d for node %d does not support DHAR\n",
+			pvt->ext_model, pvt->mc_node_id);
+		return 1;
+	}
+
+	/* only valid for Fam10h */
+	if (boot_cpu_data.x86 == 0x10 &&
+	    (pvt->dhar & F10_DRAM_MEM_HOIST_VALID) == 0) {
+		debugf1("  Dram Memory Hoisting is DISABLED on this system\n");
+		return 1;
+	}
+
+	if ((pvt->dhar & DHAR_VALID) == 0) {
+		debugf1("  Dram Memory Hoisting is DISABLED on this node %d\n",
+			pvt->mc_node_id);
+		return 1;
+	}
+
+	/* This node has Memory Hoisting */
+
+	/* +------------------+--------------------+--------------------+-----
+	 * | memory           | DRAM hole          | relocated          |
+	 * | [0, (x - 1)]     | [x, 0xffffffff]    | addresses from     |
+	 * |                  |                    | DRAM hole          |
+	 * |                  |                    | [0x100000000,      |
+	 * |                  |                    |  (0x100000000+     |
+	 * |                  |                    |   (0xffffffff-x))] |
+	 * +------------------+--------------------+--------------------+-----
+	 *
+	 * Above is a diagram of physical memory showing the DRAM hole and the
+	 * relocated addresses from the DRAM hole.  As shown, the DRAM hole
+	 * starts at address x (the base address) and extends through address
+	 * 0xffffffff.  The DRAM Hole Address Register (DHAR) relocates the
+	 * addresses in the hole so that they start at 0x100000000.
+	 */
+
+	base = dhar_base(pvt->dhar);
+
+	*hole_base = base;
+	*hole_size = (0x1ull << 32) - base;
+
+	if (boot_cpu_data.x86 > 0xf)
+		*hole_offset = f10_dhar_offset(pvt->dhar);
+	else
+		*hole_offset = k8_dhar_offset(pvt->dhar);
+
+	debugf1("  DHAR info for node %d base 0x%lx offset 0x%lx size 0x%lx\n",
+		pvt->mc_node_id, (unsigned long)*hole_base,
+		(unsigned long)*hole_offset, (unsigned long)*hole_size);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(amd64_get_dram_hole_info);
+
+
-- 
1.6.2.4


