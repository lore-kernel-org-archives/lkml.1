Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbYHNGrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbYHNGrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYHNGik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:40 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38160 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYHNGiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:00 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6Eck1006261@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 23/29] mdb: export kallsyms functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the kallsyms lookup functions to the module based debugger.
add debugger specific lookup to search for matching strstr text 
fragments for entered search terms.



Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/kallsyms.c	2008-08-13 14:22:32.000000000 -0600
+++ b/kernel/kallsyms.c	2008-08-13 11:56:03.000000000 -0600
@@ -160,6 +160,9 @@
 	}
 	return module_kallsyms_lookup_name(name);
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(kallsyms_lookup_name);
+#endif
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
@@ -262,6 +265,9 @@
 				     namebuf);
 	return NULL;
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(kallsyms_lookup);
+#endif
 
 int lookup_symbol_name(unsigned long addr, char *symname)
 {
@@ -477,5 +483,51 @@
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
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(mdb_kallsyms);
+#endif
+#endif
+
 EXPORT_SYMBOL(__print_symbol);
 EXPORT_SYMBOL_GPL(sprint_symbol);
