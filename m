Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXD0TN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXD0TN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXD0TMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:12:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:35232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757056AbXD0S5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/46] Driver core: suppress uevents via filter
Date: Fri, 27 Apr 2007 11:53:28 -0700
Message-Id: <11777000881307-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000852694-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Suppress uevents for devices if uevent_suppress is set via
dev_uevent_filter(). This makes the driver core suppress all device
uevents, not just the add event in device_add().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index be6aeb4..c34a4d8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -120,6 +120,8 @@ static int dev_uevent_filter(struct kset *kset, struct kobject *kobj)
 
 	if (ktype == &ktype_device) {
 		struct device *dev = to_dev(kobj);
+		if (dev->uevent_suppress)
+			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -675,8 +677,7 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
-- 
1.5.1.2

