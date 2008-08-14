Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYHNGqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYHNGqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHNGik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:40 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38136 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYHNGiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:01 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EcYw006262@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 24/29] mdb: add export function to module.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the ability to scan and display the loaded module list 
inside the debugger.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/module.c	2008-08-13 14:22:32.000000000 -0600
+++ b/kernel/module.c	2008-08-13 11:56:03.000000000 -0600
@@ -2503,6 +2503,41 @@
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
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(mdb_modules);
+#endif
+#endif
+
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
