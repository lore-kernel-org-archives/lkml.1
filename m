Return-Path: <linux-kernel-owner+w=401wt.eu-S1764060AbZGABN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764060AbZGABN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761581AbZGAAfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:45 -0400
Received: from kroah.org ([198.145.64.141]:60656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760665AbZGAAfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:40 2009
Message-Id: <20090701002440.703390309@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 090/108] PCI PM: Fix handling of devices without PM support by pci_target_state()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=pci-pm-fix-handling-of-devices-without-pm-support-by-pci_target_state.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit d2abdf62882d982c58e7a6b09ecdcfcc28075e2e upstream.

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
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1282,15 +1282,14 @@ pci_power_t pci_target_state(struct pci_
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


