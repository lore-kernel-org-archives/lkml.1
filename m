Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZBDS60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZBDS60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbZBDSt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:26 -0500
Received: from kroah.org ([198.145.64.141]:60965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759577AbZBDStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:17 -0500
Date: Wed, 4 Feb 2009 10:46:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Karl Bongers <kbongers@jged.com>,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [patch 18/41] USB: isp1760: Fix probe in PCI glue code
Message-ID: <20090204184624.GS25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-isp1760-fix-probe-in-pci-glue-code.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Karl Bongers <kbongers@jged.com>

This is the backported version of the upstream commit
Stefan Bader <stefan.bader@canonical.com> did the backport

Contains fixes so probe on x86 PCI runs, apparently I'm first to try
this. Several fixes to memory access to probe host scratch register.
Previously would bug check on chip_addr var used uninitialized.
Scratch reg write failed in one instance due to 16-bit initial access
mode, so added "& 0x0000ffff" to the readl as fix.
Includes some general cleanup - remove global vars, organize memory map
resource use.

Signed-off-by: Karl Bongers <kbongers@jged.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/isp1760-if.c |   96 ++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 41 deletions(-)

--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -129,23 +129,23 @@ static struct of_platform_driver isp1760
 #endif
 
 #ifdef CONFIG_PCI
-static u32 nxp_pci_io_base;
-static u32 iolength;
-static u32 pci_mem_phy0;
-static u32 length;
-static u8 __iomem *chip_addr;
-static u8 __iomem *iobase;
-
 static int __devinit isp1761_pci_probe(struct pci_dev *dev,
 		const struct pci_device_id *id)
 {
 	u8 latency, limit;
 	__u32 reg_data;
 	int retry_count;
-	int length;
-	int status = 1;
 	struct usb_hcd *hcd;
 	unsigned int devflags = 0;
+	int ret_status = 0;
+
+	resource_size_t pci_mem_phy0;
+	resource_size_t memlength;
+
+	u8 __iomem *chip_addr;
+	u8 __iomem *iobase;
+	resource_size_t nxp_pci_io_base;
+	resource_size_t iolength;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -168,26 +168,30 @@ static int __devinit isp1761_pci_probe(s
 	iobase = ioremap_nocache(nxp_pci_io_base, iolength);
 	if (!iobase) {
 		printk(KERN_ERR "ioremap #1\n");
-		release_mem_region(nxp_pci_io_base, iolength);
-		return -ENOMEM;
+		ret_status = -ENOMEM;
+		goto cleanup1;
 	}
 	/* Grab the PLX PCI shared memory of the ISP 1761 we need  */
 	pci_mem_phy0 = pci_resource_start(dev, 3);
-	length = pci_resource_len(dev, 3);
-
-	if (length < 0xffff) {
-		printk(KERN_ERR "memory length for this resource is less than "
-				"required\n");
-		release_mem_region(nxp_pci_io_base, iolength);
-		iounmap(iobase);
-		return  -ENOMEM;
+	memlength = pci_resource_len(dev, 3);
+	if (memlength < 0xffff) {
+		printk(KERN_ERR "memory length for this resource is wrong\n");
+		ret_status = -ENOMEM;
+		goto cleanup2;
 	}
 
-	if (!request_mem_region(pci_mem_phy0, length, "ISP-PCI")) {
+	if (!request_mem_region(pci_mem_phy0, memlength, "ISP-PCI")) {
 		printk(KERN_ERR "host controller already in use\n");
-		release_mem_region(nxp_pci_io_base, iolength);
-		iounmap(iobase);
-		return -EBUSY;
+		ret_status = -EBUSY;
+		goto cleanup2;
+	}
+
+	/* map available memory */
+	chip_addr = ioremap_nocache(pci_mem_phy0,memlength);
+	if (!chip_addr) {
+		printk(KERN_ERR "Error ioremap failed\n");
+		ret_status = -ENOMEM;
+		goto cleanup3;
 	}
 
 	/* bad pci latencies can contribute to overruns */
@@ -210,38 +214,54 @@ static int __devinit isp1761_pci_probe(s
 		 * */
 		writel(0xface, chip_addr + HC_SCRATCH_REG);
 		udelay(100);
-		reg_data = readl(chip_addr + HC_SCRATCH_REG);
+		reg_data = readl(chip_addr + HC_SCRATCH_REG) & 0x0000ffff;
 		retry_count--;
 	}
 
+	iounmap(chip_addr);
+
 	/* Host Controller presence is detected by writing to scratch register
 	 * and reading back and checking the contents are same or not
 	 */
 	if (reg_data != 0xFACE) {
 		err("scratch register mismatch %x", reg_data);
-		goto clean;
+		ret_status = -ENOMEM;
+		goto cleanup3;
 	}
 
 	pci_set_master(dev);
 
-	status = readl(iobase + 0x68);
-	status |= 0x900;
-	writel(status, iobase + 0x68);
+	/* configure PLX PCI chip to pass interrupts */
+#define PLX_INT_CSR_REG 0x68
+	reg_data = readl(iobase + PLX_INT_CSR_REG);
+	reg_data |= 0x900;
+	writel(reg_data, iobase + PLX_INT_CSR_REG);
 
 	dev->dev.dma_mask = NULL;
-	hcd = isp1760_register(pci_mem_phy0, length, dev->irq,
+	hcd = isp1760_register(pci_mem_phy0, memlength, dev->irq,
 		IRQF_SHARED | IRQF_DISABLED, &dev->dev, dev_name(&dev->dev),
 		devflags);
+	if (IS_ERR(hcd)) {
+		ret_status = -ENODEV;
+		goto cleanup3;
+	}
+
+	/* done with PLX IO access */
+	iounmap(iobase);
+	release_mem_region(nxp_pci_io_base, iolength);
+
 	pci_set_drvdata(dev, hcd);
-	if (!hcd)
-		return 0;
-clean:
-	status = -ENODEV;
+	return 0;
+
+cleanup3:
+	release_mem_region(pci_mem_phy0, memlength);
+cleanup2:
 	iounmap(iobase);
-	release_mem_region(pci_mem_phy0, length);
+cleanup1:
 	release_mem_region(nxp_pci_io_base, iolength);
-	return status;
+	return ret_status;
 }
+
 static void isp1761_pci_remove(struct pci_dev *dev)
 {
 	struct usb_hcd *hcd;
@@ -254,12 +274,6 @@ static void isp1761_pci_remove(struct pc
 	usb_put_hcd(hcd);
 
 	pci_disable_device(dev);
-
-	iounmap(iobase);
-	iounmap(chip_addr);
-
-	release_mem_region(nxp_pci_io_base, iolength);
-	release_mem_region(pci_mem_phy0, length);
 }
 
 static void isp1761_pci_shutdown(struct pci_dev *dev)

