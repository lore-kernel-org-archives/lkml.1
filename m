Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbYAYIlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbYAYIlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760917AbYAYIBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:52 -0500
Received: from mail.suse.de ([195.135.220.2]:59430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbYAYH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:47 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 143/196] PCI: use proper call to driver_create_file
Date: Thu, 24 Jan 2008 23:32:52 -0800
Message-Id: <1201246425-5058-64-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to call the "raw" sysfs_create_file when we already have a
helper function to do this kind of work for us.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pci-driver.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 6d1a216..73e3629 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -96,17 +96,21 @@ pci_create_newid_file(struct pci_driver *drv)
 {
 	int error = 0;
 	if (drv->probe != NULL)
-		error = sysfs_create_file(&drv->driver.kobj,
-					  &driver_attr_new_id.attr);
+		error = driver_create_file(&drv->driver, &driver_attr_new_id);
 	return error;
 }
 
+static void pci_remove_newid_file(struct pci_driver *drv)
+{
+	driver_remove_file(&drv->driver, &driver_attr_new_id);
+}
 #else /* !CONFIG_HOTPLUG */
 static inline void pci_free_dynids(struct pci_driver *drv) {}
 static inline int pci_create_newid_file(struct pci_driver *drv)
 {
 	return 0;
 }
+static inline void pci_remove_newid_file(struct pci_driver *drv) {}
 #endif
 
 /**
@@ -447,6 +451,7 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 void
 pci_unregister_driver(struct pci_driver *drv)
 {
+	pci_remove_newid_file(drv);
 	driver_unregister(&drv->driver);
 	pci_free_dynids(drv);
 }
-- 
1.5.3.8

