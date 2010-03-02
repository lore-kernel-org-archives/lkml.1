Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0CBXhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:00 -0500
Received: from kroah.org ([198.145.64.141]:51565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab0CBXgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Darius Augulis <augulis.darius@gmail.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/36] serial: 8250_pci: add support for MCS9865 / SYBA 6x Serial Port Card
Date: Tue,  2 Mar 2010 15:36:13 -0800
Message-Id: <1267573003-782-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ira W. Snyder <iws@ovro.caltech.edu>

This patch is heavily based on an earlier patch found on the linux-serial
mailing list [1], written by Darius Augulis.

The previous incarnation of this patch only supported a 2x serial port
card.  I have added support for my SYBA 6x serial port card, and tested on
x86.

[1]: http://marc.info/?l=linux-serial&m=124975806304760

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Darius Augulis <augulis.darius@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parport/parport_pc.c |    6 ++++++
 drivers/serial/8250_pci.c    |   22 +++++++++++++++++++++-
 include/linux/pci_ids.h      |    1 +
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index ad113b0..0950fa4 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2908,6 +2908,7 @@ enum parport_pc_pci_cards {
 	netmos_9805,
 	netmos_9815,
 	netmos_9901,
+	netmos_9865,
 	quatech_sppxp100,
 };
 
@@ -2989,6 +2990,7 @@ static struct parport_pc_pci {
 	/* netmos_9805 */               { 1, { { 0, -1 }, } },
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
+	/* netmos_9865 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };
 
@@ -3092,6 +3094,10 @@ static const struct pci_device_id parport_pc_pci_tbl[] = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9901,
 	  0xA000, 0x2000, 0, 0, netmos_9901 },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+	  0xA000, 0x1000, 0, 0, netmos_9865 },
+	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+	  0xA000, 0x2000, 0, 0, netmos_9865 },
 	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
 	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index b28af13..8b18c3c 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -760,7 +760,8 @@ static int pci_netmos_init(struct pci_dev *dev)
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
-	if (dev->device == PCI_DEVICE_ID_NETMOS_9901)
+	if ((dev->device == PCI_DEVICE_ID_NETMOS_9901) ||
+		(dev->device == PCI_DEVICE_ID_NETMOS_9865))
 		return 0;
 	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
 			dev->subsystem_device == 0x0299)
@@ -1479,6 +1480,7 @@ enum pci_board_num_t {
 
 	pbn_b0_bt_1_115200,
 	pbn_b0_bt_2_115200,
+	pbn_b0_bt_4_115200,
 	pbn_b0_bt_8_115200,
 
 	pbn_b0_bt_1_460800,
@@ -1703,6 +1705,12 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_bt_4_115200] = {
+		.flags		= FL_BASE0|FL_BASE_BARS,
+		.num_ports	= 4,
+		.base_baud	= 115200,
+		.uart_offset	= 8,
+	},
 	[pbn_b0_bt_8_115200] = {
 		.flags		= FL_BASE0|FL_BASE_BARS,
 		.num_ports	= 8,
@@ -3649,6 +3657,18 @@ static struct pci_device_id serial_pci_tbl[] = {
 		0, 0, pbn_b0_1_115200 },
 
 	/*
+	 * Best Connectivity PCI Multi I/O cards
+	 */
+
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+		0xA000, 0x1000,
+		0, 0, pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
+		0xA000, 0x3004,
+		0, 0, pbn_b0_bt_4_115200 },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0be8243..3ec4003 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2697,6 +2697,7 @@
 #define PCI_DEVICE_ID_NETMOS_9835	0x9835
 #define PCI_DEVICE_ID_NETMOS_9845	0x9845
 #define PCI_DEVICE_ID_NETMOS_9855	0x9855
+#define PCI_DEVICE_ID_NETMOS_9865	0x9865
 #define PCI_DEVICE_ID_NETMOS_9901	0x9901
 
 #define PCI_VENDOR_ID_3COM_2		0xa727
-- 
1.7.0.1

