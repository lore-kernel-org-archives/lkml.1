Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYESIqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYESIqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYESIq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:46:27 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:19534 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672AbYESIq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:46:26 -0400
Message-ID: <48313E23.4030104@de.ibm.com>
Date: Mon, 19 May 2008 10:45:23 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH] consolidate all within() implementations
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

This patch consolidates a number of different implementations of the
within() function which checks whether an address is within a specified
address range. Apart from parameter typing, existing implementations can
be classified in two categories which differ in the way the range is
specified:

  1) by start and end address
  2) by start and size

These categories are covered by the within() macro (case 1) and the
within_len() macro (case 2). Both macros can be used with any pointer
or pointer-equivalent type as parameter.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/x86/mm/pageattr.c |    7 +------
 include/linux/kernel.h |   24 ++++++++++++++++++++++++
 kernel/lockdep.c       |   10 +++-------
 kernel/module.c        |   25 ++++++++++---------------
 4 files changed, 38 insertions(+), 28 deletions(-)

Index: linux-2.6.26-rc3/include/linux/kernel.h
===================================================================
--- linux-2.6.26-rc3.orig/include/linux/kernel.h
+++ linux-2.6.26-rc3/include/linux/kernel.h
@@ -434,6 +434,30 @@ static inline char *pack_hex_byte(char *
 	__val > __max ? __max: __val; })
 
 /**
+ * within - check whether address is within a start-and-end address range
+ * @val: address
+ * @start: start address (included in range)
+ * @end: end address (excluded from range)
+ */
+#define within(val, start, end) ({			\
+	unsigned long __val = (unsigned long) (val);	\
+	unsigned long __start = (unsigned long) (start);	\
+	unsigned long __end = (unsigned long) (end);	\
+	(__val >= __start) && (__val < __end); })
+
+/**
+ * within_len - check whether address is within a start-and-length address range
+ * @val: address
+ * @start: start of range
+ * @len: number of bytes in range
+ */
+#define within_len(val, start, len) ({				\
+	unsigned long __val = (unsigned long) (val);		\
+	unsigned long __start = (unsigned long) (start);	\
+	unsigned long __end = __start + (unsigned long) (len);	\
+	(__val >= __start) && (__val < __end); })
+
+/**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
  * @type:	the type of the container struct this is embedded in.
Index: linux-2.6.26-rc3/kernel/lockdep.c
===================================================================
--- linux-2.6.26-rc3.orig/kernel/lockdep.c
+++ linux-2.6.26-rc3/kernel/lockdep.c
@@ -25,6 +25,7 @@
  * Thanks to Arjan van de Ven for coming up with the initial idea of
  * mapping lock dependencies runtime.
  */
+#include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
@@ -2932,11 +2933,6 @@ static void zap_class(struct lock_class 
 
 }
 
-static inline int within(const void *addr, void *start, unsigned long size)
-{
-	return addr >= start && addr < start + size;
-}
-
 void lockdep_free_key_range(void *start, unsigned long size)
 {
 	struct lock_class *class, *next;
@@ -2956,9 +2952,9 @@ void lockdep_free_key_range(void *start,
 		if (list_empty(head))
 			continue;
 		list_for_each_entry_safe(class, next, head, hash_entry) {
-			if (within(class->key, start, size))
+			if (within_len(class->key, start, size))
 				zap_class(class);
-			else if (within(class->name, start, size))
+			else if (within_len(class->name, start, size))
 				zap_class(class);
 		}
 	}
Index: linux-2.6.26-rc3/kernel/module.c
===================================================================
--- linux-2.6.26-rc3.orig/kernel/module.c
+++ linux-2.6.26-rc3/kernel/module.c
@@ -2262,11 +2262,6 @@ sys_init_module(void __user *umod,
 	return 0;
 }
 
-static inline int within(unsigned long addr, void *start, unsigned long size)
-{
-	return ((void *)addr >= start && (void *)addr < start + size);
-}
-
 #ifdef CONFIG_KALLSYMS
 /*
  * This ignores the intensely annoying "mapping symbols" found
@@ -2287,7 +2282,7 @@ static const char *get_ksymbol(struct mo
 	unsigned long nextval;
 
 	/* At worse, next value is at end of module */
-	if (within(addr, mod->module_init, mod->init_size))
+	if (within_len(addr, mod->module_init, mod->init_size))
 		nextval = (unsigned long)mod->module_init+mod->init_text_size;
 	else
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
@@ -2335,8 +2330,8 @@ const char *module_address_lookup(unsign
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size)
-		    || within(addr, mod->module_core, mod->core_size)) {
+		if (within_len(addr, mod->module_init, mod->init_size)
+		    || within_len(addr, mod->module_core, mod->core_size)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -2358,8 +2353,8 @@ int lookup_module_symbol_name(unsigned l
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_len(addr, mod->module_init, mod->init_size) ||
+		    within_len(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -2382,8 +2377,8 @@ int lookup_module_symbol_attrs(unsigned 
 
 	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_len(addr, mod->module_init, mod->init_size) ||
+		    within_len(addr, mod->module_core, mod->core_size)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, size, offset);
@@ -2579,7 +2574,7 @@ int is_module_address(unsigned long addr
 	preempt_disable();
 
 	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_core, mod->core_size)) {
+		if (within_len(addr, mod->module_core, mod->core_size)) {
 			preempt_enable();
 			return 1;
 		}
@@ -2597,8 +2592,8 @@ struct module *__module_text_address(uns
 	struct module *mod;
 
 	list_for_each_entry(mod, &modules, list)
-		if (within(addr, mod->module_init, mod->init_text_size)
-		    || within(addr, mod->module_core, mod->core_text_size))
+		if (within_len(addr, mod->module_init, mod->init_text_size)
+		    || within_len(addr, mod->module_core, mod->core_text_size))
 			return mod;
 	return NULL;
 }
Index: linux-2.6.26-rc3/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.26-rc3.orig/arch/x86/mm/pageattr.c
+++ linux-2.6.26-rc3/arch/x86/mm/pageattr.c
@@ -2,6 +2,7 @@
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * Thanks to Ben LaHaise for precious feedback.
  */
+#include <linux/kernel.h>
 #include <linux/highmem.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
@@ -54,12 +55,6 @@ static inline unsigned long highmap_end_
 # define debug_pagealloc 0
 #endif
 
-static inline int
-within(unsigned long addr, unsigned long start, unsigned long end)
-{
-	return addr >= start && addr < end;
-}
-
 /*
  * Flushing functions
  */

