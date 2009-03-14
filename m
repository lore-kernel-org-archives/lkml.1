Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZCNAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZCNAgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZCNATY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:24 -0400
Received: from kroah.org ([198.145.64.141]:47160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753190AbZCNATM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:47 2009
Message-Id: <20090314000746.939556618@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@hobbes.lan>
Subject: [patch 52/96] PCI: dont enable too many HT MSI mappings
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=pci-don-t-enable-too-many-ht-msi-mappings.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 1dec6b054dd1fc780e18b815068bf5677409eb2d upstream.

Prakash reported that his c51-mcp51 ondie sound card doesn't work with
MSI.  But if he hacks out the HT-MSI quirk, MSI works fine.

So this patch reworks the nv_msi_ht_cap_quirk().  It will now only
enable ht_msi on own its root device, avoiding enabling it on devices
following that root dev.

Reported-by: Prakash Punnoor <prakash@punnoor.de>
Tested-by: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Jesse Barnes <jbarnes@hobbes.lan>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c |  115 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 100 insertions(+), 15 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1934,10 +1934,100 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_S
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8132_BRIDGE,
 			 ht_enable_msi_mapping);
 
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
+	int pos, ttl = 48;
+
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
 	int pos, ttl = 48;
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
 
 	/*
 	 * HT MSI mapping should be disabled on devices that are below
@@ -1953,24 +2043,19 @@ static void __devinit nv_msi_ht_cap_quir
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


