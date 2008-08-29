Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYH2GXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYH2GXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYH2GQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:01 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59515 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYH2GPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:31 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lggV016139@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 24/29] mdb: add mdb_kallsyms function and export kallsyms lookup functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add mdb_kallsyms function and export kallsyms lookup functions


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/kallsyms.c	2008-08-28 14:19:32.000000000 -0600
+++ b/kernel/kallsyms.c	2008-08-28 14:20:04.000000000 -0600
@@ -160,6 +160,7 @@
 	}
 	return module_kallsyms_lookup_name(name);
 }
+EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
@@ -262,6 +263,7 @@
 				     namebuf);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(kallsyms_lookup);
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
@@ -477,5 +479,49 @@
 }
 __initcall(kallsyms_init);
 
+#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
+struct kallsym_iter mdb_iter;
+int mdb_kallsyms(char *str, int (*print)(char *s, ...))
+{
+    register loff_t pos = 0;
+    register struct kallsym_iter *iter = &mdb_iter;
+
+    if (!print)
+       return 0;
+
+    // set to beginning of the kallsyms list
+    reset_iter(iter, 0);
+    while (1)
+    {
+       // search the kallsyms list
+       if (!update_iter(iter, pos++))
+          break;
+
+       if (!iter->name[0])
+	  continue;
+
+       // if an exclusion search was specified, skip non-matching entries
+       if (str && *str && !strstr(iter->name, str))
+          continue;
+
+       if (iter->module_name[0])
+       {
+          if (print("%0*lx %c %s [%s]\n", (int)(2*sizeof(void*)),
+	      iter->value, iter->type, iter->name,
+	      iter->module_name))
+             return 1;
+       }
+       else
+       {
+          if (print("%0*lx %c %s\n", (int)(2*sizeof(void*)),
+	      iter->value, iter->type, iter->name))
+             return 1;
+       }
+    }
+    return 0;
+}
+EXPORT_SYMBOL_GPL(mdb_kallsyms);
+#endif
+
 EXPORT_SYMBOL(__print_symbol);
 EXPORT_SYMBOL_GPL(sprint_symbol);
