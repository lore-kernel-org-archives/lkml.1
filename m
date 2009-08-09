Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZHIJ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZHIJ5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZHIJ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:57:50 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:59833 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZHIJ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:57:48 -0400
Message-Id: <20090809095743.926828201@hardeman.nu>
References: <20090809095645.198777507@hardeman.nu>
User-Agent: quilt/0.46-1
Date: Sun, 09 Aug 2009 11:56:46 +0200
From: david@hardeman.nu
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, bjorn.helgaas@hp.com,
       randy.dunlap@oracle.com, david@hardeman.nu
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
