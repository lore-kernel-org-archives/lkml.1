Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXKCPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXKCPQb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 11:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXKCPQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 11:16:25 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:49509 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbXKCPQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 11:16:24 -0400
Date: Sat, 3 Nov 2007 16:16:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rubini@vision.unipv.it
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/misc: Move misplaced pci_dev_put's.
Message-ID: <Pine.LNX.4.64.0711031615021.7633@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Move pci_dev_put outside the loops in which it occurs.  Within the loop,
pci_dev_put is done implicitly by pci_get_device.

The problem was detected using the following semantic patch, and corrected
by hand.

@@
expression dev;
expression E;
@@

- pci_dev_put(dev)
   ... when != dev = E
- pci_get_device(...,dev)


Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -up a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
--- a/drivers/misc/ioc4.c	2007-06-02 22:32:17.000000000 +0200
+++ b/drivers/misc/ioc4.c	2007-11-03 15:42:48.000000000 +0100
@@ -244,10 +244,11 @@ ioc4_variant(struct ioc4_driver_data *id
  		    idd->idd_pdev->bus->number == pdev->bus->number &&
  		    3 == PCI_SLOT(pdev->devfn))
  			found = 1;
-		pci_dev_put(pdev);
  	} while (pdev && !found);
-	if (NULL != pdev)
+	if (NULL != pdev) {
+	  	pci_dev_put(pdev);
  		return IOC4_VARIANT_IO9;
+	}

  	/* IO10: Look for a Vitesse VSC 7174 at the same bus and slot 3. */
  	pdev = NULL;
@@ -258,10 +259,11 @@ ioc4_variant(struct ioc4_driver_data *id
  		    idd->idd_pdev->bus->number == pdev->bus->number &&
  		    3 == PCI_SLOT(pdev->devfn))
  			found = 1;
-		pci_dev_put(pdev);
  	} while (pdev && !found);
-	if (NULL != pdev)
+	if (NULL != pdev) {
+		pci_dev_put(pdev);
  		return IOC4_VARIANT_IO10;
+	}

  	/* PCI-RT: No SCSI/SATA controller will be present */
  	return IOC4_VARIANT_PCI_RT;
