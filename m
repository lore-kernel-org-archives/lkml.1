Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZIUVgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZIUVgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZIUVgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 17:36:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZIUVgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 17:36:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Read device power state from register after updating it (rev. 2)
Date: Mon, 21 Sep 2009 23:37:01 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909212337.01812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After attempting to change the power state of a PCI device
pci_raw_set_power_state() doesn't check if the value it wrote into
the device's PCI_PM_CTRL register has been stored in there, but
unconditionally modifies the device's current_state field to reflect
the change.  This may cause problems to happen if the power state of
the device hasn't been changed in fact, because it will make the PCI
PM core think that the device is in a power state it really is not
in.

To prevent such situations from happening modify
pci_raw_set_power_state() so that it reads the device's PCI_PM_CTRL
register after writing into it and uses the value read from the
register to update the device's current_state field.  Also make it
print a message saying that the device refused to change its power
state as requested (returning an error code in such cases would cause
suspend regressions to appear on some systems, where device drivers'
suspend routines return error codes if pci_set_power_state() fails).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -513,7 +513,12 @@ static int pci_raw_set_power_state(struc
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(PCI_PM_D2_DELAY);
 
-	dev->current_state = state;
+	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
+	dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
+	/* Return error code if we have failed to change the state */
+	if (dev->current_state != state)
+		dev_info(&dev->dev, "Refused to change power state, "
+			"currently in D%d\n", dev->current_state);
 
 	/* According to section 5.4.1 of the "PCI BUS POWER MANAGEMENT
 	 * INTERFACE SPECIFICATION, REV. 1.2", a device transitioning
