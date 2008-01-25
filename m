Return-Path: <linux-kernel-owner+w=401wt.eu-S1764727AbYAYIH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764727AbYAYIH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbYAYH75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:59392 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763710AbYAYH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 153/196] Kobject: change drivers/base/bus to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:33:02 -0800
Message-Id: <1201246425-5058-74-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 937fc10..aea5793 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -643,15 +643,12 @@ int bus_add_driver(struct device_driver *drv)
 	if (!priv)
 		return -ENOMEM;
 
-	error = kobject_set_name(&priv->kobj, "%s", drv->name);
-	if (error)
-		goto out_put_bus;
-	priv->kobj.kset = bus->p->drivers_kset;
-	priv->kobj.ktype = &driver_ktype;
 	klist_init(&priv->klist_devices, NULL, NULL);
 	priv->driver = drv;
 	drv->p = priv;
-	error = kobject_register(&priv->kobj);
+	priv->kobj.kset = bus->p->drivers_kset;
+	error = kobject_init_and_add(&priv->kobj, &driver_ktype, NULL,
+				     "%s", drv->name);
 	if (error)
 		goto out_put_bus;
 
@@ -681,6 +678,7 @@ int bus_add_driver(struct device_driver *drv)
 			__FUNCTION__, drv->name);
 	}
 
+	kobject_uevent(&priv->kobj, KOBJ_ADD);
 	return error;
 out_unregister:
 	kobject_unregister(&priv->kobj);
-- 
1.5.3.8

