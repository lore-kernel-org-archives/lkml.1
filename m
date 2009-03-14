Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZCNLir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZCNLir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZCNLf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:35:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZCNLfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 11/11] PCI PM: Restore config spaces of all devices during early resume
Date: Sat, 14 Mar 2009 12:34:47 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141234.49095.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

At present the configuration spaces of PCI devices that have no
drivers or no PM support in the drivers (either legacy or through a
pm object) are not saved during suspend and, consequently, they are
not restored during resume.  This generally may lead to the state of
the system being slightly inconsistent after the resume, so it's
better to save and restore the configuration spaces of these devices
as well.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -516,13 +516,13 @@ static int pci_pm_suspend(struct device 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_SUSPEND);
 
+	pci_dev->state_saved = false;
+
 	if (!pm) {
 		pci_pm_default_suspend(pci_dev);
 		goto Fixup;
 	}
 
-	pci_dev->state_saved = false;
-
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -554,8 +554,10 @@ static int pci_pm_suspend_noirq(struct d
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend_late(dev, PMSG_SUSPEND);
 
-	if (!pm)
+	if (!pm) {
+		pci_save_state(pci_dev);
 		return 0;
+	}
 
 	if (pm->suspend_noirq) {
 		pci_power_t prev = pci_dev->current_state;
@@ -650,13 +652,13 @@ static int pci_pm_freeze(struct device *
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_FREEZE);
 
+	pci_dev->state_saved = false;
+
 	if (!pm) {
 		pci_pm_default_suspend(pci_dev);
 		return 0;
 	}
 
-	pci_dev->state_saved = false;
-
 	if (pm->freeze) {
 		int error;
 
@@ -738,13 +740,13 @@ static int pci_pm_poweroff(struct device
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
 
+	pci_dev->state_saved = false;
+
 	if (!pm) {
 		pci_pm_default_suspend(pci_dev);
 		goto Fixup;
 	}
 
-	pci_dev->state_saved = false;
-
 	if (pm->poweroff) {
 		int error;
 
