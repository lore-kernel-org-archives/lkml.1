Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0CIO3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:29:11 -0500
Received: from centrinvest.ru ([94.25.115.130]:40664 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab0CIO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:29:06 -0500
X-Greylist: delayed 789 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 09:29:05 EST
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Tue, 9 Mar 2010 17:15:52 +0300
To: James Lamanna <jlamanna@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: SIIG DP CyberSerial 4S PCIe Support
Message-ID: <20100309141552.GD30538@centrinvest.ru>
Mail-Followup-To: James Lamanna <jlamanna@gmail.com>,
	Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <aa4c40ff1003081107n78e9f052n2a754680e5491c68@mail.gmail.com>
 <aa4c40ff1003081313s7492513bk14a48c6097b90407@mail.gmail.com>
 <4B95B028.3050106@gmail.com>
 <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <aa4c40ff1003082115x3e9e1492je90e5afb826b3408@mail.gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 067, 03 08, 2010 at 09:15:26PM -0800, James Lamanna wrote:

> That's probably the case.
> It looks like 8250 doesn't know about this PCIe device at all.
> The Oxford PCI ID is not in pci_ids.h nor is the SIIG subsystem ID.
> I'll see if I can maybe work up a patch to support this device, since I've found
> the datasheet for the Oxford 4 port UART controller, but I may need some help.
> Or if anyone else (who has more experience with this) wants to formulate one,
> it would be greatly appreciated.

Looks like you card can use existing code for Oxford Semiconductor UARTs.
Can you test the attached patch for 2.6.33 ?

--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-siig-pcie
Content-Transfer-Encoding: quoted-printable

diff -urdpX dontdiff linux-2.6.33.vanilla/drivers/serial/8250_pci.c linux-2=
=2E6.33/drivers/serial/8250_pci.c
--- linux-2.6.33.vanilla/drivers/serial/8250_pci.c	2010-03-09 16:19:55.0000=
00000 +0300
+++ linux-2.6.33/drivers/serial/8250_pci.c	2010-03-09 16:26:02.000000000 +0=
300
@@ -431,6 +431,38 @@ static void __devexit sbs_exit(struct pc
 }
=20
 /*
+ * Oxford Semiconductor Inc.
+ * Check that device is part of the Tornado range of devices, then determi=
ne
+ * the number of ports available on the device.
+ */
+static int pci_oxsemi_tornado_init(struct pci_dev *dev)
+{
+	u8 __iomem *p;
+	unsigned long deviceID;
+	unsigned int  number_uarts =3D 0;
+
+	/* OxSemi Tornado devices are all 0xCxxx */
+	if (dev->vendor =3D=3D PCI_VENDOR_ID_OXSEMI &&
+	    (dev->device & 0xF000) !=3D 0xC000)
+		return 0;
+
+	p =3D pci_iomap(dev, 0, 5);
+	if (p =3D=3D NULL)
+		return -ENOMEM;
+
+	deviceID =3D ioread32(p);
+	/* Tornado device */
+	if (deviceID =3D=3D 0x07000200) {
+		number_uarts =3D ioread8(p + 4);
+		printk(KERN_DEBUG
+			"%d ports detected on Oxford PCI Express device\n",
+								number_uarts);
+	}
+	pci_iounmap(dev, p);
+	return number_uarts;
+}
+
+/*
  * SIIG serial cards have an PCI interface chip which also controls
  * the UART clocking frequency. Each UART can be clocked independently
  * (except cards equiped with 4 UARTs) and initial clocking settings
@@ -515,6 +547,8 @@ static int pci_siig_init(struct pci_dev=20
 		return pci_siig10x_init(dev);
 	else if (type =3D=3D 0x2000)
 		return pci_siig20x_init(dev);
+	else if ((type & 0xf000) =3D=3D 0xc000)
+		return pci_oxsemi_tornado_init(dev);
=20
 	moan_device("Unknown SIIG card", dev);
 	return -ENODEV;
@@ -902,38 +936,6 @@ static void __devexit pci_ite887x_exit(s
 	release_region(ioport, ITE_887x_IOSIZE);
 }
=20
-/*
- * Oxford Semiconductor Inc.
- * Check that device is part of the Tornado range of devices, then determi=
ne
- * the number of ports available on the device.
- */
-static int pci_oxsemi_tornado_init(struct pci_dev *dev)
-{
-	u8 __iomem *p;
-	unsigned long deviceID;
-	unsigned int  number_uarts =3D 0;
-
-	/* OxSemi Tornado devices are all 0xCxxx */
-	if (dev->vendor =3D=3D PCI_VENDOR_ID_OXSEMI &&
-	    (dev->device & 0xF000) !=3D 0xC000)
-		return 0;
-
-	p =3D pci_iomap(dev, 0, 5);
-	if (p =3D=3D NULL)
-		return -ENOMEM;
-
-	deviceID =3D ioread32(p);
-	/* Tornado device */
-	if (deviceID =3D=3D 0x07000200) {
-		number_uarts =3D ioread8(p + 4);
-		printk(KERN_DEBUG
-			"%d ports detected on Oxford PCI Express device\n",
-								number_uarts);
-	}
-	pci_iounmap(dev, p);
-	return number_uarts;
-}
-
 static int
 pci_default_setup(struct serial_private *priv,
 		  const struct pciserial_board *board,
@@ -2984,6 +2986,13 @@ static struct pci_device_id serial_pci_t
 		PCI_VENDOR_ID_MAINPINE, 0x4008, 0, 0,
 		pbn_oxsemi_8_4000000 },
 	/*
+	 * SIIG cards utilizing OxSemi Tornado
+	 */
+	{	PCI_VENDOR_ID_SIIG, 0xc208,	/* SIIG DP CyberSerial 4S PCIe */
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_oxsemi_4_4000000 },
+
+	/*
 	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
 	 * from skokodyn@yahoo.com
 	 */

--w7PDEPdKQumQfZlR--
