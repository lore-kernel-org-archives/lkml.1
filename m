Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYJTDTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYJTDTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJTDTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:19:39 -0400
Received: from ozlabs.org ([203.10.76.45]:33042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYJTDTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:19:38 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 19 Oct 2008 22:19:33 -0500
Subject: [PATCH 2/5] param: Fix duplicate module prefixes
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201419.33312.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of insisting each new module_param sysfs entry is unique,
handle the case where it already exists (for builtin modules).

The current code assumes that all identical prefixes are together in
the section: true for normal uses, but not necessarily so if someone
overrides MODULE_PARAM_PREFIX.  More importantly, it's not true with
the new "core_param()" code which uses "kernel" as a prefix.

This simplifies the caller for the builtin case, at a slight loss of
efficiency (we do the lookup every time to see if the directory
exists).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/module.h |    2 
 kernel/params.c        |  253 ++++++++++++++++++++++++++-----------------------
 2 files changed, 138 insertions(+), 117 deletions(-)

diff -r 0bdb21ee0640 include/linux/module.h
--- a/include/linux/module.h	Wed Aug 27 21:00:10 2008 +1000
+++ b/include/linux/module.h	Thu Aug 28 11:45:26 2008 +1000
@@ -59,6 +59,7 @@ struct module_kobject
 	struct kobject kobj;
 	struct module *mod;
 	struct kobject *drivers_dir;
+	struct module_param_attrs *mp;
 };
 
 /* These are either module local, or the kernel's dummy ones. */
@@ -241,7 +242,6 @@ struct module
 
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
-	struct module_param_attrs *param_attrs;
 	struct module_attribute *modinfo_attrs;
 	const char *version;
 	const char *srcversion;
diff -r 0bdb21ee0640 kernel/params.c
--- a/kernel/params.c	Wed Aug 27 21:00:10 2008 +1000
+++ b/kernel/params.c	Thu Aug 28 11:45:26 2008 +1000
@@ -373,6 +373,8 @@ int param_get_string(char *buffer, struc
 }
 
 /* sysfs output in /sys/modules/XYZ/parameters/ */
+#define to_module_attr(n) container_of(n, struct module_attribute, attr);
+#define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
 
 extern struct kernel_param __start___param[], __stop___param[];
 
@@ -384,6 +386,7 @@ struct param_attribute
 
 struct module_param_attrs
 {
+	unsigned int num;
 	struct attribute_group grp;
 	struct param_attribute attrs[0];
 };
@@ -434,69 +437,84 @@ static ssize_t param_attr_store(struct m
 
 #ifdef CONFIG_SYSFS
 /*
- * param_sysfs_setup - setup sysfs support for one module or KBUILD_MODNAME
- * @mk: struct module_kobject (contains parent kobject)
- * @kparam: array of struct kernel_param, the actual parameter definitions
- * @num_params: number of entries in array
- * @name_skip: offset where the parameter name start in kparam[].name. Needed for built-in "modules"
+ * add_sysfs_param - add a parameter to sysfs
+ * @mk: struct module_kobject
+ * @kparam: the actual parameter definition to add to sysfs
+ * @name: name of parameter
  *
- * Create a kobject for a (per-module) group of parameters, and create files
- * in sysfs. A pointer to the param_kobject is returned on success,
- * NULL if there's no parameter to export, or other ERR_PTR(err).
+ * Create a kobject if for a (per-module) parameter if mp NULL, and
+ * create file in sysfs.  Returns an error on out of memory.  Always cleans up
+ * if there's an error.
  */
-static __modinit struct module_param_attrs *
-param_sysfs_setup(struct module_kobject *mk,
-		  struct kernel_param *kparam,
-		  unsigned int num_params,
-		  unsigned int name_skip)
+static __modinit int add_sysfs_param(struct module_kobject *mk,
+				     struct kernel_param *kp,
+				     const char *name)
 {
-	struct module_param_attrs *mp;
-	unsigned int valid_attrs = 0;
-	unsigned int i, size[2];
-	struct param_attribute *pattr;
-	struct attribute **gattr;
-	int err;
+	struct module_param_attrs *new;
+	struct attribute **attrs;
+	int err, num;
 
-	for (i=0; i<num_params; i++) {
-		if (kparam[i].perm)
-			valid_attrs++;
+	/* We don't bother calling this with invisible parameters. */
+	BUG_ON(!kp->perm);
+
+	if (!mk->mp) {
+		num = 0;
+		attrs = NULL;
+	} else {
+		num = mk->mp->num;
+		attrs = mk->mp->grp.attrs;
 	}
 
-	if (!valid_attrs)
-		return NULL;
+	/* Enlarge. */
+	new = krealloc(mk->mp,
+		       sizeof(*mk->mp) + sizeof(mk->mp->attrs[0]) * (num+1),
+		       GFP_KERNEL);
+	if (!new) {
+		kfree(mk->mp);
+		err = -ENOMEM;
+		goto fail;
+	}
+	attrs = krealloc(attrs, sizeof(new->grp.attrs[0])*(num+2), GFP_KERNEL);
+	if (!attrs) {
+		err = -ENOMEM;
+		goto fail_free_new;
+	}
 
-	size[0] = ALIGN(sizeof(*mp) +
-			valid_attrs * sizeof(mp->attrs[0]),
-			sizeof(mp->grp.attrs[0]));
-	size[1] = (valid_attrs + 1) * sizeof(mp->grp.attrs[0]);
+	/* Sysfs wants everything zeroed. */
+	memset(new, 0, sizeof(*new));
+	memset(&new->attrs[num], 0, sizeof(new->attrs[num]));
+	memset(&attrs[num], 0, sizeof(attrs[num]));
+	new->grp.name = "parameters";
+	new->grp.attrs = attrs;
 
-	mp = kzalloc(size[0] + size[1], GFP_KERNEL);
-	if (!mp)
-		return ERR_PTR(-ENOMEM);
+	/* Tack new one on the end. */
+	new->attrs[num].param = kp;
+	new->attrs[num].mattr.show = param_attr_show;
+	new->attrs[num].mattr.store = param_attr_store;
+	new->attrs[num].mattr.attr.name = (char *)name;
+	new->attrs[num].mattr.attr.mode = kp->perm;
+	new->num = num+1;
 
-	mp->grp.name = "parameters";
-	mp->grp.attrs = (void *)mp + size[0];
+	/* Fix up all the pointers, since krealloc can move us */
+	for (num = 0; num < new->num; num++)
+		new->grp.attrs[num] = &new->attrs[num].mattr.attr;
+	new->grp.attrs[num] = NULL;
 
-	pattr = &mp->attrs[0];
-	gattr = &mp->grp.attrs[0];
-	for (i = 0; i < num_params; i++) {
-		struct kernel_param *kp = &kparam[i];
-		if (kp->perm) {
-			pattr->param = kp;
-			pattr->mattr.show = param_attr_show;
-			pattr->mattr.store = param_attr_store;
-			pattr->mattr.attr.name = (char *)&kp->name[name_skip];
-			pattr->mattr.attr.mode = kp->perm;
-			*(gattr++) = &(pattr++)->mattr.attr;
-		}
-	}
-	*gattr = NULL;
+	mk->mp = new;
+	return 0;
 
-	if ((err = sysfs_create_group(&mk->kobj, &mp->grp))) {
-		kfree(mp);
-		return ERR_PTR(err);
-	}
-	return mp;
+fail_free_new:
+	kfree(new);
+fail:
+	mk->mp = NULL;
+	return err;
+}
+
+static void free_module_param_attrs(struct module_kobject *mk)
+{
+	kfree(mk->mp->grp.attrs);
+	kfree(mk->mp);
+	mk->mp = NULL;
 }
 
 #ifdef CONFIG_MODULES
@@ -506,21 +524,33 @@ param_sysfs_setup(struct module_kobject 
  * @kparam: module parameters (array)
  * @num_params: number of module parameters
  *
- * Adds sysfs entries for module parameters, and creates a link from
- * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
+ * Adds sysfs entries for module parameters under
+ * /sys/module/[mod->name]/parameters/
  */
 int module_param_sysfs_setup(struct module *mod,
 			     struct kernel_param *kparam,
 			     unsigned int num_params)
 {
-	struct module_param_attrs *mp;
+	int i, err;
+	bool params = false;
 
-	mp = param_sysfs_setup(&mod->mkobj, kparam, num_params, 0);
-	if (IS_ERR(mp))
-		return PTR_ERR(mp);
+	for (i = 0; i < num_params; i++) {
+		if (kparam[i].perm == 0)
+			continue;
+		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
+		if (err)
+			return err;
+		params = true;
+	}
 
-	mod->param_attrs = mp;
-	return 0;
+	if (!params)
+		return 0;
+
+	/* Create the param group. */
+	err = sysfs_create_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
+	if (err)
+		free_module_param_attrs(&mod->mkobj);
+	return err;
 }
 
 /*
@@ -532,43 +562,55 @@ int module_param_sysfs_setup(struct modu
  */
 void module_param_sysfs_remove(struct module *mod)
 {
-	if (mod->param_attrs) {
-		sysfs_remove_group(&mod->mkobj.kobj,
-				   &mod->param_attrs->grp);
+	if (mod->mkobj.mp) {
+		sysfs_remove_group(&mod->mkobj.kobj, &mod->mkobj.mp->grp);
 		/* We are positive that no one is using any param
 		 * attrs at this point.  Deallocate immediately. */
-		kfree(mod->param_attrs);
-		mod->param_attrs = NULL;
+		free_module_param_attrs(&mod->mkobj);
 	}
 }
 #endif
 
-/*
- * kernel_param_sysfs_setup - wrapper for built-in params support
- */
-static void __init kernel_param_sysfs_setup(const char *name,
-					    struct kernel_param *kparam,
-					    unsigned int num_params,
-					    unsigned int name_skip)
+static void __init kernel_add_sysfs_param(const char *name,
+					  struct kernel_param *kparam,
+					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
-	int ret;
+	struct kobject *kobj;
+	int err;
 
-	mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
-	BUG_ON(!mk);
+	kobj = kset_find_obj(module_kset, name);
+	if (kobj) {
+		/* We already have one.  Remove params so we can add more. */
+		mk = to_module_kobject(kobj);
+		/* We need to remove it before adding parameters. */
+		sysfs_remove_group(&mk->kobj, &mk->mp->grp);
+	} else {
+		mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
+		BUG_ON(!mk);
 
-	mk->mod = THIS_MODULE;
-	mk->kobj.kset = module_kset;
-	ret = kobject_init_and_add(&mk->kobj, &module_ktype, NULL, "%s", name);
-	if (ret) {
-		kobject_put(&mk->kobj);
-		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
-		      "error number %d\n", name, ret);
-		printk(KERN_ERR	"The system will be unstable now.\n");
-		return;
+		mk->mod = THIS_MODULE;
+		mk->kobj.kset = module_kset;
+		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
+					   "%s", name);
+		if (err) {
+			kobject_put(&mk->kobj);
+			printk(KERN_ERR "Module '%s' failed add to sysfs, "
+			       "error number %d\n", name, err);
+			printk(KERN_ERR	"The system will be unstable now.\n");
+			return;
+		}
+		/* So that exit path is even. */
+		kobject_get(&mk->kobj);
 	}
-	param_sysfs_setup(mk, kparam, num_params, name_skip);
+
+	/* These should not fail at boot. */
+	err = add_sysfs_param(mk, kparam, kparam->name + name_skip);
+	BUG_ON(err);
+	err = sysfs_create_group(&mk->kobj, &mk->mp->grp);
+	BUG_ON(err);
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
+	kobject_put(&mk->kobj);
 }
 
 /*
@@ -579,18 +621,19 @@ static void __init kernel_param_sysfs_se
  * The "module" name (KBUILD_MODNAME) is stored before a dot, the
  * "parameter" name is stored behind a dot in kernel_param->name. So,
  * extract the "module" name for all built-in kernel_param-eters,
- * and for all who have the same, call kernel_param_sysfs_setup.
+ * and for all who have the same, call kernel_add_sysfs_param.
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp, *kp_begin = NULL;
-	unsigned int i, name_len, count = 0;
-	char modname[MODULE_NAME_LEN] = "";
+	struct kernel_param *kp;
+	unsigned int name_len;
+	char modname[MODULE_NAME_LEN];
 
-	for (i=0; i < __stop___param - __start___param; i++) {
+	for (kp = __start___param; kp < __stop___param; kp++) {
 		char *dot;
 
-		kp = &__start___param[i];
+		if (kp->perm == 0)
+			continue;
 
 		dot = strchr(kp->name, '.');
 		if (!dot) {
@@ -599,36 +642,14 @@ static void __init param_sysfs_builtin(v
 			continue;
 		}
 		name_len = dot - kp->name;
-
- 		/* new kbuild_modname? */
-		if (strlen(modname) != name_len
-		    || strncmp(modname, kp->name, name_len) != 0) {
-			/* add a new kobject for previous kernel_params. */
-			if (count)
-				kernel_param_sysfs_setup(modname,
-							 kp_begin,
-							 count,
-							 strlen(modname)+1);
-
-			strncpy(modname, kp->name, name_len);
-			modname[name_len] = '\0';
-			count = 0;
-			kp_begin = kp;
-		}
-		count++;
+		strncpy(modname, kp->name, name_len);
+		modname[name_len] = '\0';
+		kernel_add_sysfs_param(modname, kp, name_len+1);
 	}
-
-	/* last kernel_params need to be registered as well */
-	if (count)
-		kernel_param_sysfs_setup(modname, kp_begin, count,
-					 strlen(modname)+1);
 }
 
 
 /* module-related sysfs stuff */
-
-#define to_module_attr(n) container_of(n, struct module_attribute, attr);
-#define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
 
 static ssize_t module_attr_show(struct kobject *kobj,
 				struct attribute *attr,

