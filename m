Return-Path: <linux-kernel-owner+w=401wt.eu-S1422874AbXBHAgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422874AbXBHAgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161500AbXBHAdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:07 -0500
Received: from mail.suse.de ([195.135.220.2]:56447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbXBHAcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:55 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@novell.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/28] Driver core: allow to delay the uevent at device creation time
Date: Wed,  7 Feb 2007 16:30:14 -0800
Message-Id: <11708947063663-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708947024054-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com> <11708946932742-git-send-email-greg@kroah.com> <11708946963110-git-send-email-greg@kroah.com> <11708946993815-git-send-email-greg@kroah.com> <11708947024054-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@novell.com>

For the block subsystem, we want to delay all uevents until the
disk has been scanned and allpartitons are already created before
the first event is sent out.

Signed-off-by: Kay Sievers <kay.sievers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |    3 ++-
 include/linux/device.h |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 34ac187..e136142 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -589,7 +589,8 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	kobject_uevent(&dev->kobj, KOBJ_ADD);
+	if (!dev->uevent_suppress)
+		kobject_uevent(&dev->kobj, KOBJ_ADD);
 	if ((error = bus_attach_device(dev)))
 		goto AttachError;
 	if (parent)
diff --git a/include/linux/device.h b/include/linux/device.h
index e1e164f..5ca1cdb 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -399,9 +399,10 @@ struct device {
 
 	/* class_device migration path */
 	struct list_head	node;
-	struct class		*class;		/* optional*/
+	struct class		*class;
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
+	int			uevent_suppress;
 
 	void	(*release)(struct device * dev);
 };
-- 
1.4.4.4

