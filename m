Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZDHFZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZDHFZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbZDHFYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:24:19 -0400
Received: from ozlabs.org ([203.10.76.45]:41424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761987AbZDHFYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:24:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module param bool changes
Date: Wed, 8 Apr 2009 14:54:02 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Brad Douglas <brad@neruo.com>,
       Michal Januszewski <spock@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904081454.03276.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 577c9c456f0e1371cbade38eaf91ae8e8a308555:
  Linus Torvalds (1):
        Linux 2.6.30-rc1

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Rusty Russell (5):
      module_param: invbool should take a 'bool', not an 'int'
      module_param: split perm field into flags and perm
      module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
      module_param: allow 'bool' module_params to be bool, not just int.
      uvesafb: improve parameter handling.

 drivers/video/aty/aty128fb.c |    2 +-
 drivers/video/uvesafb.c      |   10 +++-----
 include/linux/compiler.h     |    5 ++++
 include/linux/moduleparam.h  |   40 ++++++++++++++++++++++++++----------
 kernel/params.c              |   46 ++++++++++++++++++++++++++++-------------
 5 files changed, 70 insertions(+), 33 deletions(-)

commit 3d583275d99febf4f618c2de4e91be04246fc279
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Apr 8 14:46:44 2009 -0600

    module_param: invbool should take a 'bool', not an 'int'
    
    It takes an 'int' for historical reasons, and there are only two
    users: simply switch it over to bool.
    
    The other user (uvesafb.c) will get a (harmless-on-x86) warning until
    the next patch is applied.
    
    Cc: Brad Douglas <brad@neruo.com>
    Cc: Michal Januszewski <spock@gentoo.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/video/aty/aty128fb.c |    2 +-
 include/linux/moduleparam.h  |    2 +-
 kernel/params.c              |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

commit dc040c84c89b14e01b530feab719a2f9119f44ab
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Apr 8 14:46:45 2009 -0600

    module_param: split perm field into flags and perm
    
    Impact: cleanup
    
    Rather than hack KPARAM_KMALLOCED into the perm field, separate it out.
    Since the perm field was 32 bits and only needs 16, we don't add bloat.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/moduleparam.h |    8 ++++++--
 kernel/params.c             |    9 +++------
 2 files changed, 9 insertions(+), 8 deletions(-)

commit d9d6b209791385c16319a706989fc9a201684314
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Apr 8 14:46:46 2009 -0600

    module_param: add __same_type convenience wrapper for __builtin_types_compatible_p
    
    Impact: new API
    
    __builtin_types_compatible_p() is a little awkward to use: it takes two
    types rather than types or variables, and it's just damn long.
    
    (typeof(type) == type, so this works on types as well as vars).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/compiler.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

commit d2cc6a7caa0eb1dcab139f94b8318b80512b0b49
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Apr 8 14:46:48 2009 -0600

    module_param: allow 'bool' module_params to be bool, not just int.
    
    Impact: API cleanup
    
    For historical reasons, 'bool' parameters must be an int, not a bool.
    But there are around 600 users, so a conversion seems like useless churn.
    
    So we use __same_type() to distinguish, and handle both cases (we could
    avoid this and treat every parameter as a bool, but that would break if any
    arch had sizeof(bool) != sizeof(int).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/moduleparam.h |   32 +++++++++++++++++++++++---------
 kernel/params.c             |   33 ++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 16 deletions(-)

commit fba9fb4edf865c6debd6a88f3cb379d140905ff3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Apr 8 14:46:48 2009 -0600

    uvesafb: improve parameter handling.
    
    1) Now module_param(..., invbool, ...) requires a bool, and similarly
       module_param(..., bool, ...) allows it, change pmi_setpal to a bool.
    2) #define param_get_scroll to NULL, since it can never be called (perm
       argument to module_param_named is 0).
    3) Return -EINVAL from param_set_scroll if the value is bad, so it's
       reported.
    
    Note that I don't think the old fb_get_options() is required for new
    drivers: the parameters automatically work as uvesafb.XXX=... anyway.
    
    Cc: Michal Januszewski <spock@gentoo.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 drivers/video/uvesafb.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 35e8eb0..e4e4d43 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -354,7 +354,7 @@ static int default_crt_on __devinitdata = 0;
 static int default_lcd_on __devinitdata = 1;
 
 #ifdef CONFIG_MTRR
-static int mtrr = 1;
+static bool mtrr = true;
 #endif
 
 #ifdef CONFIG_PMAC_BACKLIGHT
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 0b370ae..4046373 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -45,7 +45,7 @@ static struct fb_fix_screeninfo uvesafb_fix __devinitdata = {
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
 static int ypan		= 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
-static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
+static bool pmi_setpal	__devinitdata = true; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */
 static int vram_remap	__devinitdata; /* set amt. of memory to be used */
@@ -2017,11 +2017,7 @@ static void __devexit uvesafb_exit(void)
 
 module_exit(uvesafb_exit);
 
-static int param_get_scroll(char *buffer, struct kernel_param *kp)
-{
-	return 0;
-}
-
+#define param_get_scroll NULL
 static int param_set_scroll(const char *val, struct kernel_param *kp)
 {
 	ypan = 0;
@@ -2032,6 +2028,8 @@ static int param_set_scroll(const char *val, struct kernel_param *kp)
 		ypan = 1;
 	else if (!strcmp(val, "ywrap"))
 		ypan = 2;
+	else
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 37bcb50..04fb513 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -261,6 +261,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __section(S) __attribute__ ((__section__(#S)))
 #endif
 
+/* Are two types/vars the same type (ignoring qualifiers)? */
+#ifndef __same_type
+# define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
+#endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index a4f0b93..6547c3c 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -36,9 +36,14 @@ typedef int (*param_set_fn)(const char *val, struct kernel_param *kp);
 /* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
 typedef int (*param_get_fn)(char *buffer, struct kernel_param *kp);
 
+/* Flag bits for kernel_param.flags */
+#define KPARAM_KMALLOCED	1
+#define KPARAM_ISBOOL		2
+
 struct kernel_param {
 	const char *name;
-	unsigned int perm;
+	u16 perm;
+	u16 flags;
 	param_set_fn set;
 	param_get_fn get;
 	union {
@@ -79,7 +84,7 @@ struct kparam_array
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
    writable. */
-#define __module_param_call(prefix, name, set, get, arg, perm)		\
+#define __module_param_call(prefix, name, set, get, arg, isbool, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -88,10 +93,13 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, set, get, { arg } }
+	= { __param_str_##name, perm, isbool ? KPARAM_ISBOOL : 0,	\
+	    set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
+	__module_param_call(MODULE_PARAM_PREFIX,			      \
+			    name, set, get, arg,			      \
+			    __same_type(*(arg), bool), perm)
 
 /* Helper functions: type is byte, short, ushort, int, uint, long,
    ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
@@ -120,15 +128,16 @@ struct kparam_array
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
@@ -186,21 +195,30 @@ extern int param_set_charp(const char *val, struct kernel_param *kp);
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
-#define param_check_invbool(name, p) __param_check(name, p, int)
+#define param_check_invbool(name, p) __param_check(name, p, bool)
 
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\
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
index de273ec..7f6912c 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -24,9 +24,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
-/* We abuse the high bits of "perm" to record whether we kmalloc'ed. */
-#define KPARAM_KMALLOCED	0x80000000
-
 #if 0
 #define DEBUGP printk
 #else
@@ -220,13 +217,13 @@ int param_set_charp(const char *val, struct kernel_param *kp)
 		return -ENOSPC;
 	}
 
-	if (kp->perm & KPARAM_KMALLOCED)
+	if (kp->flags & KPARAM_KMALLOCED)
 		kfree(*(char **)kp->arg);
 
 	/* This is a hack.  We can't need to strdup in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		kp->perm |= KPARAM_KMALLOCED;
+		kp->flags |= KPARAM_KMALLOCED;
 		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
 		if (!kp->arg)
 			return -ENOMEM;
@@ -241,44 +238,63 @@ int param_get_charp(char *buffer, struct kernel_param *kp)
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
-		*(int *)kp->arg = !boolval;
+		*(bool *)kp->arg = !boolval;
 	return ret;
 }
 
 int param_get_invbool(char *buffer, struct kernel_param *kp)
 {
-	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'N' : 'Y');
+	return sprintf(buffer, "%c", (*(bool *)kp->arg) ? 'N' : 'Y');
 }
 
 /* We break the rule and mangle the string. */
@@ -591,7 +607,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 	unsigned int i;
 
 	for (i = 0; i < num; i++)
-		if (params[i].perm & KPARAM_KMALLOCED)
+		if (params[i].flags & KPARAM_KMALLOCED)
 			kfree(*(char **)params[i].arg);
 }
 
