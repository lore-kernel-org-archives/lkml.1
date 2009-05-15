Return-Path: <linux-kernel-owner+w=401wt.eu-S1763639AbZEOM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763639AbZEOM1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761937AbZEOMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:23:09 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:35631
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758858AbZEOMW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:22:56 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KJOQDV-01-0C4-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/22] amd64_edac: add k8-specific methods
Date: Fri, 15 May 2009 14:22:24 +0200
Message-ID: <1242390153-24493-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 15 May 2009 12:22:46.0556 (UTC) FILETIME=[DABE85C0:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Borislav:

- fix/cleanup/move comments
- fix function return value patterns
- cleanup debug calls

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  173 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5ec44a4..24c031f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1013,3 +1013,176 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
 	return type;
 }
 
+/*
+ * Read the DRAM Configuration Low register. It differs between CG, D & E revs
+ * and the later RevF memory controllers (DDR vs DDR2)
+ *
+ * Return:
+ *      number of memory channels in operation
+ * Pass back:
+ *      contents of the DCL0_LOW register
+ */
+static int k8_early_channel_count(struct amd64_pvt *pvt)
+{
+	int flag, err = 0;
+
+	err = pci_read_config_dword(pvt->dram_f2_ctl, F10_DCLR_0, &pvt->dclr0);
+	if (err)
+		return err;
+
+	if ((boot_cpu_data.x86_model >> 4) >= OPTERON_CPU_REV_F) {
+		/* RevF (NPT) and later */
+		flag = pvt->dclr0 & F10_WIDTH_128;
+	} else {
+		/* RevE and earlier */
+		flag = pvt->dclr0 & REVE_WIDTH_128;
+	}
+
+	/* not used */
+	pvt->dclr1 = 0;
+
+	return (flag) ? 2 : 1;
+}
+
+/* extract the ERROR ADDRESS for the K8 CPUs */
+static u64 k8_get_error_address(struct mem_ctl_info *mci,
+				struct amd64_error_info_regs *info)
+{
+	return (((u64) (info->nbeah & 0xff)) << 32) +
+			(info->nbeal & ~0x03);
+}
+
+/*
+ * Read the Base and Limit registers for K8 based Memory controllers; extract
+ * fields from the 'raw' reg into separate data fields
+ *
+ * Isolates: BASE, LIMIT, IntlvEn, IntlvSel, RW_EN
+ */
+static void k8_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
+{
+	u32 low;
+	u32 off = dram << 3;	/* 8 bytes between DRAM entries */
+	int err;
+
+	err = pci_read_config_dword(pvt->addr_f1_ctl,
+				    K8_DRAM_BASE_LOW + off, &low);
+	if (err)
+		debugf0("Reading K8_DRAM_BASE_LOW failed\n");
+
+	/* Extract parts into separate data entries */
+	pvt->dram_base[dram] = ((u64) low & 0xFFFF0000) << 8;
+	pvt->dram_IntlvEn[dram] = (low >> 8) & 0x7;
+	pvt->dram_rw_en[dram] = (low & 0x3);
+
+	err = pci_read_config_dword(pvt->addr_f1_ctl,
+				    K8_DRAM_LIMIT_LOW + off, &low);
+	if (err)
+		debugf0("Reading K8_DRAM_LIMIT_LOW failed\n");
+
+	/*
+	 * Extract parts into separate data entries. Limit is the HIGHEST memory
+	 * location of the region, so lower 24 bits need to be all ones
+	 */
+	pvt->dram_limit[dram] = (((u64) low & 0xFFFF0000) << 8) | 0x00FFFFFF;
+	pvt->dram_IntlvSel[dram] = (low >> 8) & 0x7;
+	pvt->dram_DstNode[dram] = (low & 0x7);
+}
+
+static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
+					struct amd64_error_info_regs *info,
+					u64 SystemAddress)
+{
+	struct mem_ctl_info *src_mci;
+	unsigned short syndrome;
+	int channel, csrow;
+	u32 page, offset;
+
+	/* Extract the syndrome parts and form a 16-bit syndrome */
+	syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
+	syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
+
+	/* CHIPKILL enabled */
+	if (info->nbcfg & K8_NBCFG_CHIPKILL) {
+		channel = get_channel_from_ecc_syndrome(syndrome);
+		if (channel < 0) {
+			/*
+			 * Syndrome didn't map, so we don't know which of the
+			 * 2 DIMMs is in error. So we need to ID 'both' of them
+			 * as suspect.
+			 */
+			amd64_mc_printk(mci, KERN_WARNING,
+				       "unknown syndrome 0x%x - possible error "
+				       "reporting race\n", syndrome);
+			edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+			return;
+		}
+	} else {
+		/*
+		 * non-chipkill ecc mode
+		 *
+		 * The k8 documentation is unclear about how to determine the
+		 * channel number when using non-chipkill memory.  This method
+		 * was obtained from email communication with someone at AMD.
+		 * (Wish the email was placed in this comment - norsk)
+		 */
+		channel = ((SystemAddress & BIT(3)) != 0);
+	}
+
+	/*
+	 * Find out which node the error address belongs to. This may be
+	 * different from the node that detected the error.
+	 */
+	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
+	if (src_mci) {
+		amd64_mc_printk(mci, KERN_ERR,
+			     "failed to map error address 0x%lx to a node\n",
+			     (unsigned long)SystemAddress);
+		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
+		return;
+	}
+
+	/* Now map the SystemAddress to a CSROW */
+	csrow = sys_addr_to_csrow(src_mci, SystemAddress);
+	if (csrow < 0) {
+		edac_mc_handle_ce_no_info(src_mci, EDAC_MOD_STR);
+	} else {
+		error_address_to_page_and_offset(SystemAddress, &page, &offset);
+
+		edac_mc_handle_ce(src_mci, page, offset, syndrome, csrow,
+				  channel, EDAC_MOD_STR);
+	}
+}
+
+/*
+ * determrine the number of PAGES in for this DIMM's size based on its DRAM
+ * Address Mapping.
+ *
+ * First step is to calc the number of bits to shift a value of 1 left to
+ * indicate show many pages. Start with the DBAM value as the starting bits,
+ * then proceed to adjust those shift bits, based on CPU rev and the table.
+ * See BKDG on the DBAM
+ */
+static int k8_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
+{
+	int nr_pages;
+
+	if (pvt->ext_model >= OPTERON_CPU_REV_F) {
+		nr_pages = 1 << (revf_quad_ddr2_shift[dram_map] - PAGE_SHIFT);
+	} else {
+		/*
+		 * RevE and less section; this line is tricky. It collapses the
+		 * table used by RevD and later to one that matches revisions CG
+		 * and earlier.
+		 */
+		dram_map -= (pvt->ext_model >= OPTERON_CPU_REV_D) ?
+				(dram_map > 8 ? 4 : (dram_map > 5 ?
+				3 : (dram_map > 2 ? 1 : 0))) : 0;
+
+		/* 25 shift is 32MiB minimum DIMM size in RevE and prior */
+		nr_pages = 1 << (dram_map + 25 - PAGE_SHIFT);
+	}
+
+	return nr_pages;
+}
+
+
-- 
1.6.2.4


