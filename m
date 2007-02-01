Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbXBAPuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbXBAPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXBAPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:50:51 -0500
Received: from smtp40.mobistarmail.be ([193.252.23.61]:3382 "EHLO
	smtp40.mobistarmail.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXBAPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:50:50 -0500
X-Greylist: delayed 1171 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 10:50:50 EST
X-ME-UUID: 20070201153112972.ED4BF7000166@mwinf4017.mobistarmail.be
From: Peter Korsgaard <jacmet@sunsite.dk>
To: dustin@sensoria.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net/smc911x: Match up spin lock/unlock
Date: Thu, 01 Feb 2007 16:30:56 +0100
Message-ID: <87tzy53nf3.fsf@slug.be.48ers.dk>
User-Agent: Gnus/5.110004 (No Gnus v0.4) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smc911x_phy_configure's error handling unconditionally unlocks the
spinlock even if it wasn't locked. Patch fixes it.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

---
 drivers/net/smc911x.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-trunk/drivers/net/smc911x.c
===================================================================
--- linux-trunk.orig/drivers/net/smc911x.c
+++ linux-trunk/drivers/net/smc911x.c
@@ -969,11 +969,11 @@
 	 * We should not be called if phy_type is zero.
 	 */
 	if (lp->phy_type == 0)
-		 goto smc911x_phy_configure_exit;
+		 goto smc911x_phy_configure_exit_nolock;
 
 	if (smc911x_phy_reset(dev, phyaddr)) {
 		printk("%s: PHY reset timed out\n", dev->name);
-		goto smc911x_phy_configure_exit;
+		goto smc911x_phy_configure_exit_nolock;
 	}
 	spin_lock_irqsave(&lp->lock, flags);
 
@@ -1042,6 +1042,7 @@
 
 smc911x_phy_configure_exit:
 	spin_unlock_irqrestore(&lp->lock, flags);
+smc911x_phy_configure_exit_nolock:
 	lp->work_pending = 0;
 }
 

-- 
Bye, Peter Korsgaard
