Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXD0S7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXD0S7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbXD0S6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbXD0S54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Collins <bcollins@debian.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: [PATCH 27/46] IEEE1394: remove rwsem use from ieee1394 core
Date: Fri, 27 Apr 2007 11:53:41 -0700
Message-Id: <117770013729-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001333852-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The subsystem rwsem is not used by the driver core at all, so the use of
it in the ieee1394 code doesn't make any sense.  They might possibly
want to use a local lock, but as most of these operations are already
protected by a local lock, it really doesn't look like it would be
needed.

Cc: Ben Collins <bcollins@debian.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel <linux1394-devel@lists.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/nodemgr.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 1644e6f..dbeba45 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -370,9 +370,7 @@ static ssize_t fw_set_ignore_driver(struct device *dev, struct device_attribute
 
 	if (state == 1) {
 		ud->ignore_driver = 1;
-		down_write(&ieee1394_bus_type.subsys.rwsem);
 		device_release_driver(dev);
-		up_write(&ieee1394_bus_type.subsys.rwsem);
 	} else if (state == 0)
 		ud->ignore_driver = 0;
 
@@ -1391,12 +1389,10 @@ static void nodemgr_suspend_ne(struct node_entry *ne)
 		if (ud->ne != ne)
 			continue;
 
-		down_write(&ieee1394_bus_type.subsys.rwsem);
 		if (ud->device.driver &&
 		    (!ud->device.driver->suspend ||
 		      ud->device.driver->suspend(&ud->device, PMSG_SUSPEND)))
 			device_release_driver(&ud->device);
-		up_write(&ieee1394_bus_type.subsys.rwsem);
 	}
 	up(&nodemgr_ud_class.sem);
 }
@@ -1416,10 +1412,8 @@ static void nodemgr_resume_ne(struct node_entry *ne)
 		if (ud->ne != ne)
 			continue;
 
-		down_read(&ieee1394_bus_type.subsys.rwsem);
 		if (ud->device.driver && ud->device.driver->resume)
 			ud->device.driver->resume(&ud->device);
-		up_read(&ieee1394_bus_type.subsys.rwsem);
 	}
 	up(&nodemgr_ud_class.sem);
 
@@ -1440,7 +1434,6 @@ static void nodemgr_update_pdrv(struct node_entry *ne)
 		if (ud->ne != ne)
 			continue;
 
-		down_write(&ieee1394_bus_type.subsys.rwsem);
 		if (ud->device.driver) {
 			pdrv = container_of(ud->device.driver,
 					    struct hpsb_protocol_driver,
@@ -1448,7 +1441,6 @@ static void nodemgr_update_pdrv(struct node_entry *ne)
 			if (pdrv->update && pdrv->update(ud))
 				device_release_driver(&ud->device);
 		}
-		up_write(&ieee1394_bus_type.subsys.rwsem);
 	}
 	up(&nodemgr_ud_class.sem);
 }
-- 
1.5.1.2

