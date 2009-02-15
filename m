Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZBOSVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZBOSVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZBOSUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:39 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:48305 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZBOSUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Dli63sYJBhT1YmPsqxkJJCkmFteqnIMcGyqvk+7nKAqdFi4wfxUOqXt17WNyr0yH45
         FNIyJS4xtx5Fg3I7OL/z5t/HWyqSvAqoIMjgiUcC8o4y3TZzdij1VF4rlPlm/YX2Zri5
         TbZCTmUMhc16+a348VSs0vvlSdB5ZpNbOfECA=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/6] module: always prefix module parameters with the module name
Date: Sun, 15 Feb 2009 19:20:25 +0100
Message-Id: <1234722028-8110-4-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1234722028-8110-1-git-send-email-andr345@gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameters in statically linked modules now end up in the
proper sysfs directories, ie /sys/module/<modname>/parameter/*
---
 include/linux/moduleparam.h |    2 +-
 kernel/params.c             |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index e4af339..0cb2867 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -7,7 +7,7 @@
 
 /* You can override this manually, but generally this should match the
    module name. */
-#ifdef MODULE
+#if defined(MODULE) && !defined(CONFIG_MODULE_STATIC)
 #define MODULE_PARAM_PREFIX /* empty */
 #else
 #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
diff --git a/kernel/params.c b/kernel/params.c
index a1e3025..22af6ee 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -518,6 +518,19 @@ static void free_module_param_attrs(struct module_kobject *mk)
 	mk->mp = NULL;
 }
 
+#ifdef CONFIG_MODULE_STATIC
+static const char *skip_param_modname(const char *name)
+{
+	const char *dot = strchr(name, '.');
+	return (!dot) ? name : dot + 1;
+}
+#else
+static const char *skip_param_modname(const char *name)
+{
+	return name;
+}
+#endif
+
 /*
  * module_param_sysfs_setup - setup sysfs support for one module
  * @mod: module
@@ -535,9 +548,11 @@ int module_param_sysfs_setup(struct module *mod,
 	bool params = false;
 
 	for (i = 0; i < num_params; i++) {
+		const char *name;
 		if (kparam[i].perm == 0)
 			continue;
-		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
+		name = skip_param_modname(kparam[i].name);
+		err = add_sysfs_param(&mod->mkobj, &kparam[i], name);
 		if (err)
 			return err;
 		params = true;
-- 
1.5.6.3

