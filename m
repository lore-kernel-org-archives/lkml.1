Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYBRQFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYBRQFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYBRQFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:05:00 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:37419 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYBRQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:05:00 -0500
Date: Mon, 18 Feb 2008 17:04:25 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [Patch] Driver core: Fix error handling in bus_add_driver().
Message-ID: <20080218170425.56d03e37@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- If the allocation of ->priv fails, the reference on the bus
  must be dropped.
- If adding the kobject fails, kobject_put must be called to
  clean things up.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/bus.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/base/bus.c
+++ linux-2.6/drivers/base/bus.c
@@ -658,9 +658,10 @@ int bus_add_driver(struct device_driver 
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
@@ -668,7 +669,7 @@ int bus_add_driver(struct device_driver 
 	error = kobject_init_and_add(&priv->kobj, &driver_ktype, NULL,
 				     "%s", drv->name);
 	if (error)
-		goto out_put_bus;
+		goto out_unregister;
 
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
