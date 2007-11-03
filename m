Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbXKCXUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbXKCXUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbXKCXTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:19:46 -0400
Received: from smtp.xtech.com.ar ([200.68.115.49]:4958 "EHLO
	motherbox.xtech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119AbXKCXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:19:45 -0400
From: Diego Woitasen <diego@woitasen.com.ar>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Diego Woitasen <diego@woitasen.com.ar>
Subject: [PATCH] Remove unneded lock_kernel() in drivers/pci/syscall.c.
Date: Sat,  3 Nov 2007 20:19:30 -0300
Message-Id: <11941319703100-git-send-email-diego@woitasen.com.ar>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_pciconfig_{read,write}() are protected against PCI removal with the reference count in struct pci_dev. The concurrency of pci_user_{read,write}_config_* functions are already protected by pci_lock in drivers/pci/access.c.

Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
---
 drivers/pci/syscall.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index 2ac050d..645d7a6 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -34,7 +34,6 @@ sys_pciconfig_read(unsigned long bus, unsigned long dfn,
 	if (!dev)
 		goto error;
 
-	lock_kernel();
 	switch (len) {
 	case 1:
 		cfg_ret = pci_user_read_config_byte(dev, off, &byte);
@@ -47,10 +46,8 @@ sys_pciconfig_read(unsigned long bus, unsigned long dfn,
 		break;
 	default:
 		err = -EINVAL;
-		unlock_kernel();
 		goto error;
 	};
-	unlock_kernel();
 
 	err = -EIO;
 	if (cfg_ret != PCIBIOS_SUCCESSFUL)
@@ -107,7 +104,6 @@ sys_pciconfig_write(unsigned long bus, unsigned long dfn,
 	if (!dev)
 		return -ENODEV;
 
-	lock_kernel();
 	switch(len) {
 	case 1:
 		err = get_user(byte, (u8 __user *)buf);
@@ -140,7 +136,6 @@ sys_pciconfig_write(unsigned long bus, unsigned long dfn,
 		err = -EINVAL;
 		break;
 	}
-	unlock_kernel();
 	pci_dev_put(dev);
 	return err;
 }
-- 
1.5.2.4

