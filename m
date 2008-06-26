Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYFZFrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYFZFrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 01:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYFZFrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 01:47:05 -0400
Received: from ozlabs.org ([203.10.76.45]:36386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbYFZFrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 01:47:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is in a module
Date: Thu, 26 Jun 2008 15:46:58 +1000
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20080610130519.21bc66f3@infradead.org> <20080611081847.0b22079c@infradead.org> <200806121020.58881.rusty@rustcorp.com.au>
In-Reply-To: <200806121020.58881.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261546.58919.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 10:20:58 Rusty Russell wrote:
> Or, we could actually make those as variables and update them in module.c
> itself.  No arch changes required, and pretty easy to understand.

And since you didn't reply, here's the patch.

modules: Take a shortcut for checking if an address is in a module

This patch keeps track of the boundaries of module allocation, in
order to speed up module_text_address().

Inspired by Arjan's version, which required arch-specific defines:

	Various pieces of the kernel (lockdep, latencytop, etc) tend
	to store backtraces, sometimes at a relatively high
	frequency. In itself this isn't a big performance deal (after
	all you're using diagnostics features), but there have been
	some complaints from people who have over 100 modules loaded
	that this is a tad too slow.

	This is due to the new backtracer code which looks at every
	slot on the stack to see if it's a kernel/module text address,
	so that's 1024 slots.  1024 times 100 modules... that's a lot
	of list walking.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -69,6 +69,9 @@ static DECLARE_WAIT_QUEUE_HEAD(module_wq
 static DECLARE_WAIT_QUEUE_HEAD(module_wq);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
+
+/* Bounds of module allocation, for speeding __module_text_address */
+static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
 int register_module_notifier(struct notifier_block * nb)
 {
@@ -1770,6 +1773,20 @@ static inline void add_kallsyms(struct m
 }
 #endif /* CONFIG_KALLSYMS */
 
+static void *module_alloc_update_bounds(unsigned long size)
+{
+	void *ret = module_alloc(size);
+
+	if (ret) {
+		/* Update module bounds. */
+		if ((unsigned long)ret < module_addr_min)
+			module_addr_min = (unsigned long)ret;
+		if ((unsigned long)ret + size > module_addr_max)
+			module_addr_max = (unsigned long)ret + size;
+	}
+	return ret;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static struct module *load_module(void __user *umod,
@@ -1971,7 +1988,7 @@ static struct module *load_module(void _
 	layout_sections(mod, hdr, sechdrs, secstrings);
 
 	/* Do the allocs. */
-	ptr = module_alloc(mod->core_size);
+	ptr = module_alloc_update_bounds(mod->core_size);
 	if (!ptr) {
 		err = -ENOMEM;
 		goto free_percpu;
@@ -1979,7 +1996,7 @@ static struct module *load_module(void _
 	memset(ptr, 0, mod->core_size);
 	mod->module_core = ptr;
 
-	ptr = module_alloc(mod->init_size);
+	ptr = module_alloc_update_bounds(mod->init_size);
 	if (!ptr && mod->init_size) {
 		err = -ENOMEM;
 		goto free_core;
@@ -2636,6 +2653,9 @@ struct module *__module_text_address(uns
 {
 	struct module *mod;
 
+	if (addr < module_addr_min || addr > module_addr_max)
+		return NULL;
+
 	list_for_each_entry(mod, &modules, list)
 		if (within(addr, mod->module_init, mod->init_text_size)
 		    || within(addr, mod->module_core, mod->core_text_size))
