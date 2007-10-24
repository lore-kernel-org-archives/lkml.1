Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbXJXXtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbXJXXtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbXJXXs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42940 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXJXXs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:26 -0400
To: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/3] drivers/ide/pci/sc1200.c: fix suspend/resume buglets and warnings
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Message-Id: <20071024234825.829191F81A2@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:25 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* We shouldn't bother with dev->current_state, the PCI API functions we
  call manage this for us (and do a far better job at it too).

* Remove pci_set_power_state(dev, PCI_D0) call in resume, as
  pci_enable_device() does the same thing.

* Check pci_enable_device() return value.  If it failed, fail
  the entire resume and avoid programming timings into the [potentially
  dead/asleep] chip.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ide/pci/sc1200.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/pci/sc1200.c b/drivers/ide/pci/sc1200.c
index 17e58d6..10c79a5 100644
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -332,7 +332,6 @@ static int sc1200_suspend (struct pci_dev *dev, pm_message_t state)
 
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
-	dev->current_state = state.event;
 	return 0;
 }
 
@@ -341,9 +340,10 @@ static int sc1200_resume (struct pci_dev *dev)
 	ide_hwif_t		*hwif;
 	int			i;
 
-	pci_set_power_state(dev, PCI_D0);	// bring chip back from sleep state
-	dev->current_state = PM_EVENT_ON;
-	pci_enable_device(dev);
+	i = pci_enable_device(dev);
+	if (i)
+		return i;
+
 	//
 	// loop over all interfaces that are part of this pci device:
 	//
-- 
1.5.2.4

