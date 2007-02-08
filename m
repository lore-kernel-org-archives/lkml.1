Return-Path: <linux-kernel-owner+w=401wt.eu-S965708AbXBHAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708AbXBHAg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423051AbXBHAcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:35 -0500
Received: from mx1.suse.de ([195.135.220.2]:56373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422852AbXBHAcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:02 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/28] SERIO: add the sysfs driver name to all modules
Date: Wed,  7 Feb 2007 16:29:58 -0800
Message-Id: <11708946533931-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1170894650872-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This adds the module name to all SERIO drivers, if they are built into
the kernel or not.  It will show up in /sys/modules/MODULE_NAME/drivers/

Cc: Kay Sievers <kay.sievers@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/serio/serio.c |    6 ++++--
 include/linux/serio.h       |    5 +++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index f0ce822..17c8c63 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL(serio_interrupt);
 EXPORT_SYMBOL(__serio_register_port);
 EXPORT_SYMBOL(serio_unregister_port);
 EXPORT_SYMBOL(serio_unregister_child_port);
-EXPORT_SYMBOL(serio_register_driver);
+EXPORT_SYMBOL(__serio_register_driver);
 EXPORT_SYMBOL(serio_unregister_driver);
 EXPORT_SYMBOL(serio_open);
 EXPORT_SYMBOL(serio_close);
@@ -789,12 +789,14 @@ static void serio_attach_driver(struct serio_driver *drv)
 			drv->driver.name, error);
 }
 
-int serio_register_driver(struct serio_driver *drv)
+int __serio_register_driver(struct serio_driver *drv, struct module *owner, const char *mod_name)
 {
 	int manual_bind = drv->manual_bind;
 	int error;
 
 	drv->driver.bus = &serio_bus;
+	drv->driver.owner = owner;
+	drv->driver.mod_name = mod_name;
 
 	/*
 	 * Temporarily disable automatic binding because probing
diff --git a/include/linux/serio.h b/include/linux/serio.h
index 0f478a8..ac2c70e 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -86,6 +86,11 @@ static inline void serio_register_port(struct serio *serio)
 void serio_unregister_port(struct serio *serio);
 void serio_unregister_child_port(struct serio *serio);
 
+int __serio_register_driver(struct serio_driver *drv, struct module *owner, const char *mod_name);
+static inline int serio_register_driver(struct serio_driver *drv)
+{
+	return __serio_register_driver(drv, THIS_MODULE, KBUILD_MODNAME);
+}
 int serio_register_driver(struct serio_driver *drv);
 void serio_unregister_driver(struct serio_driver *drv);
 
-- 
1.4.4.4

