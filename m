Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZBWTwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZBWTwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZBWTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:52:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:47549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbZBWTwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:52:32 -0500
Message-ID: <49A2FE5F.2080307@kernel.org>
Date: Mon, 23 Feb 2009 11:51:59 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Prakash Punnoor <prakash@punnoor.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH] pci: don't enable too many HT MSI mapping
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200902221308.55053.prakash@punnoor.de> <m1iqn2ein5.fsf@fess.ebiederm.org> <200902221617.21621.prakash@punnoor.de> <49A23FBA.2020004@kernel.org>
In-Reply-To: <49A23FBA.2020004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug

Prakash reported that his c51-mcp51 system ondie sound card doesn't work MSI
but if he hack out the HT-MSI on mcp51, the MSI will work well with sound card.

this patch rework the nv_msi_ht_cap_quirk()
and will only enable ht_msi on own root device and try to avoid to enable ht_msi
on device following that root dev

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Tested-by: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/quirks.c |  115 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 100 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2050,11 +2050,101 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
 			PCI_DEVICE_ID_NVIDIA_NVENET_15,
 			nvenet_msi_disable);
 
-static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
+static void __devinit nv_ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	struct pci_dev *host_bridge;
+	int pos;
+	int i, dev_no;
+	int found = 0;
+
+	dev_no = dev->devfn >> 3;
+	for (i = dev_no; i >= 0; i--) {
+		host_bridge = pci_get_slot(dev->bus, PCI_DEVFN(i, 0));
+		if (!host_bridge)
+			continue;
+
+		pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE);
+		if (pos != 0) {
+			found = 1;
+			break;
+		}
+		pci_dev_put(host_bridge);
+	}
+
+	if (!found)
+		return;
+
+	/* root did that ! */
+	if (msi_ht_cap_enabled(host_bridge))
+		goto out;
+
+	ht_enable_msi_mapping(dev);
+
+out:
+	pci_dev_put(host_bridge);
+}
+
+static void __devinit ht_disable_msi_mapping(struct pci_dev *dev)
+{
 	int pos, ttl = 48;
 
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
+					 &flags) == 0) {
+			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags & ~HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+
+static int __devinit ht_check_msi_mapping(struct pci_dev *dev)
+{
+	int pos, ttl = 48;
+	int found = 0;
+
+	/* check if there is HT MSI cap or enabled on this device */
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (found < 1)
+			found = 1;
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
+					 &flags) == 0) {
+			if (flags & HT_MSI_FLAGS_ENABLE) {
+				if (found < 2) {
+					found = 2;
+					break;
+				}
+			}
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+
+	return found;
+}
+
+static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
+{
+	struct pci_dev *host_bridge;
+	int pos;
+	int found;
+
+	/* check if there is HT MSI cap or enabled on this device */
+	found = ht_check_msi_mapping(dev);
+
+	/* no HT MSI CAP */
+	if (found == 0)
+		return;
+
 	/*
 	 * HT MSI mapping should be disabled on devices that are below
 	 * a non-Hypertransport host bridge. Locate the host bridge...
@@ -2069,24 +2159,19 @@ static void __devinit nv_msi_ht_cap_quir
 	pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE);
 	if (pos != 0) {
 		/* Host bridge is to HT */
-		ht_enable_msi_mapping(dev);
+		if (found == 1) {
+			/* it is not enabled, try to enable it */
+			nv_ht_enable_msi_mapping(dev);
+		}
 		return;
 	}
 
-	/* Host bridge is not to HT, disable HT MSI mapping on this device */
-	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
-	while (pos && ttl--) {
-		u8 flags;
+	/* HT MSI is not enabled */
+	if (found == 1)
+		return;
 
-		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
-					 &flags) == 0) {
-			dev_info(&dev->dev, "Disabling HT MSI mapping");
-			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
-					      flags & ~HT_MSI_FLAGS_ENABLE);
-		}
-		pos = pci_find_next_ht_capability(dev, pos,
-						  HT_CAPTYPE_MSI_MAPPING);
-	}
+	/* Host bridge is not to HT, disable HT MSI mapping on this device */
+	ht_disable_msi_mapping(dev);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk);
