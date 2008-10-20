Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbYJTDS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbYJTDS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJTDSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:18:51 -0400
Received: from ozlabs.org ([203.10.76.45]:33028 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYJTDSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:18:50 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 19 Oct 2008 22:18:50 -0500
Subject: [PATCH 1/5] module: check kernel param length at compile time, not runtime
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201418.50616.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The kparam code tries to handle over-length parameter prefixes at
runtime.  Not only would I bet this has never been tested, it's not
clear that truncating names is a good idea either.

So let's check at compile time.  We need to move the #define to
moduleparam.h to do this, though.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h      |    2 +-
 include/linux/moduleparam.h |    6 +++++-
 kernel/params.c             |    7 ++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -r 87bd0f4cec3a include/linux/module.h
--- a/include/linux/module.h	Wed Aug 27 14:23:25 2008 +1000
+++ b/include/linux/module.h	Wed Aug 27 21:00:10 2008 +1000
@@ -28,7 +28,7 @@
 #define MODULE_SYMBOL_PREFIX ""
 #endif
 
-#define MODULE_NAME_LEN (64 - sizeof(unsigned long))
+#define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
 
 struct kernel_symbol
 {
diff -r 87bd0f4cec3a include/linux/moduleparam.h
--- a/include/linux/moduleparam.h	Wed Aug 27 14:23:25 2008 +1000
+++ b/include/linux/moduleparam.h	Wed Aug 27 21:00:10 2008 +1000
@@ -12,6 +12,9 @@
 #else
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
 #endif
+
+/* Chosen so that structs with an unsigned long line up. */
+#define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
 
 #ifdef MODULE
 #define ___module_cat(a,b) __mod_ ## a ## b
@@ -79,7 +82,8 @@ struct kparam_array
 #define __module_param_call(prefix, name, set, get, arg, perm)		\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
+	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
+	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
diff -r 87bd0f4cec3a kernel/params.c
--- a/kernel/params.c	Wed Aug 27 14:23:25 2008 +1000
+++ b/kernel/params.c	Wed Aug 27 21:00:10 2008 +1000
@@ -585,17 +585,14 @@ static void __init param_sysfs_builtin(v
 {
 	struct kernel_param *kp, *kp_begin = NULL;
 	unsigned int i, name_len, count = 0;
-	char modname[MODULE_NAME_LEN + 1] = "";
+	char modname[MODULE_NAME_LEN] = "";
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
-		size_t max_name_len;
 
 		kp = &__start___param[i];
-		max_name_len =
-			min_t(size_t, MODULE_NAME_LEN, strlen(kp->name));
 
-		dot = memchr(kp->name, '.', max_name_len);
+		dot = strchr(kp->name, '.');
 		if (!dot) {
 			DEBUGP("couldn't find period in first %d characters "
 			       "of %s\n", MODULE_NAME_LEN, kp->name);

