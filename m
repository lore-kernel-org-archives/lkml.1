Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbZDQQ2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbZDQQ2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbZDQQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:28:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:53410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbZDQQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:28:22 -0400
Date: Fri, 17 Apr 2009 16:27:36 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090417100746.GG16198@alberich.amd.com>
References: <20090417100746.GG16198@alberich.amd.com>
Subject: [tip:x86/cpu] x86: fixup numa_node information for AMD CPU northbridge functions
Message-ID: <tip-9b94b3a19b13e094c10f65f24bc358f6ffe4eacd@git.kernel.org>
Git-Commit-ID: 9b94b3a19b13e094c10f65f24bc358f6ffe4eacd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b94b3a19b13e094c10f65f24bc358f6ffe4eacd
Gitweb:     http://git.kernel.org/tip/9b94b3a19b13e094c10f65f24bc358f6ffe4eacd
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 17 Apr 2009 12:07:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 18:12:36 +0200

x86: fixup numa_node information for AMD CPU northbridge functions

Currently the numa_node attribute for these PCI devices is 0 (it
corresponds to the numa_node for PCI bus 0). This is not a big issue
but incorrect.

This inconsistency can be fixed by reading the node number from CPU
NB function 0.

[ Impact: fill in dev->numa_node information, to optimize DMA allocations ]

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: jbarnes@virtuousgeek.org
LKML-Reference: <20090417100746.GG16198@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/quirks.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..94ad0c0 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -493,5 +493,42 @@ void force_hpet_resume(void)
 		break;
 	}
 }
+#endif
+
+#if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
+/* Set correct numa_node information for AMD NB functions */
+static void __init quirk_amd_nb_node(struct pci_dev *dev)
+{
+	struct pci_dev *nb_ht;
+	unsigned int devfn;
+	u32 val;
+
+	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
+	nb_ht = pci_get_slot(dev->bus, devfn);
+	if (!nb_ht)
+		return;
+
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
