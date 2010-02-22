Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0BVKev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:34:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:36038 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0BVKet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:34:49 -0500
From: Dongdong Deng <dongdong.deng@windriver.com>
To: rusty@rustcorp.com.au, xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
       davem@davemloft.net, dongdong.deng@windriver.com
Subject: [RESEND PATCH] module param_call: fix potential NULL pointer dereference
Date: Mon, 22 Feb 2010 18:40:51 +0800
Message-Id: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 22 Feb 2010 10:34:42.0033 (UTC) FILETIME=[A4921610:01CAB3AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The param_set_fn() function will get a parameter which is a NULL
pointer when insmod module via bare params as following method:

$insmod foo.ko foo

If the param_set_fn() function didn't check that parameter and used
it directly, it could caused an OOPS due to NULL pointer dereference.

The solution is simple:
Using "" to replace NULL parameter, thereby the param_set_fn()
function will never get a NULL pointer.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 kernel/params.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index cf1b691..548d680 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -101,7 +101,11 @@ static char *next_arg(char *args, char **param, char **val)
 
 	*param = args;
 	if (!equals)
-		*val = NULL;
+		/*
+		 * We used to hand NULL for bare params, but most code
+		 *  didn't handle it. Using "" to replace NULL here.
+		 */
+		*val = "";
 	else {
 		args[equals] = '\0';
 		*val = args + equals + 1;
@@ -180,10 +184,7 @@ int parse_args(const char *name,
 	int param_set_##name(const char *val, struct kernel_param *kp)	\
 	{								\
 		tmptype l;						\
-		int ret;						\
-									\
-		if (!val) return -EINVAL;				\
-		ret = strtolfn(val, 0, &l);				\
+		int ret = strtolfn(val, 0, &l);				\
 		if (ret == -EINVAL || ((type)l != l))			\
 			return -EINVAL;					\
 		*((type *)kp->arg) = l;					\
@@ -204,12 +205,6 @@ STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
 
 int param_set_charp(const char *val, struct kernel_param *kp)
 {
-	if (!val) {
-		printk(KERN_ERR "%s: string parameter expected\n",
-		       kp->name);
-		return -EINVAL;
-	}
-
 	if (strlen(val) > 1024) {
 		printk(KERN_ERR "%s: string parameter too long\n",
 		       kp->name);
@@ -238,9 +233,6 @@ int param_set_bool(const char *val, struct kernel_param *kp)
 {
 	bool v;
 
-	/* No equals means "set"... */
-	if (!val) val = "1";
-
 	/* One of =[yYnN01] */
 	switch (val[0]) {
 	case 'y': case 'Y': case '1':
@@ -310,12 +302,6 @@ static int param_array(const char *name,
 	kp.arg = elem;
 	kp.flags = flags;
 
-	/* No equals sign? */
-	if (!val) {
-		printk(KERN_ERR "%s: expects arguments\n", name);
-		return -EINVAL;
-	}
-
 	*num = 0;
 	/* We expect a comma-separated list of values. */
 	do {
@@ -382,10 +368,6 @@ int param_set_copystring(const char *val, struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
-	if (!val) {
-		printk(KERN_ERR "%s: missing param set value\n", kp->name);
-		return -EINVAL;
-	}
 	if (strlen(val)+1 > kps->maxlen) {
 		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
-- 
1.6.0.4

