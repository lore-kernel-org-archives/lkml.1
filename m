Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYGVT3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYGVT3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbYGVTYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:14 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40883 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbYGVTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:03 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VA-02-3LR-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Barry Kasindorf <barry.kasindorf@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/24] x86/oprofile: Add IBS support for AMD CPUs, model specific code
Date: Tue, 22 Jul 2008 21:08:55 +0200
Message-ID: <1216753748-11261-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0730 (UTC) FILETIME=[721F5320:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Kasindorf <barry.kasindorf@amd.com>

This patchset supports the new profiling hardware available in the
latest AMD CPUs in the oProfile driver.

Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |  257 +++++++++++++++++++++++++++++++++++
 1 files changed, 257 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 40ecb02..229e0b4 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -9,9 +9,13 @@
  * @author Philippe Elie
  * @author Graydon Hoare
  * @author Robert Richter <robert.richter@amd.com>
+ * @author Barry Kasindorf
 */
 
 #include <linux/oprofile.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+
 #include <asm/ptrace.h>
 #include <asm/msr.h>
 #include <asm/nmi.h>
@@ -43,7 +47,83 @@
 #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
 #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
+#define IBS_FETCH_CTL_HIGH_MASK		0xFFFFFFFF
+/* high dword bit IbsFetchCtl[bit 49] */
+#define IBS_FETCH_VALID_BIT		(1UL << 17)
+/* high dword bit IbsFetchCtl[bit 52] */
+#define IBS_FETCH_PHY_ADDR_VALID_BIT 	(1UL << 20)
+/* high dword bit IbsFetchCtl[bit 48] */
+#define IBS_FETCH_ENABLE		(1UL << 16)
+
+#define IBS_FETCH_CTL_CNT_MASK 		0x00000000FFFF0000UL
+#define IBS_FETCH_CTL_MAX_CNT_MASK 	0x000000000000FFFFUL
+
+/*IbsOpCtl masks/bits */
+#define IBS_OP_VALID_BIT	(1ULL<<18)	/* IbsOpCtl[bit18] */
+#define IBS_OP_ENABLE		(1ULL<<17)	/* IBS_OP_ENABLE[bit17]*/
+
+/* Codes used in cpu_buffer.c */
+#define IBS_FETCH_BEGIN 3
+#define IBS_OP_BEGIN    4
+
+/*IbsOpData3 masks */
+#define IBS_CTL_LVT_OFFSET_VALID_BIT		(1ULL<<8)
+
+/*PCI Extended Configuration Constants */
+/* MSR to set the IBS control register APIC LVT offset */
+#define IBS_LVT_OFFSET_PCI		0x1CC
+
+struct ibs_fetch_sample {
+	/* MSRC001_1031 IBS Fetch Linear Address Register */
+	unsigned int ibs_fetch_lin_addr_low;
+	unsigned int ibs_fetch_lin_addr_high;
+	/* MSRC001_1030 IBS Fetch Control Register */
+	unsigned int ibs_fetch_ctl_low;
+	unsigned int ibs_fetch_ctl_high;
+	/* MSRC001_1032 IBS Fetch Physical Address Register */
+	unsigned int ibs_fetch_phys_addr_low;
+	unsigned int ibs_fetch_phys_addr_high;
+};
+
+struct ibs_op_sample {
+	/* MSRC001_1034 IBS Op Logical Address Register (IbsRIP) */
+	unsigned int ibs_op_rip_low;
+	unsigned int ibs_op_rip_high;
+	/* MSRC001_1035 IBS Op Data Register */
+	unsigned int ibs_op_data1_low;
+	unsigned int ibs_op_data1_high;
+	/* MSRC001_1036 IBS Op Data 2 Register */
+	unsigned int ibs_op_data2_low;
+	unsigned int ibs_op_data2_high;
+	/* MSRC001_1037 IBS Op Data 3 Register */
+	unsigned int ibs_op_data3_low;
+	unsigned int ibs_op_data3_high;
+	/* MSRC001_1038 IBS DC Linear Address Register (IbsDcLinAd) */
+	unsigned int ibs_dc_linear_low;
+	unsigned int ibs_dc_linear_high;
+	/* MSRC001_1039 IBS DC Physical Address Register (IbsDcPhysAd) */
+	unsigned int ibs_dc_phys_low;
+	unsigned int ibs_dc_phys_high;
+};
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
+*/
+static void clear_ibs_nmi(void);
+
 static unsigned long reset_value[NUM_COUNTERS];
+static int ibs_allowed;	/* AMD Family10h and later */
+
+struct op_ibs_config {
+	unsigned long op_enabled;
+	unsigned long fetch_enabled;
+	unsigned long max_cnt_fetch;
+	unsigned long max_cnt_op;
+	unsigned long rand_en;
+	unsigned long dispatched_ops;
+};
+
+static struct op_ibs_config ibs_config;
 
 /* functions for op_amd_spec */
 
@@ -121,6 +201,8 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 {
 	unsigned int low, high;
 	int i;
+	struct ibs_fetch_sample ibs_fetch;
+	struct ibs_op_sample ibs_op;
 
 	for (i = 0 ; i < NUM_COUNTERS; ++i) {
 		if (!reset_value[i])
@@ -132,6 +214,65 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
+	/*If AMD and IBS is available */
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		if (high & IBS_FETCH_VALID_BIT) {
+			ibs_fetch.ibs_fetch_ctl_high = high;
+			ibs_fetch.ibs_fetch_ctl_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
+			ibs_fetch.ibs_fetch_lin_addr_high = high;
+			ibs_fetch.ibs_fetch_lin_addr_low = low;
+			rdmsr(MSR_AMD64_IBSFETCHPHYSAD, low, high);
+			ibs_fetch.ibs_fetch_phys_addr_high = high;
+			ibs_fetch.ibs_fetch_phys_addr_low = low;
+
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_fetch,
+						IBS_FETCH_BEGIN);
+
+			/*reenable the IRQ */
+			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+			high &= ~(IBS_FETCH_VALID_BIT);
+			high |= IBS_FETCH_ENABLE;
+			low &= IBS_FETCH_CTL_MAX_CNT_MASK;
+			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		}
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+		if (low & IBS_OP_VALID_BIT) {
+			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
+			ibs_op.ibs_op_rip_low = low;
+			ibs_op.ibs_op_rip_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA, low, high);
+			ibs_op.ibs_op_data1_low = low;
+			ibs_op.ibs_op_data1_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA2, low, high);
+			ibs_op.ibs_op_data2_low = low;
+			ibs_op.ibs_op_data2_high = high;
+			rdmsr(MSR_AMD64_IBSOPDATA3, low, high);
+			ibs_op.ibs_op_data3_low = low;
+			ibs_op.ibs_op_data3_high = high;
+			rdmsr(MSR_AMD64_IBSDCLINAD, low, high);
+			ibs_op.ibs_dc_linear_low = low;
+			ibs_op.ibs_dc_linear_high = high;
+			rdmsr(MSR_AMD64_IBSDCPHYSAD, low, high);
+			ibs_op.ibs_dc_phys_low = low;
+			ibs_op.ibs_dc_phys_high = high;
+
+			/* reenable the IRQ */
+			oprofile_add_ibs_sample(regs,
+						(unsigned int *)&ibs_op,
+						IBS_OP_BEGIN);
+			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+			low &= ~(IBS_OP_VALID_BIT);
+			low |= IBS_OP_ENABLE;
+			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+		}
+	}
+
 	/* See op_model_ppro.c */
 	return 1;
 }
@@ -148,6 +289,17 @@ static void op_amd_start(struct op_msrs const * const msrs)
 			CTRL_WRITE(low, high, msrs, i);
 		}
 	}
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		high = IBS_FETCH_ENABLE;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_ENABLE;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
 }
 
 
@@ -165,6 +317,18 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 		CTRL_SET_INACTIVE(low);
 		CTRL_WRITE(low, high, msrs, i);
 	}
+
+	if (ibs_allowed && ibs_config.fetch_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.op_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
 }
 
 static void op_amd_shutdown(struct op_msrs const * const msrs)
@@ -181,6 +345,99 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
+static inline void apic_init_ibs_nmi_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+/*
+ * initialize the APIC for the IBS interrupts
+ * if needed on AMD Family10h rev B0 and later
+ */
+static void setup_ibs(void)
+{
+	struct pci_dev *gh_device = NULL;
+	u32 low, high;
+	u8 vector;
+
+	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
+
+	if (!ibs_allowed)
+		return;
+
+	/* This gets the APIC_EILVT_LVTOFF_IBS value */
+	vector = setup_APIC_eilvt_ibs(0, 0, 1);
+
+	/*see if the IBS control register is already set correctly*/
+	/*remove this when we know for sure it is done
+	  in the kernel init*/
+	rdmsr(MSR_AMD64_IBSCTL, low, high);
+	if ((low & (IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) !=
+		(IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) {
+
+		/**** Be sure to run loop until NULL is returned to
+		decrement reference count on any pci_dev structures
+		returned ****/
+		while ((gh_device = pci_get_device(PCI_VENDOR_ID_AMD,
+			PCI_DEVICE_ID_AMD_10H_NB_MISC, gh_device))
+			!= NULL) {
+			/* This code may change if we can find a proper
+			* way to get at the PCI extended config space */
+			pci_write_config_dword(
+				gh_device, IBS_LVT_OFFSET_PCI,
+				(vector | IBS_CTL_LVT_OFFSET_VALID_BIT));
+		}
+	}
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1, 1);
+}
+
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
+ * rev B0 and later */
+static void clear_ibs_nmi(void)
+{
+	if (ibs_allowed)
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1, 1);
+}
+
+static void setup_ibs_files(struct super_block *sb, struct dentry *root)
+{
+	char buf[12];
+	struct dentry *dir;
+
+	if (!ibs_allowed)
+		return;
+
+	/* setup some reasonable defaults */
+	ibs_config.max_cnt_fetch = 250000;
+	ibs_config.fetch_enabled = 0;
+	ibs_config.max_cnt_op = 250000;
+	ibs_config.op_enabled = 0;
+	ibs_config.dispatched_ops = 1;
+	snprintf(buf,  sizeof(buf), "ibs_fetch");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "rand_enable",
+				&ibs_config.rand_en);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.fetch_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_fetch);
+	snprintf(buf,  sizeof(buf), "ibs_uops");
+	dir = oprofilefs_mkdir(sb, root, buf);
+	oprofilefs_create_ulong(sb, dir, "enable",
+		&ibs_config.op_enabled);
+	oprofilefs_create_ulong(sb, dir, "max_count",
+		&ibs_config.max_cnt_op);
+	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+		&ibs_config.dispatched_ops);
+}
+
 static int op_amd_init(struct oprofile_operations *ops)
 {
 	return 0;
-- 
1.5.5.4


