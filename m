Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZBAVkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZBAVkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 16:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZBAVjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 16:39:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZBAVjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/3] PCI PM: Do not disable and enable bridges during suspend-resume
Date: Sun, 1 Feb 2009 22:31:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl>
In-Reply-To: <200902012229.27517.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012231.17933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It is a mistake to disable and enable PCI bridges and PCI Express
ports during suspend-resume (at least at the time when it is
currently done).  Disabling them may lead to problems with accessing
devices behind them and they should be automatically enabled when
their standard config spaces are restored.  Fix this by not attempting
to disable bridges during suspend and enable them during resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -428,16 +428,18 @@ static int pci_pm_default_resume(struct 
 {
 	pci_fixup_device(pci_fixup_resume, pci_dev);
 
-	if (!pci_is_bridge(pci_dev))
-		pci_enable_wake(pci_dev, PCI_D0, false);
+	if (pci_is_bridge(pci_dev))
+		return 0;
 
+	pci_enable_wake(pci_dev, PCI_D0, false);
 	return pci_pm_reenable_device(pci_dev);
 }
 
 static void pci_pm_default_suspend_generic(struct pci_dev *pci_dev)
 {
-	/* If device is enabled at this point, disable it */
-	pci_disable_enabled_device(pci_dev);
+	/* If a non-bridge device is enabled at this point, disable it */
+	if (!pci_is_bridge(pci_dev))
+		pci_disable_enabled_device(pci_dev);
 	/*
 	 * Save state with interrupts enabled, because in principle the bus the
 	 * device is on may be put into a low power state after this code runs.

