Return-Path: <linux-kernel-owner+w=401wt.eu-S934977AbYBHUE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977AbYBHUE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbYBHUER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:04:17 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10506 "EHLO
	outbound5-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273AbYBHUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:04:15 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Message-ID: <47ACB578.9090506@amd.com>
Date: Fri, 08 Feb 2008 15:03:04 -0500
From: "Barry Kasindorf" <barry.kasindorf@amd.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
cc: barry.kasindorf@amd.com
Subject: [PATCH 2/3] AMD Family10h IBS support for oProfile driver
X-OriginalArrivalTime: 08 Feb 2008 20:03:04.0781 (UTC)
 FILETIME=[9DA4B7D0:01C86A8D]
X-WSS-ID: 6BB26A3D2IW10897685-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
  kernel/apic_64.c           |    1
  oprofile/op_model_athlon.c |  245 ++++++++++++++++++++++++++++++++++++++++++++-
  oprofile/op_x86_model.h    |   37 ++++++
  3 files changed, 281 insertions(+), 2 deletions(-)
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 1e417df..7dbe8b0 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -224,6 +224,30 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
  	if (!oneshot)
  		apic_write_around(APIC_TMICT, clocks/APIC_DIVISOR);
  }
+#define APIC_EILVT_LVTOFF_MCE 0
+#define APIC_EILVT_LVTOFF_IBS 1
+
+static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
+{
+	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
+
+	apic_write(reg, v);
+}
+
+u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_MCE;
+}
+
+u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
+{
+	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
+	return APIC_EILVT_LVTOFF_IBS;
+}
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
+

  /*
   * Program the next event, relative to now
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 286a396..bced2a6 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -219,6 +219,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
  	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
  	return APIC_EILVT_LVTOFF_IBS;
  }
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);

  /*
   * Program the next event, relative to now
diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index c3ee433..2daf994 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -8,9 +8,13 @@
   * @author John Levon
   * @author Philippe Elie
   * @author Graydon Hoare
- */
+ * @author Barry Kasindorf
+*/

  #include <linux/oprofile.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+
  #include <asm/ptrace.h>
  #include <asm/msr.h>
  #include <asm/nmi.h>
@@ -42,8 +46,69 @@
  #define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
  #define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))

+/* high dword IbsFetchCtl[bit 49] */
+#define IBS_FETCH_VALID_BIT		0x00020000
+/* high dword IbsFetchCtl[bit 52] */
+#define IBS_FETCH_PHY_ADDR_VALID_BIT 	0x00100000
+#define IBS_FETCH_CTL_HIGH_MASK		0xFFFFFFFF
+/* high dword IbsFetchCtl[bit 48] */
+#define IBS_FETCH_ENABLE		0x00010000
+#define IBS_FETCH_CTL_CNT_MASK 		0x00000000FFFF0000
+#define IBS_FETCH_CTL_MAX_CNT_MASK 	0x000000000000FFFF
+
+/*IbsOpCtl masks/bits */
+#define IBS_OP_VALID_BIT 	0x0000000000040000 /* IbsOpCtl[bit18] */
+#define IBS_OP_ENABLE 		0x0000000000020000 /* IBS_OP_ENABLE[bit17]*/
+
+/*IbsOpData masks */
+#define IBS_OP_DATA_BRANCH_MASK	   0x3F00000000		/* IbsOpData[32:37] */
+#define IBS_OP_DATA_HIGH_MASK	   0x0000FFFF00000000	/* IbsOpData[32:47] */
+#define IBS_OP_DATA_LOW_MASK	   0x00000000FFFFFFFF	/*IbsOpData[0:31] */
+
+/*IbsOpData2 masks */
+#define IBS_OP_DATA2_MASK	   0x000000000000002F
+
+/*IbsOpData3 masks */
+#define IBS_OP_DATA3_LS_MASK	   0x0000000003
+
+#define IBS_OP_DATA3_PHY_ADDR_VALID_BIT 0x0000000000040000
+#define IBS_OP_DATA3_LIN_ADDR_VALID_BIT 0x0000000000020000
+#define IBS_CTL_LVT_OFFSET_VALID_BIT	0x100
+/* AMD ext internal APIC Local Vectors */
+#define APIC_IELVT			0x500
+/* number of APIC Entries for ieLVT */
+#define NUM_APIC_IELVT			4
+
+/*PCI Extended Configuration Constants */
+/* Northbridge Configuration Register */
+#define NB_CFG_MSR            		0xC001001F
+/* Bit 46, EnableCf8ExtCfg: enable CF8 extended configuration cycles */
+#define ENABLE_CF8_EXT_CFG_MASK		0x4000
+/* MSR to set the IBS control register APIC LVT offset */
+#define IBS_LVT_OFFSET_PCI		0x1CC
+
+/* IBS rev [bit 10] 1 = IBS Rev B */
+#define IBS_REV_MASK	    		0x400
+
+/* When pci_ids.h gets caught up remove this */
+#ifndef PCI_DEVICE_ID_AMD_FAMILY10H_NB
+#define PCI_DEVICE_ID_AMD_FAMILY10H_NB	0x1200
+#endif
+
+/**
+ * Add an AMD IBS  sample. This may be called from any context. Pass
+ * smp_processor_id() as cpu. Passes IBS registers as a unsigned int[8]
+ */
+void oprofile_add_ibs_op_sample(struct pt_regs * const regs,
+				unsigned int * const ibs_op);
+
+void oprofile_add_ibs_fetch_sample(struct pt_regs * const regs,
+				unsigned int * const ibs_fetch);
+
  static unsigned long reset_value[NUM_COUNTERS];
-
+extern int ibs_allowed;		/* AMD Family 10h+ */
+static int Extended_PCI_Enabled;
+
  static void athlon_fill_in_addresses(struct op_msrs * const msrs)
  {
  	int i;
@@ -118,6 +183,8 @@ static int athlon_check_ctrs(struct pt_regs * const regs,
  {
  	unsigned int low, high;
  	int i;
+	struct ibs_fetch_sample ibs_fetch;
+	struct ibs_op_sample ibs_op;

  	for (i = 0 ; i < NUM_COUNTERS; ++i) {
  		if (!reset_value[i])
@@ -129,6 +196,63 @@ static int athlon_check_ctrs(struct pt_regs * const regs,
  		}
  	}

+	/*If AMD and IBS is available */
+	if (ibs_allowed && ibs_config.FETCH_enabled) {
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
+			oprofile_add_ibs_fetch_sample(regs,
+						 (unsigned int *)&ibs_fetch);
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
+	if (ibs_allowed && ibs_config.OP_enabled) {
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
+			oprofile_add_ibs_op_sample(regs,
+						 (unsigned int *)&ibs_op);
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
@@ -145,6 +269,17 @@ static void athlon_start(struct op_msrs const * const msrs)
  			CTRL_WRITE(low, high, msrs, i);
  		}
  	}
+	if (ibs_allowed && ibs_config.FETCH_enabled) {
+		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		high = IBS_FETCH_ENABLE;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.OP_enabled) {
+		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF) + IBS_OP_ENABLE;
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
  }


@@ -162,6 +297,18 @@ static void athlon_stop(struct op_msrs const * const msrs)
  		CTRL_SET_INACTIVE(low);
  		CTRL_WRITE(low, high, msrs, i);
  	}
+
+	if (ibs_allowed && ibs_config.FETCH_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	}
+
+	if (ibs_allowed && ibs_config.OP_enabled) {
+		low = 0;		/* clear max count and enable */
+		high = 0;
+		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+	}
  }

  static void athlon_shutdown(struct op_msrs const * const msrs)
@@ -178,6 +325,102 @@ static void athlon_shutdown(struct op_msrs const * const msrs)
  	}
  }

+/*
+ *	Enable AMD extended PCI config space thru IO
+ *	save previous state
+ */
+static void
+	Enable_Extended_PCI_Config(void)
+{
+	unsigned int low, high;
+	rdmsr(NB_CFG_MSR, low, high);
+	Extended_PCI_Enabled = high  & ENABLE_CF8_EXT_CFG_MASK;
+	high |= ENABLE_CF8_EXT_CFG_MASK;
+	wrmsr(NB_CFG_MSR, low, high);
+}
+
+/*
+ *	Disable AMD extended PCI config space thru IO
+ *	restore to previous state
+ */
+static void
+	Disable_Extended_PCI_Config(void)
+{
+	unsigned int low, high;
+	rdmsr(NB_CFG_MSR, low, high);
+	high &= ~ENABLE_CF8_EXT_CFG_MASK;
+	high |= Extended_PCI_Enabled;
+	wrmsr(NB_CFG_MSR, low, high);
+}
+/*
+ * Modified to use AMD extended PCI config space thru IO
+ * these 2 I/Os should be atomic but there is no easy way to do that.
+ * Should use the MMio version, will when it is fixed
+ */
+
+static void
+	PCI_Extended_Write(struct pci_dev *dev, unsigned int offset,
+						 unsigned long val)
+{
+	outl(0x80000000 | (((offset >> 8)  & 0x0f) << 24) |
+		((dev->bus->number & 0xff) << 16) | ((dev->devfn | 3) << 8)
+		 | (offset & 0x0fc), 0x0cf8);
+
+	outl(val, 0xcfc);
+}
+
+static inline void APIC_init_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, 4, 0);	/* NMI */
+}
+
+static inline void APIC_clear_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, 0, 1);	/* MASK it */
+}
+
+/*
+ * initialize the APIC for the IBS interrupts
+ * if needed on AMD Family10h rev B0 and later
+ */
+void setup_ibs_nmi(void)
+{
+	struct pci_dev *gh_device = NULL;
+	u32 low, high;
+
+	/* This is a hack to get APIC_EILVT_LVTOFF_IBS */
+	unsigned long i = setup_APIC_eilvt_ibs(0, 0, 1);
+
+	/*see if the IBS control register is already set correctly*/
+	/*remove this when we know for sure it is done in the kernel init*/
+	rdmsr(MSR_AMD64_IBSCTL, low, high);
+	if ((low & (IBS_CTL_LVT_OFFSET_VALID_BIT | i)) !=
+		(IBS_CTL_LVT_OFFSET_VALID_BIT | i)) {
+		Enable_Extended_PCI_Config();
+
+		/**** Be sure to run loop until NULL is returned to
+		decrement reference count on any pci_dev structures returned ****/
+		while ((gh_device = pci_get_device(PCI_VENDOR_ID_AMD,
+			 PCI_DEVICE_ID_AMD_FAMILY10H_NB, gh_device)) != NULL) {
+			/* This code may change if we can find a proper
+			 * way to get at the PCI extended config space */
+			PCI_Extended_Write(
+				gh_device, IBS_LVT_OFFSET_PCI,
+				(i | IBS_CTL_LVT_OFFSET_VALID_BIT));
+		}
+		Disable_Extended_PCI_Config();
+	}
+	on_each_cpu(APIC_init_per_cpu, NULL, 1, 1);
+}
+
+/*
+ * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
+ * rev B0 and later */
+void clear_ibs_nmi(void)
+{
+	on_each_cpu(APIC_clear_per_cpu, NULL, 1, 1);
+}
+
  struct op_x86_model_spec const op_athlon_spec = {
  	.num_counters = NUM_COUNTERS,
  	.num_controls = NUM_CONTROLS,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..0c5960a 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -26,6 +26,39 @@ struct op_msrs {
  	struct op_msr * controls;
  };

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
  struct pt_regs;

  /* The model vtable abstracts the differences between
@@ -48,4 +81,8 @@ extern struct op_x86_model_spec const op_p4_spec;
  extern struct op_x86_model_spec const op_p4_ht2_spec;
  extern struct op_x86_model_spec const op_athlon_spec;

+/* setup AMD Family 10H IBS IRQ if needed */
+extern void setup_ibs_nmi(void);
+/* clearp AMD Family 10H IBS IRQ if needed */
+extern void clear_ibs_nmi(void);
  #endif /* OP_X86_MODEL_H */


