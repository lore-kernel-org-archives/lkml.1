Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbZC3WE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbZC3WE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 18:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZC3WEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 18:04:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36445 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbZC3WEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 18:04:49 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 18:04:48 EDT
X-IronPort-AV: E=Sophos;i="4.38,448,1233529200"; 
   d="scan'208";a="23595620"
Message-ID: <49D13FB1.9090701@inria.fr>
Date: Mon, 30 Mar 2009 23:54:57 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
CC: "Andrew J. Gallatin" <gallatin@myri.com>
Subject: [RFC] ioat-dca: force I/OAT DCA when disabled in BIOS
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some machines (for instance Dell Poweredge servers) disable I/OAT DCA
support in the BIOS without any way to reenable it.
DCA may actually be enabled manually it in the processors' MSR and in
upstream bridge registers. We have been doing this with a hacky userspace
program, but we feel that the ioatdma driver may actually take care of it.
    
Here's a patch doing so, if the ioat_dca_force module parameter is set
to 1 on load.
    
There are some things to improve:
* Which pcidev should actually get DCA enabled? The patch below looks for
  Intel upstream bridges. Do we need a check for pdev->is_pcie ? Or maybe
  even look at pdev->pcie_type? It looks like the pcidev that need to be
  configured on my machines are PCI_EXP_TYPE_ROOT_PORT, but I am not sure
  it actually matters. Some Intel people will probably know how to fix this.
* Any better name for #defin'ing bit #6 at offset 0x64 in the config-space
  of these bridges?
    
Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Andrew Gallatin <gallatin@myri.com>

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f4e505f..1e83796 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -85,6 +85,7 @@
 #define MSR_P6_PERFCTR1			0x000000c2
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
+#define MSR_P6_DCA_CAP			0x000001f8
 
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
diff --git a/drivers/dma/ioat.c b/drivers/dma/ioat.c
index ed83dd9..8af1960 100644
--- a/drivers/dma/ioat.c
+++ b/drivers/dma/ioat.c
@@ -71,10 +71,16 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
+void dca_force(void);
+
 static int ioat_dca_enabled = 1;
 module_param(ioat_dca_enabled, int, 0644);
 MODULE_PARM_DESC(ioat_dca_enabled, "control support of dca service (default: 1)");
 
+static int ioat_dca_force = 0;
+module_param(ioat_dca_force, int, 0644);
+MODULE_PARM_DESC(ioat_dca_force, "enforce dca in upstream bridges and processors (default: 0)");
+
 static struct pci_driver ioat_pci_driver = {
 	.name		= "ioatdma",
 	.id_table	= ioat_pci_tbl,
@@ -191,6 +197,9 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 
 static int __init ioat_init_module(void)
 {
+	if (ioat_dca_force)
+		dca_force();
+
 	return pci_register_driver(&ioat_pci_driver);
 }
 module_init(ioat_init_module);
diff --git a/drivers/dma/ioat_dca.c b/drivers/dma/ioat_dca.c
index c012a1e..3f45f78 100644
--- a/drivers/dma/ioat_dca.c
+++ b/drivers/dma/ioat_dca.c
@@ -88,6 +88,45 @@ static inline u16 dcaid_from_pcidev(struct pci_dev *pci)
 	return (pci->bus->number << 8) | pci->devfn;
 }
 
+static void dca_force_msr(void *dummy)
+{
+	uint32_t data1, data2;
+	rdmsr(MSR_P6_DCA_CAP, data1, data2);
+	if (!(data1 & 1))
+		data1 |= 1;
+	wrmsr(MSR_P6_DCA_CAP, data1, data2);
+}
+
+#define INTEL_BRIDGE_DCAEN_OFFSET 0x64
+#define INTEL_BRIDGE_DCAEN_BIT	6
+
+void dca_force(void)
+{
+	struct pci_dev *pdev = NULL;
+
+	/* enable DCA in intel upstream bridges */
+	for_each_pci_dev(pdev) {
+		if (pdev->hdr_type == PCI_HEADER_TYPE_BRIDGE
+		    && pdev->vendor == PCI_VENDOR_ID_INTEL
+		    && !pdev->bus->self) {
+			u32 val;
+			int ret;
+
+			ret = pci_read_config_dword(pdev, INTEL_BRIDGE_DCAEN_OFFSET, &val);
+			if (ret < 0)
+				continue;
+			if (!(val & (1<<INTEL_BRIDGE_DCAEN_BIT))) {
+				dev_printk(KERN_INFO, &pdev->dev, "enabling DCA in upstream bridge\n");
+				val |= 1<<INTEL_BRIDGE_DCAEN_BIT;
+				pci_write_config_dword(pdev, INTEL_BRIDGE_DCAEN_OFFSET, val);
+			}
+		}
+	}
+
+	/* enable DCA in processors */
+	on_each_cpu(dca_force_msr, NULL, 1);
+}
+
 static int dca_enabled_in_bios(struct pci_dev *pdev)
 {
 	/* CPUID level 9 returns DCA configuration */


