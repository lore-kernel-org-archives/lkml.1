Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYHEHK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYHEHK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbYHEGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44138 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbYHEGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:31 -0400
Date: Tue, 5 Aug 2008 00:26:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756Qb6H003784@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 24/26] mdb: add module.c fixes interative module search
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

add an iterative search for module names while the debugger is active.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/module.c	2008-08-04 15:53:44.000000000 -0600
+++ b/kernel/module.c	2008-08-04 15:49:51.000000000 -0600
@@ -2503,6 +2503,38 @@
 	return 0;
 }
 
+#ifdef CONFIG_MDB           
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
+  	   if (mod->init != NULL && mod->exit == NULL) 
+	      print("[permanent],");
+	   print(" %s ", mod->state == MODULE_STATE_GOING ? "Unloading":
+	                mod->state == MODULE_STATE_COMING ? "Loading":
+		        "Live");
+	   if (print("\n"))
+              return 1;
+	}
+        return 0;
+}
+#endif
+ 
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {
