Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbYAYI1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbYAYI1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbYAYIBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:53708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <teheo@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 156/196] sysfs: fix /sys/module/*/holders after sysfs logic change
Date: Thu, 24 Jan 2008 23:33:05 -0800
Message-Id: <1201246425-5058-77-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Sysfs symlinks now require fully registered kobjects as a target,
otherwise the call to create a symlink will fail. Here we register
the kobject before we request the symlink in the holders directory.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index dc4d3f5..0ae8117 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1227,6 +1227,8 @@ int mod_sysfs_init(struct module *mod)
 
 	kobject_init(&mod->mkobj.kobj);
 
+	/* delay uevent until full sysfs population */
+	err = kobject_add(&mod->mkobj.kobj);
 out:
 	return err;
 }
@@ -1237,11 +1239,6 @@ int mod_sysfs_setup(struct module *mod,
 {
 	int err;
 
-	/* delay uevent until full sysfs population */
-	err = kobject_add(&mod->mkobj.kobj);
-	if (err)
-		goto out;
-
 	mod->holders_dir = kobject_create_and_add("holders", &mod->mkobj.kobj);
 	if (!mod->holders_dir) {
 		err = -ENOMEM;
@@ -1266,7 +1263,6 @@ out_unreg_holders:
 out_unreg:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
-out:
 	return err;
 }
 #endif
@@ -1883,10 +1879,10 @@ static struct module *load_module(void __user *umod,
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
 
-	/* Initialize kobject, so we can reference it. */
+	/* add kobject, so we can reference it. */
 	err = mod_sysfs_init(mod);
 	if (err)
-		goto cleanup;
+		goto free_unload;
 
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
@@ -2056,6 +2052,9 @@ static struct module *load_module(void __user *umod,
  arch_cleanup:
 	module_arch_cleanup(mod);
  cleanup:
+	kobject_del(&mod->mkobj.kobj);
+	kobject_put(&mod->mkobj.kobj);
+ free_unload:
 	module_unload_free(mod);
 	module_free(mod, mod->module_init);
  free_core:
-- 
1.5.3.8

