Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYKKU5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYKKU5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYKKU4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:56:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYKKU4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:56:52 -0500
Message-ID: <4919F169.5000103@redhat.com>
Date: Tue, 11 Nov 2008 15:56:09 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH 1/7] module: Add within_module_core() and within_module_init()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add within_module_core() and within_module_init() for checking whether an
address is in the module .init.text section or .text section, and replace
within() local inline functions in kernel/module.c with them.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/module.h |   12 ++++++++++++
 kernel/module.c        |   25 ++++++++++---------------
 2 files changed, 22 insertions(+), 15 deletions(-)

kprobes uses these functions to check where the kprobe is inserted.

Index: 2.6.28-rc4/include/linux/module.h
===================================================================
--- 2.6.28-rc4.orig/include/linux/module.h
+++ 2.6.28-rc4/include/linux/module.h
@@ -368,6 +368,18 @@ struct module *module_text_address(unsig
 struct module *__module_text_address(unsigned long addr);
 int is_module_address(unsigned long addr);

+static inline int within_module_core(unsigned long addr, struct module *mod)
+{
+	return mod->module_core <= (void *)addr &&
+	       (void *)addr < mod->module_core + mod->core_size;
+}
+
+static inline int within_module_init(unsigned long addr, struct module *mod)
+{
+	return mod->module_init <= (void *)addr &&
+	       (void *)addr < mod->module_init + mod->init_size;
+}
+
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
Index: 2.6.28-rc4/kernel/module.c
===================================================================
--- 2.6.28-rc4.orig/kernel/module.c
+++ 2.6.28-rc4/kernel/module.c
@@ -2360,11 +2360,6 @@ sys_init_module(void __user *umod,
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
@@ -2385,7 +2380,7 @@ static const char *get_ksymbol(struct mo
 	unsigned long nextval;

 	/* At worse, next value is at end of module */
-	if (within(addr, mod->module_init, mod->init_size))
+	if (within_module_init(addr, mod))
 		nextval = (unsigned long)mod->module_init+mod->init_text_size;
 	else
 		nextval = (unsigned long)mod->module_core+mod->core_text_size;
@@ -2433,8 +2428,8 @@ const char *module_address_lookup(unsign

 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size)
-		    || within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -2456,8 +2451,8 @@ int lookup_module_symbol_name(unsigned l

 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			const char *sym;

 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -2480,8 +2475,8 @@ int lookup_module_symbol_attrs(unsigned

 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_init, mod->init_size) ||
-		    within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod)) {
 			const char *sym;

 			sym = get_ksymbol(mod, addr, size, offset);
@@ -2700,7 +2695,7 @@ int is_module_address(unsigned long addr
 	preempt_disable();

 	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within(addr, mod->module_core, mod->core_size)) {
+		if (within_module_core(addr, mod)) {
 			preempt_enable();
 			return 1;
 		}
@@ -2721,8 +2716,8 @@ struct module *__module_text_address(uns
 		return NULL;

 	list_for_each_entry_rcu(mod, &modules, list)
-		if (within(addr, mod->module_init, mod->init_text_size)
-		    || within(addr, mod->module_core, mod->core_text_size))
+		if (within_module_init(addr, mod) ||
+		    within_module_core(addr, mod))
 			return mod;
 	return NULL;
 }

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

