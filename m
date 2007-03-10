Return-Path: <linux-kernel-owner+w=401wt.eu-S1767811AbXCJEbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767811AbXCJEbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767812AbXCJEbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:31:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33113 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767811AbXCJEbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:31:41 -0500
Subject: [RFC PATCH 1/3] Add ability to keep track of callers of
	symbol_(get|put)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: rusty@rustcorp.com.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 02:31:35 -0200
Message-Id: <1173501095.26213.405.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <xyzzy@speakeasy.org>

When a module uses symbol_get() to increase the ref count of another
module, there is no record what module called symbol_get().  A module
can
show up as having other users, but there is no way to tell who those
users are.

This adds that ability to symbol_put() and symbol_get().

__symbol_get() and __symbol_put() get another parameter, which specifies
the module that is doing the getting or putting.  symbol_put_addr() is
renamed to __symbol_put_addr() and has the same parameter added.  The
module can be NULL, in which case the symbol's owner's refcount is
incremented without recording who did it, as was the case before.

The macros symbol_get(), symbol_put(), and symbol_put_addr() will use
THIS_MODULE as the getter/putter and so don't have an extra parameter.
A
macro symbol_put_user() is added that allows specifying the putting
module.

The module_use structure that keeps track of one modules use of another
gains a count member.  The module_use will not go away until the count
goes down to zero.  The count wasn't necessary before because a module
could only use another module once, when the module is linked in, and
un-use that module once, when it is unloaded.

When a module calls symbol_get() to get a symbol from module that owns
the symbol, the ref count of the owning module is _not_ incremented if
the getting module was already listed as using the owning module.
Rather, the count of that module_use is incremented.

When a module is loaded and the kernel module linker is resolving
symbols, it will not increment the module_use count for each symbol
used,
but will just leave it at one.  We don't count each symbol resolved,
because during module unloading we wouldn't know how many times to
decrement the module_use count.

When the module is unloaded, the module_use count will only be
decremented by one, which should bring it to zero.  If it's not zero,
then the remaining count is the number of symbol_get()s the module did
that were unmatched with a symbol_put().

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -169,9 +169,10 @@ struct notifier_block;
 #ifdef CONFIG_MODULES
 
 /* Get/put a kernel symbol (calls must be symmetric) */
-void *__symbol_get(const char *symbol);
+void *__symbol_get(const char *symbol, struct module *user);
 void *__symbol_get_gpl(const char *symbol);
-#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX
#x)))
+#define symbol_get(x) ((typeof(&x))(__symbol_get(MODULE_SYMBOL_PREFIX
#x, \
+			THIS_MODULE)))
 
 #ifndef __GENKSYMS__
 #ifdef CONFIG_MODVERSIONS
@@ -388,9 +389,11 @@ extern void __module_put_and_exit(struct
 
 #ifdef CONFIG_MODULE_UNLOAD
 unsigned int module_refcount(struct module *mod);
-void __symbol_put(const char *symbol);
-#define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x)
-void symbol_put_addr(void *addr);
+void __symbol_put(const char *symbol, struct module *user);
+#define symbol_put(x) __symbol_put(MODULE_SYMBOL_PREFIX #x,
THIS_MODULE)
+#define symbol_put_user(x,u) __symbol_put(MODULE_SYMBOL_PREFIX #x, (u))
+void __symbol_put_addr(void *addr, struct module *user);
+#define symbol_put_addr(x) __symbol_put_addr((x), THIS_MODULE)
 
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -516,30 +516,39 @@ struct module_use
 {
 	struct list_head list;
 	struct module *module_which_uses;
+	int count;
 };
 
-/* Does a already use b? */
-static int already_uses(struct module *a, struct module *b)
+/* Does a already use b?  Return NULL if it doesn't, a pointer to the 
+   relevant module_use structure if it does. */
+static struct module_use *already_uses(struct module *a, struct module
*b)
 {
 	struct module_use *use;
 
 	list_for_each_entry(use, &b->modules_which_use_me, list) {
 		if (use->module_which_uses == a) {
 			DEBUGP("%s uses %s!\n", a->name, b->name);
-			return 1;
+			return use;
 		}
 	}
 	DEBUGP("%s does not use %s!\n", a->name, b->name);
-	return 0;
-}
-
-/* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+	return NULL;
+}
+
+/* Module a uses b 
+   If inc is set, then the use count will be incremented. */
+static int use_module(struct module *a, struct module *b, bool inc)
 {
 	struct module_use *use;
 	int no_warn;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL) return 1;
+
+	if ((use = already_uses(a, b))) {
+		if (inc) use->count++;
+		DEBUGP("%s: %s already used %s, count now at %d\n", __FUNCTION__,
a->name, b->name, use->count);
+		return 1;
+	}
 
 	if (!strong_try_module_get(b))
 		return 0;
@@ -553,11 +562,32 @@ static int use_module(struct module *a, 
 	}
 
 	use->module_which_uses = a;
+	use->count = 1;
 	list_add(&use->list, &b->modules_which_use_me);
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
 
+/* Module a is "un-using" module b.  The use count is decremented, and
if
+   it reaches zero the module_use is removed.  Returns number of
+   remaining uses. */
+static int unuse_module(struct module *a, struct module *b)
+{
+	struct module_use *use = already_uses(a, b);
+	DEBUGP("%s: unuse %s by %s\n", __FUNCTION__, b->name, a->name);
+
+	BUG_ON(!use);
+	DEBUGP("%s: %s used %s %d time(s)\n", __FUNCTION__, a->name, b->name,
use->count);
+	if (! --(use->count)) {
+		DEBUGP("%s: removing module_use structure and sysfs link\n",
__FUNCTION__);
+		list_del(&use->list);
+		kfree(use);
+		sysfs_remove_link(b->holders_dir, a->name);
+		return 0;
+	}
+	return use->count;
+}
+
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
 {
@@ -569,10 +599,9 @@ static void module_unload_free(struct mo
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
 			if (use->module_which_uses == mod) {
 				DEBUGP("%s unusing %s\n", mod->name, i->name);
+				if (unuse_module(mod, i))
+					printk(KERN_ERR "%s unloading but still has uses of %s\n",
mod->name, i->name);
 				module_put(i);
-				list_del(&use->list);
-				kfree(use);
-				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
 				break;
 			}
@@ -755,32 +784,42 @@ static void print_unload_info(struct seq
 		seq_printf(m, "-");
 }
 
-void __symbol_put(const char *symbol)
+void __symbol_put(const char *symbol, struct module *user)
 {
 	struct module *owner;
 	unsigned long flags;
 	const unsigned long *crc;
 
+	DEBUGP("%s: putting %s by %s\n", __FUNCTION__, symbol,
user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	if (!__find_symbol(symbol, &owner, &crc, 1))
 		BUG();
-	module_put(owner);
+
+	/* If the symbol is owned by a module, put it if no user was
+	   specified or if this is the last of user's uses of the module. */
+	if (owner && (!user || !unuse_module(user, owner)))
+		module_put(owner);
 	spin_unlock_irqrestore(&modlist_lock, flags);
 }
 EXPORT_SYMBOL(__symbol_put);
 
-void symbol_put_addr(void *addr)
+void __symbol_put_addr(void *addr, struct module *user)
 {
 	struct module *modaddr;
-
+	unsigned long flags;
+
+	DEBUGP("%s: putting %p by %s\n", __FUNCTION__, addr,
user?user->name:"(unknown)");
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
 	if (!(modaddr = module_text_address((unsigned long)addr)))
 		BUG();
-	module_put(modaddr);
-}
-EXPORT_SYMBOL_GPL(symbol_put_addr);
+	spin_lock_irqsave(&modlist_lock, flags);
+	if (!user || !unuse_module(user, modaddr))
+		module_put(modaddr);
+	spin_unlock_irqrestore(&modlist_lock, flags);
+}
+EXPORT_SYMBOL_GPL(__symbol_put_addr);
 
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
@@ -818,7 +857,7 @@ static inline void module_unload_free(st
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+static inline int use_module(struct module *a, struct module *b, bool
inc)
 {
 	return strong_try_module_get(b);
 }
@@ -961,7 +1000,7 @@ static unsigned long resolve_symbol(Elf_
 	if (ret) {
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
+		    !use_module(mod, owner, false))
 			ret = 0;
 	}
 	return ret;
@@ -1222,15 +1261,17 @@ static void free_module(struct module *m
 	module_free(mod, mod->module_core);
 }
 
-void *__symbol_get(const char *symbol)
+void *__symbol_get(const char *symbol, struct module *user)
 {
 	struct module *owner;
 	unsigned long value, flags;
 	const unsigned long *crc;
 
+	DEBUGP("%s: get symbol %s by %s\n", __FUNCTION__, symbol,
user?user->name:"(unknown)");
 	spin_lock_irqsave(&modlist_lock, flags);
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && !strong_try_module_get(owner))
+	DEBUGP("%s: symbol %s is 0WN3D by %s\n", __FUNCTION__, symbol,
owner?owner->name:"yer mom");
+	if (value && owner && !use_module(user, owner, true))
 		value = 0;
 	spin_unlock_irqrestore(&modlist_lock, flags);
 


