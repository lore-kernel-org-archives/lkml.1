Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZCUCbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZCUCbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 22:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZCUCaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 22:30:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:50494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZCUCax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 22:30:53 -0400
Message-ID: <49C45115.2090101@kernel.org>
Date: Fri, 20 Mar 2009 19:29:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Wilcox <matthew@wil.cx>, Prakash Punnoor <prakash@punnoor.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903040815.38387.prakash@punnoor.de> <20090305171514.GB1021@parisc-linux.org> <200903060045.13509.prakash@punnoor.de> <20090306011036.GB829@parisc-linux.org> <49B0A371.4040208@kernel.org>
In-Reply-To: <49B0A371.4040208@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug

Prakash reported that his c51-mcp51 system ondie sound card doesn't work MSI
but if he hack out the HT-MSI on mcp51, the MSI will work well with sound card.

this patch rework the nv_msi_ht_cap_quirk()
and will only try to avoid to enable ht_msi on device following that root dev,
and don't touch that root dev

v3: will enable c51...
v4: will enable c51 kind of without leaf too.
v5: update to mainline

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/quirks.c |  118 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 82 insertions(+), 36 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2078,6 +2078,65 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NV
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
@@ -2102,6 +2161,10 @@ static void __devinit nv_ht_enable_msi_m
 	if (!found)
 		return;
 
+	/* don't enable host_bridge with leaf directly here */
+	if (host_bridge == dev && host_bridge_with_leaf(host_bridge))
+		goto out;
+
 	/* root did that ! */
 	if (msi_ht_cap_enabled(host_bridge))
 		goto out;
@@ -2132,44 +2195,12 @@ static void __devinit ht_disable_msi_map
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
 	int found;
 
-	/* Enabling HT MSI mapping on this device breaks MCP51 */
-	if (dev->device == 0x270)
-		return;
-
 	/* check if there is HT MSI cap or enabled on this device */
 	found = ht_check_msi_mapping(dev);
 
@@ -2193,7 +2224,10 @@ static void __devinit nv_msi_ht_cap_quir
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
@@ -2205,8 +2239,20 @@ static void __devinit nv_msi_ht_cap_quir
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
