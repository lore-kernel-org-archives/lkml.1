Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYLAMzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYLAMzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYLAMzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:55:18 -0500
Received: from ozlabs.org ([203.10.76.45]:44005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYLAMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:55:16 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:25:08 +1030
Subject: [RFC 2/8] core_param: call these really, really early.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012325.08606.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As soon as we have command line, so even before early_param.  They
just set vars, so it makes sense to do them as early as possible.

This allows them to replace early_param, and fixes a bug in the new
cpu_alloc implementation patches which was a complete PITA to find.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/vmlinux.lds.h |    3 +++
 include/linux/moduleparam.h       |   26 ++++++++++++++++----------
 init/main.c                       |   25 ++++++++++++++++++++++++-
 kernel/params.c                   |   20 ++++++++++----------
 4 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -213,6 +213,9 @@
 		VMLINUX_SYMBOL(__start___param) = .;			\
 		*(__param)						\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
+		VMLINUX_SYMBOL(__start___core_param) = .;		\
+		*(__core_param)						\
+		VMLINUX_SYMBOL(__stop___core_param) = .;		\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -79,7 +79,7 @@ struct kparam_array
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
    writable. */
-#define __module_param_call(prefix, name, set, get, arg, perm)		\
+#define __module_param_call(prefix, section, name, set, get, arg, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -87,11 +87,12 @@ struct kparam_array
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
-    __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
+    __attribute__ ((unused, __section__(section), aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
+	__module_param_call(MODULE_PARAM_PREFIX, "__param",		      \
+			    name, set, get, arg, perm)
 
 /* Helper functions: type is byte, short, ushort, int, uint, long,
    ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
@@ -106,21 +107,22 @@ struct kparam_array
 
 #ifndef MODULE
 /**
- * core_param - define a historical core kernel parameter.
+ * core_param - define a core kernel parameter to be set very early
  * @name: the name of the cmdline and sysfs parameter (often the same as var)
  * @var: the variable
  * @type: the type (for param_set_##type and param_get_##type)
  * @perm: visibility in sysfs
  *
- * core_param is just like module_param(), but cannot be modular and
- * doesn't add a prefix (such as "printk.").  This is for compatibility
- * with __setup(), and it makes sense as truly core parameters aren't
- * tied to the particular file they're in.
+ * core_param is just like module_param(), but cannot be modular,
+ * doesn't add a prefix (such as "printk.") and is called insanely
+ * early in boot.  This is for compatibility with __setup(), and it
+ * makes sense as truly core parameters aren't tied to the particular
+ * file they're in.
  */
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
-	__module_param_call("", name, param_set_##type, param_get_##type, \
-			    &var, perm)
+	__module_param_call("", "__core_param", name, param_set_##type, \
+			    param_get_##type, &var, perm)
 #endif /* !MODULE */
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
@@ -224,4 +226,8 @@ static inline void module_param_sysfs_re
 { }
 #endif
 
+/* Created by include/asm-generic/vmlinux.lds.h */
+extern struct kernel_param __start___core_param[], __stop___core_param[];
+extern struct kernel_param __start___param[], __stop___param[];
+
 #endif /* _LINUX_MODULE_PARAMS_H */
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -256,12 +256,32 @@ static int __init loglevel(char *str)
 
 early_param("loglevel", loglevel);
 
+static bool __init is_core_param(const char *param)
+{
+	const struct kernel_param *i;
+
+	for (i = __start___core_param; i < __stop___core_param; i++)
+		if (strcmp(param, i->name) == 0)
+			return true;
+	return false;
+}
+
+/* We can ignore options not found in core params. */
+static int __init unknown_core_ok(char *param, char *val)
+{
+	return 0;
+}
+
 /*
  * Unknown boot options get handed to init, unless they look like
  * failed parameters
  */
 static int __init unknown_bootoption(char *param, char *val)
 {
+	/* Already handled as a core param? */
+	if (is_core_param(param))
+		return 0;
+
 	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
 		/* param=val or param="val"? */
@@ -537,7 +557,6 @@ asmlinkage void __init start_kernel(void
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
-	extern struct kernel_param __start___param[], __stop___param[];
 
 	smp_setup_processor_id();
 
@@ -567,6 +586,10 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
+	parse_args("Core params", command_line, __start___core_param,
+		   __stop___core_param - __start___core_param,
+		   unknown_core_ok, true);
+
 	unwind_setup();
 	setup_per_cpu_areas();
 	setup_nr_cpu_ids();
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -376,8 +376,6 @@ int param_get_string(char *buffer, struc
 #define to_module_attr(n) container_of(n, struct module_attribute, attr);
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
 
-extern struct kernel_param __start___param[], __stop___param[];
-
 struct param_attribute
 {
 	struct module_attribute mattr;
@@ -636,15 +634,19 @@ static void __init param_sysfs_builtin(v
 			continue;
 
 		dot = strchr(kp->name, '.');
-		if (!dot) {
-			/* This happens for core_param() */
-			strcpy(modname, "kernel");
-			name_len = 0;
-		} else {
-			name_len = dot - kp->name + 1;
-			strlcpy(modname, kp->name, name_len);
-		}
+		/* FIXME: USB code sets prefix to "".  Should use core_param */
+		if (!dot)
+			continue;
+		name_len = dot - kp->name + 1;
+		strlcpy(modname, kp->name, name_len);
 		kernel_add_sysfs_param(modname, kp, name_len);
+	}
+
+	for (kp = __start___core_param; kp < __stop___core_param; kp++) {
+		if (kp->perm == 0)
+			continue;
+
+		kernel_add_sysfs_param("kernel", kp, 0);
 	}
 }
 


