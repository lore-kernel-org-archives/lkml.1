Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYHUUpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYHUUpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYHUUpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:45:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbYHUUp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:45:29 -0400
Date: Thu, 21 Aug 2008 16:45:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: fix warning when !CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080821204513.GC6273@redhat.com>
References: <20080820141329.GB7622@orion> <20080820142453.GA31886@suse.de> <20080820151303.GA1754@suse.de> <20080821203539.GB6273@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821203539.GB6273@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 04:35:39PM -0400, Jason Baron wrote:
> looks much cleaner. thanks.
> 
> we can simplify this module code a bit more...how about the following on top of
> what you did? 
> 
> thanks,
> 
> -Jason
> 

or better yet, without trailing whitespace...

Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 include/linux/module.h |    5 -----
 kernel/module.c        |   40 +++++++++++++++++-----------------------
 2 files changed, 17 insertions(+), 28 deletions(-)


diff --git a/include/linux/module.h b/include/linux/module.h
index 3336bd3..5d2970c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -350,11 +350,6 @@ struct module
 	/* Reference counts */
 	struct module_ref ref[NR_CPUS];
 #endif
-
-#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-	struct mod_debug *start_verbose;
-	unsigned int num_verbose;
-#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index b227ca4..2f69b81 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1787,34 +1787,28 @@ static inline void add_kallsyms(struct module *mod,
 #endif /* CONFIG_KALLSYMS */
 
 #ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
-static void dynamic_printk_setup(struct module *mod,
-				 Elf_Shdr *sechdrs,
-				 unsigned int verboseindex,
-				 const char *secstrings)
+static void dynamic_printk_setup(Elf_Shdr *sechdrs, unsigned int verboseindex)
 {
-	struct mod_debug *iter;
-	unsigned long value;
+	struct mod_debug *debug_info;
+	unsigned long pos, end;
+	unsigned int num_verbose;
 
-	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
-	mod->num_verbose = sechdrs[verboseindex].sh_size /
-				sizeof(*mod->start_verbose);
+	pos = sechdrs[verboseindex].sh_addr;
+	num_verbose = sechdrs[verboseindex].sh_size /
+				sizeof(struct mod_debug);
+	end = pos + (num_verbose * sizeof(struct mod_debug));
 
-	for (value = (unsigned long)mod->start_verbose;
-		value < (unsigned long)mod->start_verbose +
-		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
-		value += sizeof(struct mod_debug)) {
-			iter = (struct mod_debug *)value;
-			register_dynamic_debug_module(iter->modname,
-				iter->type,
-				iter->logical_modname,
-				iter->flag_names, iter->hash, iter->hash2);
+	for (; pos < end; pos += sizeof(struct mod_debug)) {
+		debug_info = (struct mod_debug *)pos;
+		register_dynamic_debug_module(debug_info->modname,
+			debug_info->type, debug_info->logical_modname,
+			debug_info->flag_names, debug_info->hash,
+			debug_info->hash2);
 	}
 }
 #else
-static inline void dynamic_printk_setup(struct module *mod,
-					Elf_Shdr *sechdrs,
-					unsigned int symindex,
-					const char *secstrings)
+static inline void dynamic_printk_setup(Elf_Shdr *sechdrs,
+					unsigned int verboseindex)
 {
 }
 #endif /* CONFIG_DYNAMIC_PRINTK_DEBUG */
@@ -2221,7 +2215,7 @@ static struct module *load_module(void __user *umod,
 			mod->tracepoints + mod->num_tracepoints);
 #endif
 	}
-	dynamic_printk_setup(mod, sechdrs, verboseindex, secstrings);
+	dynamic_printk_setup(sechdrs, verboseindex);
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
