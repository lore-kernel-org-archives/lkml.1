Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbXGXW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbXGXW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbXGXW1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 18:27:37 -0400
Received: from ozlabs.org ([203.10.76.45]:39370 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbXGXW1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 18:27:36 -0400
Subject: Re: [Lksctp-developers] __unsafe() usage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: Adrian Bunk <bunk@stusta.de>, lksctp-developers@lists.sourceforge.net,
       Gabriel C <nix.or.die@googlemail.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <46A5F91B.50403@hp.com>
References: <46A3FE3E.20300@googlemail.com>
	 <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
	 <20070723175927.GM26212@stusta.de>
	 <1185232601.1803.41.camel@localhost.localdomain>  <46A5F91B.50403@hp.com>
Content-Type: text/plain
Date: Wed, 25 Jul 2007 08:27:07 +1000
Message-Id: <1185316027.1803.351.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 09:05 -0400, Vlad Yasevich wrote:
> 
> Please don't remove module_exit point for SCTP.  Simply removing the __unsafe() call will
> be sufficient.
> 
> The code has recently been cleaned up to allow safe unloading and I working on final
> cleanups.  It currently works correctly with forced unloading.

Thanks Vlad!

I think that's everyone...

Cheers,
Rusty.
===
Remove "unsafe" from module struct

Adrian Bunk points out that "unsafe" was used to mark modules touched by
the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's
time to remove the member from the module structure, as well.

If you want a module which can't unload, don't register an exit
function.

(Vlad Yasevich says SCTP is now safe to unload, so just remove the
__unsafe there).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>

diff -r d7af727512fd drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c	Tue Jul 24 08:30:05 2007 +1000
+++ b/drivers/dma/ioatdma.c	Tue Jul 24 09:11:11 2007 +1000
@@ -811,18 +811,17 @@ MODULE_AUTHOR("Intel Corporation");
 
 static int __init ioat_init_module(void)
 {
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
-
 	return pci_register_driver(&ioat_pci_driver);
 }
 
 module_init(ioat_init_module);
 
+/* it's currently unsafe to unload this module */
+#if 0
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
 }
 
 module_exit(ioat_exit_module);
+#endif
diff -r d7af727512fd drivers/dma/iop-adma.c
--- a/drivers/dma/iop-adma.c	Tue Jul 24 08:30:05 2007 +1000
+++ b/drivers/dma/iop-adma.c	Tue Jul 24 09:11:30 2007 +1000
@@ -1446,21 +1446,20 @@ static struct platform_driver iop_adma_d
 
 static int __init iop_adma_init (void)
 {
-	/* it's currently unsafe to unload this module */
-	/* if forced, worst case is that rmmod hangs */
-	__unsafe(THIS_MODULE);
-
 	return platform_driver_register(&iop_adma_driver);
 }
 
+/* it's currently unsafe to unload this module */
+#if 0
 static void __exit iop_adma_exit (void)
 {
 	platform_driver_unregister(&iop_adma_driver);
 	return;
 }
+module_exit(iop_adma_exit);
+#endif
 
 module_init(iop_adma_init);
-module_exit(iop_adma_exit);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("IOP ADMA Engine Driver");
diff -r d7af727512fd include/linux/module.h
--- a/include/linux/module.h	Tue Jul 24 08:30:05 2007 +1000
+++ b/include/linux/module.h	Tue Jul 24 09:00:19 2007 +1000
@@ -312,9 +312,6 @@ struct module
 	/* Arch-specific module values */
 	struct mod_arch_specific arch;
 
-	/* Am I unsafe to unload? */
-	int unsafe;
-
 	unsigned int taints;	/* same bits as kernel:tainted */
 
 #ifdef CONFIG_GENERIC_BUG
@@ -441,16 +438,6 @@ static inline void __module_get(struct m
 	__mod ? __mod->name : "kernel";		\
 })
 
-#define __unsafe(mod)							     \
-do {									     \
-	if (mod && !(mod)->unsafe) {					     \
-		printk(KERN_WARNING					     \
-		       "Module %s cannot be unloaded due to unsafe usage in" \
-		       " %s:%u\n", (mod)->name, __FILE__, __LINE__);	     \
-		(mod)->unsafe = 1;					     \
-	}								     \
-} while(0)
-
 /* For kallsyms to ask for address resolution.  NULL means not found. */
 const char *module_address_lookup(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -518,8 +505,6 @@ static inline void module_put(struct mod
 
 #define module_name(mod) "kernel"
 
-#define __unsafe(mod)
-
 /* For kallsyms to ask for address resolution.  NULL means not found. */
 static inline const char *module_address_lookup(unsigned long addr,
 						unsigned long *symbolsize,
diff -r d7af727512fd kernel/module.c
--- a/kernel/module.c	Tue Jul 24 08:30:05 2007 +1000
+++ b/kernel/module.c	Tue Jul 24 09:00:58 2007 +1000
@@ -692,8 +692,7 @@ sys_delete_module(const char __user *nam
 	}
 
 	/* If it has an init func, it must have an exit func to unload */
-	if ((mod->init != NULL && mod->exit == NULL)
-	    || mod->unsafe) {
+	if (mod->init && !mod->exit) {
 		forced = try_force_unload(flags);
 		if (!forced) {
 			/* This module can't be removed */
@@ -739,11 +738,6 @@ static void print_unload_info(struct seq
 	list_for_each_entry(use, &mod->modules_which_use_me, list) {
 		printed_something = 1;
 		seq_printf(m, "%s,", use->module_which_uses->name);
-	}
-
-	if (mod->unsafe) {
-		printed_something = 1;
-		seq_printf(m, "[unsafe],");
 	}
 
 	if (mod->init != NULL && mod->exit == NULL) {
@@ -2012,15 +2006,10 @@ sys_init_module(void __user *umod,
                    buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
 		synchronize_sched();
-		if (mod->unsafe)
-			printk(KERN_ERR "%s: module is now stuck!\n",
-			       mod->name);
-		else {
-			module_put(mod);
-			mutex_lock(&module_mutex);
-			free_module(mod);
-			mutex_unlock(&module_mutex);
-		}
+		module_put(mod);
+		mutex_lock(&module_mutex);
+		free_module(mod);
+		mutex_unlock(&module_mutex);
 		return ret;
 	}
 
diff -r d7af727512fd net/sctp/protocol.c
--- a/net/sctp/protocol.c	Tue Jul 24 08:30:05 2007 +1000
+++ b/net/sctp/protocol.c	Tue Jul 24 09:12:43 2007 +1000
@@ -1176,7 +1176,6 @@ SCTP_STATIC __init int sctp_init(void)
 	if (status)
 		goto err_v6_add_protocol;
 
-	__unsafe(THIS_MODULE);
 	status = 0;
 out:
 	return status;


