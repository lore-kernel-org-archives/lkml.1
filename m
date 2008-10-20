Return-Path: <linux-kernel-owner+w=401wt.eu-S1751538AbYJTDUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbYJTDUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYJTDU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:20:28 -0400
Received: from ozlabs.org ([203.10.76.45]:33057 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYJTDU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:20:28 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 19 Oct 2008 22:20:17 -0500
Subject: [PATCH 3/5] core_param() for genuinely core kernel parameters
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201420.17428.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a lot of one-liner uses of __setup() in the kernel: they're
cumbersome and not queryable (definitely not settable) via /sys.  Yet
it's ugly to simplify them to module_param(), because by default that
inserts a prefix of the module name (usually filename).

So, introduce a "core_param".  The parameter gets no prefix, but
appears in /sys/module/kernel/parameters/ (if non-zero perms arg).  I
thought about using the name "core", but that's more common than
"kernel".  And if you create a module called "kernel", you will die
a horrible death.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |   19 +++++++++++++++++++
 kernel/params.c             |   14 +++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff -r 45c9db682016 include/linux/moduleparam.h
--- a/include/linux/moduleparam.h	Thu Aug 28 11:45:26 2008 +1000
+++ b/include/linux/moduleparam.h	Thu Aug 28 11:46:26 2008 +1000
@@ -104,6 +104,25 @@ struct kparam_array
 #define module_param(name, type, perm)				\
 	module_param_named(name, name, type, perm)
 
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
+ * with __setup(), and it makes sense as truly core parameters aren't
+ * tied to the particular file they're in.
+ */
+#define core_param(name, var, type, perm)				\
+	param_check_##type(name, &(var));				\
+	__module_param_call("", name, param_set_##type, param_get_##type, \
+			    &var, perm)
+#endif /* !MODULE */
+
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
 	static const struct kparam_string __param_string_##name		\
diff -r 45c9db682016 kernel/params.c
--- a/kernel/params.c	Thu Aug 28 11:45:26 2008 +1000
+++ b/kernel/params.c	Thu Aug 28 11:46:26 2008 +1000
@@ -637,14 +637,14 @@ static void __init param_sysfs_builtin(v
 
 		dot = strchr(kp->name, '.');
 		if (!dot) {
-			DEBUGP("couldn't find period in first %d characters "
-			       "of %s\n", MODULE_NAME_LEN, kp->name);
-			continue;
+			/* This happens for core_param() */
+			strcpy(modname, "kernel");
+			name_len = 0;
+		} else {
+			name_len = dot - kp->name + 1;
+			strlcpy(modname, kp->name, name_len);
 		}
-		name_len = dot - kp->name;
-		strncpy(modname, kp->name, name_len);
-		modname[name_len] = '\0';
-		kernel_add_sysfs_param(modname, kp, name_len+1);
+		kernel_add_sysfs_param(modname, kp, name_len);
 	}
 }
 

