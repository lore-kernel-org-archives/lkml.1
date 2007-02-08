Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXBHAcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXBHAcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422874AbXBHAcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:56379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422904AbXBHAcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:09 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/28] /sys/modules/*/holders
Date: Wed,  7 Feb 2007 16:30:00 -0800
Message-Id: <11708946601643-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946561557-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

  /sys/module/usbcore/
  |-- drivers
  |   |-- usb:hub -> ../../../subsystem/usb/drivers/hub
  |   |-- usb:usb -> ../../../subsystem/usb/drivers/usb
  |   `-- usb:usbfs -> ../../../subsystem/usb/drivers/usbfs
  |-- holders
  |   |-- ehci_hcd -> ../../../module/ehci_hcd
  |   |-- uhci_hcd -> ../../../module/uhci_hcd
  |   |-- usb_storage -> ../../../module/usb_storage
  |   `-- usbhid -> ../../../module/usbhid
  |-- initstate

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/module.h |    1 +
 kernel/module.c        |   37 +++++++++++++++++++++++++++++++------
 kernel/params.c        |   17 ++++++++++++++++-
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 90dc254..419d3ef 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -264,6 +264,7 @@ struct module
 	struct module_attribute *modinfo_attrs;
 	const char *version;
 	const char *srcversion;
+	struct kobject *holders_dir;
 
 	/* Exported symbols */
 	const struct kernel_symbol *syms;
diff --git a/kernel/module.c b/kernel/module.c
index 9de4209..8a94e05 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -537,6 +537,8 @@ static int already_uses(struct module *a, struct module *b)
 static int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
+	int no_warn;
+
 	if (b == NULL || already_uses(a, b)) return 1;
 
 	if (!strong_try_module_get(b))
@@ -552,6 +554,7 @@ static int use_module(struct module *a, struct module *b)
 
 	use->module_which_uses = a;
 	list_add(&use->list, &b->modules_which_use_me);
+	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
 
@@ -569,6 +572,7 @@ static void module_unload_free(struct module *mod)
 				module_put(i);
 				list_del(&use->list);
 				kfree(use);
+				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
 				break;
 			}
@@ -1106,9 +1110,7 @@ static void module_remove_modinfo_attrs(struct module *mod)
 	kfree(mod->modinfo_attrs);
 }
 
-static int mod_sysfs_setup(struct module *mod,
-			   struct kernel_param *kparam,
-			   unsigned int num_params)
+static int mod_sysfs_init(struct module *mod)
 {
 	int err;
 
@@ -1125,15 +1127,30 @@ static int mod_sysfs_setup(struct module *mod,
 	kobj_set_kset_s(&mod->mkobj, module_subsys);
 	mod->mkobj.mod = mod;
 
-	/* delay uevent until full sysfs population */
 	kobject_init(&mod->mkobj.kobj);
+
+out:
+	return err;
+}
+
+static int mod_sysfs_setup(struct module *mod,
+			   struct kernel_param *kparam,
+			   unsigned int num_params)
+{
+	int err;
+
+	/* delay uevent until full sysfs population */
 	err = kobject_add(&mod->mkobj.kobj);
 	if (err)
 		goto out;
 
+	mod->holders_dir = kobject_add_dir(&mod->mkobj.kobj, "holders");
+	if (!mod->holders_dir)
+		goto out_unreg;
+
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
-		goto out_unreg_drivers;
+		goto out_unreg_holders;
 
 	err = module_add_modinfo_attrs(mod);
 	if (err)
@@ -1144,7 +1161,9 @@ static int mod_sysfs_setup(struct module *mod,
 
 out_unreg_param:
 	module_param_sysfs_remove(mod);
-out_unreg_drivers:
+out_unreg_holders:
+	kobject_unregister(mod->holders_dir);
+out_unreg:
 	kobject_del(&mod->mkobj.kobj);
 	kobject_put(&mod->mkobj.kobj);
 out:
@@ -1157,6 +1176,8 @@ static void mod_kobject_remove(struct module *mod)
 	module_param_sysfs_remove(mod);
 	if (mod->mkobj.drivers_dir)
 		kobject_unregister(mod->mkobj.drivers_dir);
+	if (mod->holders_dir)
+		kobject_unregister(mod->holders_dir);
 
 	kobject_unregister(&mod->mkobj.kobj);
 }
@@ -1761,6 +1782,10 @@ static struct module *load_module(void __user *umod,
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);
 
+	/* Initialize kobject, so we can reference it. */
+	if (mod_sysfs_init(mod) != 0)
+		goto cleanup;
+
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
diff --git a/kernel/params.c b/kernel/params.c
index cbaac85..553cf7d 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -30,6 +30,8 @@
 #define DEBUGP(fmt, a...)
 #endif
 
+static struct kobj_type module_ktype;
+
 static inline char dash2underscore(char c)
 {
 	if (c == '-')
@@ -671,6 +673,19 @@ static struct sysfs_ops module_sysfs_ops = {
 	.store = module_attr_store,
 };
 
+static int uevent_filter(struct kset *kset, struct kobject *kobj)
+{
+	struct kobj_type *ktype = get_ktype(kobj);
+
+	if (ktype == &module_ktype)
+		return 1;
+	return 0;
+}
+
+static struct kset_uevent_ops module_uevent_ops = {
+	.filter = uevent_filter,
+};
+
 #else
 static struct sysfs_ops module_sysfs_ops = {
 	.show = NULL,
@@ -682,7 +697,7 @@ static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
 };
 
-decl_subsys(module, &module_ktype, NULL);
+decl_subsys(module, &module_ktype, &module_uevent_ops);
 
 /*
  * param_sysfs_init - wrapper for built-in params support
-- 
1.4.4.4

