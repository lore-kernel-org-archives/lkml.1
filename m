Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYAUJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYAUJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 04:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbYAUJT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 04:19:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:14527 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbYAUJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n80PUfBoHF4LLnxN1ReAwGm6VTONep0948iPfFyxBZHJFVXsnmOUNChy5ud5byBfRwgR9BShU9uUq5Wju9xYQEjbgwDqleJcsJ/GpceMTCDpob9DHQVpGHPMjKglz7lnhlFB6E20N8Bl2u4I2dI0kAAlgNFO35QrZorFPieVeM8=
From: Denis Cheng <crquan@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/params.c: fix the module name length in param_sysfs_builtin
Date: Mon, 21 Jan 2008 17:20:09 +0800
Message-Id: <1200907209-29088-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original code use KOBJ_NAME_LEN for built-in module name length,
that's defined to 20 in linux/kobject.h, but this is not enough,
some module names(such as nf_conntrack_proto_icmp) are longer than this;
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

