Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZC1NYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZC1NYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbZC1NYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:24:08 -0400
Received: from ozlabs.org ([203.10.76.45]:52797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbZC1NYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:24:06 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 28 Mar 2009 23:54:00 +1030
Subject: [PATCH 4/5] module_param: allow 'bool' module_params to be bool, not just int.
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282354.00819.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: API cleanup

For historical reasons, 'bool' parameters must be an int, not a bool.
But there are around 600 users, so a conversion seems like useless churn.

So we use __same_type() to distinguish, and handle both cases (we could
avoid this and treat every parameter as a bool, but that would break if any
arch had sizeof(bool) != sizeof(int).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |   32 +++++++++++++++++++++++---------
 kernel/params.c             |   33 ++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -38,6 +38,7 @@ typedef int (*param_get_fn)(char *buffer
 
 /* Flag bits for kernel_param.flags */
 #define KPARAM_KMALLOCED	1
+#define KPARAM_ISBOOL		2
 
 struct kernel_param {
 	const char *name;
@@ -83,7 +84,7 @@ struct kparam_array
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
    writable. */
-#define __module_param_call(prefix, name, set, get, arg, perm)		\
+#define __module_param_call(prefix, name, set, get, arg, isbool, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -92,10 +93,13 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, 0, set, get, { arg } }
+	= { __param_str_##name, perm, isbool ? KPARAM_ISBOOL : 0,	\
+	    set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
+	__module_param_call(MODULE_PARAM_PREFIX,			      \
+			    name, set, get, arg,			      \
+			    __same_type(*(arg), bool), perm)
 
 /* Helper functions: type is byte, short, ushort, int, uint, long,
    ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
@@ -124,15 +128,16 @@ struct kparam_array
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", name, param_set_##type, param_get_##type, \
-			    &var, perm)
+			    &var, __same_type(var, bool), perm)
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
@@ -190,9 +195,16 @@ extern int param_get_charp(char *buffer,
 extern int param_get_charp(char *buffer, struct kernel_param *kp);
 #define param_check_charp(name, p) __param_check(name, p, char *)
 
+/* For historical reasons "bool" parameters can be (unsigned) "int". */
 extern int param_set_bool(const char *val, struct kernel_param *kp);
 extern int param_get_bool(char *buffer, struct kernel_param *kp);
-#define param_check_bool(name, p) __param_check(name, p, int)
+#define param_check_bool(name, p)					\
+	static inline void __check_##name(void)				\
+	{								\
+		BUILD_BUG_ON(!__same_type(*(p), bool) &&		\
+			     !__same_type(*(p), unsigned int) &&	\
+			     !__same_type(*(p), int));			\
+	}
 
 extern int param_set_invbool(const char *val, struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);
@@ -203,8 +215,10 @@ extern int param_get_invbool(char *buffe
 	static const struct kparam_array __param_arr_##name		\
 	= { ARRAY_SIZE(array), nump, param_set_##type, param_get_##type,\
 	    sizeof(array[0]), array };					\
-	module_param_call(name, param_array_set, param_array_get, 	\
-			  .arr = &__param_arr_##name, perm);		\
+	__module_param_call(MODULE_PARAM_PREFIX, name,			\
+			    param_array_set, param_array_get,		\
+			    .arr = &__param_arr_##name,			\
+			    __same_type(array[0], bool), perm);		\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 #define module_param_array(name, type, nump, perm)		\
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -238,35 +238,54 @@ int param_get_charp(char *buffer, struct
 	return sprintf(buffer, "%s", *((char **)kp->arg));
 }
 
+/* Actually could be a bool or an int, for historical reasons. */
 int param_set_bool(const char *val, struct kernel_param *kp)
 {
+	bool v;
+
 	/* No equals means "set"... */
 	if (!val) val = "1";
 
 	/* One of =[yYnN01] */
 	switch (val[0]) {
 	case 'y': case 'Y': case '1':
-		*(int *)kp->arg = 1;
-		return 0;
+		v = true;
+		break;
 	case 'n': case 'N': case '0':
-		*(int *)kp->arg = 0;
-		return 0;
+		v = false;
+		break;
+	default:
+		return -EINVAL;
 	}
-	return -EINVAL;
+
+	if (kp->flags & KPARAM_ISBOOL)
+		*(bool *)kp->arg = v;
+	else
+		*(int *)kp->arg = v;
+	return 0;
 }
 
 int param_get_bool(char *buffer, struct kernel_param *kp)
 {
+	bool val;
+	if (kp->flags & KPARAM_ISBOOL)
+		val = *(bool *)kp->arg;
+	else
+		val = *(int *)kp->arg;
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
+	dummy.flags = KPARAM_ISBOOL;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
 		*(bool *)kp->arg = !boolval;

