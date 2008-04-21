Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYDUMf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYDUMf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbYDUMen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:43 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:53180 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbYDUMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:41 -0400
Message-ID: <480C89DF.9090905@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:39 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au
Subject: [RFC PATCH 5/8] module: add function to map address to containing
 module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

module_address() maps an address to the module containing it in either
text or data section. Required by the gcov profiling infrastructure to
associate profiling data structures with modules.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 include/linux/module.h |    1 +
 kernel/module.c        |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

Index: linux-2.6.25/include/linux/module.h
===================================================================
--- linux-2.6.25.orig/include/linux/module.h
+++ linux-2.6.25/include/linux/module.h
@@ -380,6 +380,7 @@ static inline int module_is_live(struct 
 /* Is this address in a module? (second is with no locks, for oops) */
 struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
+struct module *module_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
Index: linux-2.6.25/kernel/module.c
===================================================================
--- linux-2.6.25.orig/kernel/module.c
+++ linux-2.6.25/kernel/module.c
@@ -2527,10 +2527,16 @@ const struct exception_table_entry *sear
 	return e;
 }
 
-/*
- * Is this a valid module address?
+/**
+ * module_address - map an address to the containing module
+ * @addr: address for which the containing module should be searched
+ *
+ * Return the module which contains the address in either text or data
+ * section. Return NULL if no matching module was found. Callers should
+ * be aware that no reference counting is being performed for the returned
+ * module reference.
  */
-int is_module_address(unsigned long addr)
+struct module *module_address(unsigned long addr)
 {
 	struct module *mod;
 
@@ -2539,15 +2545,22 @@ int is_module_address(unsigned long addr
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_core, mod->core_size)) {
 			preempt_enable();
-			return 1;
+			return mod;
 		}
 	}
 
 	preempt_enable();
 
-	return 0;
+	return NULL;
 }
 
+/*
+ * Is this a valid module address?
+ */
+int is_module_address(unsigned long addr)
+{
+	return module_address(addr) ? 1 : 0;
+}
 
 /* Is this a valid kernel address? */
 struct module *__module_text_address(unsigned long addr)





