Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbXEOL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbXEOL7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbXEOL7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:59:13 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:14882 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbXEOL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:59:12 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: gregkh@suse.de
Subject: [PATCH 1/2] PCI-X/PCI-Express read control interfaces
Date: Tue, 15 May 2007 13:59:13 +0200
User-Agent: KMail/1.9.6
cc: cramerj@intel.com, john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       rolandd@cisco.com, halr@voltaire.com, linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <200705151350.28330.peter.oruba@amd.com>
In-Reply-To: <200705151350.28330.peter.oruba@amd.com>
MIME-Version: 1.0
Message-ID: <200705151359.15116.peter.oruba@amd.com>
X-OriginalArrivalTime: 15 May 2007 11:58:38.0764 (UTC)
 FILETIME=[5FD3BEC0:01C796E8]
X-WSS-ID: 6A577FF420G2344212-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an interface to read and write PCI-X / PCI-Express 
maximum read byte count values from PCI config space. There is a second 
function that returns the maximum _designed_ read byte count, which marks the 
maximum value for a device, since some drivers try to set MMRBC to the 
highest allowed value and rely on such a function.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on patch set by Stephen Hemminger <shemminger@linux-foundation.org>

---
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/pci/pci.c linux-2.6.22-rc1/drivers/pci/pci.c
--- linux-2.6.22-rc1.orig/drivers/pci/pci.c	2007-05-14 11:29:39.473498000 
+0200
+++ linux-2.6.22-rc1/drivers/pci/pci.c	2007-05-15 11:44:33.804254000 +0200
@@ -1375,6 +1375,170 @@ pci_set_consistent_dma_mask(struct pci_d
 #endif
 
 /**
+ * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
+ * @dev: PCI device to query
+ *
+ * Returns mmrbc: maximum designed memory read count in bytes
+ *    or appropriate error value.
+ */
+int
+pcix_get_max_mmrbc(struct pci_dev *dev)
+{
+	int ret, err, cap;
+	u32 stat;
+	
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		return -EINVAL;
+
+	err = pci_read_config_dword(dev, cap + PCI_X_STATUS, &stat);
+	if (err)
+		return -EINVAL;
+
+	ret = (stat & PCI_X_STATUS_MAX_READ) >> 12;
+
+	return ret;
+}
+EXPORT_SYMBOL(pcix_get_max_mmrbc);
+
+/**
+ * pcix_get_mmrbc - get PCI-X maximum memory read byte count
+ * @dev: PCI device to query
+ *
+ * Returns mmrbc: maximum memory read count in bytes
+ *    or appropriate error value.
+ */
+int
+pcix_get_mmrbc(struct pci_dev *dev)
+{
+	int ret, cap;
+	u32 cmd;
+	
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		return -EINVAL;
+	
+	ret = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	if (!ret)
+		ret = 512 << ((cmd & PCI_X_CMD_MAX_READ) >> 2);
+	
+	return ret;
+}
+EXPORT_SYMBOL(pcix_get_mmrbc);
+
+/**
+ * pcix_set_mmrbc - set PCI-X maximum memory read byte count
+ * @dev: PCI device to query
+ * @mmrbc: maximum memory read count in bytes
+ *    valid values are 512, 1024, 2048, 4096
+ *
+ * If possible sets maximum memory read byte count, some bridges have erratas
+ * that prevent this.
+ */
+int
+pcix_set_mmrbc(struct pci_dev *dev, int mmrbc)
+{
+	int cap, err = -EINVAL;
+	u32 stat, cmd, v, o;
+		
+	if (mmrbc < 512 || mmrbc > 4096 || (mmrbc & (mmrbc-1)))
+		goto out;
+	
+	v = ffs(mmrbc) - 10;
+	
+	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
+	if (!cap)
+		goto out;
+	
+	err = pci_read_config_dword(dev, cap + PCI_X_STATUS, &stat);
+	if (err)
+		goto out;
+	
+	if (v > (stat & PCI_X_STATUS_MAX_READ) >> 21)
+		return -E2BIG;
+	
+	err = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	if (err)
+		goto out;
+	
+	o = (cmd & PCI_X_CMD_MAX_READ) >> 2;
+	if (o != v) {
+		if (v > o && dev->bus && 
+		   (dev->bus->bus_flags & PCI_BUS_FLAGS_NO_MMRBC))
+			return -EIO;
+		
+		cmd &= ~PCI_X_CMD_MAX_READ;
+		cmd |= v << 2;
+		err = pci_write_config_dword(dev, cap + PCI_X_CMD, cmd);
+	}
+out:
+	return err;
+}
+EXPORT_SYMBOL(pcix_set_mmrbc);
+
+/**
+ * pcie_get_readrq - get PCI Express read request size
+ * @dev: PCI device to query
+ *
+ * Returns maximum memory read request in bytes
+ *    or appropriate error value.
+ */
+int pcie_get_readrq(struct pci_dev *dev)
+{
+	int ret, cap;
+	u16 ctl;
+
+	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!cap)
+		return -EINVAL;
+
+	ret = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (!ret)
+	ret = 128 << ((ctl & PCI_EXP_DEVCTL_READRQ) >> 12);
+
+	return ret;
+}
+EXPORT_SYMBOL(pcie_get_readrq);
+
+/**
+ * pcie_set_readrq - set PCI Express maximum memory read request
+ * @dev: PCI device to query
+ * @count: maximum memory read count in bytes
+ *    valid values are 128, 256, 512, 1024, 2048, 4096
+ *
+ * If possible sets maximum read byte count
+ */
+int
+pcie_set_readrq(struct pci_dev *dev, int rq)
+{
+	int cap, err = -EINVAL;
+	u16 ctl, v;
+	
+	if (rq < 128 || rq > 4096 || (rq & (rq-1)))
+		goto out;
+	
+	v = (ffs(rq) - 8) << 12;
+	
+	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	if (!cap)
+		goto out;
+
+	err = pci_read_config_word(dev, cap + PCI_EXP_DEVCTL, &ctl);
+	if (err)
+		goto out;
+	
+	if ((ctl & PCI_EXP_DEVCTL_READRQ) != v) {
+		ctl &= ~PCI_EXP_DEVCTL_READRQ;
+		ctl |= v;
+		err = pci_write_config_dword(dev, cap + PCI_EXP_DEVCTL, ctl);
+	}
+	
+out:
+	return err;
+}
+EXPORT_SYMBOL(pcie_set_readrq);
+
+/**
  * pci_select_bars - Make BAR mask from the type of resource
  * @dev: the PCI device for which BAR mask is made
  * @flags: resource type mask to be selected
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/pci/quirks.c 
linux-2.6.22-rc1/drivers/pci/quirks.c
--- linux-2.6.22-rc1.orig/drivers/pci/quirks.c	2007-05-14 11:29:39.596501000 
+0200
+++ linux-2.6.22-rc1/drivers/pci/quirks.c	2007-05-15 10:07:43.342427000 +0200
@@ -627,6 +627,22 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AM
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, 
quirk_amd_8131_ioapic);
 #endif /* CONFIG_X86_IO_APIC */
 
+/*
+ * Some settings of MMRBC can lead to data corruption so block changes.
+ * See AMD 8131 HyperTransport PCI-X Tunnel Revision Guide
+ */
+static void __init quirk_amd_8131_mmrbc(struct pci_dev *dev)
+{
+	unsigned char revid;
+
+	pci_read_config_byte(dev, PCI_REVISION_ID, &revid);
+	if (dev->subordinate && revid <= 0x12) {
+        	printk(KERN_INFO "AMD8131 rev %x detected, disabling PCI-X MMRBC\n",
+        		revid);
+        	dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MMRBC;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, 
quirk_amd_8131_mmrbc);
 
 /*
  * FIXME: it is questionable that quirk_via_acpi
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/include/linux/pci.h 
linux-2.6.22-rc1/include/linux/pci.h
--- linux-2.6.22-rc1.orig/include/linux/pci.h	2007-05-14 11:29:55.025995000 
+0200
+++ linux-2.6.22-rc1/include/linux/pci.h	2007-05-15 11:34:26.602039000 +0200
@@ -111,7 +111,8 @@ enum pcie_reset_state {
 
 typedef unsigned short __bitwise pci_bus_flags_t;
 enum pci_bus_flags {
-	PCI_BUS_FLAGS_NO_MSI = (__force pci_bus_flags_t) 1,
+	PCI_BUS_FLAGS_NO_MSI   = (__force pci_bus_flags_t) 1,
+	PCI_BUS_FLAGS_NO_MMRBC = (__force pci_bus_flags_t) 2,
 };
 
 struct pci_cap_saved_state {
@@ -549,6 +550,10 @@ void pci_intx(struct pci_dev *dev, int e
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pcix_get_max_mmrbc(struct pci_dev *dev);
+int pcix_get_mmrbc(struct pci_dev *dev);
+int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
+int pcie_set_readrq(struct pci_dev *dev, int rq);
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int 
resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_assign_resource_fixed(struct pci_dev *dev, int i);

---

-- 
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


