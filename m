Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZCNLic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZCNLic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZCNLf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:35:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40250 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbZCNLfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 10/11] PCI PM: Make pci_set_power_state() handle devices with no PM support
Date: Sat, 14 Mar 2009 12:33:55 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141233.56694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is a problem with PCI devices without any PM support (either
native or through the platform) that pci_set_power_state() always
returns error code for them, even if they are being put into D0.
However, such devices are always in D0, so pci_set_power_state()
should return success when attempting to put such a device into D0.
It also should update the current_state field for these devices as
appropriate.  This modification is necessary so that the standard
configuration registers of these devices are successfully restored by
pci_restore_standard_config() during the "early" phase of resume.

In addition, pci_set_power_state() should check the value of
current_state before calling the platform to change the power state
of the device to avoid doing that unnecessarily.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -439,6 +439,10 @@ static int pci_raw_set_power_state(struc
 	u16 pmcsr;
 	bool need_restore = false;
 
+	/* Check if we're already there */
+	if (dev->current_state == state)
+		return 0;
+
 	if (!dev->pm_cap)
 		return -EIO;
 
@@ -449,10 +453,7 @@ static int pci_raw_set_power_state(struc
 	 * Can enter D0 from any state, but if we can only go deeper 
 	 * to sleep if we're already in a low power state
 	 */
-	if (dev->current_state == state) {
-		/* we're already there */
-		return 0;
-	} else if (state != PCI_D0 && dev->current_state <= PCI_D3cold
+	if (state != PCI_D0 && dev->current_state <= PCI_D3cold
 	    && dev->current_state > state) {
 		dev_err(&dev->dev, "invalid power transition "
 			"(from state %d to %d)\n", dev->current_state, state);
@@ -570,12 +571,17 @@ int pci_set_power_state(struct pci_dev *
 		 */
 		return 0;
 
-	if (state == PCI_D0 && platform_pci_power_manageable(dev)) {
+	/* Check if we're already there */
+	if (dev->current_state == state)
+		return 0;
+
+	if (state == PCI_D0) {
 		/*
 		 * Allow the platform to change the state, for example via ACPI
 		 * _PR0, _PS0 and some such, but do not trust it.
 		 */
-		int ret = platform_pci_set_power_state(dev, PCI_D0);
+		int ret = platform_pci_power_manageable(dev) ?
+			platform_pci_set_power_state(dev, PCI_D0) : 0;
 		if (!ret)
 			pci_update_current_state(dev, PCI_D0);
 	}
