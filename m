Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYHUUgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYHUUgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYHUUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:35:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYHUUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:35:54 -0400
Date: Thu, 21 Aug 2008 16:35:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/module: fix warning when !CONFIG_DYNAMIC_PRINTK_DEBUG
Message-ID: <20080821203539.GB6273@redhat.com>
References: <20080820141329.GB7622@orion> <20080820142453.GA31886@suse.de> <20080820151303.GA1754@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820151303.GA1754@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 08:13:03AM -0700, Greg KH wrote:
> I'll merge in this patch below, unless someone objects.
> 
> thanks,
> 
> greg k-h
> 
> ---
>  kernel/module.c |   54 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 20 deletions(-)
> 
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1778,12 +1778,44 @@ static void add_kallsyms(struct module *
>  static inline void add_kallsyms(struct module *mod,
>  				Elf_Shdr *sechdrs,
>  				unsigned int symindex,
> -				unsigned int strindex,
>  				const char *secstrings)
>  {
>  }
>  #endif /* CONFIG_KALLSYMS */
>  
> +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> +static void dynamic_printk_setup(struct module *mod,
> +				 Elf_Shdr *sechdrs,
> +				 unsigned int verboseindex,
> +				 const char *secstrings)
> +{
> +	struct mod_debug *iter;
> +	unsigned long value;
> +
> +	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
> +	mod->num_verbose = sechdrs[verboseindex].sh_size /
> +				sizeof(*mod->start_verbose);
> +
> +	for (value = (unsigned long)mod->start_verbose;
> +		value < (unsigned long)mod->start_verbose +
> +		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
> +		value += sizeof(struct mod_debug)) {
> +			iter = (struct mod_debug *)value;
> +			register_dynamic_debug_module(iter->modname,
> +				iter->type,
> +				iter->logical_modname,
> +				iter->flag_names, iter->hash, iter->hash2);
> +	}
> +}
> +#else
> +static inline void dynamic_printk_setup(struct module *mod,
> +					Elf_Shdr *sechdrs,
> +					unsigned int symindex,
> +					const char *secstrings)
> +{
> +}
> +#endif /* CONFIG_DYNAMIC_PRINTK_DEBUG */
> +
>  static void *module_alloc_update_bounds(unsigned long size)
>  {
>  	void *ret = module_alloc(size);
> @@ -1833,8 +1865,6 @@ static struct module *load_module(void _
>  	unsigned int markersindex;
>  	unsigned int markersstringsindex;
>  	unsigned int verboseindex;
> -	struct mod_debug *iter;
> -	unsigned long value;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> @@ -2149,11 +2179,6 @@ static struct module *load_module(void _
>  	mod->num_markers =
>  		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
>  #endif
> -#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> -	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
> -	mod->num_verbose = sechdrs[verboseindex].sh_size /
> -				sizeof(*mod->start_verbose);
> -#endif
>  
>          /* Find duplicate symbols */
>  	err = verify_export_symbols(mod);
> @@ -2177,18 +2202,7 @@ static struct module *load_module(void _
>  		marker_update_probe_range(mod->markers,
>  			mod->markers + mod->num_markers);
>  #endif
> -#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> -	for (value = (unsigned long)mod->start_verbose;
> -		value < (unsigned long)mod->start_verbose +
> -		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
> -		value += sizeof(struct mod_debug)) {
> -			iter = (struct mod_debug *)value;
> -			register_dynamic_debug_module(iter->modname,
> -				iter->type,
> -				iter->logical_modname,
> -				iter->flag_names, iter->hash, iter->hash2);
> -	}
> -#endif
> +	dynamic_printk_setup(mod, sechdrs, verboseindex, secstrings);
>  	err = module_finalize(hdr, sechdrs, mod);
>  	if (err < 0)
>  		goto cleanup;


looks much cleaner. thanks.

we can simplify this module code a bit more...how about the following on top of
what you did? 

thanks,

-Jason

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
index b227ca4..dc5fa65 100644
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
