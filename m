Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZDFPfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZDFPfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZDFPdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:33:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56958 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755448AbZDFPdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:33:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/27] 8250_pci: add support for National Instruments legacy
	8420 RS232 boards
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:32:15 +0100
Message-ID: <20090406163213.12934.77878.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Page <will.page@ni.com>

Signed-off-by: Will Page <will.page@ni.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@ni.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/8250_pci.c |  218 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |   12 ++
 2 files changed, 230 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 2f570c7..5b0e80d 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -306,6 +306,33 @@ static void __devexit pci_plx9050_exit(struct pci_dev *dev)
 	}
 }
 
+#define NI8420_INT_ENABLE_REG	0x38
+#define NI8420_INT_ENABLE_BIT	0x2000
+
+static void __devexit pci_ni8420_exit(struct pci_dev *dev)
+{
+	void __iomem *p;
+	unsigned long base, len;
+	unsigned int bar = 0;
+
+	if ((pci_resource_flags(dev, bar) & IORESOURCE_MEM) == 0) {
+		moan_device("no memory in bar", dev);
+		return;
+	}
+
+	base = pci_resource_start(dev, bar);
+	len =  pci_resource_len(dev, bar);
+	p = ioremap_nocache(base, len);
+	if (p == NULL)
+		return;
+
+	/* Disable the CPU Interrupt */
+	writel(readl(p + NI8420_INT_ENABLE_REG) & ~(NI8420_INT_ENABLE_BIT),
+	       p + NI8420_INT_ENABLE_REG);
+	iounmap(p);
+}
+
+
 /* MITE registers */
 #define MITE_IOWBSR1	0xc4
 #define MITE_IOWCR1	0xf4
@@ -627,6 +654,31 @@ static int pci_xircom_init(struct pci_dev *dev)
 	return 0;
 }
 
+static int pci_ni8420_init(struct pci_dev *dev)
+{
+	void __iomem *p;
+	unsigned long base, len;
+	unsigned int bar = 0;
+
+	if ((pci_resource_flags(dev, bar) & IORESOURCE_MEM) == 0) {
+		moan_device("no memory in bar", dev);
+		return 0;
+	}
+
+	base = pci_resource_start(dev, bar);
+	len =  pci_resource_len(dev, bar);
+	p = ioremap_nocache(base, len);
+	if (p == NULL)
+		return -ENOMEM;
+
+	/* Enable CPU Interrupt */
+	writel(readl(p + NI8420_INT_ENABLE_REG) | NI8420_INT_ENABLE_BIT,
+	       p + NI8420_INT_ENABLE_REG);
+
+	iounmap(p);
+	return 0;
+}
+
 #define MITE_IOWBSR1_WSIZE	0xa
 #define MITE_IOWBSR1_WIN_OFFSET	0x800
 #define MITE_IOWBSR1_WENAB	(1 << 7)
@@ -1023,6 +1075,114 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 	 */
 	{
 		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI23216,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI2328,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI2324,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI2322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI2324I,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PCI2322I,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8420_23216,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8420_2328,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8420_2324,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8420_2322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8422_2324,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
+		.device		= PCI_DEVICE_ID_NI_PXI8422_2322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.init		= pci_ni8420_init,
+		.setup		= pci_default_setup,
+		.exit		= __devexit_p(pci_ni8420_exit),
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_NI,
 		.device		= PCI_ANY_ID,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
@@ -1334,6 +1494,7 @@ enum pci_board_num_t {
 	pbn_b1_2_115200,
 	pbn_b1_4_115200,
 	pbn_b1_8_115200,
+	pbn_b1_16_115200,
 
 	pbn_b1_1_921600,
 	pbn_b1_2_921600,
@@ -1343,6 +1504,9 @@ enum pci_board_num_t {
 	pbn_b1_2_1250000,
 
 	pbn_b1_bt_1_115200,
+	pbn_b1_bt_2_115200,
+	pbn_b1_bt_4_115200,
+
 	pbn_b1_bt_2_921600,
 
 	pbn_b1_1_1382400,
@@ -1609,6 +1773,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b1_16_115200] = {
+		.flags		= FL_BASE1,
+		.num_ports	= 16,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 
 	[pbn_b1_1_921600] = {
 		.flags		= FL_BASE1,
@@ -1647,6 +1817,18 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b1_bt_2_115200] = {
+		.flags		= FL_BASE1|FL_BASE_BARS,
+		.num_ports	= 2,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
+	[pbn_b1_bt_4_115200] = {
+		.flags		= FL_BASE1|FL_BASE_BARS,
+		.num_ports	= 4,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 
 	[pbn_b1_bt_2_921600] = {
 		.flags		= FL_BASE1|FL_BASE_BARS,
@@ -3207,6 +3389,42 @@ static struct pci_device_id serial_pci_tbl[] = {
 	/*
 	 * National Instruments
 	 */
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI23216,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_16_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI2328,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_8_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI2324,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_4_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI2322,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_2_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI2324I,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_4_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PCI2322I,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_2_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8420_23216,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_16_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8420_2328,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_8_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8420_2324,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_4_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8420_2322,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_2_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8422_2324,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_4_115200 },
+	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8422_2322,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b1_bt_2_115200 },
 	{	PCI_VENDOR_ID_NI, PCI_DEVICE_ID_NI_PXI8430_2322,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_ni8430_2 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 449e7d9..ee98cd5 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -945,6 +945,18 @@
 #define PCI_DEVICE_ID_SUN_CASSINI	0xabba
 
 #define PCI_VENDOR_ID_NI		0x1093
+#define PCI_DEVICE_ID_NI_PCI2322	0xd130
+#define PCI_DEVICE_ID_NI_PCI2324	0xd140
+#define PCI_DEVICE_ID_NI_PCI2328	0xd150
+#define PCI_DEVICE_ID_NI_PXI8422_2322	0xd190
+#define PCI_DEVICE_ID_NI_PXI8422_2324	0xd1a0
+#define PCI_DEVICE_ID_NI_PXI8420_2322	0xd1d0
+#define PCI_DEVICE_ID_NI_PXI8420_2324	0xd1e0
+#define PCI_DEVICE_ID_NI_PXI8420_2328	0xd1f0
+#define PCI_DEVICE_ID_NI_PXI8420_23216	0xd1f1
+#define PCI_DEVICE_ID_NI_PCI2322I	0xd250
+#define PCI_DEVICE_ID_NI_PCI2324I	0xd270
+#define PCI_DEVICE_ID_NI_PCI23216	0xd2b0
 #define PCI_DEVICE_ID_NI_PXI8430_2322	0x7080
 #define PCI_DEVICE_ID_NI_PCI8430_2322	0x70db
 #define PCI_DEVICE_ID_NI_PXI8430_2324	0x70dd

