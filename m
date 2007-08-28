Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXH1KJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXH1KJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXH1KJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:09:04 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:25831
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbXH1KJD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:09:03 -0400
Message-Id: <46D4107C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:09:32 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] constify string/array kparam tracking structures
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

.. in an effort to make read-only whatever can be made, so that
CONFIG_DEBUG_RODATA can catch as many issues as possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/linux/moduleparam.h |   18 +++++++++++-------
 kernel/params.c             |   17 +++++++----------
 2 files changed, 18 insertions(+), 17 deletions(-)

--- linux-2.6.23-rc4/include/linux/moduleparam.h	2007-04-26 05:08:32.000000000 +0200
+++ 2.6.23-rc4-const-kparam/include/linux/moduleparam.h	2007-08-20 09:50:12.000000000 +0200
@@ -38,7 +38,11 @@ struct kernel_param {
 	unsigned int perm;
 	param_set_fn set;
 	param_get_fn get;
-	void *arg;
+	union {
+		void *arg;
+		const struct kparam_string *str;
+		const struct kparam_array *arr;
+	};
 };
 
 /* Special one for strings we want to copy into */
@@ -66,11 +70,11 @@ struct kparam_array
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
-	static char __param_str_##name[] = prefix #name;		\
+	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
 	__attribute_used__						\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, set, get, arg }
+	= { __param_str_##name, perm, set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
 	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
@@ -88,10 +92,10 @@ struct kparam_array
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
-	static struct kparam_string __param_string_##name		\
+	static const struct kparam_string __param_string_##name		\
 		= { len, string };					\
 	module_param_call(name, param_set_copystring, param_get_string,	\
-		   &__param_string_##name, perm);			\
+			  .str = &__param_string_##name, perm);		\
 	__MODULE_PARM_TYPE(name, "string")
 
 /* Called on module insert or kernel boot */
@@ -149,11 +153,11 @@ extern int param_get_invbool(char *buffe
 
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\
-	static struct kparam_array __param_arr_##name			\
+	static const struct kparam_array __param_arr_##name		\
 	= { ARRAY_SIZE(array), nump, param_set_##type, param_get_##type,\
 	    sizeof(array[0]), array };					\
 	module_param_call(name, param_array_set, param_array_get, 	\
-			  &__param_arr_##name, perm);			\
+			  .arr = &__param_arr_##name, perm);		\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 #define module_param_array(name, type, nump, perm)		\
--- linux-2.6.23-rc4/kernel/params.c	2007-08-28 09:42:37.000000000 +0200
+++ 2.6.23-rc4-const-kparam/kernel/params.c	2007-08-20 10:07:33.000000000 +0200
@@ -252,8 +252,9 @@ int param_get_bool(char *buffer, struct 
 int param_set_invbool(const char *val, struct kernel_param *kp)
 {
 	int boolval, ret;
-	struct kernel_param dummy = { .arg = &boolval };
+	struct kernel_param dummy;
 
+	dummy.arg = &boolval;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
 		*(int *)kp->arg = !boolval;
@@ -262,11 +263,7 @@ int param_set_invbool(const char *val, s
 
 int param_get_invbool(char *buffer, struct kernel_param *kp)
 {
-	int val;
-	struct kernel_param dummy = { .arg = &val };
-
-	val = !*(int *)kp->arg;
-	return param_get_bool(buffer, &dummy);
+	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'N' : 'Y');
 }
 
 /* We break the rule and mangle the string. */
@@ -325,7 +322,7 @@ static int param_array(const char *name,
 
 int param_array_set(const char *val, struct kernel_param *kp)
 {
-	struct kparam_array *arr = kp->arg;
+	const struct kparam_array *arr = kp->arr;
 	unsigned int temp_num;
 
 	return param_array(kp->name, val, 1, arr->max, arr->elem,
@@ -335,7 +332,7 @@ int param_array_set(const char *val, str
 int param_array_get(char *buffer, struct kernel_param *kp)
 {
 	int i, off, ret;
-	struct kparam_array *arr = kp->arg;
+	const struct kparam_array *arr = kp->arr;
 	struct kernel_param p;
 
 	p = *kp;
@@ -354,7 +351,7 @@ int param_array_get(char *buffer, struct
 
 int param_set_copystring(const char *val, struct kernel_param *kp)
 {
-	struct kparam_string *kps = kp->arg;
+	const struct kparam_string *kps = kp->str;
 
 	if (!val) {
 		printk(KERN_ERR "%s: missing param set value\n", kp->name);
@@ -371,7 +368,7 @@ int param_set_copystring(const char *val
 
 int param_get_string(char *buffer, struct kernel_param *kp)
 {
-	struct kparam_string *kps = kp->arg;
+	const struct kparam_string *kps = kp->str;
 	return strlcpy(buffer, kps->string, kps->maxlen);
 }
 


