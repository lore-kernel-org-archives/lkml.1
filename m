Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbYAYHr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbYAYHr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbYAYHfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:20 -0500
Received: from ns.suse.de ([195.135.220.2]:55081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759766AbYAYHfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Dirk Behme <dirk.behme@de.bosch.com>
Subject: [PATCH 082/196] kobject: convert arm/mach-omap1/pm.c to kobj_attr interface
Date: Thu, 24 Jan 2008 23:31:51 -0800
Message-Id: <1201246425-5058-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code a bit simpler and and gets us one step closer to
deleting the deprecated subsys_attr code.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-omap1/pm.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 402113c..63edafb 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -69,14 +69,14 @@ static unsigned int mpui1610_sleep_save[MPUI1610_SLEEP_SAVE_SIZE];
 
 static unsigned short enable_dyn_sleep = 1;
 
-static ssize_t omap_pm_sleep_while_idle_show(struct kset *kset, char *buf)
+static ssize_t idle_show(struct kobject *kobj, struct kobj_attribute *attr,
+			 char *buf)
 {
 	return sprintf(buf, "%hu\n", enable_dyn_sleep);
 }
 
-static ssize_t omap_pm_sleep_while_idle_store(struct kset *kset,
-					      const char * buf,
-					      size_t n)
+static ssize_t idle_store(struct kobject *kobj, struct kobj_attribute *attr,
+			  const char * buf, size_t n)
 {
 	unsigned short value;
 	if (sscanf(buf, "%hu", &value) != 1 ||
@@ -88,14 +88,8 @@ static ssize_t omap_pm_sleep_while_idle_store(struct kset *kset,
 	return n;
 }
 
-static struct subsys_attribute sleep_while_idle_attr = {
-	.attr   = {
-		.name = __stringify(sleep_while_idle),
-		.mode = 0644,
-	},
-	.show   = omap_pm_sleep_while_idle_show,
-	.store  = omap_pm_sleep_while_idle_store,
-};
+static struct kobj_attribute sleep_while_idle_attr =
+	__ATTR(sleep_while_idle, 0644, idle_show, idle_store);
 
 static void (*omap_sram_idle)(void) = NULL;
 static void (*omap_sram_suspend)(unsigned long r0, unsigned long r1) = NULL;
@@ -725,9 +719,9 @@ static int __init omap_pm_init(void)
 	omap_pm_init_proc();
 #endif
 
-	error = subsys_create_file(power_kset, &sleep_while_idle_attr);
+	error = sysfs_create_file(&power_kset->kobj, &sleep_while_idle_attr);
 	if (error)
-		printk(KERN_ERR "subsys_create_file failed: %d\n", error);
+		printk(KERN_ERR "sysfs_create_file failed: %d\n", error);
 
 	if (cpu_is_omap16xx()) {
 		/* configure LOW_PWR pin */
-- 
1.5.3.8

