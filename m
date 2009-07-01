Return-Path: <linux-kernel-owner+w=401wt.eu-S1764504AbZGABNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764504AbZGABNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbZGAAfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:46 -0400
Received: from kroah.org ([198.145.64.141]:60667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761566AbZGAAfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:41 2009
Message-Id: <20090701002440.895036580@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 091/108] PCI PM: Follow PCI_PM_CTRL_NO_SOFT_RESET during transitions from D3
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=pci-pm-follow-pci_pm_ctrl_no_soft_reset-during-transitions-from-d3.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit f62795f1e892ca9269849fa83de97621da7e02c0 upstream.

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
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -480,6 +480,8 @@ static int pci_raw_set_power_state(struc
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= state;
 		break;
+	case PCI_D3hot:
+	case PCI_D3cold:
 	case PCI_UNKNOWN: /* Boot-up */
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) == PCI_D3hot
 		 && !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET))


