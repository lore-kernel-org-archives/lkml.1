Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZERUx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZERUx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZERUxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:53:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZERUx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:53:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/2] PCI PM: Read device power state from register after updating it
Date: Mon, 18 May 2009 22:52:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200905182246.41129.rjw@sisk.pl>
In-Reply-To: <200905182246.41129.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182252.21478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After attempting to change the power state of a PCI device
pci_raw_set_power_state() doesn't check if the value it wrote into
the device's PCI_PM_CTRL register has been stored in there.  Still,
it modifies the device's current_state field as though that's the
case.  This may cause the driver of the device to think that its
power state has been changed while in fact it hasn't.

To prevent such situations from happening modify
pci_raw_set_power_state() so that it reads the device's PCI_PM_CTRL
register after writing into it and uses the value read from the
register to update the device's current_state field.  Also make it
return -EIO if the new state of the device is not equal to the state
requested by the called.

To distinguish this error condition from the other ones make
pci_raw_set_power_state() return -ENOSYS instead of -EIO when it is
impossible to change the power state of the device, because it
doesn't support the native PCI PM at all or the requested target
state is not supported by it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -446,7 +446,7 @@ static int pci_raw_set_power_state(struc
 		return 0;
 
 	if (!dev->pm_cap)
-		return -EIO;
+		return -ENOSYS;
 
 	if (state < PCI_D0 || state > PCI_D3hot)
 		return -EINVAL;
@@ -465,7 +465,7 @@ static int pci_raw_set_power_state(struc
 	/* check if this device supports the desired state */
 	if ((state == PCI_D1 && !dev->d1_support)
 	   || (state == PCI_D2 && !dev->d2_support))
-		return -EIO;
+		return -ENOSYS;
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 
@@ -502,7 +502,11 @@ static int pci_raw_set_power_state(struc
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(PCI_PM_D2_DELAY);
 
-	dev->current_state = state;
+	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
+	dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
+	/* Return error code if we have failed to change the state */
+	if (dev->current_state != state)
+		return -EIO;
 
 	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
 	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
