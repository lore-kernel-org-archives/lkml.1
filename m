Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZBIH5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZBIH5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZBIH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:56:14 -0500
Received: from ozlabs.org ([203.10.76.45]:34169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBIH4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:56:13 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 09 Feb 2009 18:22:26 +1030
CC: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 3/4] module_param: allow 'bool' module_params to be bool, not just (unsigned) int.
Message-Id: <20090209075611.81991DDDA3@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For historical reasons, 'bool' parameters must be an int, not a bool.
But there are around 600 users, so a conversion seems like useless churn.
Be a little clever about it:

1) Put a size arg in struct kernel_param,
2) Allow int, unsigned int or bool in param_check_bool(),
3) Use the size to know what to do in the set and get functions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -38,7 +38,8 @@ typedef int (*param_get_fn)(char *buffer
 
 struct kernel_param {
 	const char *name;
-	unsigned int perm;
+	u16 perm;
+	u16 size;
 	param_set_fn set;
 	param_get_fn get;
 	union {
@@ -79,7 +80,7 @@ struct kparam_array
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
    writable. */
-#define __module_param_call(prefix, name, set, get, arg, perm)		\
+#define __module_param_call(prefix, name, set, get, arg, asize, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -88,10 +89,11 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, set, get, { arg } }
+	= { __param_str_##name, perm, asize, set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
+	__module_param_call(MODULE_PARAM_PREFIX,			      \
+			    name, set, get, arg, sizeof(*(arg)), perm)
 
 /* Helper functions: type is byte, short, ushort, int, uint, long,
    ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
@@ -120,15 +122,16 @@ struct kparam_array
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", name, param_set_##type, param_get_##type, \
-			    &var, perm)
+			    &var, sizeof(var), perm)
 #endif /* !MODULE */
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
 	static const struct kparam_string __param_string_##name		\
 		= { len, string };					\
-	module_param_call(name, param_set_copystring, param_get_string,	\
-			  .str = &__param_string_##name, perm);		\
+	__module_param_call(MODULE_PARAM_PREFIX, name,			\
+			    param_set_copystring, param_get_string,	\
+			    .str = &__param_string_##name, 0, perm);	\
 	__MODULE_PARM_TYPE(name, "string")
 
 /* Called on module insert or kernel boot */
@@ -176,9 +179,14 @@ extern int param_get_charp(char *buffer,
 extern int param_get_charp(char *buffer, struct kernel_param *kp);
 #define param_check_charp(name, p) __param_check(name, p, char *)
 
+/* For historical reasons "bool" parameters can be "int". */
 extern int param_set_bool(const char *val, struct kernel_param *kp);
 extern int param_get_bool(char *buffer, struct kernel_param *kp);
-#define param_check_bool(name, p) __param_check(name, p, int)
+#define param_check_bool(name, p)					\
+	static inline void __check_##name(void)				\
+	{								\
+		(void)(union { int *i; unsigned *u; bool *b; })(p);	\
+	}
 
 /* #include <stdbool.h> transforms module_param(foo, bool, 0). */
 #define param_set__Bool param_set_bool
@@ -194,8 +202,10 @@ extern int param_get_invbool(char *buffe
 	static const struct kparam_array __param_arr_##name		\
 	= { ARRAY_SIZE(array), nump, param_set_##type, param_get_##type,\
 	    sizeof(array[0]), array };					\
-	module_param_call(name, param_array_set, param_array_get, 	\
-			  .arr = &__param_arr_##name, perm);		\
+	__module_param_call(MODULE_PARAM_PREFIX, name,			\
+			    param_array_set, param_array_get,		\
+			    .arr = &__param_arr_##name,			\
+			    sizeof(array[0]), perm);			\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 #define module_param_array(name, type, nump, perm)		\
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -226,6 +226,7 @@ int param_get_charp(char *buffer, struct
 	return sprintf(buffer, "%s", *((char **)kp->arg));
 }
 
+/* Actually could be a bool or an int. */
 int param_set_bool(const char *val, struct kernel_param *kp)
 {
 	/* No equals means "set"... */
@@ -234,10 +235,10 @@ int param_set_bool(const char *val, stru
 	/* One of =[yYnN01] */
 	switch (val[0]) {
 	case 'y': case 'Y': case '1':
-		*(int *)kp->arg = 1;
+		memset(kp->arg, 0xff, kp->size);
 		return 0;
 	case 'n': case 'N': case '0':
-		*(int *)kp->arg = 0;
+		memset(kp->arg, 0, kp->size);
 		return 0;
 	}
 	return -EINVAL;
@@ -245,16 +246,25 @@ int param_set_bool(const char *val, stru
 
 int param_get_bool(char *buffer, struct kernel_param *kp)
 {
+	bool val;
+	if (sizeof(kp->arg) == sizeof(int))
+		val = *(int *)kp->arg;
+	else
+		val = *(bool *)kp->arg;
+
 	/* Y and N chosen as being relatively non-coder friendly */
-	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'Y' : 'N');
+	return sprintf(buffer, "%c", val ? 'Y' : 'N');
 }
 
+/* This one must be bool. */
 int param_set_invbool(const char *val, struct kernel_param *kp)
 {
-	int boolval, ret;
+	int ret;
+	bool boolval;
 	struct kernel_param dummy;
 
 	dummy.arg = &boolval;
+	dummy.size = sizeof(boolval);
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
 		*(bool *)kp->arg = !boolval;

