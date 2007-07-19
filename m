Return-Path: <linux-kernel-owner+w=401wt.eu-S938237AbXGSKWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938237AbXGSKWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759619AbXGSJ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:05 -0400
Received: from ns1.suse.de ([195.135.220.2]:35430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760151AbXGSJzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:41 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: adurbin@google.com, ak@suse.de, rientjes@google.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [47/58] i386: insert unclaimed MMCONFIG resources
Message-Id: <20070719095533.E259E14E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Aaron Durbin <adurbin@google.com>

Insert the unclaimed MMCONFIG resources into the resource tree without the
IORESOURCE_BUSY flag during late initialization.  This allows the MMCONFIG
regions to be visible in the iomem resource tree without interfering with
other system resources that were discovered during PCI initialization.

[akpm@linux-foundation.org: nanofixes]
Signed-off-by: Aaron Durbin <adurbin@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |   48 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

Index: linux/arch/i386/pci/mmconfig-shared.c
===================================================================
--- linux.orig/arch/i386/pci/mmconfig-shared.c
+++ linux/arch/i386/pci/mmconfig-shared.c
@@ -24,6 +24,9 @@
 
 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
+/* Indicate if the mmcfg resources have been placed into the resource table. */
+static int __initdata pci_mmcfg_resources_inserted;
+
 /* K8 systems have some devices (typically in the builtin northbridge)
    that are only accessible using type1
    Normally this can be expressed in the MCFG by not listing them
@@ -170,7 +173,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(void)
+static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -194,10 +197,13 @@ static void __init pci_mmcfg_insert_reso
 			 cfg->pci_segment);
 		res->start = cfg->address;
 		res->end = res->start + (num_buses << 20) - 1;
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		res->flags = IORESOURCE_MEM | resource_flags;
 		insert_resource(&iomem_resource, res);
 		names += PCI_MMCFG_RESOURCE_NAME_LEN;
 	}
+
+	/* Mark that the resources have been inserted. */
+	pci_mmcfg_resources_inserted = 1;
 }
 
 static void __init pci_mmcfg_reject_broken(int type)
@@ -267,7 +273,43 @@ void __init pci_mmcfg_init(int type)
 		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
-			pci_mmcfg_insert_resources();
+			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+	} else {
+		/*
+		 * Signal not to attempt to insert mmcfg resources because
+		 * the architecture mmcfg setup could not initialize.
+		 */
+		pci_mmcfg_resources_inserted = 1;
 	}
 }
+
+static int __init pci_mmcfg_late_insert_resources(void)
+{
+	/*
+	 * If resources are already inserted or we are not using MMCONFIG,
+	 * don't insert the resources.
+	 */
+	if ((pci_mmcfg_resources_inserted == 1) ||
+	    (pci_probe & PCI_PROBE_MMCONF) == 0 ||
+	    (pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return 1;
+
+	/*
+	 * Attempt to insert the mmcfg resources but not with the busy flag
+	 * marked so it won't cause request errors when __request_region is
+	 * called.
+	 */
+	pci_mmcfg_insert_resources(0);
+
+	return 0;
+}
+
+/*
+ * Perform MMCONFIG resource insertion after PCI initialization to allow for
+ * misprogrammed MCFG tables that state larger sizes but actually conflict
+ * with other system resources.
+ */
+late_initcall(pci_mmcfg_late_insert_resources);
