Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZCFERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZCFERT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 23:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZCFERE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 23:17:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:45453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZCFERB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 23:17:01 -0500
Message-ID: <49B0A371.4040208@kernel.org>
Date: Thu, 05 Mar 2009 20:15:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>, Prakash Punnoor <prakash@punnoor.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too many HT MSI mapping
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903040815.38387.prakash@punnoor.de> <20090305171514.GB1021@parisc-linux.org> <200903060045.13509.prakash@punnoor.de> <20090306011036.GB829@parisc-linux.org>
In-Reply-To: <20090306011036.GB829@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check v4:

[PATCH] pci: don't enable too much HT MSI mapping -v4

Impact: fix bug

Prakash reported that his c51-mcp51 system ondie sound card doesn't work MSI
but if he hack out the HT-MSI on mcp51, the MSI will work well with sound card.

this patch rework the nv_msi_ht_cap_quirk()
and will only try to avoid to enable ht_msi on device following that root dev,
and don't touch that root dev

v3: will enable c51...
v4: will enable c51 kind of without leaf too.

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/quirks.c |  116 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 33 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2053,6 +2053,65 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
 			PCI_DEVICE_ID_NVIDIA_NVENET_15,
 			nvenet_msi_disable);
 
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
+static int __devinit host_bridge_with_leaf(struct pci_dev *host_bridge)
+{
+	struct pci_dev *dev;
+	int pos;
+	int i, dev_no;
+	int found = 0;
+
+	dev_no = host_bridge->devfn >> 3;
+	for (i = dev_no + 1; i < 0x20; i++) {
+		dev = pci_get_slot(host_bridge->bus, PCI_DEVFN(i, 0));
+		if (!dev)
+			continue;
+
+		/* found next host bridge ?*/
+		pos = pci_find_ht_capability(dev, HT_CAPTYPE_SLAVE);
+		if (pos != 0) {
+			pci_dev_put(dev);
+			break;
+		}
+
+		if (ht_check_msi_mapping(dev)) {
+			found = 1;
+			pci_dev_put(dev);
+			break;
+		}
+		pci_dev_put(dev);
+	}
+
+	return found;
+}
+
 static void __devinit nv_ht_enable_msi_mapping(struct pci_dev *dev)
 {
 	struct pci_dev *host_bridge;
@@ -2077,6 +2136,10 @@ static void __devinit nv_ht_enable_msi_m
 	if (!found)
 		return;
 
+	/* don't enable host_bridge with leaf directly here */
+	if (host_bridge == dev && host_bridge_with_leaf(host_bridge))
+		goto out;
+
 	/* root did that ! */
 	if (msi_ht_cap_enabled(host_bridge))
 		goto out;
@@ -2097,7 +2160,7 @@ static void __devinit ht_disable_msi_map
 
 		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
 					 &flags) == 0) {
-			dev_info(&dev->dev, "Enabling HT MSI Mapping\n");
+			dev_info(&dev->dev, "Disabling HT MSI Mapping\n");
 
 			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
 					      flags & ~HT_MSI_FLAGS_ENABLE);
@@ -2107,35 +2170,7 @@ static void __devinit ht_disable_msi_map
 	}
 }
 
-static int __devinit ht_check_msi_mapping(struct pci_dev *dev)
-{
-	int pos, ttl = 48;
-	int found = 0;
-
-	/* check if there is HT MSI cap or enabled on this device */
-	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
-	while (pos && ttl--) {
-		u8 flags;
-
-		if (found < 1)
-			found = 1;
-		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS,
-					 &flags) == 0) {
-			if (flags & HT_MSI_FLAGS_ENABLE) {
-				if (found < 2) {
-					found = 2;
-					break;
-				}
-			}
-		}
-		pos = pci_find_next_ht_capability(dev, pos,
-						  HT_CAPTYPE_MSI_MAPPING);
-	}
-
-	return found;
-}
-
-static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev)
+static void __devinit __nv_msi_ht_cap_quirk(struct pci_dev *dev, int all)
 {
 	struct pci_dev *host_bridge;
 	int pos;
@@ -2164,7 +2199,10 @@ static void __devinit nv_msi_ht_cap_quir
 		/* Host bridge is to HT */
 		if (found == 1) {
 			/* it is not enabled, try to enable it */
-			nv_ht_enable_msi_mapping(dev);
+			if (all)
+				ht_enable_msi_mapping(dev);
+			else
+				nv_ht_enable_msi_mapping(dev);
 		}
 		return;
 	}
@@ -2176,8 +2214,20 @@ static void __devinit nv_msi_ht_cap_quir
 	/* Host bridge is not to HT, disable HT MSI mapping on this device */
 	ht_disable_msi_mapping(dev);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk);
+
+static void __devinit nv_msi_ht_cap_quirk_all(struct pci_dev *dev)
+{
+	return __nv_msi_ht_cap_quirk(dev, 1);
+}
+
+static void __devinit nv_msi_ht_cap_quirk_leaf(struct pci_dev *dev)
+{
+	return __nv_msi_ht_cap_quirk(dev, 0);
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, nv_msi_ht_cap_quirk_leaf);
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, PCI_ANY_ID, nv_msi_ht_cap_quirk_all);
 
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
