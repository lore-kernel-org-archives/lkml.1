Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYAJOmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYAJOmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 09:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYAJOmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 09:42:05 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:55087 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbYAJOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 09:42:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KXXzBNp+M4uzfWdmSs88PvprVNU8W8brvCXhNVbwdmPkxSosiPvotoNkxy3tSgFI81hJHCi47Z5+PLmvlM+hNU7iWlDOhB2QJnS9udBge9b0R6xV5BLTtSM8IwwCVGymFmgYSmbThtGqYHaZlbSO0LDddgw44ju8NEng399FuGQ=
Date: Thu, 10 Jan 2008 22:41:58 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "ebiederm" <ebiederm@xmission.com>,
       "acurrid" <acurrid@nvidia.com>, "pchen" <pchen@nvidia.com>
Subject: [PATCH]quirks: set 'En' bit of MSI Mapping for devices on HT-based nvidia platform
Message-ID: <200801102241563593942@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>

---
--- linux-2.6.24-rc7/drivers/pci/quirks.c.orig	2008-01-09 16:37:36.000000000 -0500
+++ linux-2.6.24-rc7/drivers/pci/quirks.c	2008-01-10 15:03:09.000000000 -0500
@@ -1705,6 +1705,70 @@ static void __devinit quirk_nvidia_ck804
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
 
+/*
+ *  Force enable MSI mapping capability on HT bridges  */
+static inline void ht_enable_msi_mapping(struct pci_dev *dev)
+{
+	int pos, ttl = 48;
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
+			printk(KERN_INFO "PCI: Enabling HT MSI Mapping on %s\n",
+						dev->dev.bus_id);
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags | HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+
+static void __devinit nv_msi_ht_cap_quirk(struct pci_dev *dev) {
+
+	struct pci_dev *host_bridge;
+	int pos, ttl = 48;
+	
+	/* HT MSI mapping should be disabled on devices that are below
+	 * a non-Hypertransport host bridge. Locate the host bridge...
+ 	 */
+
+	if ((host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0))) == NULL) {
+		printk(KERN_WARNING
+			"PCI: nv_msi_ht_cap_quirk didn't locate host bridge\n");
+		return;
+	}
+
+	if ((pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE)) != 0) {
+		/* Host bridge is to HT */
+		ht_enable_msi_mapping(dev);
+		return;
+	}
+
+	/* Host bridge is not to HT, disable HT MSI mapping on this device */
+
+	pos = pci_find_ht_capability(dev, HT_CAPTYPE_MSI_MAPPING);
+	while (pos && ttl--) {
+		u8 flags;
+
+		if (pci_read_config_byte(dev, pos + HT_MSI_FLAGS, &flags) == 0) {
+			printk(KERN_INFO "PCI: Quirk disabling HT MSI mapping on %s\n",
+			       pci_name(dev));
+
+			pci_write_config_byte(dev, pos + HT_MSI_FLAGS,
+					      flags & ~HT_MSI_FLAGS_ENABLE);
+		}
+		pos = pci_find_next_ht_capability(dev, pos,
+						  HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+							nv_msi_ht_cap_quirk);
+
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
-

