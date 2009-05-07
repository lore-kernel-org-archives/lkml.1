Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZEGN6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZEGN6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbZEGNur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:55686 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZEGNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:20 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KJA12Y-02-CL4-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 06/21] amd64_edac: add memory scrubber interface
Date: Thu, 7 May 2009 15:49:28 +0200
Message-ID: <1241704183-29223-7-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:50.0656 (UTC) FILETIME=[B13EEC00:01C9CF1A]
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
 drivers/edac/amd64_edac.c |  134 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd64_edac.c

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
new file mode 100644
index 0000000..df72ecc
--- /dev/null
+++ b/drivers/edac/amd64_edac.c
@@ -0,0 +1,134 @@
+#include "amd64_edac.h"
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
+/* Lookup table for all possible MC control instances */
+struct amd64_pvt;
+static struct mem_ctl_info *mci_lookup[MAX_NUMNODES];
+static struct amd64_pvt *pvt_lookup[MAX_NUMNODES];
+
+/*
+ * Memory scrubber control interface. For the K8, memory scrubbing is handled by
+ * hardware and can involve L2 cache, dcache as well as the main memory. With
+ * F10, this is extended to L3 cache scrubbing on CPU models sporting that
+ * functionality.
+ * This causes the "units" for the scrubbing speed to vary from 64 byte blocks
+ * (dram) over to cache lines. This is nasty, so we will use bandwidth in
+ * bytes/sec for the setting.
+ * Currently, we only do dram scrubbing. If the scrubbing is done in software on
+ * other archs, we might not have access to the caches directly.
+ */
+
+/*
+ * amd64_search_set_scrub_rate
+ *
+ * scan the scrub rate mapping table for a close or matching bandwidth value to
+ * issue. If requested is too big, then use last maximum value found.
+ */
+static int amd64_search_set_scrub_rate(struct pci_dev *ctl, u32 new_bw,
+				       u32 min_scrubrate)
+{
+	u32 scrubval;
+	int i;
+
+	/*
+	 * map the configured rate (new_bw) to a value specific to the AMD64
+	 * memory controller and apply to register. Search for the first
+	 * bandwidth entry that is greater or equal than the setting requested
+	 * and program that. If at last entry, accept that as the maximum. This
+	 * saves the user from determing the maximum empirically.
+	 */
+	for (i = 0; i < ARRAY_SIZE(scrubrates); i++) {
+		/*
+		 * skip scrub rates which aren't recommended
+		 * (see F10 BKDG, F3x58)
+		 */
+		if (scrubrates[i].scrubval < min_scrubrate)
+			continue;
+
+		if (scrubrates[i].bandwidth <= new_bw)
+			break;
+
+		/*
+		 * if no suitable bandwidth found, turn off DRAM scrubbing
+		 * entirely by falling back to the last element in the
+		 * scrubrates array.
+		 */
+	}
+
+	scrubval = scrubrates[i].scrubval;
+	if (scrubval)
+		edac_printk(KERN_DEBUG, EDAC_MC,
+			"Setting scrub rate bandwidth: %u\n",
+			scrubrates[i].bandwidth);
+	else
+		edac_printk(KERN_DEBUG, EDAC_MC,
+			"Turning scrubbing off.\n");
+
+	pci_write_bits32(ctl, K8_SCRCTRL, scrubval, 0x001F);
+
+	return 0;
+}
+
+static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 *bandwidth)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 min_scrubrate = 0x0;
+
+	switch (boot_cpu_data.x86) {
+	case 0xf:
+		min_scrubrate = K8_MIN_SCRUB_RATE_BITS;
+		break;
+	case 0x10:
+		min_scrubrate = F10_MIN_SCRUB_RATE_BITS;
+		break;
+	case 0x11:
+		min_scrubrate = F11_MIN_SCRUB_RATE_BITS;
+		break;
+
+	default:
+		amd64_printk(KERN_ERR, "Unsupported family!\n");
+		break;
+	}
+	return amd64_search_set_scrub_rate(pvt->misc_f3_ctl, *bandwidth,
+			min_scrubrate);
+}
+
+static int amd64_get_scrub_rate(struct mem_ctl_info *mci, u32 *bw)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 scrubval = 0;
+	int status = -1;
+	int i;
+	int err;
+
+	err = pci_read_config_dword(pvt->misc_f3_ctl, K8_SCRCTRL, &scrubval);
+	if (err != 0)
+		debugf0("%s() Reading K8_SCRCTRL failed\n", __func__);
+
+	scrubval = scrubval & 0x001F;
+
+	edac_printk(KERN_DEBUG, EDAC_MC,
+		    "pci-read, sdram scrub control value: %d \n", scrubval);
+
+	for (i = 0; ARRAY_SIZE(scrubrates); i++) {
+		if (scrubrates[i].scrubval == scrubval) {
+			*bw = scrubrates[i].bandwidth;
+			status = 0;
+			break;
+		}
+	}
+
+	return status;
+}
+
-- 
1.6.2.4


