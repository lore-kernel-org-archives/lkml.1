Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZBDBUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZBDBUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZBDBTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:19:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42189 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZBDBTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:19:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/7] PCI PM: Fix saving of device state in pci_legacy_suspend
Date: Wed, 4 Feb 2009 01:59:09 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl>
In-Reply-To: <200902040154.36018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040159.10258.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make pci_legacy_suspend() save the state of the device if it is
in PCI_UNKNOWN after its suspend callback has run and warn only if
the power state of the device has been changed by its suspend
callback.

Also, use WARN_ONCE(), which is more useful, in pci_legacy_suspend(),
so that the name of the offending function is printed.

Additionaly, remove the unnecessary line of code setting
pci_dev->state_saved.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/pci/pci-driver.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -355,6 +355,8 @@ static int pci_legacy_suspend(struct dev
 	int i = 0;
 
 	if (drv && drv->suspend) {
+		pci_power_t prev = pci_dev->current_state;
+
 		pci_dev->state_saved = false;
 
 		i = drv->suspend(pci_dev, state);
@@ -365,12 +367,16 @@ static int pci_legacy_suspend(struct dev
 		if (pci_dev->state_saved)
 			goto Fixup;
 
-		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
+		if (pci_dev->current_state != PCI_D0
+		    && pci_dev->current_state != PCI_UNKNOWN) {
+			WARN_ONCE(pci_dev->current_state != prev,
+				"PCI PM: Device state not saved by %pF\n",
+				drv->suspend);
 			goto Fixup;
+		}
 	}
 
 	pci_save_state(pci_dev);
-	pci_dev->state_saved = true;
 	/*
 	 * This is for compatibility with existing code with legacy PM support.
 	 */

