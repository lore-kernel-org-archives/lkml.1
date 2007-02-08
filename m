Return-Path: <linux-kernel-owner+w=401wt.eu-S965703AbXBHAg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965703AbXBHAg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422852AbXBHAci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422850AbXBHAb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:31:59 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 9/28] PCI: add the sysfs driver name to all modules
Date: Wed,  7 Feb 2007 16:29:57 -0800
Message-Id: <1170894650872-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946472324-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This adds the module name to all PCI drivers, if they are built into the
kernel or not.  It will show up in /sys/modules/MODULE_NAME/drivers/

It also fixes up the IDE core, which was calling __pci_register_driver()
directly.

Cc: Kay Sievers <kay.sievers@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/setup-pci.c  |    7 ++++---
 drivers/pci/pci-driver.c |    4 +++-
 include/linux/ide.h      |    4 ++--
 include/linux/pci.h      |    5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 695e239..a52c80f 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -783,10 +783,11 @@ static LIST_HEAD(ide_pci_drivers);
  *	Returns are the same as for pci_register_driver
  */
 
-int __ide_pci_register_driver(struct pci_driver *driver, struct module *module)
+int __ide_pci_register_driver(struct pci_driver *driver, struct module *module,
+			      const char *mod_name)
 {
 	if(!pre_init)
-		return __pci_register_driver(driver, module);
+		return __pci_register_driver(driver, module, mod_name);
 	driver->driver.owner = module;
 	list_add_tail(&driver->node, &ide_pci_drivers);
 	return 0;
@@ -862,6 +863,6 @@ void __init ide_scan_pcibus (int scan_direction)
 	{
 		list_del(l);
 		d = list_entry(l, struct pci_driver, node);
-		__pci_register_driver(d, d->driver.owner);
+		__pci_register_driver(d, d->driver.owner, d->driver.mod_name);
 	}
 }
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 92d5e8d..3587668 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -422,7 +422,8 @@ static struct kobj_type pci_driver_kobj_type = {
  * If no error occurred, the driver remains registered even if 
  * no device was claimed during registration.
  */
-int __pci_register_driver(struct pci_driver *drv, struct module *owner)
+int __pci_register_driver(struct pci_driver *drv, struct module *owner,
+			  const char *mod_name)
 {
 	int error;
 
@@ -430,6 +431,7 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner)
 	drv->driver.name = drv->name;
 	drv->driver.bus = &pci_bus_type;
 	drv->driver.owner = owner;
+	drv->driver.mod_name = mod_name;
 	drv->driver.kobj.ktype = &pci_driver_kobj_type;
 
 	if (pci_multithread_probe)
diff --git a/include/linux/ide.h b/include/linux/ide.h
index e26a039..827688f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1192,8 +1192,8 @@ void ide_init_disk(struct gendisk *, ide_drive_t *);
 extern int ideprobe_init(void);
 
 extern void ide_scan_pcibus(int scan_direction) __init;
-extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner);
-#define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE)
+extern int __ide_pci_register_driver(struct pci_driver *driver, struct module *owner, const char *mod_name);
+#define ide_pci_register_driver(d) __ide_pci_register_driver(d, THIS_MODULE, KBUILD_MODNAME)
 void ide_pci_setup_ports(struct pci_dev *, struct ide_pci_device_s *, int, ata_index_t *);
 extern void ide_setup_pci_noise (struct pci_dev *dev, struct ide_pci_device_s *d);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f3c617e..cb899eb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -573,10 +573,11 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 void pci_enable_bridges(struct pci_bus *bus);
 
 /* Proper probing supporting hot-pluggable devices */
-int __must_check __pci_register_driver(struct pci_driver *, struct module *);
+int __must_check __pci_register_driver(struct pci_driver *, struct module *,
+				       const char *mod_name);
 static inline int __must_check pci_register_driver(struct pci_driver *driver)
 {
-	return __pci_register_driver(driver, THIS_MODULE);
+	return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
 }
 
 void pci_unregister_driver(struct pci_driver *);
-- 
1.4.4.4

