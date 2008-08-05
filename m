Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbYHEHKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbYHEHKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbYHEGr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:56 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44148 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbYHEGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:28 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QaCJ003783@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 23/26] mdb: add kallsyms fixes for duplicate names
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

add the ability to call through kallsyms and output strstr() matches
for name searches, since modules can have functions that share identical
names with the kernel functions.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/kallsyms.c	2008-08-04 15:53:44.000000000 -0600
+++ b/kernel/kallsyms.c	2008-08-04 15:49:51.000000000 -0600
@@ -477,5 +477,48 @@
 }
 __initcall(kallsyms_init);
 
+#ifdef CONFIG_MDB
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
+ 	  continue;
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
+   	      iter->value, iter->type, iter->name))
+             return 1;
+       }
+    }
+    return 0;
+}
+#endif
+
 EXPORT_SYMBOL(__print_symbol);
 EXPORT_SYMBOL_GPL(sprint_symbol);
