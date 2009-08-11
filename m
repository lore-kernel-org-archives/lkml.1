Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZHKQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZHKQ27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZHKQ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:28:57 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:56009 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZHKQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:28:56 -0400
Message-Id: <20090811162852.708008640@hardeman.nu>
References: <20090811162614.757030930@hardeman.nu>
User-Agent: quilt/0.46-1
Date: Tue, 11 Aug 2009 18:26:15 +0200
From: =?utf-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, akpm@linux-foundation.org, bjorn.helgaas@hp.com,
       linux-input@vger.kernel.org
Subject: [patch 1/2] Add a shutdown method to pnp drivers
Content-Disposition: inline; filename=add-pnp-shutdown-method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shutdown method is used by the winbond cir driver to setup the
hardware for wake-from-S5.

Changes since last version: the previous patch added a shutdown method
to acpi drivers, the winbond cir driver is now a pnp driver so the
shutdown method is added to pnp drivers instead. Patch by
Bjorn Helgaas <bjorn.helgaas@hp.com>.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David Härdeman <david@hardeman.nu>

Index: linux-2.6/drivers/pnp/driver.c
===================================================================
--- linux-2.6.orig/drivers/pnp/driver.c	2009-07-25 19:53:32.000000000 +0200
+++ linux-2.6/drivers/pnp/driver.c	2009-07-25 19:54:21.000000000 +0200
@@ -135,6 +135,15 @@
 	return 0;
 }
 
+static void pnp_device_shutdown(struct device *dev)
+{
+	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
+	struct pnp_driver *drv = pnp_dev->driver;
+
+	if (drv && drv->shutdown)
+		drv->shutdown(pnp_dev);
+}
+
 static int pnp_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
@@ -203,6 +212,7 @@
 	.match   = pnp_bus_match,
 	.probe   = pnp_device_probe,
 	.remove  = pnp_device_remove,
+	.shutdown = pnp_device_shutdown,
 	.suspend = pnp_bus_suspend,
 	.resume  = pnp_bus_resume,
 	.dev_attrs = pnp_interface_attrs,
Index: linux-2.6/include/linux/pnp.h
===================================================================
--- linux-2.6.orig/include/linux/pnp.h	2009-07-25 19:53:32.000000000 +0200
+++ linux-2.6/include/linux/pnp.h	2009-07-25 19:54:21.000000000 +0200
@@ -360,6 +360,7 @@
 	unsigned int flags;
 	int (*probe) (struct pnp_dev *dev, const struct pnp_device_id *dev_id);
 	void (*remove) (struct pnp_dev *dev);
+	void (*shutdown) (struct pnp_dev *dev);
 	int (*suspend) (struct pnp_dev *dev, pm_message_t state);
 	int (*resume) (struct pnp_dev *dev);
 	struct device_driver driver;

-- 
David Härdeman
