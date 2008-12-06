Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYLFAGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYLFAGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbYLFAFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:05:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57845 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbYLFAFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:05:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Sat, 6 Dec 2008 01:04:49 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812052301.45450.rjw@sisk.pl> <alpine.LFD.2.00.0812051411400.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812051411400.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812060104.50050.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Well, actually I think we should go further and save the standard config
> > registers of _all_ PCI devices in the _late() callbacks (ie. with interrupts
> > disabled) and restore them in the _early() callbacks.
> 
> That would certainly simplify the code. 
> 
> > I don't really understand why pci_restore_state() is not called by the core
> > and every single driver calls it by itself.
> 
> The idea was to allow PCI drivers to override it if they wanted to.
> 
> That said, the ones that do their own state restore generally do it wrong 
> (eg the USB host controllers doing things in the wrong order and enabling 
> the device before having actually written back the BAR values), so it's 
> arguably broken to let drivers override it.
> 
> > IOW, I would split the resume of PCI devices into two parts, the first of
> > which will call pci_restore_state() with interrupts disabled and the second
> > will do the remaining stuff.
> 
> I would definitely not disagree with that - leave the regular 
> "suspend/resume" callbacks for purely higher-level actions. It would 
> interesting to hear what it does for you.

I tested the appended patch with suspend-to-RAM and it just hangs during
resume.

Next, I'll try to do that only for devices the drivers of which don't define their own
suspend-resume callbacks at all.

Thanks,
Rafael

---
 drivers/pci/pci-driver.c |   50 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -300,6 +300,46 @@ static void pci_device_shutdown(struct d
 
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
 /*
  * Default "suspend" method for devices that have no driver provided suspend,
  * or not even a driver at all.
@@ -346,8 +386,6 @@ static int pci_legacy_suspend(struct dev
 	if (drv && drv->suspend) {
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
-	} else {
-		pci_default_pm_suspend(pci_dev);
 	}
 	return i;
 }
@@ -362,6 +400,9 @@ static int pci_legacy_suspend_late(struc
 		i = drv->suspend_late(pci_dev, state);
 		suspend_report_result(drv->suspend_late, i);
 	}
+
+	pci_default_suspend_noirq(pci_dev);
+
 	return i;
 }
 
@@ -374,7 +415,7 @@ static int pci_legacy_resume(struct devi
 	if (drv && drv->resume)
 		error = drv->resume(pci_dev);
 	else
-		error = pci_default_pm_resume(pci_dev);
+		error = pci_default_resume(pci_dev);
 	return error;
 }
 
@@ -384,8 +425,11 @@ static int pci_legacy_resume_early(struc
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
 
+	pci_default_resume_noirq(pci_dev);
+
 	if (drv && drv->resume_early)
 		error = drv->resume_early(pci_dev);
+
 	return error;
 }
 
