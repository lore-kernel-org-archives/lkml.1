Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZD2Q4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZD2Q4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZD2Qz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:55:29 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16695
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756983AbZD2Qz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:55:27 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KIVGBY-01-3UK-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 03/21] amd64_edac: add driver structs
Date: Wed, 29 Apr 2009 18:54:49 +0200
Message-ID: <1241024107-14535-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 16:55:14.0335 (UTC) FILETIME=[442BA2F0:01C9C8EB]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  264 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 264 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index d43be21..532a059 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -736,3 +736,267 @@ enum {
 #define K8_MSR_MC4CTL	0x0410	/* North Bridge Check report ctl (64b) */
 #define K8_MSR_MC4STAT	0x0411	/* North Bridge status (64b) */
 #define K8_MSR_MC4ADDR	0x0412	/* North Bridge Address (64b) */
+
+/**
+ * popcnt - count the set bits in a bit vector.
+ * @vec - bit vector
+ *
+ * This instruction is supported only on F10h and later CPUs.
+ */
+#define popcnt(x)						\
+({								\
+	typeof(x) __ret;					\
+	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
+	__ret;							\
+})
+
+
+static struct edac_pci_ctl_info *amd64_ctl_pci;
+
+static int report_gart_errors;
+module_param(report_gart_errors, int, 0644);
+
+/*
+ * Set by command line parameter. If BIOS has enabled the ECC, this override is
+ * cleared to prevent re-enabling the hardware by this driver.
+ */
+static int ecc_enable_override;
+module_param(ecc_enable_override, int, 0644);
+
+/* AMD sets the first MC device at device ID 0x18. */
+static inline int get_mc_node_id_from_pdev(struct pci_dev *pdev)
+{
+	return PCI_SLOT(pdev->devfn) - 0x18;
+}
+
+/* Lookup table for all possible MC control instances */
+struct amd64_pvt;
+static struct mem_ctl_info *mci_lookup[MAX_NUMNODES];
+static struct amd64_pvt *pvt_lookup[MAX_NUMNODES];
+
+enum amd64_chipset_families {
+	K8_CPUS = 0,
+	F10_CPUS,
+	F11_CPUS,
+};
+
+/*
+ * Structure to hold:
+ *	1) dynamicly read status and error address HW registers
+ *	2) sysfs entered values
+ *	3) MCE values
+ *
+ * Depends on entry into the modules
+ */
+struct amd64_error_info_regs {
+	u32 nbcfg;
+	u32 nbsh;
+	u32 nbsl;
+	u32 nbeah;
+	u32 nbeal;
+};
+
+/*
+ * Each of the PCI Device IDs types have their own set of hardware
+ * accessor function and per device encoding/decoding logic.
+ */
+struct low_ops {
+	int (*probe_valid_hardware)(struct amd64_pvt *pvt);
+	int (*early_channel_count)(struct amd64_pvt *pvt);
+
+	u64 (*get_error_address)(struct mem_ctl_info *mci,
+			struct amd64_error_info_regs *info);
+	void (*read_dram_base_limit)(struct amd64_pvt *pvt, int dram);
+	void (*read_dram_ctl_register)(struct amd64_pvt *pvt);
+	void (*map_sysaddr_to_csrow)(struct mem_ctl_info *mci,
+					struct amd64_error_info_regs *info,
+					u64 SystemAddr);
+	int (*dbam_map_to_pages)(struct amd64_pvt *pvt, int dram_map);
+};
+
+/*
+ * amd64 family unique informatoin
+ */
+struct amd64_family_type {
+	const char *ctl_name;
+	u16 addr_f1_ctl;
+	u16 misc_f3_ctl;
+	struct low_ops ops;
+};
+
+static struct amd64_family_type amd64_family_types[];
+
+static inline const char *get_amd_family_name(int index)
+{
+	return amd64_family_types[index].ctl_name;
+}
+
+static inline struct low_ops *get_amd_family_ops(int index)
+{
+	return &amd64_family_types[index].ops;
+}
+
+/*
+ * Error injection control structure
+ */
+struct error_injection {
+	u32	section;
+	u32	word;
+	u32	bit_map;
+};
+
+struct amd64_pvt {
+	/* pci_device handles which we utilize */
+	struct pci_dev *addr_f1_ctl;
+	struct pci_dev *dram_f2_ctl;
+	struct pci_dev *misc_f3_ctl;
+
+	int mc_node_id;		/* MC index of this MC node */
+	int ext_model;		/* extended model value of this node */
+
+	struct low_ops	*ops;	/* pointer to per PCI Device ID func table */
+
+	int channel_count;	/* Count of 'channels' */
+
+	/* Raw registers */
+	u32 dclr0;		/* DRAM Configuration Low DCT0 reg */
+	u32 dclr1;		/* DRAM Configuration Low DCT1 reg */
+	u32 dchr0;		/* DRAM Configuration High DCT0 reg */
+	u32 dchr1;		/* DRAM Configuration High DCT1 reg */
+	u32 nbcap;		/* North Bridge Capabilities */
+	u32 nbcfg;		/* F10 North Bridge Configuration */
+	u32 ext_nbcfg;		/* Extended F10 North Bridge Configuration */
+	u32 dhar;		/* DRAM Hoist reg */
+	u32 dbam0;		/* DRAM Base Address Mapping reg for DCT0 */
+	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
+
+	/* DRAM CS Base Address Registers
+	 *   F2x[1,0][5C:40]
+	 */
+	u32 dcsb0[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
+	u32 dcsb1[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
+
+	/* DRAM CS Mask Registers
+	 *   F2x[1,0][6C:60]
+	 */
+	u32 dcsm0[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
+	u32 dcsm1[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
+
+	/* Decoded parts of DRAM BASE and LIMIT Registers
+	 * F1x[78,70,68,60,58,50,48,40]
+	 */
+	u64 dram_base[DRAM_REG_COUNT];/* DRAM Base Reg */
+	u64 dram_limit[DRAM_REG_COUNT];/* DRAM Limit Reg */
+	u8 dram_IntlvSel[DRAM_REG_COUNT];
+	u8 dram_IntlvEn[DRAM_REG_COUNT];
+	u8 dram_DstNode[DRAM_REG_COUNT];
+	u8 dram_rw_en[DRAM_REG_COUNT];
+
+	/* The following fields are set at (load) run time, after Revision has
+	 * been determined, since the dct_base and dct_mask registers vary
+	 * by CPU Revsion
+	 */
+	u32 dcsb_base;		/* DCSB base bits */
+	u32 dcsm_mask;		/* DCSM mask bits */
+	u32 num_dcsm;		/* Number of DCSM registers */
+	u32 dcs_mask_notused;	/* DCSM notused mask bits */
+	u32 dcs_shift;		/* DCSB and DCSM shift value */
+
+	u64 top_mem;		/* top of memory below 4GB */
+	u64 top_mem2;		/* top of memory above 4GB */
+
+	/* F10 registers */
+	u32 dram_ctl_select_low;	/* DRAM Controller Select Low Reg */
+	u32 dram_ctl_select_high;	/* DRAM Controller Select High Reg */
+	u32 online_spare;               /* On-Line spare Reg */
+
+	/* sysfs storage area: Temp storage for when input
+	 * is received from sysfs
+	 */
+	struct amd64_error_info_regs ctl_error_info;
+
+	/* Place to store error injection parameters prior to issue */
+	struct error_injection injection;
+
+	/* Save old hw registers' values before we modified them */
+	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
+	u32 old_nbctl;
+	u32 *old_mcgctl;		/* per core on this node */
+
+	/* MC Type Index value: socket F vs Family 10h */
+	u32 mc_type_index;
+
+	/* misc settings */
+	struct flags {
+		unsigned long cf8_extcfg:1;
+	} flags;
+};
+
+/*
+ * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
+ * for DDR2 DRAM mapping.
+ */
+static u32 revf_quad_ddr2_shift[] = {
+	0,	/* 0000b NULL DIMM (128mb) */
+	28,	/* 0001b 256mb */
+	29,	/* 0010b 512mb */
+	29,	/* 0011b 512mb */
+	29,	/* 0100b 512mb */
+	30,	/* 0101b 1gb */
+	30,	/* 0110b 1gb */
+	31,	/* 0111b 2gb */
+	31,	/* 1000b 2gb */
+	32,	/* 1001b 4gb */
+	32,	/* 1010b 4gb */
+	33,	/* 1011b 8gb */
+	0,	/* 1100b future */
+	0,	/* 1101b future */
+	0,	/* 1110b future */
+	0	/* 1111b future */
+};
+
+/* Valid scrub rates for the K8 hardware memory scrubber. We map
+ *	the scrubbing bandwidth to a valid bit pattern. The 'set'
+ *	operation finds the 'matching- or higher value'.
+ *
+ *FIXME: Produce a better mapping/linearisation.
+ */
+
+static struct scrubrate {
+	u32 scrubval;		/* bit pattern for scrub rate */
+	u32 bandwidth;		/* bandwidth consumed (bytes/sec) */
+} scrubrates[] = {
+	{ 0x01, 1600000000UL},
+	{ 0x02, 800000000UL},
+	{ 0x03, 400000000UL},
+	{ 0x04, 200000000UL},
+	{ 0x05, 100000000UL},
+	{ 0x06, 50000000UL},
+	{ 0x07, 25000000UL},
+	{ 0x08, 12284069UL},
+	{ 0x09, 6274509UL},
+	{ 0x0A, 3121951UL},
+	{ 0x0B, 1560975UL},
+	{ 0x0C, 781440UL},
+	{ 0x0D, 390720UL},
+	{ 0x0E, 195300UL},
+	{ 0x0F, 97650UL},
+	{ 0x10, 48854UL},
+	{ 0x11, 24427UL},
+	{ 0x12, 12213UL},
+	{ 0x13, 6101UL},
+	{ 0x14, 3051UL},
+	{ 0x15, 1523UL},
+	{ 0x16, 761UL},
+	{ 0x00, 0UL},        /* scrubbing off */
+
+};
+
+/*
+ * For future CPU versions, verify the following as new 'slow' rates appear and
+ * modify the necessary skip values for the supported CPU.
+ */
+#define K8_MIN_SCRUB_RATE_BITS		0
+#define F10_MIN_SCRUB_RATE_BITS	0x5
+#define F11_MIN_SCRUB_RATE_BITS	0x6
+
-- 
1.6.2.4


