Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbYAYIhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbYAYIhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbYAYIBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:59452 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764075AbYAYH7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 183/196] driver core: fix build with SYSFS=n
Date: Thu, 24 Jan 2008 23:33:32 -0800
Message-Id: <1201246425-5058-104-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When SYSFS=n and MODULES=y, build ends with:

linux-2.6.24-rc6-mm1/drivers/base/module.c: In function 'module_add_driver':
linux-2.6.24-rc6-mm1/drivers/base/module.c:49: error: 'module_kset' undeclared (first use in this function)
make[3]: *** [drivers/base/module.o] Error 1

Below is one possible fix.
Build-tested with all 4 config combinations of SYSFS & MODULES.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Makefile |    2 ++
 drivers/base/base.h   |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index ff26968..63e09c0 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -11,7 +11,9 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
+endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff --git a/drivers/base/base.h b/drivers/base/base.h
index a74ceda..f7ad65a 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -81,7 +81,7 @@ extern int devres_release_all(struct device *dev);
 
 extern struct kset *devices_kset;
 
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
 extern void module_remove_driver(struct device_driver *drv);
 #else
-- 
1.5.3.8

