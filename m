Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXDDWqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXDDWqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbXDDWqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:46:31 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:42547 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbXDDWqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:46:24 -0400
Message-Id: <20070404224608.371449000@ldl.fc.hp.com>
References: <20070404224536.337573000@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Wed, 04 Apr 2007 16:45:37 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: linux-serial@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/5] PNP: notice whether we have PNP devices (PNPBIOS or PNPACPI)
Content-Disposition: inline; filename=pnp-platform-devs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we can discover devices using PNP, we can skip some legacy probes.
This flag ("pnp_platform_devices") indicates that PNPBIOS or PNPACPI
is enabled and should tell us about builtin devices.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work/drivers/pnp/core.c
===================================================================
--- work.orig/drivers/pnp/core.c	2007-03-27 13:05:23.000000000 -0600
+++ work/drivers/pnp/core.c	2007-03-27 16:12:54.000000000 -0600
@@ -23,6 +23,14 @@
 LIST_HEAD(pnp_global);
 DEFINE_SPINLOCK(pnp_lock);
 
+/*
+ * ACPI or PNPBIOS should tell us about all platform devices, so we can
+ * skip some blind probes.  ISAPNP typically enumerates only plug-in ISA
+ * devices, not built-in things like COM ports.
+ */
+int pnp_platform_devices;
+EXPORT_SYMBOL(pnp_platform_devices);
+
 void *pnp_alloc(long size)
 {
 	void *result;
Index: work/drivers/pnp/pnpacpi/core.c
===================================================================
--- work.orig/drivers/pnp/pnpacpi/core.c	2007-03-27 13:05:23.000000000 -0600
+++ work/drivers/pnp/pnpacpi/core.c	2007-03-27 14:44:05.000000000 -0600
@@ -247,6 +247,7 @@
 	pnp_register_protocol(&pnpacpi_protocol);
 	acpi_get_devices(NULL, pnpacpi_add_device_handler, NULL, NULL);
 	pnp_info("PnP ACPI: found %d devices", num);
+	pnp_platform_devices = 1;
 	return 0;
 }
 subsys_initcall(pnpacpi_init);
Index: work/drivers/pnp/pnpbios/core.c
===================================================================
--- work.orig/drivers/pnp/pnpbios/core.c	2007-03-27 13:05:23.000000000 -0600
+++ work/drivers/pnp/pnpbios/core.c	2007-03-27 14:44:05.000000000 -0600
@@ -574,6 +574,7 @@
 	/* scan for pnpbios devices */
 	build_devlist();
 
+	pnp_platform_devices = 1;
 	return 0;
 }
 
Index: work/include/linux/pnp.h
===================================================================
--- work.orig/include/linux/pnp.h	2007-03-27 13:05:23.000000000 -0600
+++ work/include/linux/pnp.h	2007-03-27 14:44:05.000000000 -0600
@@ -364,6 +364,7 @@
 int pnp_device_attach(struct pnp_dev *pnp_dev);
 void pnp_device_detach(struct pnp_dev *pnp_dev);
 extern struct list_head pnp_global;
+extern int pnp_platform_devices;
 
 /* multidevice card support */
 int pnp_add_card(struct pnp_card *card);
@@ -411,6 +412,7 @@
 static inline int pnp_add_device(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_device_attach(struct pnp_dev *pnp_dev) { return -ENODEV; }
 static inline void pnp_device_detach(struct pnp_dev *pnp_dev) { ; }
+#define pnp_platform_devices 0
 
 /* multidevice card support */
 static inline int pnp_add_card(struct pnp_card *card) { return -ENODEV; }

--
