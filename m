Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYL3Wxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYL3Wxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYL3Wub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:50:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYL3WuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:50:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 8/10] PCI PM: Register power state of devices during initialization
Date: Tue, 30 Dec 2008 23:45:53 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl>
In-Reply-To: <200812302333.45560.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812302345.55072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the observation that the power state of a PCI device can be
loaded into its pci_dev structure as soon as pci_pm_init() is run for
it and make that happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1259,14 +1259,15 @@ void pci_pm_init(struct pci_dev *dev)
 	/* find PCI PM capability in list */
 	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
 	if (!pm)
-		return;
+		goto Exit;
+
 	/* Check device's ability to generate PME# */
 	pci_read_config_word(dev, pm + PCI_PM_PMC, &pmc);
 
 	if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
 		dev_err(&dev->dev, "unsupported PM cap regs version (%u)\n",
 			pmc & PCI_PM_CAP_VER_MASK);
-		return;
+		goto Exit;
 	}
 
 	dev->pm_cap = pm;
@@ -1305,6 +1306,9 @@ void pci_pm_init(struct pci_dev *dev)
 	} else {
 		dev->pme_support = 0;
 	}
+
+ Exit:
+	pci_update_current_state(dev, PCI_D0);
 }
 
 /**

