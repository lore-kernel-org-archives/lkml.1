Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbYAYHsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbYAYHsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbYAYHfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:49654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761607AbYAYHfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Manish Ahuja <mahuja@us.ibm.com>
Subject: [PATCH 083/196] kobject: convert pseries/power.c to kobj_attr interface
Date: Thu, 24 Jan 2008 23:31:52 -0800
Message-Id: <1201246425-5058-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
index c36febe..90706cf 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -28,13 +28,15 @@
 
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
@@ -47,14 +49,8 @@ auto_poweron_store(struct kset *kset, const char *buf, size_t n)
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
@@ -79,7 +75,7 @@ core_initcall(pm_init);
 #else
 static int __init apo_pm_init(void)
 {
-	return (subsys_create_file(power_kset, &auto_poweron_attr));
+	return (sysfs_create_file(&power_kset->kobj, &auto_poweron_attr));
 }
 __initcall(apo_pm_init);
 #endif
-- 
1.5.3.8

