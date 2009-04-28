Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbZD1PIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbZD1PIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761631AbZD1PGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:06:40 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:36333
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761633AbZD1PGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:06:38 -0400
X-BigFish: VPS-6(zz14ffOzz1202hzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KITGMQ-01-UAP-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/21] amd64_edac: add per-family descriptors
Date: Tue, 28 Apr 2009 17:06:05 +0200
Message-ID: <1240931173-17477-14-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:22.0474 (UTC) FILETIME=[E476FEA0:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   76 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e60a5a2..ac4e265 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3046,3 +3046,79 @@ static int f10_probe_valid_hardware(struct amd64_pvt *pvt)
 	return rc;
 }
 
+/*
+ * There currently are 3 types type of MC devices for AMD
+ * Athlon/Opterons (as per PCI DEVICE_IDs):
+ *
+ * Family K8: That is the Athlon64 and Opteron CPUs. They all have the
+ * same PCI DEVICE ID, even though there is differences between
+ * the different Revisions (CG,D,E,F).
+ *
+ * Family F10h.
+ *
+ * Family F11h.
+ *
+ */
+static struct amd64_family_type amd64_family_types[] = {
+	[K8_CPUS] = {
+		.ctl_name = "RevF",
+		.addr_f1_ctl = PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
+		.misc_f3_ctl = PCI_DEVICE_ID_AMD_K8_NB_MISC,
+		.ops = {
+			.early_channel_count = k8_early_channel_count,
+			.get_error_address = k8_get_error_address,
+			.read_dram_base_limit = k8_read_dram_base_limit,
+			.map_sysaddr_to_csrow = k8_map_sysaddr_to_csrow,
+			.dbam_map_to_pages = k8_dbam_map_to_pages,
+		}
+	},
+	[F10_CPUS] = {
+		.ctl_name = "Family 10h",
+		.addr_f1_ctl = PCI_DEVICE_ID_AMD_10H_NB_MAP,
+		.misc_f3_ctl = PCI_DEVICE_ID_AMD_10H_NB_MISC,
+		.ops = {
+			.probe_valid_hardware = f10_probe_valid_hardware,
+			.early_channel_count = f10_early_channel_count,
+			.get_error_address = f10_get_error_address,
+			.read_dram_base_limit = f10_read_dram_base_limit,
+			.read_dram_ctl_register = f10_read_dram_ctl_register,
+			.map_sysaddr_to_csrow = f10_map_sysaddr_to_csrow,
+			.dbam_map_to_pages = f10_dbam_map_to_pages,
+		}
+	},
+	[F11_CPUS] = {
+		.ctl_name = "Family 11h",
+		.addr_f1_ctl = PCI_DEVICE_ID_AMD_11H_NB_MAP,
+		.misc_f3_ctl = PCI_DEVICE_ID_AMD_11H_NB_MISC,
+		.ops = {
+			.probe_valid_hardware = f10_probe_valid_hardware,
+			.early_channel_count = f10_early_channel_count,
+			.get_error_address = f10_get_error_address,
+			.read_dram_base_limit = f10_read_dram_base_limit,
+			.read_dram_ctl_register = f10_read_dram_ctl_register,
+			.map_sysaddr_to_csrow = f10_map_sysaddr_to_csrow,
+			.dbam_map_to_pages = f10_dbam_map_to_pages,
+		}
+	},
+};
+
+static struct pci_dev *pci_get_related_function(unsigned int vendor,
+						unsigned int device,
+						struct pci_dev *related)
+{
+	struct pci_dev *dev;
+
+	dev = NULL;
+
+	dev = pci_get_device(vendor, device, dev);
+	while (dev != NULL) {
+		if ((dev->bus->number == related->bus->number) &&
+		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
+			break;
+		dev = pci_get_device(vendor, device, dev);
+	}
+
+	return dev;
+}
+
+
-- 
1.6.2.4


