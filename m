Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZLaLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZLaLP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 06:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZLaLP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 06:15:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45530 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbZLaLPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 06:15:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / PM: Use per-device D3 delays
Date: Thu, 31 Dec 2009 12:15:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Maciej J. Woloszyk" <mat@esi.com.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912311215.54412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It turns out that some PCI devices require extra delays when changing
power state from D3 to D0 (and the other way around).  Although this
is against the PCI specification, we can handle it quite easily by
allowing drivers to define arbitrary D3 delays for devices known to
require extra time for switching power states.

Introduce additional field d3_delay in struct pci_dev and use it to
store the value of the device's D0->D3 delay, in miliseconds.  Make
the PCI PM core code use the per-device d3_delay unless
pci_pm_d3_delay is greater (in which case the latter is used).
[This also allows the driver to specify d3_delay shorter than the
 10 ms required by the PCI standard if the device is known to be able
 to handle that.]

Make the sky2 driver set d3_delay to 150 for devices handled by it.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14730 which is a
listed regression from 2.6.30.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/sky2.c  |    1 +
 drivers/pci/pci.c   |   19 +++++++++++++++----
 include/linux/pci.h |    1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -244,6 +244,7 @@ struct pci_dev {
 	unsigned int	d2_support:1;	/* Low power state D2 is supported */
 	unsigned int	no_d1d2:1;	/* Only allow D0 and D3 */
 	unsigned int	wakeup_prepared:1;
+	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 
 #ifdef CONFIG_PCIEASPM
 	struct pcie_link_state	*link_state;	/* ASPM link state. */
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -30,7 +30,17 @@ const char *pci_power_names[] = {
 };
 EXPORT_SYMBOL_GPL(pci_power_names);
 
-unsigned int pci_pm_d3_delay = PCI_PM_D3_WAIT;
+unsigned int pci_pm_d3_delay;
+
+static void pci_dev_d3_sleep(struct pci_dev *dev)
+{
+	unsigned int delay = dev->d3_delay;
+
+	if (delay < pci_pm_d3_delay)
+		delay = pci_pm_d3_delay;
+
+	msleep(delay);
+}
 
 #ifdef CONFIG_PCI_DOMAINS
 int pci_domains_supported = 1;
@@ -529,7 +539,7 @@ static int pci_raw_set_power_state(struc
 	/* Mandatory power management transition delays */
 	/* see PCI PM 1.1 5.6.1 table 18 */
 	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
-		msleep(pci_pm_d3_delay);
+		pci_dev_d3_sleep(dev);
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(PCI_PM_D2_DELAY);
 
@@ -1544,6 +1554,7 @@ void pci_pm_init(struct pci_dev *dev)
 	}
 
 	dev->pm_cap = pm;
+	dev->d3_delay = PCI_PM_D3_WAIT;
 
 	dev->d1_support = false;
 	dev->d2_support = false;
@@ -2382,12 +2393,12 @@ static int pci_pm_reset(struct pci_dev *
 	csr &= ~PCI_PM_CTRL_STATE_MASK;
 	csr |= PCI_D3hot;
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
-	msleep(pci_pm_d3_delay);
+	pci_dev_d3_sleep(dev);
 
 	csr &= ~PCI_PM_CTRL_STATE_MASK;
 	csr |= PCI_D0;
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, csr);
-	msleep(pci_pm_d3_delay);
+	pci_dev_d3_sleep(dev);
 
 	return 0;
 }
Index: linux-2.6/drivers/net/sky2.c
===================================================================
--- linux-2.6.orig/drivers/net/sky2.c
+++ linux-2.6/drivers/net/sky2.c
@@ -4684,6 +4684,7 @@ static int __devinit sky2_probe(struct p
 	INIT_WORK(&hw->restart_work, sky2_restart);
 
 	pci_set_drvdata(pdev, hw);
+	pdev->d3_delay = 150;
 
 	return 0;
 
