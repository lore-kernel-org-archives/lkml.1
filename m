Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbXCKTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbXCKTLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbXCKTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:11:16 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:23969 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934012AbXCKTLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:11:15 -0400
To: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] driver core: handles kobject_uevent failure while device_add
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sun, 11 Mar 2007 22:11:38 +0300
Message-ID: <876497vbmd.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 drivers/base/core.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 142c222..da73012 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -630,8 +630,11 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	if (!dev->uevent_suppress) {
+		error = kobject_uevent(&dev->kobj, KOBJ_ADD);
+		if (error)
+			goto UeventError;
+	}
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
@@ -651,6 +654,9 @@ int device_add(struct device *dev)
  	kfree(class_name);
 	put_device(dev);
 	return error;
+
+ UeventError:
+ 	bus_remove_device(dev);
  BusError:
 	device_pm_remove(dev);
  PMError:
-- 
1.5.0.1


