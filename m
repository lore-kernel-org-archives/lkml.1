Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXBWVjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXBWVjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 16:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXBWVjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 16:39:55 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53394 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbXBWVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 16:39:54 -0500
To: linux-kernel@vger.kernel.org
CC: vortex@scyld.com, netdev@vger.kernel.org
Subject: [PATCH] 3c59x: Handle pci_enable_device() failure while resuming 
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sat, 24 Feb 2007 00:40:10 +0300
Message-ID: <87d540blj9.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Sat, 24 Feb 2007 00:39:51 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle pci_enable_device() failure while resuming, we can safely exit here.
Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/net/3c59x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 2b750bd..ea4a78f 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -821,11 +821,17 @@ static int vortex_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct vortex_private *vp = netdev_priv(dev);
+	int err;
 
 	if (dev && vp) {
 		pci_set_power_state(pdev, PCI_D0);
 		pci_restore_state(pdev);
-		pci_enable_device(pdev);
+		err = pci_enable_device(pdev);
+		if (err) {
+			printk(KERN_WARNING "%s: Could not enable device \n",
+				dev->name);
+			return err;
+		}
 		pci_set_master(pdev);
 		if (request_irq(dev->irq, vp->full_bus_master_rx ?
 				&boomerang_interrupt : &vortex_interrupt, IRQF_SHARED, dev->name, dev)) {
-- 
1.4.4.4


