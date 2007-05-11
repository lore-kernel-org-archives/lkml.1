Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXEKUfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXEKUfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbXEKUfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:35:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:21254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbXEKUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:35:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=L+EMw5GdtUQImf+bgujMH7mfVNuFlL/rjxPvt9UAAos4ApWHUsiUY/4E/KwLddbAO
	Pefpj0ShXdnsB6SsBIEkw==
Message-ID: <8f95bb250705111334l4f121a46kc92a8e2fa8662094@mail.gmail.com>
Date: Fri, 11 May 2007 13:34:53 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmconfig x86_64/i386 : Insert unclaimed MMCONFIG resources.
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Insert the unclaimed MMCONFIG resources into the resource tree without the
IORESOURCE_BUSY flag during late initialization. This allows the MMCONFIG
regions to be visible in the iomem resource tree without interfering with other
system resources that were discovered during PCI initialization.

Signed-off-by: Aaron Durbin <adurbin@google.com>
---

diff --git a/arch/i386/pci/mmconfig-shared.c b/arch/i386/pci/mmconfig-shared.c
index 747d8c6..c85a5f7 100644
--- a/arch/i386/pci/mmconfig-shared.c
+++ b/arch/i386/pci/mmconfig-shared.c
@@ -24,6 +24,9 @@ #define MMCONFIG_APER_MAX	(256 * 1024*10

 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);

+/* Indicate if the mmcfg resources have been placed into the resource table. */
+static int __initdata pci_mmcfg_resources_inserted = 0;
+
 /* K8 systems have some devices (typically in the builtin northbridge)
    that are only accessible using type1
    Normally this can be expressed in the MCFG by not listing them
@@ -161,7 +164,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }

-static void __init pci_mmcfg_insert_resources(void)
+static void __init pci_mmcfg_insert_resources(int resource_flags)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -185,10 +188,13 @@ #define PCI_MMCFG_RESOURCE_NAME_LEN 19
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
@@ -258,7 +264,42 @@ void __init pci_mmcfg_init(int type)
 		if (type == 1)
 			unreachable_devices();
 		if (known_bridge)
-			pci_mmcfg_insert_resources();
+			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
-	}
+	} else
+		/*
+		 * Signal not to attempt to insert mmcfg resources because
+		 * the architecture mmcfg setup could not initialize.
+		 */
+		pci_mmcfg_resources_inserted = 1;
+}
+
+static int __init pci_mmcfg_late_insert_resources(void)
+{
+	/*
+	 * If resources are already inserted or we are not using MMCONFIG,
+	 * don't insert the resources.
+	 * */
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
 }
+
+/*
+ * Perform MMCONFIG resource insertion after PCI initialization to allow for
+ * misprogrammed MCFG tables that state larger sizes but actually conflict
+ * with other system resources.
+ */
+late_initcall(pci_mmcfg_late_insert_resources);
