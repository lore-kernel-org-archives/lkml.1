Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYASFqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYASFqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYASFqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:46:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:47006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbYASFqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wvDtjHkkxe3AvgZ1f2kzzHw8JPUKF7atTLT7aHJcjNXczmgCh6yCDQlrUf4GgssRkcM3X3LdfK94arvfQ643OPLDiqLDqvaXW4+wxPRrvDS984sFgBbtkfmkeca3mexUnXW/2CdA2GeonS0yGuHyi0ubO9N00o5Xt+zQgKl6G7M=
Message-ID: <91b13c310801182146r2efa0eebifadc2375763ccfd9@mail.gmail.com>
Date: Sat, 19 Jan 2008 13:46:07 +0800
From: "rae l" <crquan@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Sat, 19 Jan 2008 13:29:51 +0800
Subject: [PATCH] kernel/params.c: fix the module name length in
param_sysfs_builtin

the original code use KOBJ_NAME_LEN for built-in module name length,
that's defined to 20 in linux/kobject.h, but this is not enough appearntly,
many module names are longer than this;
 #define KOBJ_NAME_LEN                   20

another macro is MODULE_NAME_LEN defined in linux/module.h, I think this is
enough for module names:
 #define MODULE_NAME_LEN (64 - sizeof(unsigned long))

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 kernel/params.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 7686417..a085b40 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -376,8 +376,6 @@ int param_get_string(char *buffer, struct kernel_param *kp)

 extern struct kernel_param __start___param[], __stop___param[];

-#define MAX_KBUILD_MODNAME KOBJ_NAME_LEN
-
 struct param_attribute
 {
 	struct module_attribute mattr;
@@ -588,7 +586,7 @@ static void __init param_sysfs_builtin(void)
 {
 	struct kernel_param *kp, *kp_begin = NULL;
 	unsigned int i, name_len, count = 0;
-	char modname[MAX_KBUILD_MODNAME + 1] = "";
+	char modname[MODULE_NAME_LEN + 1] = "";

 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
@@ -596,12 +594,12 @@ static void __init param_sysfs_builtin(void)

 		kp = &__start___param[i];
 		max_name_len =
-			min_t(size_t, MAX_KBUILD_MODNAME, strlen(kp->name));
+			min_t(size_t, MODULE_NAME_LEN, strlen(kp->name));

 		dot = memchr(kp->name, '.', max_name_len);
 		if (!dot) {
 			DEBUGP("couldn't find period in first %d characters "
-			       "of %s\n", MAX_KBUILD_MODNAME, kp->name);
+			       "of %s\n", MODULE_NAME_LEN, kp->name);
 			continue;
 		}
 		name_len = dot - kp->name;
-- 
1.5.3.5

-- 
Denis Cheng
