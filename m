Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYLEV1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYLEV1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYLEV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:27:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbYLEV1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:27:33 -0500
Date: Fri, 5 Dec 2008 13:26:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812051312160.3386@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812041229.45443.elendil@planet.nl> <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org> <200812041900.27514.elendil@planet.nl> <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Linus Torvalds wrote:
> 
> The third thing that worries me is the _very_ early occurrence of
> 
> 	ACPI: Waking up from system sleep state S3
> 	APIC error on CPU1: 00(40)
> 	ACPI: EC: non-query interrupt received, switching to interrupt mode
> 
> Now, that "APIC error" thing is worrisome. It's worrisome for multiple 
> reasons:
> 
>  - errors are never good (0x40 means "received illegal vector", whatever 
>    caused _that_)
> 
>  - more importantly, it seems to imply that interrupts are enabled on 
>    CPU1, and they sure as hell shouldn't be enabled at this stage!
> 
>    Do we perhaps have a SMP resume bug where we resume the other CPU's 
>    with interrupts enabled?
> 
>  - the "ACPI: EC: non-query interrupt received, switching to interrupt 
>    mode" thing is from ACPI, and _also_ implies that interrupts are on. 
> 
> Why are interrupts enabled that early? I really don't like seeing 
> interrupts enabled before we've even done the basic PCI resume. 

Oh, I finally started looking more at this.

It's because the PCI layer uses the late resume for resuming. Which is 
horrid. It really shouldn't. Resuming your device after interrupts were 
enabled really sounds like a disaster. *Especially* if the device was 
active before, either because of hibernation or simply because firmware 
pre-initialized it to some "live" state (which could easily happen with 
ethernet in particular).

I do wonder why the PCI layer wants to resume things so late. It sounds 
totally insane to do things like resume the PCI bridge setup long *after* 
you have resumed other devices early. So by doing the default resume late, 
it just means that nobody can possibly use the early resume, and now 
everybody needs to resume everything with interrupts already going full 
blast.

IOW, the _sane_ thing would be to do something like the following patch 
does, namely:

 - if the driver has a suspend or suspend_early function, _only_ call that 
   (whether legacy or not)

 - otherwise, do the default suspend/resume late/early with interrupts 
   disabled.

which means that by default, we'll do all save-restore of the PCI state 
close to the actual CPU suspend event as possible.

Of course, hibernate probably depends on ->suspend() saving state, which 
it won't. Again, if thats' the case, then that's just hibernate (again) 
being totally fundamentally broken, and messing with STR functions. 

Rafael?

I have neither tested the patch nor even tried to compile it - it's meant 
to be an example and get people thinking about this, rather than anything 
else.

		Linus
---
 drivers/pci/pci-driver.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..6395983 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -346,8 +346,6 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 	if (drv && drv->suspend) {
 		i = drv->suspend(pci_dev, state);
 		suspend_report_result(drv->suspend, i);
-	} else {
-		pci_default_pm_suspend(pci_dev);
 	}
 	return i;
 }
@@ -361,7 +359,8 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 	if (drv && drv->suspend_late) {
 		i = drv->suspend_late(pci_dev, state);
 		suspend_report_result(drv->suspend_late, i);
-	}
+	} else if (!drv || !drv->suspend)
+		pci_default_pm_suspend(pci_dev);
 	return i;
 }
 
@@ -373,8 +372,6 @@ static int pci_legacy_resume(struct device *dev)
 
 	if (drv && drv->resume)
 		error = drv->resume(pci_dev);
-	else
-		error = pci_default_pm_resume(pci_dev);
 	return error;
 }
 
@@ -386,6 +383,8 @@ static int pci_legacy_resume_early(struct device *dev)
 
 	if (drv && drv->resume_early)
 		error = drv->resume_early(pci_dev);
+	else if (!drv || !drv->resume)
+		error = pci_default_pm_resume(pci_dev);
 	return error;
 }
 
@@ -420,8 +419,6 @@ static int pci_pm_suspend(struct device *dev)
 		if (drv->pm->suspend) {
 			error = drv->pm->suspend(dev);
 			suspend_report_result(drv->pm->suspend, error);
-		} else {
-			pci_default_pm_suspend(pci_dev);
 		}
 	} else {
 		error = pci_legacy_suspend(dev, PMSG_SUSPEND);
@@ -441,7 +438,8 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		if (drv->pm->suspend_noirq) {
 			error = drv->pm->suspend_noirq(dev);
 			suspend_report_result(drv->pm->suspend_noirq, error);
-		}
+		} else if (!drv->pm->suspend)
+			pci_default_pm_suspend(pci_dev);
 	} else {
 		error = pci_legacy_suspend_late(dev, PMSG_SUSPEND);
 	}
@@ -458,8 +456,7 @@ static int pci_pm_resume(struct device *dev)
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
 	if (drv && drv->pm) {
-		error = drv->pm->resume ? drv->pm->resume(dev) :
-			pci_default_pm_resume(pci_dev);
+		error = drv->pm->resume ? drv->pm->resume(dev) : 0;
 	} else {
 		error = pci_legacy_resume(dev);
 	}
@@ -467,6 +464,7 @@ static int pci_pm_resume(struct device *dev)
 	return error;
 }
 
+
 static int pci_pm_resume_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
@@ -478,6 +476,8 @@ static int pci_pm_resume_noirq(struct device *dev)
 	if (drv && drv->pm) {
 		if (drv->pm->resume_noirq)
 			error = drv->pm->resume_noirq(dev);
+		else if (!drv->pm->resume)
+			error = pci_default_pm_resume(pci_dev);
 	} else {
 		error = pci_legacy_resume_early(dev);
 	}
