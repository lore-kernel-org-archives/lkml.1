Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYLAMzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYLAMzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbYLAMzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:55:21 -0500
Received: from ozlabs.org ([203.10.76.45]:44011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYLAMzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:55:20 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:25:16 +1030
Subject: [RFC 3/8] param: make sure charp isn't used as a core_param
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012325.16654.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"charp" sets a variable to point to a char string in a command line.
This doesn't work if the command line isn't going to stick around.
Add a compile-breaking check for this case, and make a note of it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |    3 +++
 kernel/params.c             |    7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -118,11 +118,15 @@ struct kparam_array
  * early in boot.  This is for compatibility with __setup(), and it
  * makes sense as truly core parameters aren't tied to the particular
  * file they're in.
+ *
+ * Note: You can't use 'charp' here (which keeps a pointer into our
+ * tmp cmdline).
  */
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", "__core_param", name, param_set_##type, \
-			    param_get_##type, &var, perm)
+			    param_get_##type, &var, perm		\
+			    + BUILD_BUG_ON_ZERO(param_##type##_keeps_reference))
 #endif /* !MODULE */
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
@@ -150,42 +154,52 @@ extern int param_set_byte(const char *va
 extern int param_set_byte(const char *val, struct kernel_param *kp);
 extern int param_get_byte(char *buffer, struct kernel_param *kp);
 #define param_check_byte(name, p) __param_check(name, p, unsigned char)
+#define param_byte_keeps_reference 0
 
 extern int param_set_short(const char *val, struct kernel_param *kp);
 extern int param_get_short(char *buffer, struct kernel_param *kp);
 #define param_check_short(name, p) __param_check(name, p, short)
+#define param_short_keeps_reference 0
 
 extern int param_set_ushort(const char *val, struct kernel_param *kp);
 extern int param_get_ushort(char *buffer, struct kernel_param *kp);
 #define param_check_ushort(name, p) __param_check(name, p, unsigned short)
+#define param_ushort_keeps_reference 0
 
 extern int param_set_int(const char *val, struct kernel_param *kp);
 extern int param_get_int(char *buffer, struct kernel_param *kp);
 #define param_check_int(name, p) __param_check(name, p, int)
+#define param_int_keeps_reference 0
 
 extern int param_set_uint(const char *val, struct kernel_param *kp);
 extern int param_get_uint(char *buffer, struct kernel_param *kp);
 #define param_check_uint(name, p) __param_check(name, p, unsigned int)
+#define param_uint_keeps_reference 0
 
 extern int param_set_long(const char *val, struct kernel_param *kp);
 extern int param_get_long(char *buffer, struct kernel_param *kp);
 #define param_check_long(name, p) __param_check(name, p, long)
+#define param_long_keeps_reference 0
 
 extern int param_set_ulong(const char *val, struct kernel_param *kp);
 extern int param_get_ulong(char *buffer, struct kernel_param *kp);
 #define param_check_ulong(name, p) __param_check(name, p, unsigned long)
+#define param_ulong_keeps_reference 0
 
 extern int param_set_charp(const char *val, struct kernel_param *kp);
 extern int param_get_charp(char *buffer, struct kernel_param *kp);
 #define param_check_charp(name, p) __param_check(name, p, char *)
+#define param_charp_keeps_reference 1
 
 extern int param_set_bool(const char *val, struct kernel_param *kp);
 extern int param_get_bool(char *buffer, struct kernel_param *kp);
 #define param_check_bool(name, p) __param_check(name, p, int)
+#define param_bool_keeps_reference 0
 
 extern int param_set_invbool(const char *val, struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);
 #define param_check_invbool(name, p) __param_check(name, p, int)
+#define param_invbool_keeps_reference 0
 
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\


