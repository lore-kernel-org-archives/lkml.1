Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXBWXTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXBWXTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933278AbXBWXTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:19:01 -0500
Received: from ns1.suse.de ([195.135.220.2]:54417 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXBWXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 9/9] Revert "Driver core: let request_module() send a /sys/modules/kmod/-uevent"
Date: Fri, 23 Feb 2007 15:15:56 -0800
Message-Id: <11722725833599-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <1172272579116-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de> <1172272565581-git-send-email-gregkh@suse.de> <1172272569255-git-send-email-gregkh@suse.de> <11722725722238-git-send-email-gregkh@suse.de> <11722725761560-git-send-email-gregkh@suse.de> <1172272579116-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c353c3fb0700a3c17ea2b0237710a184232ccd7f.

It turns out that we end up with a loop trying to load the unix
module and calling netfilter to do that.  Will redo the patch
later to not have this loop.

Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kmod.h |    2 -
 kernel/kmod.c        |  120 --------------------------------------------------
 kernel/module.c      |   26 ++++-------
 kernel/params.c      |    1 -
 4 files changed, 10 insertions(+), 139 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index cc8e674..10f505c 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -28,10 +28,8 @@
 #ifdef CONFIG_KMOD
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
-extern void kmod_sysfs_init(void);
 extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
 #else
-static inline void kmod_sysfs_init(void) {};
 static inline int request_module(const char * name, ...) { return -ENOSYS; }
 #endif
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index f936108..7962761 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -36,8 +36,6 @@
 #include <linux/resource.h>
 #include <asm/uaccess.h>
 
-extern int delete_module(const char *name, unsigned int flags);
-
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
@@ -48,7 +46,6 @@ static struct workqueue_struct *khelper_wq;
 	modprobe_path is set via /proc/sys.
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
-static struct module_kobject kmod_mk;
 
 /**
  * request_module - try to load a kernel module
@@ -78,11 +75,6 @@ int request_module(const char *fmt, ...)
 	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
-	char modalias[16 + MODULE_NAME_LEN] = "MODALIAS=";
-	char *uevent_envp[2] = {
-		modalias,
-		NULL
-	};
 
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
@@ -90,12 +82,6 @@ int request_module(const char *fmt, ...)
 	if (ret >= MODULE_NAME_LEN)
 		return -ENAMETOOLONG;
 
-	strcpy(&modalias[strlen("MODALIAS=")], module_name);
-	kobject_uevent_env(&kmod_mk.kobj, KOBJ_CHANGE, uevent_envp);
-
-	if (modprobe_path[0] == '\0')
-		goto out;
-
 	/* If modprobe needs a service that is in a module, we get a recursive
 	 * loop.  Limit the number of running kmod threads to max_threads/2 or
 	 * MAX_KMOD_CONCURRENT, whichever is the smaller.  A cleaner method
@@ -122,115 +108,9 @@ int request_module(const char *fmt, ...)
 
 	ret = call_usermodehelper(modprobe_path, argv, envp, 1);
 	atomic_dec(&kmod_concurrent);
-out:
 	return ret;
 }
 EXPORT_SYMBOL(request_module);
-
-static ssize_t store_mod_request(struct module_attribute *mattr,
-				 struct module *mod,
-			      const char *buffer, size_t count)
-{
-	char name[MODULE_NAME_LEN];
-	int ret;
-
-	if (count < 1 || count+1 > MODULE_NAME_LEN)
-		return -EINVAL;
-	memcpy(name, buffer, count);
-	name[count] = '\0';
-	if (name[count-1] == '\n')
-		name[count-1] = '\0';
-
-	ret = request_module(name);
-	if (ret < 0)
-		return ret;
-	return count;
-}
-
-static struct module_attribute mod_request = {
-	.attr = { .name = "mod_request", .mode = S_IWUSR, .owner = THIS_MODULE },
-	.store = store_mod_request,
-};
-
-#ifdef CONFIG_MODULE_UNLOAD
-static ssize_t store_mod_unload(struct module_attribute *mattr,
-			    struct module *mod,
-			    const char *buffer, size_t count)
-{
-	char name[MODULE_NAME_LEN];
-	int ret;
-
-	if (count < 1 || count+1 > MODULE_NAME_LEN)
-		return -EINVAL;
-	memcpy(name, buffer, count);
-	name[count] = '\0';
-	if (name[count-1] == '\n')
-		name[count-1] = '\0';
-
-	ret = delete_module(name, O_NONBLOCK);
-	if (ret < 0)
-		return ret;
-	return count;
-}
-
-static struct module_attribute mod_unload = {
-	.attr = { .name = "mod_unload", .mode = S_IWUSR, .owner = THIS_MODULE },
-	.store = store_mod_unload,
-};
-#endif
-
-static ssize_t show_mod_request_helper(struct module_attribute *mattr,
-				       struct module *mod,
-				       char *buffer)
-{
-	return sprintf(buffer, "%s\n", modprobe_path);
-}
-
-static ssize_t store_mod_request_helper(struct module_attribute *mattr,
-					struct module *mod,
-					const char *buffer, size_t count)
-{
-	if (count < 1 || count+1 > KMOD_PATH_LEN)
-		return -EINVAL;
-	memcpy(modprobe_path, buffer, count);
-	modprobe_path[count] = '\0';
-	if (modprobe_path[count-1] == '\n')
-		modprobe_path[count-1] = '\0';
-	return count;
-}
-
-static struct module_attribute mod_request_helper = {
-	.attr = {
-		.name = "mod_request_helper",
-		.mode = S_IWUSR | S_IRUGO,
-		.owner = THIS_MODULE
-	},
-	.show = show_mod_request_helper,
-	.store = store_mod_request_helper,
-};
-
-void __init kmod_sysfs_init(void)
-{
-	int ret;
-
-	kmod_mk.mod = THIS_MODULE;
-	kobj_set_kset_s(&kmod_mk, module_subsys);
-	kobject_set_name(&kmod_mk.kobj, "kmod");
-	kobject_init(&kmod_mk.kobj);
-	ret = kobject_add(&kmod_mk.kobj);
-	if (ret < 0)
-		goto out;
-
-	ret = sysfs_create_file(&kmod_mk.kobj, &mod_request_helper.attr);
-	ret = sysfs_create_file(&kmod_mk.kobj, &mod_request.attr);
-#ifdef CONFIG_MODULE_UNLOAD
-	ret = sysfs_create_file(&kmod_mk.kobj, &mod_unload.attr);
-#endif
-
-	kobject_uevent(&kmod_mk.kobj, KOBJ_ADD);
-out:
-	return;
-}
 #endif /* CONFIG_KMOD */
 
 struct subprocess_info {
diff --git a/kernel/module.c b/kernel/module.c
index 1ecf081..f77e893 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -653,11 +653,20 @@ static void wait_for_zero_refcount(struct module *mod)
 	mutex_lock(&module_mutex);
 }
 
-int delete_module(const char *name, unsigned int flags)
+asmlinkage long
+sys_delete_module(const char __user *name_user, unsigned int flags)
 {
 	struct module *mod;
+	char name[MODULE_NAME_LEN];
 	int ret, forced = 0;
 
+	if (!capable(CAP_SYS_MODULE))
+		return -EPERM;
+
+	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
+		return -EFAULT;
+	name[MODULE_NAME_LEN-1] = '\0';
+
 	if (mutex_lock_interruptible(&module_mutex) != 0)
 		return -EINTR;
 
@@ -718,21 +727,6 @@ int delete_module(const char *name, unsigned int flags)
 	return ret;
 }
 
-asmlinkage long
-sys_delete_module(const char __user *name_user, unsigned int flags)
-{
-	char name[MODULE_NAME_LEN];
-
-	if (!capable(CAP_SYS_MODULE))
-		return -EPERM;
-
-	if (strncpy_from_user(name, name_user, MODULE_NAME_LEN-1) < 0)
-		return -EFAULT;
-	name[MODULE_NAME_LEN-1] = '\0';
-
-	return delete_module(name, flags);
-}
-
 static void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
diff --git a/kernel/params.c b/kernel/params.c
index 7a75157..e265b13 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -707,7 +707,6 @@ static int __init param_sysfs_init(void)
 	}
 
 	param_sysfs_builtin();
-	kmod_sysfs_init();
 
 	return 0;
 }
-- 
1.5.0.1

