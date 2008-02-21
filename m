Return-Path: <linux-kernel-owner+w=401wt.eu-S935972AbYBUXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935972AbYBUXvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934669AbYBUXse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:34 -0500
Received: from ns.suse.de ([195.135.220.2]:45025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763752AbYBUXsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/11] Driver core: Fix error handling in bus_add_driver().
Date: Thu, 21 Feb 2008 15:48:01 -0800
Message-Id: <1203637687-7273-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

- If the allocation of ->priv fails, the reference on the bus
  must be dropped.
- If adding the kobject fails, kobject_put must be called to
  clean things up.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 055989e..2d207ad 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -658,9 +658,10 @@ int bus_add_driver(struct device_driver *drv)
 	pr_debug("bus: '%s': add driver %s\n", bus->name, drv->name);
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
+	if (!priv) {
+		error = -ENOMEM;
+		goto out_put_bus;
+	}
 	klist_init(&priv->klist_devices, NULL, NULL);
 	priv->driver = drv;
 	drv->p = priv;
@@ -668,7 +669,7 @@ int bus_add_driver(struct device_driver *drv)
 	error = kobject_init_and_add(&priv->kobj, &driver_ktype, NULL,
 				     "%s", drv->name);
 	if (error)
-		goto out_put_bus;
+		goto out_unregister;
 
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
-- 
1.5.4

