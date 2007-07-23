Return-Path: <linux-kernel-owner+w=401wt.eu-S934418AbXGWXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbXGWXRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759382AbXGWXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:17:09 -0400
Received: from ozlabs.org ([203.10.76.45]:46405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757780AbXGWXRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:17:06 -0400
Subject: Re: __unsafe() usage
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@stusta.de>
Cc: "Nelson, Shannon" <shannon.nelson@intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lksctp-developers@lists.sourceforge.net
In-Reply-To: <20070723175927.GM26212@stusta.de>
References: <46A3FE3E.20300@googlemail.com>
	 <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
	 <20070723175927.GM26212@stusta.de>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 09:16:41 +1000
Message-Id: <1185232601.1803.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 19:59 +0200, Adrian Bunk wrote:
> On Mon, Jul 23, 2007 at 09:05:54AM -0700, Nelson, Shannon wrote:
> > Gabriel C [mailto:nix.or.die@googlemail.com] 
> > >
> > >Hi,
> > >
> > >I got this warning on current git using gcc 4.2.1 :
> > >
> > >...
> > >
> > >drivers/dma/ioatdma.c: In function 'ioat_init_module':
> > >drivers/dma/ioatdma.c:816: warning: the address of 
> > >'__this_module' will always evaluate as 'true'
> >...
> 
> I'm less interested in why this gives a warning, more interesting is the 
> code:
>         __unsafe(THIS_MODULE);
> 
> @Rusty:
> As far as I understand it, __unsafe() wasn't intended for such a usage, 
> and simply not providing an exit function would be the right solution?
> If this is true, and since the MOD_INC_USE_COUNT compat code is long 
> gone, shouldn't we be able to completely remove __unsafe() and the 
> struct member "unsafe"?

Yes, indeed, something like this:
==
Remove "unsafe" from module struct

Adrian Bunk points out that "unsafe" was used to mark modules touched by
the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's
time to remove the member from the module structure, as well.

If you want a module which can't unload, don't register an exit
function.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
@@ -1216,6 +1215,7 @@ err_chunk_cachep:
 	goto out;
 }
 
+#if 0
 /* Exit handler for the SCTP protocol.  */
 SCTP_STATIC __exit void sctp_exit(void)
 {
@@ -1263,9 +1263,10 @@ SCTP_STATIC __exit void sctp_exit(void)
 
 	proto_unregister(&sctp_prot);
 }
+module_exit(sctp_exit);
+#endif
 
 module_init(sctp_init);
-module_exit(sctp_exit);
 
 /*
  * __stringify doesn't likes enums, so use IPPROTO_SCTP value (132) directly.


