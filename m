Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbXLaSGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbXLaSGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXLaSGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:06:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36384 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbXLaSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:06:15 -0500
Date: Mon, 31 Dec 2007 10:05:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH -mm] driver core: build with SYSFS=n
Message-Id: <20071231100543.99b6ca42.randy.dunlap@oracle.com>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
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
---
 drivers/base/Makefile |    2 ++
 drivers/base/base.h   |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc6-mm1.orig/drivers/base/Makefile
+++ linux-2.6.24-rc6-mm1/drivers/base/Makefile
@@ -11,7 +11,9 @@ obj-$(CONFIG_FW_LOADER)	+= firmware_clas
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 obj-$(CONFIG_SMP)	+= topology.o
+ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
+endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
--- linux-2.6.24-rc6-mm1.orig/drivers/base/base.h
+++ linux-2.6.24-rc6-mm1/drivers/base/base.h
@@ -79,7 +79,7 @@ extern char *make_class_name(const char 
 
 extern int devres_release_all(struct device *dev);
 
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
 extern void module_remove_driver(struct device_driver *drv);
 #else
