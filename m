Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZCJJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZCJJdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZCJJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:33:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbZCJJdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:33:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gaudenz Steinlin <gaudenz@soziologie.ch>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms" breaks resume from RAM on PowerBook
Date: Tue, 10 Mar 2009 10:32:58 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20090304083859.GB6889@soziologie.ch> <20090306114149.GA5371@soziologie.ch> <1236638264.7260.192.camel@pasglop>
In-Reply-To: <1236638264.7260.192.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903101032.58617.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 March 2009, Benjamin Herrenschmidt wrote:
> On Fri, 2009-03-06 at 12:41 +0100, Gaudenz Steinlin wrote:
> 
> > > Another thing you can try in radeonfb_pci_resume():
> > > 
> > >         if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
> > > +		pci_restore_state(pdev);
> > 
> > Adding this fixes the bug. Apparently the PCI core does not fully
> > restore the state. Before your suggestions I also tried to find out
> > which part of your commit breaks resume and I found out that if I
> > reinsert the parts to save and restore the pci configuration the bug is
> > fixed. It seems that somehow the PCI coniguration is not fully restored [1].  
> 
> Ok so this doesn't make sense to me at this stage... I see two
> possibilities:
> 
>  1- You haven't properly done the test disabling the early resume hack
> (ie, you may have done it with also CPU_FREQ disabled for example) and
> got a false negative there. The platform code calls into the early
> resume stuff before the PCI core gets a chance to restore things so that
> would be an explanation. I'll send a patch fixing that.
> 
> or
> 
>  2- For some reason, the core call to pci_raw_set_power_state() from
> pci_restore_standard_config() is returning an error. That would cause
> the later not to restore the rest of the config.
> 
> So what I suggest is that while keeping your added pci_restore_state()
> in there, you also add some printk's in pci_restore_standard_config() to
> see anything weird happens in there or if it appears to properly call
> pci_restore_state(). It would be useful for us to know.

Gaudenz, I'd also like to know if the appended patch (on top of vanilla Linus'
tree) makes any different.  Unfortunately, I haven't had the time to test it
myself yet.

Thanks,
Rafael

---
 drivers/pci/pci-driver.c |   42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -556,7 +556,7 @@ static int pci_pm_suspend_noirq(struct d
 static int pci_pm_resume_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	pci_pm_default_resume_noirq(pci_dev);
@@ -564,8 +564,13 @@ static int pci_pm_resume_noirq(struct de
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
-	if (drv && drv->pm && drv->pm->resume_noirq)
-		error = drv->pm->resume_noirq(dev);
+	if (pm) {
+		if (pm->resume_noirq)
+			error = pm->resume_noirq(dev);
+	} else {
+		if (pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
+	}
 
 	return error;
 }
@@ -592,7 +597,8 @@ static int pci_pm_resume(struct device *
 		if (pm->resume)
 			error = pm->resume(dev);
 	} else {
-		pci_pm_reenable_device(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
 	}
 
 	return 0;
@@ -662,7 +668,7 @@ static int pci_pm_freeze_noirq(struct de
 static int pci_pm_thaw_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
@@ -670,8 +676,13 @@ static int pci_pm_thaw_noirq(struct devi
 
 	pci_update_current_state(pci_dev, PCI_D0);
 
-	if (drv && drv->pm && drv->pm->thaw_noirq)
-		error = drv->pm->thaw_noirq(dev);
+	if (pm) {
+		if (pm->thaw_noirq)
+			error = pm->thaw_noirq(dev);
+	} else {
+		if (pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
+	}
 
 	return error;
 }
@@ -689,7 +700,8 @@ static int pci_pm_thaw(struct device *de
 		if (pm->thaw)
 			error = pm->thaw(dev);
 	} else {
-		pci_pm_reenable_device(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
 	}
 
 	return error;
@@ -744,7 +756,7 @@ static int pci_pm_poweroff_noirq(struct 
 static int pci_pm_restore_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	struct device_driver *drv = dev->driver;
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int error = 0;
 
 	pci_pm_default_resume_noirq(pci_dev);
@@ -752,8 +764,13 @@ static int pci_pm_restore_noirq(struct d
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
 
-	if (drv && drv->pm && drv->pm->restore_noirq)
-		error = drv->pm->restore_noirq(dev);
+	if (pm) {
+		if (pm->restore_noirq)
+			error = pm->restore_noirq(dev);
+	} else {
+		if (pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
+	}
 
 	return error;
 }
@@ -780,7 +797,8 @@ static int pci_pm_restore(struct device 
 		if (pm->restore)
 			error = pm->restore(dev);
 	} else {
-		pci_pm_reenable_device(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_pm_reenable_device(pci_dev);
 	}
 
 	return error;
