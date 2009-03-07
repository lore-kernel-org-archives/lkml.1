Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZCGC2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZCGC2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 21:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZCGC2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 21:28:22 -0500
Received: from ozlabs.org ([203.10.76.45]:34439 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZCGC2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 21:28:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] param: fix charp parameters set via sysfs
Date: Sat, 7 Mar 2009 12:58:03 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Greg KH <gregkh@suse.de>,
       stable@kernel.org
References: <200902171010.34819.rusty@rustcorp.com.au> <20090306175854.GA28349@silver.sucs.org>
In-Reply-To: <20090306175854.GA28349@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903071258.03701.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 March 2009 04:28:55 Sitsofe Wheeler wrote:
> On Tue, Feb 17, 2009 at 10:10:34AM +1030, Rusty Russell wrote:
> > Impact: fix crash on reading from /sys/module/.../ieee80211_default_rc_algo
> 
> Is this too late to be queued for 2.6.30 (I guess it missed the current
> window as it doesn't appear to be in 2.6.29-rc7)?

Linus didn't take it.  Since it predates 2.6.29 and not a one-line fix, I
guessed that meant he doesn't want it in 2.6.30.

Just in case, here it is again:

Subject: param: fix charp parameters set via sysfs

Impact: fix crash on reading from /sys/module/.../ieee80211_default_rc_algo

The module_param type "charp" simply sets a char * pointer in the
module to the parameter in the commandline string: this is why we keep
the (mangled) module command line around.  But when set via sysfs (as
about 11 charp parameters can be) this memory is freed on the way
out of the write().  Future reads hit random mem.

So we kstrdup instead: we have to check we're not in early commandline
parsing, and we have to note when we've used it so we can reliably
kfree the parameter when it's next overwritten, and also on module
unload.

(Thanks to Randy Dunlap for CONFIG_SYSFS=n fixes)

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Diagnosed-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/params.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

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
@@ -138,6 +138,16 @@ extern int parse_args(const char *name,
 		      unsigned num,
 		      int (*unknown)(char *param, char *val));
 
+/* Called by module remove. */
+#ifdef CONFIG_SYSFS
+extern void destroy_params(const struct kernel_param *params, unsigned num);
+#else
+static inline void destroy_params(const struct kernel_param *params,
+				  unsigned num)
+{
+}
+#endif /* !CONFIG_SYSFS */
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
@@ -217,7 +220,19 @@ int param_set_charp(const char *val, str
 		return -ENOSPC;
 	}
 
-	*(char **)kp->arg = (char *)val;
+	if (kp->perm & KPARAM_KMALLOCED)
+		kfree(*(char **)kp->arg);
+
+	/* This is a hack.  We can't need to strdup in early boot, and we
+	 * don't need to; this mangled commandline is preserved. */
+	if (slab_is_available()) {
+		kp->perm |= KPARAM_KMALLOCED;
+		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
+		if (!kp->arg)
+			return -ENOMEM;
+	} else
+		*(const char **)kp->arg = val;
+
 	return 0;
 }
 
@@ -571,6 +586,15 @@ void module_param_sysfs_remove(struct mo
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
