Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbZFNTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbZFNTY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbZFNTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:24:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809AbZFNTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:24:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI PM: Fix handling of devices without PM support by pci_target_state()
Date: Sun, 14 Jun 2009 21:25:02 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andreas Mohr <andim2@users.sourceforge.net>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906142125.03418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If a PCI device is not power-manageable either by the platform, or
with the help of the native PCI PM interface, pci_target_state() will
return either PCI_D3hot, or PCI_POWER_ERROR for it, depending on
whether or not the device is configured to wake up the system.  Alas,
none of these return values is correct, because each of them causes
pci_prepare_to_sleep() to return error code, although it should
complete successfully in such a case.

Fix this problem by making pci_target_state() always return PCI_D0
for devices that cannot be power managed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
Hi Jesse,

I think this is 2.6.31 material, probably -stable too.

Best,
Rafael

---
 drivers/pci/pci.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1288,15 +1288,14 @@ pci_power_t pci_target_state(struct pci_
 		default:
 			target_state = state;
 		}
+	} else if (!dev->pm_cap) {
+		target_state = PCI_D0;
 	} else if (device_may_wakeup(&dev->dev)) {
 		/*
 		 * Find the deepest state from which the device can generate
 		 * wake-up events, make it the target state and enable device
 		 * to generate PME#.
 		 */
-		if (!dev->pm_cap)
-			return PCI_POWER_ERROR;
-
 		if (dev->pme_support) {
 			while (target_state
 			      && !(dev->pme_support & (1 << target_state)))
