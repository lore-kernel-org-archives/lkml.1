Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYGaD7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYGaD7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYGaD7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:59:41 -0400
Received: from ozlabs.org ([203.10.76.45]:42232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYGaD7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:59:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Core kernel parameters and /sys/parameters?
Date: Thu, 31 Jul 2008 13:59:02 +1000
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311359.02561.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

   Was looking at implementing "core_param" for things like "initcall_debug"
(ie. params with no prefix), and wanted to put them in sysfs of course.  I
hacked in a new "kernel" dir, but /sys/module/kernel/parameters/ is a bit
of an odd place for it to end up in.

   I noticed this comment in params.c:

 * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/

I like the idea of /sys/parameters/ much better (perhaps even with core
parameters at the top level).  Is this obsolete?  Planned?

Thanks,
Rusty.

diff -r e7ea7e2ee243 include/linux/moduleparam.h
--- a/include/linux/moduleparam.h	Thu Jul 31 11:06:10 2008 +1000
+++ b/include/linux/moduleparam.h	Thu Jul 31 13:58:16 2008 +1000
@@ -99,6 +99,25 @@ struct kparam_array
 
 #define module_param(name, type, perm)				\
 	module_param_named(name, name, type, perm)
+
+#ifndef MODULE
+/**
+ * core_param - define a historical core kernel parameter.
+ * @name: the name of the cmdline and sysfs parameter (often the same as var)
+ * @var: the variable
+ * @type: the type (for param_set_##type and param_get_##type)
+ * @perm: visibility in sysfs
+ *
+ * core_param is just like module_param(), but cannot be modular and
+ * doesn't add a prefix (such as "printk.").  This is for compatibility
+ * with __setup(), and it makes sense that truly core parameters aren't
+ * tied to the particular file they're in.
+ */
+#define core_param(name, var, type, perm)				\
+	param_check_##type(name, &(var));				\
+	__module_param_call("", name, param_set_##type, param_get_##type, \
+			    &var, perm)
+#endif /* !MODULE */
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
diff -r e7ea7e2ee243 kernel/params.c
--- a/kernel/params.c	Thu Jul 31 11:06:10 2008 +1000
+++ b/kernel/params.c	Thu Jul 31 13:58:16 2008 +1000
@@ -584,12 +584,14 @@ static void __init param_sysfs_builtin(v
 static void __init param_sysfs_builtin(void)
 {
 	struct kernel_param *kp, *kp_begin = NULL;
-	unsigned int i, name_len, count = 0;
+	unsigned int i, name_len, skip, count = 0;
 	char modname[MODULE_NAME_LEN + 1] = "";
+	char core[] = "kernel";
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
 		size_t max_name_len;
+		const char *name;
 
 		kp = &__start___param[i];
 		max_name_len =
@@ -597,25 +599,28 @@ static void __init param_sysfs_builtin(v
 
 		dot = memchr(kp->name, '.', max_name_len);
 		if (!dot) {
-			DEBUGP("couldn't find period in first %d characters "
-			       "of %s\n", MODULE_NAME_LEN, kp->name);
-			continue;
+			name = core;
+			name_len = strlen(name);
+		} else {
+			name = kp->name;
+			name_len = dot - kp->name;
 		}
-		name_len = dot - kp->name;
 
  		/* new kbuild_modname? */
 		if (strlen(modname) != name_len
-		    || strncmp(modname, kp->name, name_len) != 0) {
+		    || strncmp(modname, name, name_len) != 0) {
 			/* add a new kobject for previous kernel_params. */
 			if (count)
-				kernel_param_sysfs_setup(modname,
-							 kp_begin,
-							 count,
-							 strlen(modname)+1);
+				kernel_param_sysfs_setup(modname, kp_begin,
+							 count, skip);
 
-			strncpy(modname, kp->name, name_len);
+			strncpy(modname, name, name_len);
 			modname[name_len] = '\0';
 			count = 0;
+			if (!dot)
+				skip = 0;
+			else
+				skip = name_len + 1;
 			kp_begin = kp;
 		}
 		count++;
@@ -623,8 +628,7 @@ static void __init param_sysfs_builtin(v
 
 	/* last kernel_params need to be registered as well */
 	if (count)
-		kernel_param_sysfs_setup(modname, kp_begin, count,
-					 strlen(modname)+1);
+		kernel_param_sysfs_setup(modname, kp_begin, count, skip);
 }
 
 
