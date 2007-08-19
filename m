Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbXHSOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbXHSOu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXHSOuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:50:50 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:21670 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbXHSOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:50:49 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pdc202xx_new: fix PCI refcounting
Date: Sun, 19 Aug 2007 18:53:12 +0400
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708191853.12724.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver erroneously "lets go" the mate IDE chip in init_setup_pdc20270()
when ide_setup_pci_devices() call succeeds -- fix this, and drop a couple of
useless assignments in this function while at it...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This patch is against the current Linus' tree, it has only been compile tested
since I do not have PDC2027x chips (and even less so behind DC21150 bridge :-).
I'm reposting the patchset a wider audience now...

 drivers/ide/pci/pdc202xx_new.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/pdc202xx_new.c
+++ linux-2.6/drivers/ide/pci/pdc202xx_new.c
@@ -9,7 +9,7 @@
  *  Split from:
  *  linux/drivers/ide/pdc202xx.c	Version 0.35	Mar. 30, 2002
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
- *  Copyright (C) 2005-2006		MontaVista Software, Inc.
+ *  Copyright (C) 2005-2007		MontaVista Software, Inc.
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
  *  Author: Frank Tiernan (frankt@promise.com)
  *  Released under terms of General Public License
@@ -521,7 +521,7 @@ static int __devinit init_setup_pdcnew(s
 static int __devinit init_setup_pdc20270(struct pci_dev *dev,
 					 ide_pci_device_t *d)
 {
-	struct pci_dev *findev = NULL;
+	struct pci_dev *findev;
 	int ret;
 
 	if ((dev->bus->self &&
@@ -529,7 +529,7 @@ static int __devinit init_setup_pdc20270
 	    (dev->bus->self->device == PCI_DEVICE_ID_DEC_21150)) {
 		if (PCI_SLOT(dev->devfn) & 2)
 			return -ENODEV;
-		d->extra = 0;
+
 		while ((findev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, findev)) != NULL) {
 			if ((findev->vendor == dev->vendor) &&
 			    (findev->device == dev->device) &&
@@ -538,7 +538,8 @@ static int __devinit init_setup_pdc20270
 					findev->irq = dev->irq;
 				}
 				ret = ide_setup_pci_devices(dev, findev, d);
-				pci_dev_put(findev);
+				if (ret < 0)
+					pci_dev_put(findev);
 				return ret;
 			}
 		}

