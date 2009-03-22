Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZCVVOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZCVVOe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbZCVVNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:13:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320AbZCVVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:13:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH 2/2] radeonfb: Avoid open coding of PCI PM operations
Date: Sun, 22 Mar 2009 22:13:13 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903210003.55161.rjw@sisk.pl> <200903222208.22434.rjw@sisk.pl>
In-Reply-To: <200903222208.22434.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222213.14186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The radeonfb driver uses open coded programming of the low power
state D2 into the device, because it has to handle some chips
that don't follow the specification.  Avoid that by making it use
__pci_set_power_state() for this purpose.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/video/aty/radeon_pm.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

Index: linux-2.6/drivers/video/aty/radeon_pm.c
===================================================================
--- linux-2.6.orig/drivers/video/aty/radeon_pm.c
+++ linux-2.6/drivers/video/aty/radeon_pm.c
@@ -2507,25 +2507,6 @@ static void radeon_reinitialize_QW(struc
 
 #endif /* CONFIG_PPC_OF */
 
-static void radeonfb_whack_power_state(struct radeonfb_info *rinfo, pci_power_t state)
-{
-	u16 pwr_cmd;
-
-	for (;;) {
-		pci_read_config_word(rinfo->pdev,
-				     rinfo->pm_reg+PCI_PM_CTRL,
-				     &pwr_cmd);
-		if (pwr_cmd & 2)
-			break;
-		pwr_cmd = (pwr_cmd & ~PCI_PM_CTRL_STATE_MASK) | 2;
-		pci_write_config_word(rinfo->pdev,
-				      rinfo->pm_reg+PCI_PM_CTRL,
-				      pwr_cmd);
-		msleep(500);
-	}
-	rinfo->pdev->current_state = state;
-}
-
 static void radeon_set_suspend(struct radeonfb_info *rinfo, int suspend)
 {
 	u32 tmp;
@@ -2578,11 +2559,10 @@ static void radeon_set_suspend(struct ra
 		pci_disable_device(rinfo->pdev);
 		pci_save_state(rinfo->pdev);
 		/* The chip seems to need us to whack the PM register
-		 * repeatedly until it sticks. We do that -prior- to
-		 * calling pci_set_power_state()
+		 * repeatedly until it sticks.  However, with the 500 ms delay,
+		 * it's better to give up after 10 unsuccessful attempts.
 		 */
-		radeonfb_whack_power_state(rinfo, PCI_D2);
-		pci_set_power_state(rinfo->pdev, PCI_D2);
+		__pci_set_power_state(rinfo->pdev, PCI_D2, 10, 500);
 	} else {
 		printk(KERN_DEBUG "radeonfb (%s): switching to D0 state...\n",
 		       pci_name(rinfo->pdev));
