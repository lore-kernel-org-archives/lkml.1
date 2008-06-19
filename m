Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYFSNMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYFSNMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbYFSNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:11:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:40908 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754978AbYFSNL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:11:56 -0400
Date: Thu, 19 Jun 2008 15:11:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, llipavsky@suse.cz
Subject: [PATCH] module: make symbol_put_addr() work for all exported
 symbols
Message-ID: <alpine.LNX.1.10.0806191508020.4593@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

symbol_put_addr() works only for exported function names (symbols present 
in text section). This for example means that

         symbol_put_addr(__symbol_get("any_exported_variable_name"))

triggers a BUG, which really seems wrong.

This patch introduces generic lookup_symbol_address(), which performs 
lookup on symbol tables of all modules according to the address, and makes 
symbol_put_addr() use this interface to find the module owner instead.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..77ff23e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -302,6 +302,64 @@ static unsigned long find_symbol(const char *name,
  	return -ENOENT;
  }

+/* Lookup module symbol by address */
+const static struct kernel_symbol *lookup_symbol_address(unsigned long addr,
+		struct module **owner)
+{
+	struct module *mod;
+	const struct kernel_symbol *s;
+	unsigned int i;
+
+	/* Core kernel first */
+	struct {
+		const struct kernel_symbol *s_start;
+		const struct kernel_symbol *s_end;
+	} kern_syms[] = {
+		{ __start___ksymtab, __stop___ksymtab },
+		{ __start___ksymtab_gpl, __stop___ksymtab_gpl },
+		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future },
+		{ __start___ksymtab_unused, __stop___ksymtab_unused },
+		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(kern_syms); i++) {
+		for (s = kern_syms[i].s_start; s < kern_syms[i].s_end; s++) {
+			if (s->value == addr) {
+				if (owner)
+					*owner = NULL;
+				return s;
+			}
+		}
+	}
+
+	/* Now try modules */
+	list_for_each_entry(mod, &modules, list) {
+		struct {
+			const struct kernel_symbol *sym;
+			unsigned int num;
+		} arr[] = {
+			{ mod->syms, mod->num_syms },
+			{ mod->gpl_syms, mod->num_gpl_syms },
+			{ mod->gpl_future_syms, mod->num_gpl_future_syms },
+			{ mod->unused_syms, mod->num_unused_syms },
+			{ mod->unused_gpl_syms, mod->num_unused_gpl_syms },
+		};
+
+		for (i = 0; i < ARRAY_SIZE(arr); i++) {
+			for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
+				if (s->value == addr) {
+					if (owner)
+						*owner = mod;
+					return s;
+				}
+			}
+		}
+	}
+	return NULL;
+}
+
+
+
  /* Search for module by name: must hold module_mutex. */
  static struct module *find_module(const char *name)
  {
@@ -799,13 +857,12 @@ EXPORT_SYMBOL(__symbol_put);
  void symbol_put_addr(void *addr)
  {
  	struct module *modaddr;
-
-	if (core_kernel_text((unsigned long)addr))
-		return;
-
-	if (!(modaddr = module_text_address((unsigned long)addr)))
+
+	if (!lookup_symbol_address((unsigned long)addr, &modaddr))
  		BUG();
-	module_put(modaddr);
+
+	if(modaddr)
+		module_put(modaddr);
  }
  EXPORT_SYMBOL_GPL(symbol_put_addr);



