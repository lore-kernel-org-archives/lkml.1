Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZBDUth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZBDUth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 15:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZBDUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 15:49:25 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52052 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZBDUtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 15:49:25 -0500
Date: Wed, 4 Feb 2009 15:48:36 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Jeff Arnold <jbarnold@MIT.EDU>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 4/7] Ksplice: Add module_data_address (the analogue of
 module_text_address)
In-Reply-To: <200902042151.35977.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0902041455140.32142@vinegar-pot.mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-4-git-send-email-jbarnold@mit.edu> <1228521840-3886-5-git-send-email-jbarnold@mit.edu> <200902042151.35977.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Rusty Russell wrote:
> Does this mean you really want module_data_address, or you actually want
> a module_address()?

Yeah, that works better.

diff --git a/include/linux/module.h b/include/linux/module.h
index ccbcfa7..42e7c8a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -363,8 +363,8 @@ static inline int module_is_live(struct module *mod)
 /* Is this address in a module? (second is with no locks, for oops) */
 struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
-struct module *module_data_address(unsigned long addr);
-struct module *__module_data_address(unsigned long addr);
+struct module *module_address(unsigned long addr);
+struct module *__module_address(unsigned long addr);
 int is_module_address(unsigned long addr);

 static inline int within_module_core(unsigned long addr, struct module *mod)
diff --git a/kernel/module.c b/kernel/module.c
index b47772d..556112c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2773,35 +2773,32 @@ struct module *module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(module_text_address);

-struct module *__module_data_address(unsigned long addr)
+__notrace_funcgraph struct module *__module_address(unsigned long addr)
 {
 	struct module *mod;

 	if (addr < module_addr_min || addr > module_addr_max)
 		return NULL;

-	list_for_each_entry(mod, &modules, list) {
-		if (within(addr, mod->module_core + mod->core_text_size,
-			   mod->core_size - mod->core_text_size) ||
-		    within(addr, mod->module_init + mod->init_text_size,
-			   mod->init_size - mod->init_text_size))
+	list_for_each_entry_rcu(mod, &modules, list)
+		if (within_module_core(addr, mod) ||
+		    within_module_init(addr, mod))
 			return mod;
-	}
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__module_data_address);
+EXPORT_SYMBOL_GPL(__module_address);

-struct module *module_data_address(unsigned long addr)
+struct module *module_address(unsigned long addr)
 {
 	struct module *mod;

 	preempt_disable();
-	mod = __module_data_address(addr);
+	mod = __module_address(addr);
 	preempt_enable();

 	return mod;
 }
-EXPORT_SYMBOL_GPL(module_data_address);
+EXPORT_SYMBOL_GPL(module_address);

 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
diff --git a/kernel/ksplice.c b/kernel/ksplice.c
index a3f21a6..0404e46 100644
--- a/kernel/ksplice.c
+++ b/kernel/ksplice.c
@@ -999,8 +999,7 @@ static void *map_writable(void *addr, size_t len)
 	int nr_pages = 2;
 	struct page *pages[2];

-	if (__module_text_address((unsigned long)addr) == NULL &&
-	    __module_data_address((unsigned long)addr) == NULL) {
+	if (__module_address((unsigned long)addr) == NULL) {
 		pages[0] = virt_to_page(addr);
 		WARN_ON(!PageReserved(pages[0]));
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
@@ -1412,13 +1411,8 @@ static abort_t try_addr(struct ksplice_pack *pack,
 			enum run_pre_mode mode)
 {
 	abort_t ret;
-	const struct module *run_module;
+	const struct module *run_module = __module_address(run_addr);

-	if ((sect->flags & KSPLICE_SECTION_RODATA) != 0 ||
-	    (sect->flags & KSPLICE_SECTION_DATA) != 0)
-		run_module = __module_data_address(run_addr);
-	else
-		run_module = __module_text_address(run_addr);
 	if (run_module == pack->primary) {
 		ksdebug(pack, "run-pre: unexpected address %lx in primary "
 			"module %s for sect %s\n", run_addr, run_module->name,
