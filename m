Return-Path: <linux-kernel-owner+w=401wt.eu-S936288AbZLQEI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936288AbZLQEI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936230AbZLQEHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:07:48 -0500
Received: from kroah.org ([198.145.64.141]:52296 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936225AbZLQEF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:01 2009
Message-Id: <20091217035701.797183647@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [145/151] intel-iommu: Apply BIOS sanity checks for interrupt remapping too.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit 6ecbf01c7ce4c0f4c3bdfa0e64ac6258328fda6c upstream.

The BIOS errors where an IOMMU is reported either at zero or a bogus
address are causing problems even when the IOMMU is disabled -- because
interrupt remapping uses the same hardware. Ensure that the checks get
applied for the interrupt remapping initialisation too.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -582,6 +582,8 @@ int __init dmar_table_init(void)
 	return 0;
 }
 
+static int bios_warned;
+
 int __init check_zero_address(void)
 {
 	struct acpi_table_dmar *dmar;
@@ -612,6 +614,7 @@ int __init check_zero_address(void)
 				     dmi_get_system_info(DMI_BIOS_VENDOR),
 				     dmi_get_system_info(DMI_BIOS_VERSION),
 				     dmi_get_system_info(DMI_PRODUCT_VERSION));
+				bios_warned = 1;
 				goto failed;
 			}
 
@@ -631,6 +634,7 @@ int __init check_zero_address(void)
 				      dmi_get_system_info(DMI_BIOS_VENDOR),
 				      dmi_get_system_info(DMI_BIOS_VERSION),
 				      dmi_get_system_info(DMI_PRODUCT_VERSION));
+				bios_warned = 1;
 				goto failed;
 			}
 		}
@@ -688,6 +692,18 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	int agaw = 0;
 	int msagaw = 0;
 
+	if (!drhd->reg_base_addr) {
+		if (!bios_warned) {
+			WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
+			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			     dmi_get_system_info(DMI_BIOS_VENDOR),
+			     dmi_get_system_info(DMI_BIOS_VERSION),
+			     dmi_get_system_info(DMI_PRODUCT_VERSION));
+			bios_warned = 1;
+		}
+		return -EINVAL;
+	}
+
 	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
 		return -ENOMEM;
@@ -704,13 +720,16 @@ int alloc_iommu(struct dmar_drhd_unit *d
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
 	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
-		/* Promote an attitude of violence to a BIOS engineer today */
-		WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
-		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
-		     drhd->reg_base_addr,
-		     dmi_get_system_info(DMI_BIOS_VENDOR),
-		     dmi_get_system_info(DMI_BIOS_VERSION),
-		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		if (!bios_warned) {
+			/* Promote an attitude of violence to a BIOS engineer today */
+			WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
+			     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+			     drhd->reg_base_addr,
+			     dmi_get_system_info(DMI_BIOS_VENDOR),
+			     dmi_get_system_info(DMI_BIOS_VERSION),
+			     dmi_get_system_info(DMI_PRODUCT_VERSION));
+			bios_warned = 1;
+		}
 		goto err_unmap;
 	}
 


