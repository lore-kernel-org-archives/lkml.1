Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbXD0S63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbXD0S63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXD0S5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060AbXD0S5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Adam Belay <ambx1@neo.rr.com>
Subject: [PATCH 23/46] PNP: stop using the subsystem rwsem
Date: Fri, 27 Apr 2007 11:53:37 -0700
Message-Id: <11777001222882-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001182501-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rwsem is not used to protect anything, so the use of it by the PNP
subsystem isn't really useful, and it's doubtful if it really did anything or
not.  So I've removed it.

Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pnp/card.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index 91c047a..dd6384b 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -311,7 +311,6 @@ done:
 	return NULL;
 
 found:
-	down_write(&dev->dev.bus->subsys.rwsem);
 	dev->card_link = clink;
 	dev->dev.driver = &drv->link.driver;
 	if (pnp_bus_type.probe(&dev->dev))
@@ -319,14 +318,11 @@ found:
 	if (device_bind_driver(&dev->dev))
 		goto err_out;
 
-	up_write(&dev->dev.bus->subsys.rwsem);
-
 	return dev;
 
 err_out:
 	dev->dev.driver = NULL;
 	dev->card_link = NULL;
-	up_write(&dev->dev.bus->subsys.rwsem);
 	return NULL;
 }
 
@@ -340,11 +336,9 @@ void pnp_release_card_device(struct pnp_dev * dev)
 	struct pnp_card_driver * drv = dev->card_link->driver;
 	if (!drv)
 		return;
-	down_write(&dev->dev.bus->subsys.rwsem);
 	drv->link.remove = &card_remove;
 	device_release_driver(&dev->dev);
 	drv->link.remove = &card_remove_first;
-	up_write(&dev->dev.bus->subsys.rwsem);
 }
 
 /*
-- 
1.5.1.2

