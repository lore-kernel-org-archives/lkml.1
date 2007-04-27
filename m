Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbXD0TD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbXD0TD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXD0S6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:35288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbXD0S6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, netdev <netdev@vger.kernel.org>
Subject: [PATCH 28/46] PHY: remove rwsem use from phy core
Date: Fri, 27 Apr 2007 11:53:42 -0700
Message-Id: <11777001413571-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <117770013729-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The subsystem rwsem is not used by the driver core at all, so the use of
it in the phy code doesn't make any sense.  They might possibly
want to use a local lock, but I am unsure about that.

Cc: netdev <netdev@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/phy/fixed.c      |    6 ------
 drivers/net/phy/phy_device.c |    9 +--------
 2 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/fixed.c b/drivers/net/phy/fixed.c
index 66da91b..68c99b4 100644
--- a/drivers/net/phy/fixed.c
+++ b/drivers/net/phy/fixed.c
@@ -276,21 +276,15 @@ static int fixed_mdio_register_device(int number, int speed, int duplex)
 	   artificially, we are binding the driver here by hand;
 	   it will be the same for all the fixed phys anyway.
 	 */
-	down_write(&phydev->dev.bus->subsys.rwsem);
-
 	phydev->dev.driver = &fixed_mdio_driver.driver;
 
 	err = phydev->dev.driver->probe(&phydev->dev);
 	if(err < 0) {
 		printk(KERN_ERR "Phy %s: problems with fixed driver\n",phydev->dev.bus_id);
-		up_write(&phydev->dev.bus->subsys.rwsem);
 		goto probe_fail;
 	}
 
 	err = device_bind_driver(&phydev->dev);
-
-	up_write(&phydev->dev.bus->subsys.rwsem);
-
 	if (err)
 		goto probe_fail;
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7d5b6d1..8f01952 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -208,16 +208,12 @@ struct phy_device *phy_attach(struct net_device *dev,
 	 * exist, and we should use the genphy driver. */
 	if (NULL == d->driver) {
 		int err;
-		down_write(&d->bus->subsys.rwsem);
 		d->driver = &genphy_driver.driver;
 
 		err = d->driver->probe(d);
-
 		if (err >= 0)
 			err = device_bind_driver(d);
 
-		up_write(&d->bus->subsys.rwsem);
-
 		if (err)
 			return ERR_PTR(err);
 	}
@@ -258,11 +254,8 @@ void phy_detach(struct phy_device *phydev)
 	 * was using the generic driver), we unbind the device
 	 * from the generic driver so that there's a chance a
 	 * real driver could be loaded */
-	if (phydev->dev.driver == &genphy_driver.driver) {
-		down_write(&phydev->dev.bus->subsys.rwsem);
+	if (phydev->dev.driver == &genphy_driver.driver)
 		device_release_driver(&phydev->dev);
-		up_write(&phydev->dev.bus->subsys.rwsem);
-	}
 }
 EXPORT_SYMBOL(phy_detach);
 
-- 
1.5.1.2

