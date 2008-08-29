Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbYH2GYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbYH2GYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYH2GQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:05 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59524 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYH2GPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:31 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgDu016140@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 25/29] mdb: add mdb_modules function 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb_modules function 


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/module.c	2008-08-28 14:19:38.000000000 -0600
+++ b/kernel/module.c	2008-08-28 14:20:04.000000000 -0600
@@ -2503,6 +2503,39 @@
 	return 0;
 }
 
+#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
+int mdb_modules(char *str, int (*print)(char *s, ...))
+{
+	struct module *mod;
+	struct module_use *use;
+
+        if (!print)
+           return 0;
+
+	list_for_each_entry(mod, &modules, list)
+        {
+           if (str && *str && !strstr(mod->name, str))
+              continue;
+
+	   print(" 0x%08p ", mod->module_core);
+	   print("%s", mod->name);
+	   print(" %lu %02u ", mod->init_size + mod->core_size,
+                 module_refcount(mod));
+	   list_for_each_entry(use, &mod->modules_which_use_me, list)
+		print("%s,", use->module_which_uses->name);
+	   if (mod->init != NULL && mod->exit == NULL)
+	      print("[permanent],");
+	   print(" %s ", mod->state == MODULE_STATE_GOING ? "Unloading":
+	                mod->state == MODULE_STATE_COMING ? "Loading":
+		        "Live");
+	   if (print("\n"))
+              return 1;
+	}
+        return 0;
+}
+EXPORT_SYMBOL_GPL(mdb_modules);
+#endif
+
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
