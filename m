Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYGVTax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYGVTax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYGVTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:55 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:29097 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbYGVTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:53 -0400
X-BigFish: VPS24(zzzz10d3izzz32i87il43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WW-02-3OR-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/24] OProfile: Change IBS interrupt initialization
Date: Tue, 22 Jul 2008 21:08:57 +0200
Message-ID: <1216753748-11261-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0917 (UTC) FILETIME=[723BDBD0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |   84 ++++++++++++++++++++++------------
 1 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index a2c8e2e..90193b1 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -356,9 +356,11 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
+static u8 ibs_eilvt_off;
+
 static inline void apic_init_ibs_nmi_per_cpu(void *arg)
 {
-	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
 }
 
 static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
@@ -366,45 +368,67 @@ static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
 	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 }
 
+static int pfm_amd64_setup_eilvt(void)
+{
+#define IBSCTL_LVTOFFSETVAL		(1 << 8)
+#define IBSCTL				0x1cc
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	/* per CPU setup */
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 0, 1);
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVTOFFSETVAL);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+				"IBSCTL = 0x%08x", value);
+			return 1;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS");
+		return 1;
+	}
+
+#ifdef CONFIG_NUMA
+	/* Sanity check */
+	/* Works only for 64bit with proper numa implementation. */
+	if (nodes != num_possible_nodes()) {
+		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
+			"found: %d, expected %d",
+			nodes, num_possible_nodes());
+		return 1;
+	}
+#endif
+	return 0;
+}
+
 /*
  * initialize the APIC for the IBS interrupts
- * if needed on AMD Family10h rev B0 and later
+ * if available (AMD Family10h rev B0 and later)
  */
 static void setup_ibs(void)
 {
-	struct pci_dev *gh_device = NULL;
-	u32 low, high;
-	u8 vector;
-
 	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
 
 	if (!ibs_allowed)
 		return;
 
-	/* This gets the APIC_EILVT_LVTOFF_IBS value */
-	vector = setup_APIC_eilvt_ibs(0, 0, 1);
-
-	/*see if the IBS control register is already set correctly*/
-	/*remove this when we know for sure it is done
-	  in the kernel init*/
-	rdmsr(MSR_AMD64_IBSCTL, low, high);
-	if ((low & (IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) !=
-		(IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) {
-
-		/**** Be sure to run loop until NULL is returned to
-		decrement reference count on any pci_dev structures
-		returned ****/
-		while ((gh_device = pci_get_device(PCI_VENDOR_ID_AMD,
-			PCI_DEVICE_ID_AMD_10H_NB_MISC, gh_device))
-			!= NULL) {
-			/* This code may change if we can find a proper
-			* way to get at the PCI extended config space */
-			pci_write_config_dword(
-				gh_device, IBS_LVT_OFFSET_PCI,
-				(vector | IBS_CTL_LVT_OFFSET_VALID_BIT));
-		}
-	}
-	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1, 1);
+	if (pfm_amd64_setup_eilvt())
+		ibs_allowed = 0;
 }
 
 
-- 
1.5.5.4


