Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbYKYInY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbYKYInY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYKYInP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:43:15 -0500
Received: from usul.saidi.cx ([204.11.33.34]:45091 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751836AbYKYInP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:43:15 -0500
Message-ID: <492BBA91.5010302@overt.org>
Date: Tue, 25 Nov 2008 00:42:57 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>, sdhci-devel@list.drzeus.cx,
       Pierre Ossman <drzeus@drzeus.cx>
CC: Frank Seidel <fseidel@suse.de>, Mathias Weyland <weyland@library.ethz.ch>
Subject: [PATCH] ricoh_mmc: Handle newer models of Ricoh controllers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest generation of laptops are shipping with a newer
model of Ricoh chip where the firewire controller is the
primary PCI function but a cardbus controller is also present.

The existing code assumes that if a cardbus controller is,
present, then it must be the one to manipulate - but the real
rule is that you manipulate PCI function 0. This patch adds an
additional constraint that the target must be function 0.

Signed-off-by: Philip Langdale <philipl@overt.org>
---

  ricoh_mmc.c |   17 +++++++++++------
  1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/ricoh_mmc.c b/drivers/mmc/host/ricoh_mmc.c
index a16d760..be9e7b3 100644
--- a/drivers/mmc/host/ricoh_mmc.c
+++ b/drivers/mmc/host/ricoh_mmc.c
@@ -11,9 +11,10 @@

  /*
   * This is a conceptually ridiculous driver, but it is required by the way
- * the Ricoh multi-function R5C832 works. This chip implements firewire
- * and four different memory card controllers. Two of those controllers are
- * an SDHCI controller and a proprietary MMC controller. The linux SDHCI
+ * the Ricoh multi-function chips (R5CXXX) work. These chips implement
+ * the four main memory card controllers (SD, MMC, MS, xD) and one or both
+ * of cardbus or firewire. It happens that they implement SD and MMC
+ * support as separate controllers (and PCI functions). The linux SDHCI
   * driver supports MMC cards but the chip detects MMC cards in hardware
   * and directs them to the MMC controller - so the SDHCI driver never sees
   * them. To get around this, we must disable the useless MMC controller.
@@ -21,8 +22,10 @@
   * a detection event occurs immediately, even if the MMC card is already
   * in the reader.
   *
- * The relevant registers live on the firewire function, so this is unavoidably
- * ugly. Such is life.
+ * It seems to be the case that the relevant PCI registers to deactivate the
+ * MMC controller live on PCI function 0, which might be the cardbus controller
+ * or the firewire controller, depending on the particular chip in question. As
+ * such, it makes what this driver has to do unavoidably ugly. Such is life.
   */

  #include <linux/pci.h>
@@ -143,6 +146,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
  		pci_get_device(PCI_VENDOR_ID_RICOH,
  			PCI_DEVICE_ID_RICOH_RL5C476, fw_dev))) {
  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
+		    PCI_FUNC(fw_dev->devfn) == 0 &&
  		    pdev->bus == fw_dev->bus) {
  			if (ricoh_mmc_disable(fw_dev) != 0)
  				return -ENODEV;
@@ -160,6 +164,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,
  	    (fw_dev = pci_get_device(PCI_VENDOR_ID_RICOH,
  					PCI_DEVICE_ID_RICOH_R5C832, fw_dev))) {
  		if (PCI_SLOT(pdev->devfn) == PCI_SLOT(fw_dev->devfn) &&
+		    PCI_FUNC(fw_dev->devfn) == 0 &&
  		    pdev->bus == fw_dev->bus) {
  			if (ricoh_mmc_disable(fw_dev) != 0)
  				return -ENODEV;
@@ -172,7 +177,7 @@ static int __devinit ricoh_mmc_probe(struct pci_dev *pdev,

  	if (!ctrlfound) {
  		printk(KERN_WARNING DRIVER_NAME
-		       ": Main firewire function not found. Cannot disable controller.\n");
+		       ": Main Ricoh function not found. Cannot disable controller.\n");
  		return -ENODEV;
  	}


