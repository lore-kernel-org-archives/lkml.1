Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZEGNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZEGNwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZEGNuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:17 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:53992 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbZEGNuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:04 -0400
X-BigFish: VPS-8(zz936eQzz1202hzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 7,
X-WSS-ID: 0KJA12Z-01-QXN-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 07/21] amd64_edac: add sys addr to memory controller mapping helpers
Date: Thu, 7 May 2009 15:49:29 +0200
Message-ID: <1241704183-29223-8-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:51.0172 (UTC) FILETIME=[B18DA840:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  164 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 164 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index df72ecc..44aa102 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -132,3 +132,167 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 	return status;
 }
 
+/*
+ * amd64_map_to_dcs_mask
+ *
+ *	Map from a CSROW entry to the mask entry that operates on it
+ */
+static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
+{
+	return csrow >> (pvt->num_dcsm >> 3);
+}
+
+/*
+ * amd64_get_dct_base()
+ *
+ *	getter function to return the 'base' address the i'th CS entry
+ *	of the 'dct' DRAM controller
+ */
+static u32 amd64_get_dct_base(struct amd64_pvt *pvt, int dct, int csrow)
+{
+	if (dct == 0)
+		return pvt->dcsb0[csrow];
+	else
+		return pvt->dcsb1[csrow];
+}
+
+/*
+ * amd64_get_dct_mask()
+ *
+ *	getter function to return the 'mask' address the i'th CS entry.
+ *	This getter function is needed because there different number
+ *	of DCSM registers on Rev E and prior vs Rev F and later
+ */
+static u32 amd64_get_dct_mask(struct amd64_pvt *pvt, int dct, int csrow)
+{
+	if (dct == 0)
+		return pvt->dcsm0[amd64_map_to_dcs_mask(pvt, csrow)];
+	else
+		return pvt->dcsm1[amd64_map_to_dcs_mask(pvt, csrow)];
+}
+
+
+/*
+ * amd64_get_base_and_limit()
+ *
+ * In *base and *limit, pass back the full 40-bit base and limit physical
+ * addresses for the node given by node_id.  This information is obtained from
+ * DRAM Base (section 3.4.4.1) and DRAM Limit (section 3.4.4.2) registers. The
+ * base and limit addresses are of type SysAddr, as defined at the start of
+ * section 3.4.4 (p. 70).  They are the lowest and highest physical addresses
+ * in the address range they represent.
+ */
+static void amd64_get_base_and_limit(struct amd64_pvt *pvt, int node_id,
+			       u64 *base, u64 *limit)
+{
+	*base = pvt->dram_base[node_id];
+	*limit = pvt->dram_limit[node_id];
+}
+
+/*
+ * Return 1 if the SysAddr given by sys_addr matches the base/limit associated
+ * with node_id
+ */
+static int amd64_base_limit_match(struct amd64_pvt *pvt,
+					u64 sys_addr, int node_id)
+{
+	u64 base, limit, addr;
+
+	amd64_get_base_and_limit(pvt, node_id, &base, &limit);
+
+	/* The K8 treats this as a 40-bit value.  However, bits 63-40 will be
+	 * all ones if the most significant implemented address bit is 1.
+	 * Here we discard bits 63-40.  See section 3.4.2 of AMD publication
+	 * 24592: AMD x86-64 Architecture Programmer's Manual Volume 1
+	 * Application Programming.
+	 */
+	addr = sys_addr & 0x000000ffffffffffull;
+
+	return (addr >= base) && (addr <= limit);
+}
+
+/* find_mc_by_sys_addr
+ *
+ *	Attempt to map a SysAddr to a node.
+ *
+ *	On success, return a pointer to the mem_ctl_info structure for
+ *	the node that the SysAddr maps to.
+ *
+ *	On failure, return NULL
+ */
+static struct mem_ctl_info *find_mc_by_sys_addr(struct mem_ctl_info *mci,
+						u64 sys_addr)
+{
+	struct amd64_pvt *pvt;
+	int node_id;
+	u32 intlv_en, bits;
+
+	/*
+	 * Here we use the DRAM Base (section 3.4.4.1) and DRAM Limit (section
+	 * 3.4.4.2) registers to map the SysAddr to a node ID.
+	 */
+	pvt = mci->pvt_info;
+
+	/* The value of this field should be the same for all DRAM Base
+	 * registers.  Therefore we arbitrarily choose to read it from the
+	 * register for node 0.
+	 */
+	intlv_en = pvt->dram_IntlvEn[0];
+
+	if (intlv_en == 0) {
+		debugf2("%s(): node interleaving disabled\n", __func__);
+		for (node_id = 0; ; ) {
+			if (amd64_base_limit_match(pvt, sys_addr, node_id))
+				break;
+
+			if (++node_id >= DRAM_REG_COUNT) {
+				debugf2("%s(): sys_addr 0x%lx "
+					"does not match any node\n", __func__,
+					(unsigned long)sys_addr);
+				return NULL;
+			}
+		}
+
+		goto found;
+	}
+
+	if (unlikely((intlv_en != (0x01 << 8)) &&
+		     (intlv_en != (0x03 << 8)) && (intlv_en != (0x07 << 8)))) {
+		amd64_printk(KERN_WARNING,
+			  "%s(): junk value of 0x%x extracted from IntlvEn "
+			  "field of DRAM Base Register for node 0: This "
+			  "probably indicates a BIOS bug.\n", __func__,
+			  intlv_en);
+		return NULL;
+	}
+
+	debugf2("%s(): node interleaving enabled\n", __func__);
+	bits = (((u32) sys_addr) >> 12) & intlv_en;
+
+	for (node_id = 0; ; ) {
+		if ((pvt->dram_limit[node_id] & intlv_en) == bits)
+			break;	/* intlv_sel field matches */
+
+		if (++node_id >= DRAM_REG_COUNT) {
+			debugf2("%s(): sys_addr 0x%lx does not match any "
+				"node\n", __func__, (unsigned long)sys_addr);
+			return NULL;
+		}
+	}
+
+	/* sanity test for sys_addr */
+	if (unlikely(!amd64_base_limit_match(pvt, sys_addr, node_id))) {
+		amd64_printk(KERN_WARNING,
+			  "%s(): sys_addr 0x%lx falls outside base/limit "
+			  "address range for node %d with node interleaving "
+			  "enabled.\n", __func__, (unsigned long)sys_addr,
+			  node_id);
+		return NULL;
+	}
+
+found:
+	debugf2("%s(): sys_addr 0x%lx matches node %d\n", __func__,
+		(unsigned long)sys_addr, node_id);
+
+	return edac_mc_find(node_id);
+}
-- 
1.6.2.4


