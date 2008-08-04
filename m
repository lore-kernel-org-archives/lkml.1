Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbYHDHB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbYHDHB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbYHDHBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:01:49 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50394 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030AbYHDHBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:01:49 -0400
Message-ID: <45479.166.70.238.45.1217832083.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:41:23 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 22/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/kernel/kallsyms.c	2008-08-03 16:10:19.000000000 -0600
+++ b/kernel/kallsyms.c	2008-08-03 16:15:00.000000000 -0600
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


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



