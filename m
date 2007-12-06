Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXLFHtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXLFHtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXLFHto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:49:44 -0500
Received: from firewall1.addi-data.de ([62.154.208.154]:48722 "EHLO
	firewal1.addi-data.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753200AbXLFHtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:49:42 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: AW: [PATCH] serial: add ADDI-DATA GmbH Communication
 cardsin8250_pci.c and pci_ids.h.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 6 Dec 2007 08:49:44 +0100
Message-ID: <DD0BA80209AFF04091B518EA708D0A0BA23ED5@exchange01.addi-data.intra>
Thread-Topic: [PATCH] serial: add ADDI-DATA GmbH Communication 
    cardsin8250_pci.c and pci_ids.h.
Thread-Index: AcgzIQVH3gDOCzZvS5SrU4Uo1CG18AAAewQgAS3wxvA=
References: <DD0BA80209AFF04091B518EA708D0A0B9F91BF@exchange01.addi-data.intra> 
    <20071128104914.GA23074@pazke.donpac.ru> 
    <DD0BA80209AFF04091B518EA708D0A0B9F9210@exchange01.addi-data.intra> 
    <20071130071339.GB24928@pazke.donpac.ru> 
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>
To: "Andrey Panin" <pazke@donpac.ru>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Here is the last version of the patch updated regarding your remarks.

Regards,

Julien Krauth

Changes:
========

- Indentation.

- Code optimisation: all boards except the APCI-7800 are now managed
with the pci_default_setup() function.

- Add pbn_b0_8_115200 to manage the APCI-7800-3 with the
pci_default_setup() function.


---

From: Krauth Julien <krauth.julien@addi-data.com>

Add ADDI-DATA GmbH communication cards to 8250_pci driver.
Supported cards are:

APCI-7300, APCI-7420, APCI-7500, APCI-7800 APCI-7300-2, APCI-7420-2,
APCI-7500-2 APCI-7300-3, APCI-7420-3, APCI-7500-3, APCI-7800-3

8250_pci.c.patch
================
Add ADDI-DATA GmbH communication cards to 8250_pci.c.

pci_ids.h.patch
===============
Add ADDI-DATA GmbH communication cards Vendor and Device IDs to
pci_ids.h.

WARNING:
========
8250_pci.c.patch depend on pci_ids.h.patch.
8250_pci.c is using Vendor and Device ID defined in pci_ids.h.


Signed-off-by: Krauth J. <krauth.julien@addi-data.com>
---

This patch applies to kernel 2.6.23.9.

--- linux-2.6.23.9-vanilla/include/linux/pci_ids.h	2007-11-26
18:51:43.000000000 +0100
+++ linux-2.6.23.9/include/linux/pci_ids.h	2007-11-27
10:55:12.000000000 +0100
@@ -2019,6 +2019,23 @@
 #define PCI_VENDOR_ID_QUICKNET		0x15e2
 #define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
 
+/*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>  */
+#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
+#define PCI_VENDOR_ID_ADDIDATA                 0x15B8
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_3      0x700C
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+
 #define PCI_VENDOR_ID_PDC		0x15e9
 
 #define PCI_VENDOR_ID_FARSITE           0x1619


--- linux-2.6.23.9-vanilla/drivers/serial/8250_pci.c	2007-11-26
18:51:43.000000000 +0100
+++ linux-2.6.23.9/drivers/serial/8250_pci.c	2007-11-30
08:33:50.000000000 +0100
@@ -106,6 +106,32 @@ setup_port(struct serial_private *priv, 
 }
 
 /*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>
+ */
+static int
+addidata_apci7800_setup(struct serial_private *priv, struct
pciserial_board *board,
+               struct uart_port *port, int idx)
+{
+	unsigned int bar = 0, offset = board->first_offset;
+	bar = FL_GET_BASE(board->flags);
+
+	if (idx < 2 ) {
+		offset += idx * board->uart_offset;
+	} else if ((idx >= 2) && (idx < 4)) {
+		bar += 1;
+		offset += ((idx - 2) * board->uart_offset);
+	} else if ((idx >= 4) && (idx < 6 )) {
+		bar += 2;
+		offset += ((idx - 4) * board->uart_offset);
+	} else if (idx >= 6) {
+		bar += 3;
+		offset += ((idx - 6) * board->uart_offset);
+	}
+
+	return setup_port(priv, port, bar, offset, board->reg_shift);
+}
+
+/*
  * AFAVLAB uses a different mixture of BARs and offsets
  * Not that ugly ;) -- HW
  */
@@ -752,6 +778,16 @@ pci_default_setup(struct serial_private 
  */
 static struct pci_serial_quirk pci_serial_quirks[] = {
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA_OLD,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_apci7800_setup,
+	},
+	/*
 	 * AFAVLAB cards - these may be called via parport_serial
 	 *  It is not clear whether this applies to all products.
 	 */
@@ -1036,6 +1072,7 @@ enum pci_board_num_t {
 	pbn_b0_2_115200,
 	pbn_b0_4_115200,
 	pbn_b0_5_115200,
+	pbn_b0_8_115200,
 
 	pbn_b0_1_921600,
 	pbn_b0_2_921600,
@@ -1172,6 +1209,12 @@ static struct pciserial_board pci_boards
 		.base_baud	= 115200,
 		.uart_offset	= 8,
 	},
+	[pbn_b0_8_115200] = {
+		.flags       = FL_BASE0,
+		.num_ports   = 8,
+		.base_baud   = 115200,
+		.uart_offset = 8,
+	},
 
 	[pbn_b0_1_921600] = {
 		.flags		= FL_BASE0,
@@ -2574,6 +2617,97 @@ static struct pci_device_id serial_pci_t
 		pbn_pasemi_1682M },
 
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA_OLD,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b1_8_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_8_115200 },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */


ADDI-DATA GmbH - Dieselstraße 3 - 77833 Ottersweier (Germany)
Amtsgericht Mannheim HRB210433
Geschäftsführer Antonio Agnetti, René Ohlmann 
UST-ID-Nr.: DE 143754253 WEEE-Reg.-Nr. DE 65862200

This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. If you have received this email in error please notify the system manager.
This footnote confirms that this email message has been scanned for the presence of computer viruses.

