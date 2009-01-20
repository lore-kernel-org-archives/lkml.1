Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbZATWCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbZATWCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZATWBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:01:51 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:4586 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173AbZATWBu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:01:50 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] PCI PM: Consistently use variable name "error" for pm call return values
Date: Tue, 20 Jan 2009 23:01:44 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, yakui.zhao@intel.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org
References: <1232413680.3971.32.camel@yakui_zhao.sh.intel.com> <20090120074534.GE16426@elte.hu> <20090120074534.GE16426@elte.hu> <200901202132.04682.rjw@sisk.pl>
In-reply-To: <200901202132.04682.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901202301.46198.elendil@planet.nl>
X-OriginalArrivalTime: 20 Jan 2009 22:01:46.0767 (UTC) FILETIME=[B004C9F0:01C97B4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

PCI PM: Consistently use variable name "error" for pm call return values
    
Signed-off-by: Frans Pop <elendil@planet.nl>
---
While looking at your patch

> Subject: PCI PM: Restore standard config registers of all devices early
>
> There is a problem in our handling of suspend-resume of PCI devices
> that many of them have their standard config registers restored with
> interrupts enabled and they are put into the full power state with
> interrupts enabled as well.  This may lead to the following scenario:
> [...]

I noticed two functions use a variable "i" to store the return value of PM
function calls while the rest of the file uses "error". As "i" normally
indicates a counter of some sort it seems better to keep this consistent.

I have no objection if you prefer to fold this patch into yours.
Compile tested.

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 9de07b7..6976669 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -352,15 +352,15 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
+	int error = 0;
 
 	if (drv && drv->suspend) {
 		pci_dev->state_saved = false;
 
-		i = drv->suspend(pci_dev, state);
-		suspend_report_result(drv->suspend, i);
-		if (i)
-			return i;
+		error = drv->suspend(pci_dev, state);
+		suspend_report_result(drv->suspend, error);
+		if (error)
+			return error;
 
 		if (pci_dev->state_saved)
 			goto Fixup;
@@ -378,20 +378,20 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
  Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
-	return i;
+	return error;
 }
 
 static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
+	int error = 0;
 
 	if (drv && drv->suspend_late) {
-		i = drv->suspend_late(pci_dev, state);
-		suspend_report_result(drv->suspend_late, i);
+		error = drv->suspend_late(pci_dev, state);
+		suspend_report_result(drv->suspend_late, error);
 	}
-	return i;
+	return error;
 }
 
 static int pci_legacy_resume_early(struct device *dev)
