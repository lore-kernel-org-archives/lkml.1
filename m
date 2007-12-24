Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbXLXSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbXLXSf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 13:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXLXSfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 13:35:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbXLXSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 13:35:16 -0500
Date: Mon, 24 Dec 2007 10:34:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-Reply-To: <200712241444.24031.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0712241008150.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712231703390.21557@woody.linux-foundation.org> <200712240305.18080.carlos@strangeworlds.co.uk> <200712241444.24031.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Dec 2007, Rafael J. Wysocki wrote:
> 
> Well, having considered that for a longer while, I think the AML code is
> referring to a device that we have suspended already, and since it's in a low
> power state, it just can't handle the reference.
> 
> If that is the case, we'll have to find the device (that should be possible
> using some code instrumentation) and move the suspending of it into the late
> stage.

Yes. 

In general, I'm personally of the opinion that drivers should *not* 
actually go into D3 at all in the regular "->suspend()" phase. It should 
be done in ->suspend_late. The early suspend is for saving state and 
returning errors.

Sadly, we've made it a bit too inconvenient to actually do that. Almost 
all drivers only do the "->suspend" thing, and the default PCI behaviour 
doesn't help us in any way either.

Anyway, I wonder if a patch like this could make it easier for driver 
writers to handle things. It basically does:

 - if you don't have a regular "suspend()" function, we'll just save state 
   at suspend time.

 - if you don't have a "suspend_late()" function, we'll look at the 
   current state, and if it's still in PCI_D0, we'll suspend to PCI_D3hot 
   if it's a regular PCI device (ie not a bridge or something else odd).

 - then, at resume time, by default we don't do anything in the early 
   resume, but in the late resume we'll undo everything, of course.

Anyway, with this, most drivers could just remove the 
"pci_set_power_state()" call *entirely*, and let the default 
suspend_late action power the device down. But if you want to override 
that default action, you can either:

 - set the power state in your own ->suspend() routine (either by using 
   pci_set_power_state(), or by just explicitly setting the state to 
   unknown with "dev->current_state =  PCI_UNKNOWN"

 - have a "late_suspend()" action, which obviously will override the 
   default action entirely.

Hmm?

In the case of the NVidia issue, one thing to try migh be to remove the 
current call to "pci_set_power_state(pdev, 3);" in agp_nvidia_suspend() in 
drivers/char/agp/nvidia-agp.c. That sounds like the most likely culprit 
for something that ACPI might want to shut down.

NOTE! This following patch is just for discussion, and while I think it's 
conceptually a good thing to try, I don't think it will help Carlos' 
problem. But removing the "pci_set_power_state()" in agp_nvidia_suspend() 
might.

			Linus

---
 drivers/pci/pci-driver.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 6d1a216..6992f73 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -264,6 +264,28 @@ static int pci_device_remove(struct device * dev)
 	return 0;
 }
 
+static void pci_default_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	pci_save_state(dev);
+}
+
+static void pci_default_suspend_late(struct pci_dev *dev, pm_message_t state)
+{
+	/* Something has already suspended it? Never mind then.. */
+	if (dev->current_state != PCI_D0)
+		return;
+
+	/* We avoid powering down bridges by default.. */
+	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL)
+		pci_set_power_state(dev, PCI_D3hot);
+
+	/*
+	 * mark its power state as "unknown", since we don't know if
+	 * e.g. the BIOS will change its device state when we suspend.
+	 */
+	dev->current_state = PCI_UNKNOWN;
+}
+
 static int pci_device_suspend(struct device * dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -274,13 +296,7 @@ static int pci_device_suspend(struct device * dev, pm_message_t state)
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
 	} else {
-		pci_save_state(pci_dev);
-		/*
-		 * mark its power state as "unknown", since we don't know if
-		 * e.g. the BIOS will change its device state when we suspend.
-		 */
-		if (pci_dev->current_state == PCI_D0)
-			pci_dev->current_state = PCI_UNKNOWN;
+		pci_default_suspend(pci_dev, state);
 	}
 	return i;
 }
@@ -294,6 +310,8 @@ static int pci_device_suspend_late(struct device * dev, pm_message_t state)
 	if (drv && drv->suspend_late) {
 		i = drv->suspend_late(pci_dev, state);
 		suspend_report_result(drv->suspend_late, i);
+	} else {
+		pci_default_suspend_late(pci_dev, state);
 	}
 	return i;
 }
