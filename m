Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZASSja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZASSja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbZASSir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:38:47 -0500
Received: from mail-bw0-f18.google.com ([209.85.218.18]:65275 "EHLO
	mail-bw0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbZASSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=iqSNjNr4lU9zqP/yeRuKz0gY4XSTvqtuGHQIhIwmFuiOvXmUy4FmrhM2vRCwYfDMsT
         FSH8t+rCBkHdBhuY6hrzwDv3Y2kRm00UOdLFfHadjE1jiH8lX4ghyOpX6dbo40BcS6XH
         OIH/cL5ju3cvWXK97QRbPmQSJKq7AQSN+B+7g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ide: remove pciirq argument from ide_pci_setup_ports()
Date: Mon, 19 Jan 2009 19:30:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901191930.33078.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove pciirq argument from ide_pci_setup_ports()

* Set ->irq explicitly in cs5520.c.

* Remove irq argument from ide_hw_configure().

* Remove pciirq argument from ide_pci_setup_ports().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
on top of http://lkml.org/lkml/2009/1/19/163

 drivers/ide/cs5520.c    |    3 ++-
 drivers/ide/setup-pci.c |   13 +++++--------
 include/linux/ide.h     |    2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -133,7 +133,8 @@ static int __devinit cs5520_init_one(str
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
+	hw[0].irq = 14;
 
 	return ide_host_add(d, hws, NULL);
 }
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -305,7 +305,6 @@ static int ide_pci_check_iomem(struct pc
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
- *	@irq: PCI IRQ
  *	@hw: hw_regs_t instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
@@ -316,7 +315,7 @@ static int ide_pci_check_iomem(struct pc
  */
 
 static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
-			    unsigned int port, int irq, hw_regs_t *hw)
+			    unsigned int port, hw_regs_t *hw)
 {
 	unsigned long ctl = 0, base = 0;
 
@@ -344,7 +343,6 @@ static int ide_hw_configure(struct pci_d
 	}
 
 	memset(hw, 0, sizeof(*hw));
-	hw->irq = irq;
 	hw->dev = &dev->dev;
 	hw->chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(hw, base, ctl | 2);
@@ -448,7 +446,6 @@ out:
  *	ide_pci_setup_ports	-	configure ports/devices on PCI IDE
  *	@dev: PCI device
  *	@d: IDE port info
- *	@pciirq: IRQ line
  *	@hw: hw_regs_t instances corresponding to this PCI IDE device
  *	@hws: hw_regs_t pointers table to update
  *
@@ -462,7 +459,7 @@ out:
  */
 
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
-			 int pciirq, hw_regs_t *hw, hw_regs_t **hws)
+			 hw_regs_t *hw, hw_regs_t **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	u8 tmp;
@@ -481,7 +478,7 @@ void ide_pci_setup_ports(struct pci_dev 
 			continue;	/* port not enabled */
 		}
 
-		if (ide_hw_configure(dev, d, port, pciirq, hw + port))
+		if (ide_hw_configure(dev, d, port, hw + port))
 			continue;
 
 		*(hws + port) = hw + port;
@@ -549,7 +546,7 @@ int ide_pci_init_one(struct pci_dev *dev
 	if (ret < 0)
 		goto out;
 
-	ide_pci_setup_ports(dev, d, 0, &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 
 	host = ide_host_alloc(d, hws);
 	if (host == NULL) {
@@ -595,7 +592,7 @@ int ide_pci_init_two(struct pci_dev *dev
 		if (ret < 0)
 			goto out;
 
-		ide_pci_setup_ports(pdev[i], d, 0, &hw[i*2], &hws[i*2]);
+		ide_pci_setup_ports(pdev[i], d, &hw[i*2], &hws[i*2]);
 	}
 
 	host = ide_host_alloc(d, hws);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1263,7 +1263,7 @@ static inline int ide_pci_is_in_compatib
 	return 0;
 }
 
-void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int,
+void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *,
 			 hw_regs_t *, hw_regs_t **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
