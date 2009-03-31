Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbZCaPZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbZCaPZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbZCaPXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:41 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47519 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762290AbZCaPXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:38 -0400
Subject: [PATCH 06/15] PCI Hotplug: cpqphp: refactor cpqhp_probe
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:36 -0600
Message-ID: <20090331152336.26622.15024.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply DeMorgan's theorem:

	if ((pdev->revision > 2) || (vendor_id == PCI_VENDOR_ID_INTEL))

turns into

	if ((pdev->revision <= 2) && (vendor_id != PCI_VENDOR_ID_INTEL))

Now we can bail out early from the function if the controller is not
supported.

This allows us to un-indent the remainder of the function quite a bit and
make it much more readable.

Fix up some extra braces, and un-indent the 'case' labels in the switch
statement as per CodingStyle.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_core.c |  382 ++++++++++++++++++-------------------
 1 files changed, 185 insertions(+), 197 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 195c8c9..857e466 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -887,214 +887,202 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * For Intel, each SSID bit identifies a PHP capability.
 	 * Also Intel HPC's may have RID=0.
 	 */
-	if ((pdev->revision > 2) || (vendor_id == PCI_VENDOR_ID_INTEL)) {
-		/* TODO: This code can be made to support non-Compaq or Intel
-		 * subsystem IDs
-		 */
-		rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vid);
-		if (rc) {
-			err("%s : pci_read_config_word failed\n", __func__);
-			goto err_disable_device;
-		}
-		dbg("Subsystem Vendor ID: %x\n", subsystem_vid);
-		if ((subsystem_vid != PCI_VENDOR_ID_COMPAQ) && (subsystem_vid != PCI_VENDOR_ID_INTEL)) {
-			err(msg_HPC_non_compaq_or_intel);
-			rc = -ENODEV;
-			goto err_disable_device;
-		}
+	if ((pdev->revision <= 2) && (vendor_id != PCI_VENDOR_ID_INTEL)) {
+		err(msg_HPC_not_supported);
+		return -ENODEV;
+	}
+
+	/* TODO: This code can be made to support non-Compaq or Intel
+	 * subsystem IDs
+	 */
+	rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vid);
+	if (rc) {
+		err("%s : pci_read_config_word failed\n", __func__);
+		goto err_disable_device;
+	}
+	dbg("Subsystem Vendor ID: %x\n", subsystem_vid);
+	if ((subsystem_vid != PCI_VENDOR_ID_COMPAQ) && (subsystem_vid != PCI_VENDOR_ID_INTEL)) {
+		err(msg_HPC_non_compaq_or_intel);
+		rc = -ENODEV;
+		goto err_disable_device;
+	}
+
+	ctrl = kzalloc(sizeof(struct controller), GFP_KERNEL);
+	if (!ctrl) {
+		err("%s : out of memory\n", __func__);
+		rc = -ENOMEM;
+		goto err_disable_device;
+	}
 
-		ctrl = kzalloc(sizeof(struct controller), GFP_KERNEL);
-		if (!ctrl) {
-			err("%s : out of memory\n", __func__);
-			rc = -ENOMEM;
-			goto err_disable_device;
+	rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsystem_deviceid);
+	if (rc) {
+		err("%s : pci_read_config_word failed\n", __func__);
+		goto err_free_ctrl;
+	}
+
+	info("Hot Plug Subsystem Device ID: %x\n", subsystem_deviceid);
+
+	/* Set Vendor ID, so it can be accessed later from other
+	 * functions
+	 */
+	ctrl->vendor_id = vendor_id;
+
+	switch (subsystem_vid) {
+	case PCI_VENDOR_ID_COMPAQ:
+		if (pdev->revision >= 0x13) { /* CIOBX */
+			ctrl->push_flag = 1;
+			ctrl->slot_switch_type = 1;
+			ctrl->push_button = 1;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 1;
+			ctrl->pcix_speed_capability = 1;
+			pci_read_config_byte(pdev, 0x41, &bus_cap);
+			if (bus_cap & 0x80) {
+				dbg("bus max supports 133MHz PCI-X\n");
+				ctrl->speed_capability = PCI_SPEED_133MHz_PCIX;
+				break;
+			}
+			if (bus_cap & 0x40) {
+				dbg("bus max supports 100MHz PCI-X\n");
+				ctrl->speed_capability = PCI_SPEED_100MHz_PCIX;
+				break;
+			}
+			if (bus_cap & 20) {
+				dbg("bus max supports 66MHz PCI-X\n");
+				ctrl->speed_capability = PCI_SPEED_66MHz_PCIX;
+				break;
+			}
+			if (bus_cap & 10) {
+				dbg("bus max supports 66MHz PCI\n");
+				ctrl->speed_capability = PCI_SPEED_66MHz;
+				break;
+			}
+
+			break;
 		}
 
-		rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsystem_deviceid);
-		if (rc) {
-			err("%s : pci_read_config_word failed\n", __func__);
+		switch (subsystem_deviceid) {
+		case PCI_SUB_HPC_ID:
+			/* Original 6500/7000 implementation */
+			ctrl->slot_switch_type = 1;
+			ctrl->speed_capability = PCI_SPEED_33MHz;
+			ctrl->push_button = 0;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 0;
+			ctrl->pcix_speed_capability = 0;
+			break;
+		case PCI_SUB_HPC_ID2:
+			/* First Pushbutton implementation */
+			ctrl->push_flag = 1;
+			ctrl->slot_switch_type = 1;
+			ctrl->speed_capability = PCI_SPEED_33MHz;
+			ctrl->push_button = 1;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 0;
+			ctrl->pcix_speed_capability = 0;
+			break;
+		case PCI_SUB_HPC_ID_INTC:
+			/* Third party (6500/7000) */
+			ctrl->slot_switch_type = 1;
+			ctrl->speed_capability = PCI_SPEED_33MHz;
+			ctrl->push_button = 0;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 0;
+			ctrl->pcix_speed_capability = 0;
+			break;
+		case PCI_SUB_HPC_ID3:
+			/* First 66 Mhz implementation */
+			ctrl->push_flag = 1;
+			ctrl->slot_switch_type = 1;
+			ctrl->speed_capability = PCI_SPEED_66MHz;
+			ctrl->push_button = 1;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 0;
+			ctrl->pcix_speed_capability = 0;
+			break;
+		case PCI_SUB_HPC_ID4:
+			/* First PCI-X implementation, 100MHz */
+			ctrl->push_flag = 1;
+			ctrl->slot_switch_type = 1;
+			ctrl->speed_capability = PCI_SPEED_100MHz_PCIX;
+			ctrl->push_button = 1;
+			ctrl->pci_config_space = 1;
+			ctrl->defeature_PHP = 1;
+			ctrl->pcix_support = 1;
+			ctrl->pcix_speed_capability = 0;
+			break;
+		default:
+			err(msg_HPC_not_supported);
+			rc = -ENODEV;
 			goto err_free_ctrl;
 		}
+		break;
 
-		info("Hot Plug Subsystem Device ID: %x\n", subsystem_deviceid);
+	case PCI_VENDOR_ID_INTEL:
+		/* Check for speed capability (0=33, 1=66) */
+		if (subsystem_deviceid & 0x0001)
+			ctrl->speed_capability = PCI_SPEED_66MHz;
+		else
+			ctrl->speed_capability = PCI_SPEED_33MHz;
 
-		/* Set Vendor ID, so it can be accessed later from other
-		 * functions
-		 */
-		ctrl->vendor_id = vendor_id;
-
-		switch (subsystem_vid) {
-			case PCI_VENDOR_ID_COMPAQ:
-				if (pdev->revision >= 0x13) { /* CIOBX */
-					ctrl->push_flag = 1;
-					ctrl->slot_switch_type = 1;
-					ctrl->push_button = 1;
-					ctrl->pci_config_space = 1;
-					ctrl->defeature_PHP = 1;
-					ctrl->pcix_support = 1;
-					ctrl->pcix_speed_capability = 1;
-					pci_read_config_byte(pdev, 0x41, &bus_cap);
-					if (bus_cap & 0x80) {
-						dbg("bus max supports 133MHz PCI-X\n");
-						ctrl->speed_capability = PCI_SPEED_133MHz_PCIX;
-						break;
-					}
-					if (bus_cap & 0x40) {
-						dbg("bus max supports 100MHz PCI-X\n");
-						ctrl->speed_capability = PCI_SPEED_100MHz_PCIX;
-						break;
-					}
-					if (bus_cap & 20) {
-						dbg("bus max supports 66MHz PCI-X\n");
-						ctrl->speed_capability = PCI_SPEED_66MHz_PCIX;
-						break;
-					}
-					if (bus_cap & 10) {
-						dbg("bus max supports 66MHz PCI\n");
-						ctrl->speed_capability = PCI_SPEED_66MHz;
-						break;
-					}
-
-					break;
-				}
-
-				switch (subsystem_deviceid) {
-					case PCI_SUB_HPC_ID:
-						/* Original 6500/7000 implementation */
-						ctrl->slot_switch_type = 1;
-						ctrl->speed_capability = PCI_SPEED_33MHz;
-						ctrl->push_button = 0;
-						ctrl->pci_config_space = 1;
-						ctrl->defeature_PHP = 1;
-						ctrl->pcix_support = 0;
-						ctrl->pcix_speed_capability = 0;
-						break;
-					case PCI_SUB_HPC_ID2:
-						/* First Pushbutton implementation */
-						ctrl->push_flag = 1;
-						ctrl->slot_switch_type = 1;
-						ctrl->speed_capability = PCI_SPEED_33MHz;
-						ctrl->push_button = 1;
-						ctrl->pci_config_space = 1;
-						ctrl->defeature_PHP = 1;
-						ctrl->pcix_support = 0;
-						ctrl->pcix_speed_capability = 0;
-						break;
-					case PCI_SUB_HPC_ID_INTC:
-						/* Third party (6500/7000) */
-						ctrl->slot_switch_type = 1;
-						ctrl->speed_capability = PCI_SPEED_33MHz;
-						ctrl->push_button = 0;
-						ctrl->pci_config_space = 1;
-						ctrl->defeature_PHP = 1;
-						ctrl->pcix_support = 0;
-						ctrl->pcix_speed_capability = 0;
-						break;
-					case PCI_SUB_HPC_ID3:
-						/* First 66 Mhz implementation */
-						ctrl->push_flag = 1;
-						ctrl->slot_switch_type = 1;
-						ctrl->speed_capability = PCI_SPEED_66MHz;
-						ctrl->push_button = 1;
-						ctrl->pci_config_space = 1;
-						ctrl->defeature_PHP = 1;
-						ctrl->pcix_support = 0;
-						ctrl->pcix_speed_capability = 0;
-						break;
-					case PCI_SUB_HPC_ID4:
-						/* First PCI-X implementation, 100MHz */
-						ctrl->push_flag = 1;
-						ctrl->slot_switch_type = 1;
-						ctrl->speed_capability = PCI_SPEED_100MHz_PCIX;
-						ctrl->push_button = 1;
-						ctrl->pci_config_space = 1;
-						ctrl->defeature_PHP = 1;
-						ctrl->pcix_support = 1;
-						ctrl->pcix_speed_capability = 0;	
-						break;
-					default:
-						err(msg_HPC_not_supported);
-						rc = -ENODEV;
-						goto err_free_ctrl;
-				}
-				break;
+		/* Check for push button */
+		if (subsystem_deviceid & 0x0002)
+			ctrl->push_button = 0;
+		else
+			ctrl->push_button = 1;
 
-			case PCI_VENDOR_ID_INTEL:
-				/* Check for speed capability (0=33, 1=66) */
-				if (subsystem_deviceid & 0x0001) {
-					ctrl->speed_capability = PCI_SPEED_66MHz;
-				} else {
-					ctrl->speed_capability = PCI_SPEED_33MHz;
-				}
-
-				/* Check for push button */
-				if (subsystem_deviceid & 0x0002) {
-					/* no push button */
-					ctrl->push_button = 0;
-				} else {
-					/* push button supported */
-					ctrl->push_button = 1;
-				}
-
-				/* Check for slot switch type (0=mechanical, 1=not mechanical) */
-				if (subsystem_deviceid & 0x0004) {
-					/* no switch */
-					ctrl->slot_switch_type = 0;
-				} else {
-					/* switch */
-					ctrl->slot_switch_type = 1;
-				}
-
-				/* PHP Status (0=De-feature PHP, 1=Normal operation) */
-				if (subsystem_deviceid & 0x0008) {
-					ctrl->defeature_PHP = 1;	/* PHP supported */
-				} else {
-					ctrl->defeature_PHP = 0;	/* PHP not supported */
-				}
-
-				/* Alternate Base Address Register Interface (0=not supported, 1=supported) */
-				if (subsystem_deviceid & 0x0010) {
-					ctrl->alternate_base_address = 1;	/* supported */
-				} else {
-					ctrl->alternate_base_address = 0;	/* not supported */
-				}
-
-				/* PCI Config Space Index (0=not supported, 1=supported) */
-				if (subsystem_deviceid & 0x0020) {
-					ctrl->pci_config_space = 1;		/* supported */
-				} else {
-					ctrl->pci_config_space = 0;		/* not supported */
-				}
-
-				/* PCI-X support */
-				if (subsystem_deviceid & 0x0080) {
-					/* PCI-X capable */
-					ctrl->pcix_support = 1;
-					/* Frequency of operation in PCI-X mode */
-					if (subsystem_deviceid & 0x0040) {
-						/* 133MHz PCI-X if bit 7 is 1 */
-						ctrl->pcix_speed_capability = 1;
-					} else {
-						/* 100MHz PCI-X if bit 7 is 1 and bit 0 is 0, */
-						/* 66MHz PCI-X if bit 7 is 1 and bit 0 is 1 */
-						ctrl->pcix_speed_capability = 0;
-					}
-				} else {
-					/* Conventional PCI */
-					ctrl->pcix_support = 0;
-					ctrl->pcix_speed_capability = 0;
-				}
-				break;
+		/* Check for slot switch type (0=mechanical, 1=not mechanical) */
+		if (subsystem_deviceid & 0x0004)
+			ctrl->slot_switch_type = 0;
+		else
+			ctrl->slot_switch_type = 1;
+
+		/* PHP Status (0=De-feature PHP, 1=Normal operation) */
+		if (subsystem_deviceid & 0x0008)
+			ctrl->defeature_PHP = 1;	/* PHP supported */
+		else
+			ctrl->defeature_PHP = 0;	/* PHP not supported */
+
+		/* Alternate Base Address Register Interface
+		 * (0=not supported, 1=supported)
+		 */
+		if (subsystem_deviceid & 0x0010)
+			ctrl->alternate_base_address = 1;
+		else
+			ctrl->alternate_base_address = 0;
 
-			default:
-				err(msg_HPC_not_supported);
-				rc = -ENODEV;
-				goto err_free_ctrl;
+		/* PCI Config Space Index (0=not supported, 1=supported) */
+		if (subsystem_deviceid & 0x0020)
+			ctrl->pci_config_space = 1;
+		else
+			ctrl->pci_config_space = 0;
+
+		/* PCI-X support */
+		if (subsystem_deviceid & 0x0080) {
+			ctrl->pcix_support = 1;
+			if (subsystem_deviceid & 0x0040)
+				/* 133MHz PCI-X if bit 7 is 1 */
+				ctrl->pcix_speed_capability = 1;
+			else
+				/* 100MHz PCI-X if bit 7 is 1 and bit 0 is 0, */
+				/* 66MHz PCI-X if bit 7 is 1 and bit 0 is 1 */
+				ctrl->pcix_speed_capability = 0;
+		} else {
+			/* Conventional PCI */
+			ctrl->pcix_support = 0;
+			ctrl->pcix_speed_capability = 0;
 		}
+		break;
 
-	} else {
+	default:
 		err(msg_HPC_not_supported);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto err_free_ctrl;
 	}
 
 	/* Tell the user that we found one. */
@@ -1164,7 +1152,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_mem_region;
 	}
 
-	// Check for 66Mhz operation
+	/* Check for 66Mhz operation */
 	ctrl->speed = get_controller_speed(ctrl);
 
 

