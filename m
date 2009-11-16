Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZKPORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZKPORP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZKPORO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:17:14 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27093 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZKPOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:16:38 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz1fa4Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KT7GZ5-01-9KO-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, <norsk5@yahoo.com>
Subject: [PATCH 11/21] amd64_edac: enhance address to DRAM bank mapping
Date: Mon, 16 Nov 2009 15:16:38 +0100
Message-ID: <1258381008-18783-12-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
References: <1258381008-18783-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Nov 2009 14:16:13.0094 (UTC) FILETIME=[5A2D8C60:01CA66C7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cs mode to cs size mapping tables for DDR2 and DDR3 and F10
and all K8 flavors and remove klugdy table of pseudo values. Add a
low_ops->dbam_to_cs member which is family-specific and replaces
low_ops->dbam_map_to_pages since the pages calculation is a one liner
now.

Further cleanups, while at it:

- shorten family name defines
- align amd64_family_types struct members

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  194 ++++++++++++++++++++++-----------------------
 drivers/edac/amd64_edac.h |   34 +++-----
 2 files changed, 108 insertions(+), 120 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ed9b07a..7e67054 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -19,26 +19,48 @@ static struct mem_ctl_info *mci_lookup[EDAC_MAX_NUMNODES];
 static struct amd64_pvt *pvt_lookup[EDAC_MAX_NUMNODES];
 
 /*
- * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
- * for DDR2 DRAM mapping.
+ * Address to DRAM bank mapping: see F2x80 for K8 and F2x[1,0]80 for Fam10 and
+ * later.
  */
-u32 revf_quad_ddr2_shift[] = {
-	0,	/* 0000b NULL DIMM (128mb) */
-	28,	/* 0001b 256mb */
-	29,	/* 0010b 512mb */
-	29,	/* 0011b 512mb */
-	29,	/* 0100b 512mb */
-	30,	/* 0101b 1gb */
-	30,	/* 0110b 1gb */
-	31,	/* 0111b 2gb */
-	31,	/* 1000b 2gb */
-	32,	/* 1001b 4gb */
-	32,	/* 1010b 4gb */
-	33,	/* 1011b 8gb */
-	0,	/* 1100b future */
-	0,	/* 1101b future */
-	0,	/* 1110b future */
-	0	/* 1111b future */
+static int ddr2_dbam_revCG[] = {
+			   [0]		= 32,
+			   [1]		= 64,
+			   [2]		= 128,
+			   [3]		= 256,
+			   [4]		= 512,
+			   [5]		= 1024,
+			   [6]		= 2048,
+};
+
+static int ddr2_dbam_revD[] = {
+			   [0]		= 32,
+			   [1]		= 64,
+			   [2 ... 3]	= 128,
+			   [4]		= 256,
+			   [5]		= 512,
+			   [6]		= 256,
+			   [7]		= 512,
+			   [8 ... 9]	= 1024,
+			   [10]		= 2048,
+};
+
+static int ddr2_dbam[] = { [0]		= 128,
+			   [1]		= 256,
+			   [2 ... 4]	= 512,
+			   [5 ... 6]	= 1024,
+			   [7 ... 8]	= 2048,
+			   [9 ... 10]	= 4096,
+			   [11]		= 8192,
+};
+
+static int ddr3_dbam[] = { [0]		= -1,
+			   [1]		= 256,
+			   [2]		= 512,
+			   [3 ... 4]	= -1,
+			   [5 ... 6]	= 1024,
+			   [7 ... 8]	= 2048,
+			   [9 ... 10]	= 4096,
+			   [11]	= 8192,
 };
 
 /*
@@ -187,7 +209,7 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
 /* Map from a CSROW entry to the mask entry that operates on it */
 static inline u32 amd64_map_to_dcs_mask(struct amd64_pvt *pvt, int csrow)
 {
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_F)
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F)
 		return csrow;
 	else
 		return csrow >> 1;
@@ -435,7 +457,7 @@ int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
 	u64 base;
 
 	/* only revE and later have the DRAM Hole Address Register */
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_E) {
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_E) {
 		debugf1("  revision %d for node %d does not support DHAR\n",
 			pvt->ext_model, pvt->mc_node_id);
 		return 1;
@@ -795,7 +817,7 @@ static void amd64_cpu_display_info(struct amd64_pvt *pvt)
 		edac_printk(KERN_DEBUG, EDAC_MC, "F10h CPU detected\n");
 	else if (boot_cpu_data.x86 == 0xf)
 		edac_printk(KERN_DEBUG, EDAC_MC, "%s detected\n",
-			(pvt->ext_model >= OPTERON_CPU_REV_F) ?
+			(pvt->ext_model >= K8_REV_F) ?
 			"Rev F or later" : "Rev E or earlier");
 	else
 		/* we'll hardly ever ever get here */
@@ -811,7 +833,7 @@ static enum edac_type amd64_determine_edac_cap(struct amd64_pvt *pvt)
 	int bit;
 	enum dev_type edac_cap = EDAC_FLAG_NONE;
 
-	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= OPTERON_CPU_REV_F)
+	bit = (boot_cpu_data.x86 > 0xf || pvt->ext_model >= K8_REV_F)
 		? 19
 		: 17;
 
@@ -936,7 +958,7 @@ static void amd64_read_dbam_reg(struct amd64_pvt *pvt)
 static void amd64_set_dct_base_and_mask(struct amd64_pvt *pvt)
 {
 
-	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < OPTERON_CPU_REV_F) {
+	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
 		pvt->dcsb_base		= REV_E_DCSB_BASE_BITS;
 		pvt->dcsm_mask		= REV_E_DCSM_MASK_BITS;
 		pvt->dcs_mask_notused	= REV_E_DCS_NOTUSED_BITS;
@@ -1009,7 +1031,7 @@ static enum mem_type amd64_determine_memory_type(struct amd64_pvt *pvt)
 {
 	enum mem_type type;
 
-	if (boot_cpu_data.x86 >= 0x10 || pvt->ext_model >= OPTERON_CPU_REV_F) {
+	if (boot_cpu_data.x86 >= 0x10 || pvt->ext_model >= K8_REV_F) {
 		/* Rev F and later */
 		type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
 	} else {
@@ -1042,7 +1064,7 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 	if (err)
 		return err;
 
-	if ((boot_cpu_data.x86_model >> 4) >= OPTERON_CPU_REV_F) {
+	if ((boot_cpu_data.x86_model >> 4) >= K8_REV_F) {
 		/* RevF (NPT) and later */
 		flag = pvt->dclr0 & F10_WIDTH_128;
 	} else {
@@ -1158,36 +1180,18 @@ static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 	}
 }
 
-/*
- * determrine the number of PAGES in for this DIMM's size based on its DRAM
- * Address Mapping.
- *
- * First step is to calc the number of bits to shift a value of 1 left to
- * indicate show many pages. Start with the DBAM value as the starting bits,
- * then proceed to adjust those shift bits, based on CPU rev and the table.
- * See BKDG on the DBAM
- */
-static int k8_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
+static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 {
-	int nr_pages;
+	int *dbam_map;
 
-	if (pvt->ext_model >= OPTERON_CPU_REV_F) {
-		nr_pages = 1 << (revf_quad_ddr2_shift[dram_map] - PAGE_SHIFT);
-	} else {
-		/*
-		 * RevE and less section; this line is tricky. It collapses the
-		 * table used by RevD and later to one that matches revisions CG
-		 * and earlier.
-		 */
-		dram_map -= (pvt->ext_model >= OPTERON_CPU_REV_D) ?
-				(dram_map > 8 ? 4 : (dram_map > 5 ?
-				3 : (dram_map > 2 ? 1 : 0))) : 0;
-
-		/* 25 shift is 32MiB minimum DIMM size in RevE and prior */
-		nr_pages = 1 << (dram_map + 25 - PAGE_SHIFT);
-	}
+	if (pvt->ext_model >= K8_REV_F)
+		dbam_map = ddr2_dbam;
+	else if (pvt->ext_model >= K8_REV_D)
+		dbam_map = ddr2_dbam_revD;
+	else
+		dbam_map = ddr2_dbam_revCG;
 
-	return nr_pages;
+	return dbam_map[cs_mode];
 }
 
 /*
@@ -1249,9 +1253,16 @@ err_reg:
 
 }
 
-static int f10_dbam_map_to_pages(struct amd64_pvt *pvt, int dram_map)
+static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
 {
-	return 1 << (revf_quad_ddr2_shift[dram_map] - PAGE_SHIFT);
+	int *dbam_map;
+
+	if (pvt->dchr0 & DDR3_MODE || pvt->dchr1 & DDR3_MODE)
+		dbam_map = ddr3_dbam;
+	else
+		dbam_map = ddr2_dbam;
+
+	return dbam_map[cs_mode];
 }
 
 /* Enable extended configuration access via 0xCF8 feature */
@@ -1706,23 +1717,6 @@ static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
 }
 
 /*
- * Input (@index) is the DBAM DIMM value (1 of 4) used as an index into a shift
- * table (revf_quad_ddr2_shift) which starts at 128MB DIMM size. Index of 0
- * indicates an empty DIMM slot, as reported by Hardware on empty slots.
- *
- * Normalize to 128MB by subracting 27 bit shift.
- */
-static int map_dbam_to_csrow_size(int index)
-{
-	int mega_bytes = 0;
-
-	if (index > 0 && index <= DBAM_MAX_VALUE)
-		mega_bytes = ((128 << (revf_quad_ddr2_shift[index]-27)));
-
-	return mega_bytes;
-}
-
-/*
  * debug routine to display the memory sizes of all logical DIMMs and its
  * CSROWs as well
  */
@@ -1734,7 +1728,7 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 
 	if (boot_cpu_data.x86 == 0xf) {
 		/* K8 families < revF not supported yet */
-	       if (pvt->ext_model < OPTERON_CPU_REV_F)
+	       if (pvt->ext_model < K8_REV_F)
 			return;
 	       else
 		       WARN_ON(ctrl != 0);
@@ -1753,11 +1747,11 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 
 		size0 = 0;
 		if (dcsb[dimm*2] & K8_DCSB_CS_ENABLE)
-			size0 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
+			size0 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		size1 = 0;
 		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
-			size1 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
+			size1 = pvt->ops->dbam_to_cs(pvt, DBAM_DIMM(dimm, dbam));
 
 		edac_printk(KERN_DEBUG, EDAC_MC, " %d: %5dMB %d: %5dMB\n",
 			    dimm * 2, size0, dimm * 2 + 1, size1);
@@ -1780,8 +1774,8 @@ static int f10_probe_valid_hardware(struct amd64_pvt *pvt)
 	 * If we are on a DDR3 machine, we don't know yet if
 	 * we support that properly at this time
 	 */
-	if ((pvt->dchr0 & F10_DCHR_Ddr3Mode) ||
-	    (pvt->dchr1 & F10_DCHR_Ddr3Mode)) {
+	if ((pvt->dchr0 & DDR3_MODE) ||
+	    (pvt->dchr1 & DDR3_MODE)) {
 
 		amd64_printk(KERN_WARNING,
 			"%s() This machine is running with DDR3 memory. "
@@ -1817,11 +1811,11 @@ static struct amd64_family_type amd64_family_types[] = {
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_K8_NB_MISC,
 		.ops = {
-			.early_channel_count = k8_early_channel_count,
-			.get_error_address = k8_get_error_address,
-			.read_dram_base_limit = k8_read_dram_base_limit,
-			.map_sysaddr_to_csrow = k8_map_sysaddr_to_csrow,
-			.dbam_map_to_pages = k8_dbam_map_to_pages,
+			.early_channel_count	= k8_early_channel_count,
+			.get_error_address	= k8_get_error_address,
+			.read_dram_base_limit	= k8_read_dram_base_limit,
+			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
+			.dbam_to_cs		= k8_dbam_to_chip_select,
 		}
 	},
 	[F10_CPUS] = {
@@ -1829,13 +1823,13 @@ static struct amd64_family_type amd64_family_types[] = {
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_10H_NB_MAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
-			.probe_valid_hardware = f10_probe_valid_hardware,
-			.early_channel_count = f10_early_channel_count,
-			.get_error_address = f10_get_error_address,
-			.read_dram_base_limit = f10_read_dram_base_limit,
-			.read_dram_ctl_register = f10_read_dram_ctl_register,
-			.map_sysaddr_to_csrow = f10_map_sysaddr_to_csrow,
-			.dbam_map_to_pages = f10_dbam_map_to_pages,
+			.probe_valid_hardware	= f10_probe_valid_hardware,
+			.early_channel_count	= f10_early_channel_count,
+			.get_error_address	= f10_get_error_address,
+			.read_dram_base_limit	= f10_read_dram_base_limit,
+			.read_dram_ctl_register	= f10_read_dram_ctl_register,
+			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f10_dbam_to_chip_select,
 		}
 	},
 	[F11_CPUS] = {
@@ -1843,13 +1837,13 @@ static struct amd64_family_type amd64_family_types[] = {
 		.addr_f1_ctl = PCI_DEVICE_ID_AMD_11H_NB_MAP,
 		.misc_f3_ctl = PCI_DEVICE_ID_AMD_11H_NB_MISC,
 		.ops = {
-			.probe_valid_hardware = f10_probe_valid_hardware,
-			.early_channel_count = f10_early_channel_count,
-			.get_error_address = f10_get_error_address,
-			.read_dram_base_limit = f10_read_dram_base_limit,
-			.read_dram_ctl_register = f10_read_dram_ctl_register,
-			.map_sysaddr_to_csrow = f10_map_sysaddr_to_csrow,
-			.dbam_map_to_pages = f10_dbam_map_to_pages,
+			.probe_valid_hardware	= f10_probe_valid_hardware,
+			.early_channel_count	= f10_early_channel_count,
+			.get_error_address	= f10_get_error_address,
+			.read_dram_base_limit	= f10_read_dram_base_limit,
+			.read_dram_ctl_register	= f10_read_dram_ctl_register,
+			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f10_dbam_to_chip_select,
 		}
 	},
 };
@@ -2425,7 +2419,7 @@ static void amd64_read_mc_registers(struct amd64_pvt *pvt)
  */
 static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
 {
-	u32 dram_map, nr_pages;
+	u32 cs_mode, nr_pages;
 
 	/*
 	 * The math on this doesn't look right on the surface because x/2*4 can
@@ -2434,9 +2428,9 @@ static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
 	 * number of bits to shift the DBAM register to extract the proper CSROW
 	 * field.
 	 */
-	dram_map = (pvt->dbam0 >> ((csrow_nr / 2) * 4)) & 0xF;
+	cs_mode = (pvt->dbam0 >> ((csrow_nr / 2) * 4)) & 0xF;
 
-	nr_pages = pvt->ops->dbam_map_to_pages(pvt, dram_map);
+	nr_pages = pvt->ops->dbam_to_cs(pvt, cs_mode) << (20 - PAGE_SHIFT);
 
 	/*
 	 * If dual channel then double the memory size of single channel.
@@ -2444,7 +2438,7 @@ static u32 amd64_csrow_nr_pages(int csrow_nr, struct amd64_pvt *pvt)
 	 */
 	nr_pages <<= (pvt->channel_count - 1);
 
-	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, dram_map);
+	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
 	debugf0("    nr_pages= %u  channel-count = %d\n",
 		nr_pages, pvt->channel_count);
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 24e2804..f8c187e 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -135,13 +135,9 @@
 #define EDAC_MAX_NUMNODES		8
 
 /* Extended Model from CPUID, for CPU Revision numbers */
-#define OPTERON_CPU_LE_REV_C		0
-#define OPTERON_CPU_REV_D		1
-#define OPTERON_CPU_REV_E		2
-
-/* NPT processors have the following Extended Models */
-#define OPTERON_CPU_REV_F		4
-#define OPTERON_CPU_REV_FA		5
+#define K8_REV_D			1
+#define K8_REV_E			2
+#define K8_REV_F			4
 
 /* Hardware limit on ChipSelect rows per MC and processors per system */
 #define MAX_CS_COUNT			8
@@ -243,7 +239,7 @@
 #define F10_DCHR_1			0x194
 
 #define F10_DCHR_FOUR_RANK_DIMM		BIT(18)
-#define F10_DCHR_Ddr3Mode		BIT(8)
+#define DDR3_MODE			BIT(8)
 #define F10_DCHR_MblMode		BIT(6)
 
 
@@ -501,7 +497,6 @@ struct scrubrate {
 };
 
 extern struct scrubrate scrubrates[23];
-extern u32 revf_quad_ddr2_shift[16];
 extern const char *tt_msgs[4];
 extern const char *ll_msgs[4];
 extern const char *rrrr_msgs[16];
@@ -531,17 +526,16 @@ extern struct mcidev_sysfs_attribute amd64_dbg_attrs[NUM_DBG_ATTRS],
  * functions and per device encoding/decoding logic.
  */
 struct low_ops {
-	int (*probe_valid_hardware)(struct amd64_pvt *pvt);
-	int (*early_channel_count)(struct amd64_pvt *pvt);
-
-	u64 (*get_error_address)(struct mem_ctl_info *mci,
-			struct err_regs *info);
-	void (*read_dram_base_limit)(struct amd64_pvt *pvt, int dram);
-	void (*read_dram_ctl_register)(struct amd64_pvt *pvt);
-	void (*map_sysaddr_to_csrow)(struct mem_ctl_info *mci,
-					struct err_regs *info,
-					u64 SystemAddr);
-	int (*dbam_map_to_pages)(struct amd64_pvt *pvt, int dram_map);
+	int (*probe_valid_hardware)	(struct amd64_pvt *pvt);
+	int (*early_channel_count)	(struct amd64_pvt *pvt);
+
+	u64 (*get_error_address)	(struct mem_ctl_info *mci,
+					 struct err_regs *info);
+	void (*read_dram_base_limit)	(struct amd64_pvt *pvt, int dram);
+	void (*read_dram_ctl_register)	(struct amd64_pvt *pvt);
+	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci,
+					 struct err_regs *info, u64 SystemAddr);
+	int (*dbam_to_cs)		(struct amd64_pvt *pvt, int cs_mode);
 };
 
 struct amd64_family_type {
-- 
1.6.4.3


