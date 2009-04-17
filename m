Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbZDQKXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbZDQKXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZDQKXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:23:10 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:26144 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZDQKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:23:09 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 06:23:09 EDT
X-BigFish: VPS-6(zba6jz936eQzz1202hzzz32i6bh14bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KI8PH3-02-E7T-01
Date: Fri, 17 Apr 2009 12:07:46 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fixup numa_node information for AMD CPU northbridge
	functions
Message-ID: <20090417100746.GG16198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Apr 2009 10:07:53.0631 (UTC) FILETIME=[5F6B2AF0:01C9BF44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the numa_node attribute for these PCI devices is 0 (it
corresponds to the numa_node for PCI bus 0). This is not a big issue
but incorrect.

This inconsistency can be fixed by reading the node number from CPU
NB function 0.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..4dd4e70 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -493,5 +493,40 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+#endif
+
+#if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
+/* Set correct numa_node information for AMD NB functions */
+static void __init quirk_amd_nb_node(struct pci_dev *dev)
+{
+	u32 val;
+	struct pci_dev *nb_ht;
+	unsigned int devfn;
 
+	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
+	nb_ht = pci_get_slot(dev->bus, devfn);
+	if (!nb_ht)
+		return;
+	pci_read_config_dword(nb_ht, 0x60, &val);
+	set_dev_node(&dev->dev, val & 7);
+	pci_dev_put(dev);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_HT,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MAP,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
+			quirk_amd_nb_node);
 #endif
-- 
1.6.2



