Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZERUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZERUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZERUx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:53:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZERUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:53:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PCI PM: Follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3
Date: Mon, 18 May 2009 22:51:12 +0200
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
Message-Id: <200905182251.13197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

According to the PCI PM specification (PCI Bus Power Management
Interface Specification, Rev. 1.2, Section 5.4.1) we are supposed to
reinitialize devices that have PCI_PM_CTRL_NO_SOFT_RESET clear during
all transitions from PCI_D3hot to PCI_D0, but we only do it if the
device's current_state field is equal to PCI_UNKNOWN.

This may lead to problems if a device with PCI_PM_CTRL_NO_SOFT_RESET
unset is put into PCI_D3hot at run time by its driver and
pci_set_power_state() is used to put it back into PCI_D0, because in
that case the device will remain uninitialized after
pci_set_power_state() has returned.  Prevent that from happening by
modifying pci_raw_set_power_state() to reinitialize devices with
PCI_PM_CTRL_NO_SOFT_RESET unset during all transitions from D3 to D0.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -480,6 +480,8 @@ static int pci_raw_set_power_state(struc
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= state;
 		break;
+	case PCI_D3hot:
+	case PCI_D3cold:
 	case PCI_UNKNOWN: /* Boot-up */
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
 		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))
