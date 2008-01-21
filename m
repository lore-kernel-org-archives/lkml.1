Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbYAUJI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbYAUJI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 04:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYAUJIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 04:08:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:45620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbYAUJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:08:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ISkQfftHmKKqtoWoya/L6+ZAQfJt3V9QLHSPJD8WJ5c8+pq52aXoqxKjGRWjQmujOQsP15/2tAM0D8yBhHQy98+C7P1aKCELh44CzPFS7jEQD6AGytHnXAfwIWUoO6gT1cFTz7OjvduyCPtvCH8y6mFMAGYbkOSG7czFmOqq4j4=
From: Denis Cheng <crquan@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Date: Mon, 21 Jan 2008 17:08:25 +0800
Message-Id: <1200906505-28859-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

