Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYLFBTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYLFBTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYLFBS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:18:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbYLFBS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:18:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Sat, 6 Dec 2008 02:18:12 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812060104.50050.rjw@sisk.pl> <alpine.LFD.2.00.0812051647130.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812051647130.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812060218.13030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > I tested the appended patch with suspend-to-RAM and it just hangs during
> > resume.
> 
> That patch looks bogus. It only changes the "legacy" cases as far as I can 
> tell, so anybogy who has drv->pm set will now not do any state save at 
> all.
> 
> Or am I misreading it?

It only affects the legacy handling, but the non-legacy handling was left
untouched.  IOW, the old "default" functions are still there and are being
called by the "non-legacy" code (it's only used by USB at the moment, AFAICS).

Anyway, I did the test doing it only to the devices which don't have any
non-default suspend-resume handling at all and _that_ apparently fixed the
problem on my box. :-)

Appended is a very crude version of the patch (it duplicates some code),
tomorrow I'll post a cleaned-up version.

I'm still thinkig it will be reasonable to save standard config registers for
all devices with interrupts disabled, but that appears to be more complicated
that I thought it would be.

Thanks,
Rafael

---
 drivers/pci/pci-driver.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -300,6 +300,54 @@ static void pci_device_shutdown(struct d
 
 #ifdef CONFIG_PM_SLEEP
 
+static void pci_default_suspend_noirq(struct pci_dev *pci_dev)
+{
+	dev_info(&pci_dev->dev, "saving standard PCI config registers\n");
+
+	/* save the PCI config space */
+	pci_save_state(pci_dev);
+	/*
+	 * mark its power state as "unknown", since we don't know if
+	 * e.g. the BIOS will change its device state when we suspend.
+	 */
+	if (pci_dev->current_state == PCI_D0)
+		pci_dev->current_state = PCI_UNKNOWN;
+}
+
+static void pci_default_resume_noirq(struct pci_dev *pci_dev)
+{
+	dev_info(&pci_dev->dev, "restoring standard PCI config registers\n");
+
+	/* restore the PCI config space */
+	pci_restore_state(pci_dev);
+}
+
+static int pci_default_resume(struct pci_dev *pci_dev)
+{
+	int retval = 0;
+
+	dev_info(&pci_dev->dev, "trying to reenable device\n");
+
+	/* if the device was enabled before suspend, reenable */
+	retval = pci_reenable_device(pci_dev);
+	/*
+	 * if the device was busmaster before the suspend, make it busmaster
+	 * again
+	 */
+	if (pci_dev->is_busmaster)
+		pci_set_master(pci_dev);
+
+	return retval;
+}
+
+static bool pci_has_legacy_pm_handling(struct pci_dev *pci_dev)
+{
+	struct pci_driver *drv = pci_dev->driver;
+
+	return drv && (drv->suspend || drv->suspend_late || drv->resume
+		|| drv->resume_early);
+}
+
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all.
@@ -343,6 +391,9 @@ static int pci_legacy_suspend(struct dev
 	struct pci_driver * drv = pci_dev->driver;
 	int i = 0;
 
+	if (!pci_has_legacy_pm_handling(pci_dev))
+		return 0;
+
 	if (drv && drv->suspend) {
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
@@ -358,10 +409,16 @@ static int pci_legacy_suspend_late(struc
 	struct pci_driver * drv = pci_dev->driver;
 	int i = 0;
 
+	if (!pci_has_legacy_pm_handling(pci_dev)) {
+		pci_default_suspend_noirq(pci_dev);
+		return 0;
+	}
+
 	if (drv && drv->suspend_late) {
 		i = drv->suspend_late(pci_dev, state);
 		suspend_report_result(drv->suspend_late, i);
 	}
+
 	return i;
 }
 
@@ -371,6 +428,9 @@ static int pci_legacy_resume(struct devi
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
+	if (!pci_has_legacy_pm_handling(pci_dev))
+		return pci_default_resume(pci_dev);
+
 	if (drv && drv->resume)
 		error = drv->resume(pci_dev);
 	else
@@ -384,8 +444,14 @@ static int pci_legacy_resume_early(struc
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
+	if (!pci_has_legacy_pm_handling(pci_dev)) {
+		pci_default_resume_noirq(pci_dev);
+		return 0;
+	}
+
 	if (drv && drv->resume_early)
 		error = drv->resume_early(pci_dev);
+
 	return error;
 }
 
