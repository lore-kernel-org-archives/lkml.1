Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCZMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCZMQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZCZMQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:16:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49313 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZCZMQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:16:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH 1/2] PCI PM: Introduce __pci_[start|complete]_power_transition()
Date: Thu, 26 Mar 2009 13:15:52 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903250138.53234.linux-pci-owner@vger.kernel.org> <200903250141.08478.rjw@sisk.pl>
In-Reply-To: <200903250141.08478.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903261315.52699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The radeonfb driver needs to program the device's PMCSR directly due
> to some quirky hardware it has to handle (see
> http://bugzilla.kernel.org/show_bug.cgi?id=12846 for details) and
> after doing that it needs to call the platform (usually ACPI) to
> finish the power transition of the device.  Currently it uses
> pci_set_power_state() for this purpose, however making a specific
> assumption about the internal behavior of this function, which has
> changed recently so that this assumption is no longer satisfied.
> For this reason, introduce __pci_complete_power_transition() that may
> be called by the radeonfb driver to complete the power transition of
> the device.  For symmetry, introduce __pci_start_power_transition().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Sorry, with this version of the patch the following failure scenarion is
possible:
* a caller of pci_set_power_state() wants to put a device into D3
* pci_raw_set_power_state() fails and returns error code
* device is not power manageable by the platform, so
  __pci_complete_power_transition() returns 0
* pci_set_power_state() returns 0, although it should return the error code
  from pci_raw_set_power_state().

Also, if the device doesn't support the native PM and is not power manageable
by the platform, we should always fall back to D0.

The updated patch below has these problems fixed.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI PM: Introduce __pci_[start|complete]_power_transition() (rev. 2)

The radeonfb driver needs to program the device's PMCSR directly due
to some quirky hardware it has to handle (see
http://bugzilla.kernel.org/show_bug.cgi?id=12846 for details) and
after doing that it needs to call the platform (usually ACPI) to
finish the power transition of the device.  Currently it uses
pci_set_power_state() for this purpose, however making a specific
assumption about the internal behavior of this function, which has
changed recently so that this assumption is no longer satisfied.
For this reason, introduce __pci_complete_power_transition() that may
be called by the radeonfb driver to complete the power transition of
the device.  For symmetry, introduce __pci_start_power_transition().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c   |   69 ++++++++++++++++++++++++++++++++++++++--------------
 include/linux/pci.h |    1 
 2 files changed, 52 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -540,6 +540,53 @@ void pci_update_current_state(struct pci
 }
 
 /**
+ * pci_platform_power_transition - Use platform to change device power state
+ * @dev: PCI device to handle.
+ * @state: State to put the device into.
+ */
+static int pci_platform_power_transition(
+	struct pci_dev *dev, pci_power_t state)
+{
+	int error;
+
+	if (platform_pci_power_manageable(dev)) {
+		error = platform_pci_set_power_state(dev, state);
+		if (!error)
+			pci_update_current_state(dev, state);
+	} else {
+		error = -ENODEV;
+		pci_update_current_state(dev, PCI_D0);
+	}
+
+	return error;
+}
+
+/**
+ * __pci_start_power_transition - Start power transition of a PCI device
+ * @dev: PCI device to handle.
+ * @state: State to put the device into.
+ */
+static void __pci_start_power_transition(struct pci_dev *dev, pci_power_t state)
+{
+	if (state == PCI_D0)
+		pci_platform_power_transition(dev, PCI_D0);
+}
+
+/**
+ * __pci_complete_power_transition - Complete power transition of a PCI device
+ * @dev: PCI device to handle.
+ * @state: State to put the device into.
+ *
+ * This function should not be called directly by device drivers.
+ */
+int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
+{
+	return state > PCI_D0 ?
+			pci_platform_power_transition(dev, state) : -ENODEV;
+}
+EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
+
+/**
  * pci_set_power_state - Set the power state of a PCI device
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
@@ -575,16 +622,8 @@ int pci_set_power_state(struct pci_dev *
 	if (dev->current_state == state)
 		return 0;
 
-	if (state == PCI_D0) {
-		/*
-		 * Allow the platform to change the state, for example via ACPI
-		 * _PR0, _PS0 and some such, but do not trust it.
-		 */
-		int ret = platform_pci_power_manageable(dev) ?
-			platform_pci_set_power_state(dev, PCI_D0) : 0;
-		if (!ret)
-			pci_update_current_state(dev, PCI_D0);
-	}
+	__pci_start_power_transition(dev, state);
+
 	/* This device is quirked not to be put into D3, so
 	   don't put it in D3 */
 	if (state == PCI_D3hot && (dev->dev_flags & PCI_DEV_FLAGS_NO_D3))
@@ -592,14 +631,8 @@ int pci_set_power_state(struct pci_dev *
 
 	error = pci_raw_set_power_state(dev, state);
 
-	if (state > PCI_D0 && platform_pci_power_manageable(dev)) {
-		/* Allow the platform to finalize the transition */
-		int ret = platform_pci_set_power_state(dev, state);
-		if (!ret) {
-			pci_update_current_state(dev, state);
-			error = 0;
-		}
-	}
+	if (!__pci_complete_power_transition(dev, state))
+		error = 0;
 
 	return error;
 }
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -689,6 +689,7 @@ size_t pci_get_rom_size(struct pci_dev *
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
 int pci_restore_state(struct pci_dev *dev);
+int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state);
 int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
