Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbXKCAOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbXKCAOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbXKCADI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbXKCADG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Manish Ahuja <mahuja@us.ibm.com>
Subject: [PATCH 44/54] kobject: convert pseries/power.c to kobj_attr interface
Date: Fri,  2 Nov 2007 16:59:22 -0700
Message-Id: <1194047972-9850-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the code a bit simpler and and gets us one step closer to
deleting the deprecated subsys_attr code.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Manish Ahuja <mahuja@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/power.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index bf35de4..012224b 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -29,13 +29,15 @@
 
 unsigned long rtas_poweron_auto; /* default and normal state is 0 */
 
-static ssize_t auto_poweron_show(struct kset *kset, char *buf)
+static ssize_t auto_poweron_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
 {
         return sprintf(buf, "%lu\n", rtas_poweron_auto);
 }
 
-static ssize_t
-auto_poweron_store(struct kset *kset, const char *buf, size_t n)
+static ssize_t auto_poweron_store(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  const char *buf, size_t n)
 {
 	int ret;
 	unsigned long ups_restart;
@@ -48,14 +50,8 @@ auto_poweron_store(struct kset *kset, const char *buf, size_t n)
 	return -EINVAL;
 }
 
-static struct subsys_attribute auto_poweron_attr = {
-        .attr   = {
-                .name = __stringify(auto_poweron),
-                .mode = 0644,
-        },
-        .show   = auto_poweron_show,
-        .store  = auto_poweron_store,
-};
+static struct kobj_attribute auto_poweron_attr =
+	__ATTR(auto_poweron, 0644, auto_poweron_show, auto_poweron_store);
 
 #ifndef CONFIG_PM
 struct kset *power_kset;
@@ -80,7 +76,7 @@ core_initcall(pm_init);
 #else
 static int __init apo_pm_init(void)
 {
-	return (subsys_create_file(power_kset, &auto_poweron_attr));
+	return (sysfs_create_file(&power_kset->kobj, &auto_poweron_attr));
 }
 __initcall(apo_pm_init);
 #endif
-- 
1.5.3.4

