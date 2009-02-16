Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZBPKLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZBPKLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZBPKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:10:58 -0500
Received: from ozlabs.org ([203.10.76.45]:55784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZBPKK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:10:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Date: Mon, 16 Feb 2009 20:40:43 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215193522.GA5790@nowhere>
In-Reply-To: <20090215193522.GA5790@nowhere>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902162040.44178.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 06:05:23 Frederic Weisbecker wrote:
> So the problem seems not related to mac80211 but actually to module parameter management.
> I'm not sure what is the right fix.

Good spotting.  And in fact this bug has been here for quite a while...

The "simple" fix is to kstrdup, but that leaks.

How's this?

param: fix charp parameters set via sysfs (eg. ieee80211_default_rc_algo)

The module_param type "charp" simply sets a char * pointer in the
module to the parameter in the commandline string: this is why we keep
the (mangled) module command line around.  But when set via sysfs (as
about 11 charp parameters can be) this memory is freed on the way
out of the write().

So we kstrdup instead: this is fine, but it means we have to note when
we've used it so we can reliably kfree the parameter when it's next
overwritten, and also on module unload.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -247,6 +247,10 @@ struct module
 	const struct kernel_symbol *syms;
 	const unsigned long *crcs;
 	unsigned int num_syms;
+
+	/* Kernel parameters. */
+	struct kernel_param *kp;
+	unsigned int num_kp;
 
 	/* GPL-only exported symbols. */
 	unsigned int num_gpl_syms;
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -138,6 +138,9 @@ extern int parse_args(const char *name,
 		      unsigned num,
 		      int (*unknown)(char *param, char *val));
 
+/* Called by module remove. */
+extern void destroy_params(const struct kernel_param *params, unsigned num);
+
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub
    Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1457,6 +1457,9 @@ static void free_module(struct module *m
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+	/* Free any allocated parameters. */
+	destroy_params(mod->kp, mod->num_kp);
+
 	/* release any pointers to mcount in this module */
 	ftrace_release(mod->module_core, mod->core_size);
 
@@ -1870,8 +1873,7 @@ static noinline struct module *load_modu
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
 	unsigned int modindex, versindex, infoindex, pcpuindex;
-	unsigned int num_kp, num_mcount;
-	struct kernel_param *kp;
+	unsigned int num_mcount;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2116,8 +2118,8 @@ static noinline struct module *load_modu
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	kp = section_objs(hdr, sechdrs, secstrings, "__param", sizeof(*kp),
-			  &num_kp);
+	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
+			       sizeof(*mod->kp), &mod->num_kp);
 	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
 				 sizeof(*mod->syms), &mod->num_syms);
 	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
@@ -2262,11 +2264,11 @@ static noinline struct module *load_modu
 	 */
 	list_add_rcu(&mod->list, &modules);
 
-	err = parse_args(mod->name, mod->args, kp, num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
 		goto unlink;
 
-	err = mod_sysfs_setup(mod, kp, num_kp);
+	err = mod_sysfs_setup(mod, mod->kp, mod->num_kp);
 	if (err < 0)
 		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -23,6 +23,9 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+
+/* We abuse the high bits of "perm" to record whether we kmalloc'ed. */
+#define KPARAM_KMALLOCED	0x80000000
 
 #if 0
 #define DEBUGP printk
@@ -217,7 +220,13 @@ int param_set_charp(const char *val, str
 		return -ENOSPC;
 	}
 
-	*(char **)kp->arg = (char *)val;
+	if (kp->perm & KPARAM_KMALLOCED)
+		kfree(*(char **)kp->arg);
+
+	kp->perm |= KPARAM_KMALLOCED;
+	*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
+	if (!kp->arg)
+		return -ENOMEM;
 	return 0;
 }
 
@@ -571,6 +580,15 @@ void module_param_sysfs_remove(struct mo
 }
 #endif
 
+void destroy_params(const struct kernel_param *params, unsigned num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		if (params[i].perm & KPARAM_KMALLOCED)
+			kfree(*(char **)params[i].arg);
+}
+
 static void __init kernel_add_sysfs_param(const char *name,
 					  struct kernel_param *kparam,
 					  unsigned int name_skip)
