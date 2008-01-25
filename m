Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbYAYIgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbYAYIgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764153AbYAYIBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:53693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764088AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 174/196] Kobject: convert remaining kobject_unregister() to kobject_put()
Date: Thu, 24 Jan 2008 23:33:23 -0800
Message-Id: <1201246425-5058-95-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for kobject_unregister() anymore, thanks to Kay's
kobject cleanup changes, so replace all instances of it with
kobject_put().


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/ksysfs.c          |    2 +-
 kernel/module.c          |    9 ++++-----
 lib/kobject.c            |    4 ++--
 net/bridge/br_sysfs_br.c |    2 +-
 security/inode.c         |    2 +-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 1081aff..e53bc30 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -154,7 +154,7 @@ notes_exit:
 group_exit:
 	sysfs_remove_group(kernel_kobj, &kernel_attr_group);
 kset_exit:
-	kobject_unregister(kernel_kobj);
+	kobject_put(kernel_kobj);
 exit:
 	return error;
 }
diff --git a/kernel/module.c b/kernel/module.c
index 89cd4c7..dcb8a2c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1257,9 +1257,8 @@ int mod_sysfs_setup(struct module *mod,
 out_unreg_param:
 	module_param_sysfs_remove(mod);
 out_unreg_holders:
-	kobject_unregister(mod->holders_dir);
+	kobject_put(mod->holders_dir);
 out_unreg:
-	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
 	return err;
 }
@@ -1269,9 +1268,9 @@ static void mod_kobject_remove(struct module *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	kobject_unregister(mod->mkobj.drivers_dir);
-	kobject_unregister(mod->holders_dir);
-	kobject_unregister(&mod->mkobj.kobj);
+	kobject_put(mod->mkobj.drivers_dir);
+	kobject_put(mod->holders_dir);
+	kobject_put(&mod->mkobj.kobj);
 }
 
 /*
diff --git a/lib/kobject.c b/lib/kobject.c
index 4fce5ca..462946e 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -664,7 +664,7 @@ struct kobject *kobject_create(void)
  *
  * This function creates a kset structure dynamically and registers it
  * with sysfs.  When you are finished with this structure, call
- * kobject_unregister() and the structure will be dynamically freed when
+ * kobject_put() and the structure will be dynamically freed when
  * it is no longer being used.
  *
  * If the kobject was not able to be created, NULL will be returned.
@@ -761,7 +761,7 @@ void kset_unregister(struct kset * k)
 {
 	if (!k)
 		return;
-	kobject_unregister(&k->kobj);
+	kobject_put(&k->kobj);
 }
 
 
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 4e7f91f..9cf0538 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -447,7 +447,7 @@ void br_sysfs_delbr(struct net_device *dev)
 	struct kobject *kobj = &dev->dev.kobj;
 	struct net_bridge *br = netdev_priv(dev);
 
-	kobject_unregister(br->ifobj);
+	kobject_put(br->ifobj);
 	sysfs_remove_bin_file(kobj, &bridge_forward);
 	sysfs_remove_group(kobj, &bridge_group);
 }
diff --git a/security/inode.c b/security/inode.c
index def0cc1..acc6cf0 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -327,7 +327,7 @@ static int __init securityfs_init(void)
 
 	retval = register_filesystem(&fs_type);
 	if (retval)
-		kobject_unregister(security_kobj);
+		kobject_put(security_kobj);
 	return retval;
 }
 
-- 
1.5.3.8

