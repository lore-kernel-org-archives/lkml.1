Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbYH2TRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbYH2TRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYH2TRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:17:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34118 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbYH2TRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:17:38 -0400
Date: Fri, 29 Aug 2008 21:17:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: rusty@rustcorp.com.au, paulmck@us.ibm.com, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: [PATCH] Remove stop_machine during module load
Message-ID: <20080829191734.GA28329@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove stop_machine during module load

module loading currently does a stop_machine on each module load to insert
the module into the global module lists.  Especially on larger systems this 
can be quite expensive.

It does that to handle concurrent lock lessmodule list readers
like kallsyms.

I don't think stop_machine() is actually needed to insert something
into a list though. There are no concurrent writers because the
module mutex is taken. And the RCU list functions know how to insert
a node into a list with the right memory ordering so that concurrent
readers don't go off into the wood.

So remove the stop_machine for the module list insert and just
do a list_add_rcu() instead. 

Module removal will still do a stop_machine of course, it needs
that for other reasons.

[cc Paul McKenney for review. It's not RCU, but quite similar.]

Cc: rusty@rustcorp.com.au
Cc: paulmck@us.ibm.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/kernel/module.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/kernel/module.c
+++ linux-2.6.27-rc4-misc/kernel/module.c
@@ -42,6 +42,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/unwind.h>
+#include <linux/rculist.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
@@ -61,7 +62,7 @@
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
 /* List of modules, protected by module_mutex or preempt_disable
- * (add/delete uses stop_machine). */
+ * (delete uses stop_machine/add uses RCU list operations). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
@@ -1391,17 +1392,6 @@ static void mod_kobject_remove(struct mo
 }
 
 /*
- * link the module with the whole machine is stopped with interrupts off
- * - this defends against kallsyms not taking locks
- */
-static int __link_module(void *_mod)
-{
-	struct module *mod = _mod;
-	list_add(&mod->list, &modules);
-	return 0;
-}
-
-/*
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
@@ -2196,8 +2186,12 @@ static struct module *load_module(void _
 
 	/* Now sew it into the lists so we can get lockdep and oops
          * info during argument parsing.  Noone should access us, since
-         * strong_try_module_get() will fail. */
-	stop_machine(__link_module, mod, NULL);
+         * strong_try_module_get() will fail.
+	 * lockdep/oops can run asynchronous, so use the RCU list insertion
+	 * function to insert in a way safe to concurrent readers.
+	 * The mutex protects against concurrent writers.
+	 */
+	list_add_rcu(&mod->list, &modules);
 
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
