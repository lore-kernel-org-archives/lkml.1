Return-Path: <linux-kernel-owner+w=401wt.eu-S936273AbZLQEIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273AbZLQEIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936234AbZLQEHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:07:50 -0500
Received: from kroah.org ([198.145.64.141]:52291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936224AbZLQEFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035701.669572591@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wright <chrisw@sous-sol.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [144/151] intel-iommu: Detect DMAR in hyperspace at probe time.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit 2c99220810c1c79322034628b993573b088ff2da upstream.

Many BIOSes will lie to us about the existence of an IOMMU, and claim
that there is one at an address which actually returns all 0xFF.

We need to detect this early, so that we know we don't have a viable
IOMMU and can set up swiotlb before it's too late.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |   34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -601,6 +601,9 @@ int __init check_zero_address(void)
 		}
 
 		if (entry_header->type == ACPI_DMAR_TYPE_HARDWARE_UNIT) {
+			void __iomem *addr;
+			u64 cap, ecap;
+
 			drhd = (void *)entry_header;
 			if (!drhd->address) {
 				/* Promote an attitude of violence to a BIOS engineer today */
@@ -609,17 +612,38 @@ int __init check_zero_address(void)
 				     dmi_get_system_info(DMI_BIOS_VENDOR),
 				     dmi_get_system_info(DMI_BIOS_VERSION),
 				     dmi_get_system_info(DMI_PRODUCT_VERSION));
-#ifdef CONFIG_DMAR
-				dmar_disabled = 1;
-#endif
-				return 0;
+				goto failed;
+			}
+
+			addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
+			if (!addr ) {
+				printk("IOMMU: can't validate: %llx\n", drhd->address);
+				goto failed;
+			}
+			cap = dmar_readq(addr + DMAR_CAP_REG);
+			ecap = dmar_readq(addr + DMAR_ECAP_REG);
+			early_iounmap(addr, VTD_PAGE_SIZE);
+			if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
+				/* Promote an attitude of violence to a BIOS engineer today */
+				WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
+				     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+				      drhd->address,
+				      dmi_get_system_info(DMI_BIOS_VENDOR),
+				      dmi_get_system_info(DMI_BIOS_VERSION),
+				      dmi_get_system_info(DMI_PRODUCT_VERSION));
+				goto failed;
 			}
-			break;
 		}
 
 		entry_header = ((void *)entry_header + entry_header->length);
 	}
 	return 1;
+
+failed:
+#ifdef CONFIG_DMAR
+	dmar_disabled = 1;
+#endif
+	return 0;
 }
 
 void __init detect_intel_iommu(void)


