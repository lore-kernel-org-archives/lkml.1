Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbXLRPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbXLRPCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbXLRPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:02:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:49188 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbXLRPC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:02:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KzPG7KiXkWwXfFP8PZx4/YQPt7rRaQsalQ485o9t+UPFd6a6+yxFzCSDO5uIyM1MDEWsjDV3vJuCpM+sSap8J7wd0eoEYdNxbMqeSpwZGruCewftLmvsNioyW+BPt+AEhox9wMLHc3PL1QyC39Q6VRl25CO31Mj+LAbRv9DPKPw=
Date: Tue, 18 Dec 2007 23:00:52 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "acurrid" <acurrid@nvidia.com>,
       "pchen" <pchen@nvidia.com>, "ebiederm" <ebiederm@xmission.com>
Subject: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Message-ID: <200712182300373901202@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active.
Set the 'En' bit when setup pci and add the quirk for some nvidia devices. 

The patch base on kernel 2.6.24-rc5

Signed-off-by: Andy Currid <acurrid@nvidia.com>
Signed-off-by: Peer Chen <pchen@nvidia.com>

---
diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/drivers/pci/probe.c linux-2.6.24-rc5/drivers/pci/probe.c
--- linux-2.6.24-rc5-vanilla/drivers/pci/probe.c	2007-12-18 14:35:46.000000000 -0500
+++ linux-2.6.24-rc5/drivers/pci/probe.c	2007-12-18 16:28:29.000000000 -0500
@@ -721,6 +721,9 @@ static int pci_setup_device(struct pci_d
 
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
+	
+	/* Enable HT MSI mapping */
+	ht_enable_msi_mapping(dev);
 
 	/* Early fixups, before probing the BARs */
 	pci_fixup_device(pci_fixup_early, dev);
diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c linux-2.6.24-rc5/drivers/pci/quirks.c
--- linux-2.6.24-rc5-vanilla/drivers/pci/quirks.c	2007-12-18 14:35:46.000000000 -0500
+++ linux-2.6.24-rc5/drivers/pci/quirks.c	2007-12-18 16:28:41.000000000 -0500
@@ -1705,6 +1705,45 @@ static void __devinit quirk_nvidia_ck804
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_CK804_PCIE,
 			quirk_nvidia_ck804_msi_ht_cap);
 
+static void __devinit quirk_msi_ht_cap_disable(struct pci_dev *dev) {
+	struct pci_dev *host_bridge;
+	int pos, ttl = 48;
+
+	/* HT MSI mapping should be disabled on devices that are below
+	 * a non-Hypertransport host bridge. Locate the host bridge...
+ 	 */
+
+	if ((host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0,0))) == NULL) {
+		printk(KERN_WARNING
+			 "PCI: quirk_msi_ht_cap_disable didn't locate host bridge\n");
+		return;
+	}
+
+	if ((pos = pci_find_ht_capability(host_bridge, HT_CAPTYPE_SLAVE)) != 0) {
+		/* Host bridge is to HT */
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
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+							quirk_msi_ht_cap_disable);
+
 static void __devinit quirk_msi_intx_disable_bug(struct pci_dev *dev)
 {
 	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h linux-2.6.24-rc5/include/asm-generic/pci.h
--- linux-2.6.24-rc5-vanilla/include/asm-generic/pci.h	2007-12-18 14:35:52.000000000 -0500
+++ linux-2.6.24-rc5/include/asm-generic/pci.h	2007-12-18 16:29:12.000000000 -0500
@@ -45,6 +45,10 @@ pcibios_select_root(struct pci_dev *pdev
 
 #define pcibios_scan_all_fns(a, b)	0
 
+#ifndef HAVE_ARCH_HT_ENABLE_MSI_MAPPING
+#define ht_enable_msi_mapping(a)	0
+#endif /* HAVE_ARCH_HT_ENABLE_MSI_MAPPING */
+
 #ifndef HAVE_ARCH_PCI_GET_LEGACY_IDE_IRQ
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
diff -uprN -X linux-2.6.24-rc5-vanilla/Documentation/dontdiff linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h linux-2.6.24-rc5/include/asm-x86/pci.h
--- linux-2.6.24-rc5-vanilla/include/asm-x86/pci.h	2007-12-18 14:35:51.000000000 -0500
+++ linux-2.6.24-rc5/include/asm-x86/pci.h	2007-12-18 16:28:58.000000000 -0500
@@ -75,6 +75,27 @@ static inline void pci_dma_burst_advice(
 }
 #endif
 
+#ifdef CONFIG_PCI
+#define HAVE_ARCH_HT_ENABLE_MSI_MAPPING
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
+		pos = pci_find_next_ht_capability(dev, pos, HT_CAPTYPE_MSI_MAPPING);
+	}
+}
+#endif
 
 #endif  /* __KERNEL__ */
-

