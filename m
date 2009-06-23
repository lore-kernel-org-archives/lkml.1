Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZFWCoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZFWCoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZFWCoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:44:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:60966 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbZFWCoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:44:24 -0400
Date: Tue, 23 Jun 2009 12:43:08 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] RO/NX protection for loadable kernel modules
In-Reply-To: <817ecb6f0906181833m77dcbeder76f0e8c6e85555ef@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0906231240060.31540@tundra.namei.org>
References: <817ecb6f0906181833m77dcbeder76f0e8c6e85555ef@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Siarhei Liakh wrote:

> This patch is a logical extension of the protection provided by
> CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> module_core and module_init into three logical parts each and setting
> appropriate page access permissions for each individual section:
> 
>    1. Code: RO+X
>    2. RO data: RO+NX
>    3. RW data: RW+NX
> 
> In order to achieve proper protection, layout_sections() have been
> modified to align each of the three parts mentioned above onto page
> boundary. Next, the corresponding page access permissions are set
> right before successful exit from load_module(). Further,
> module_free() have been modified to set module_core or module_init as
> RW+NX right before calling vfree(). Functionality of this patch is
> enabled only when CONFIG_DEBUG_RODATA defined at compile time.
> 

This looks potentially useful to me, but I'm not an x86 expert (several 
now added to Cc:).


> The patch have been developed for Linux 2.6.30 i386.
> 
> If there are any issues with the patch formatting and/or kernel
> version, please let me know and I will gladly correct the issues.
> Thank you.
> 
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
> index 0edd819..8a72ef8 100644
> --- a/arch/x86/kernel/module_32.c
> +++ b/arch/x86/kernel/module_32.c
> @@ -22,6 +22,7 @@
>  #include <linux/string.h>
>  #include <linux/kernel.h>
>  #include <linux/bug.h>
> +#include <asm/cacheflush.h>
> 
>  #if 0
>  #define DEBUGP printk
> @@ -29,6 +30,14 @@
>  #define DEBUGP(fmt...)
>  #endif
> 
> +#ifdef CONFIG_DEBUG_RODATA
> +/* Given BASE and SIZE this macro calculates the number of pages this
> + * memory regions occupies */
> +#define NUMBER_OF_PAGES(BASE, SIZE) ( \
> +	( ( (unsigned long) BASE + (unsigned long) SIZE ) >> PAGE_SHIFT ) - \
> +	( ( (unsigned long) BASE ) >> PAGE_SHIFT) + ( (SIZE>0) ? 1:0 ) )
> +#endif
> +
>  void *module_alloc(unsigned long size)
>  {
>  	if (size == 0)
> @@ -40,6 +49,26 @@ void *module_alloc(unsigned long size)
>  /* Free memory returned from module_alloc */
>  void module_free(struct module *mod, void *module_region)
>  {
> +#ifdef CONFIG_DEBUG_RODATA
> +	unsigned long total_pages;
> +
> +	if(mod->module_core == module_region){
> +		/* Set core as NX+RW */
> +		total_pages = NUMBER_OF_PAGES( mod->module_core, mod->core_size );
> +		DEBUGP(KERN_WARNING "RELEASING MODULE CORE: 0x%lx %lu\n",
> +				(unsigned long)mod->module_core, total_pages);
> +		set_memory_nx( (unsigned long)mod->module_core, total_pages);
> +		set_memory_rw( (unsigned long)mod->module_core, total_pages);
> +
> +	}else if(mod->module_init == module_region){
> +		/* Set init as NX+RW */
> +		total_pages = NUMBER_OF_PAGES( mod->module_init, mod->init_size );
> +		DEBUGP(KERN_WARNING "RELEASING MODULE INIT: 0x%lx %lu\n",
> +				(unsigned long)mod->module_init, total_pages);
> +		set_memory_nx( (unsigned long)mod->module_init, total_pages);
> +		set_memory_rw( (unsigned long)mod->module_init, total_pages);
> +	}
> +#endif
>  	vfree(module_region);
>  	/* FIXME: If module_region == mod->init_region, trim exception
>  	   table entries. */
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 627ac08..75e7428 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -293,6 +293,11 @@ struct module
>  	/* The size of the executable code in each section.  */
>  	unsigned int init_text_size, core_text_size;
> 
> +#ifdef CONFIG_DEBUG_RODATA
> +	/* Size of RO sections of the module (text+rodata) */
> +	unsigned int init_ro_size, core_ro_size;
> +#endif
> +
>  	/* Arch-specific module values */
>  	struct mod_arch_specific arch;
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index e797812..4afcb06 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -63,6 +63,14 @@
>  #define ARCH_SHF_SMALL 0
>  #endif
> 
> +#ifdef CONFIG_DEBUG_RODATA
> +/* Given BASE and SIZE this macro calculates the number of pages this
> + * memory regions occupies */
> +#define NUMBER_OF_PAGES(BASE, SIZE) ( \
> +	( ( (unsigned long) BASE + (unsigned long) SIZE ) >> PAGE_SHIFT ) - \
> +	( ( (unsigned long) BASE ) >> PAGE_SHIFT) + ( (SIZE>0) ? 1:0 ) )
> +#endif
> +
>  /* If this is set, the section belongs in the init part of the module */
>  #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
> 
> @@ -1661,6 +1669,10 @@ static void layout_sections(struct module *mod,
>  		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 }
>  	};
>  	unsigned int m, i;
> +#ifdef CONFIG_DEBUG_RODATA
> +	/* always align first section on page boundary */
> +	int need_alignment = 1;
> +#endif
> 
>  	for (i = 0; i < hdr->e_shnum; i++)
>  		sechdrs[i].sh_entsize = ~0UL;
> @@ -1675,13 +1687,39 @@ static void layout_sections(struct module *mod,
>  			    || s->sh_entsize != ~0UL
>  			    || strstarts(secstrings + s->sh_name, ".init"))
>  				continue;
> +#ifdef CONFIG_DEBUG_RODATA
> +			if(need_alignment){
> +				mod->core_size = ALIGN(mod->core_size, PAGE_SIZE);
> +				need_alignment = 0;
> +			}
> +#endif
>  			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
>  			DEBUGP("\t%s\n", secstrings + s->sh_name);
>  		}
> -		if (m == 0)
> +
> +		if (m == 0) {
> +			/* module code size */
>  			mod->core_text_size = mod->core_size;
> +#ifdef CONFIG_DEBUG_RODATA
> +			/* next section should start on new page */
> +			need_alignment = 1;
> +#endif
> +		}
> +
> +#ifdef CONFIG_DEBUG_RODATA
> +		if (m == 1) {
> +			/* module RO size (text+rodata) */
> +			mod->core_ro_size = mod->core_size;
> +			/* next section should start on new page */
> +			need_alignment = 1;
> +		}
> +#endif
>  	}
> 
> +#ifdef CONFIG_DEBUG_RODATA
> +	/* always align first section on page boundary */
> +	need_alignment = 1;
> +#endif
>  	DEBUGP("Init section allocation order:\n");
>  	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
>  		for (i = 0; i < hdr->e_shnum; ++i) {
> @@ -1692,13 +1730,50 @@ static void layout_sections(struct module *mod,
>  			    || s->sh_entsize != ~0UL
>  			    || !strstarts(secstrings + s->sh_name, ".init"))
>  				continue;
> +#ifdef CONFIG_DEBUG_RODATA
> +			if(need_alignment){
> +				mod->init_size = ALIGN(mod->init_size, PAGE_SIZE);
> +				need_alignment = 0;
> +			}
> +#endif			
> +
>  			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
>  					 | INIT_OFFSET_MASK);
>  			DEBUGP("\t%s\n", secstrings + s->sh_name);
>  		}
> -		if (m == 0)
> +
> +		if (m == 0) {
> +			/* module code size */
>  			mod->init_text_size = mod->init_size;
> +#ifdef CONFIG_DEBUG_RODATA
> +			/* next section should start on new page */
> +			need_alignment = 1;
> +#endif
> +		}
> +
> +#ifdef CONFIG_DEBUG_RODATA
> +		if (m == 1) {
> +			// module RO size (text+rodata)
> +			mod->init_ro_size = mod->init_size;
> +			// next section should start on new page
> +			need_alignment = 1;
> +		}
> +#endif
>  	}
> +#ifdef CONFIG_DEBUG_RODATA
> +	DEBUGP( "core_text_size: %i\n"
> +		"core_ro_size: %i\n"
> +		"core_size: %i\n"
> +		"init_text_size: %i\n"
> +		"init_ro_size: %i\n"
> +		"init_size: %i\n",
> +		mod->core_text_size,
> +		mod->core_ro_size,
> +		mod->core_size,
> +		mod->init_text_size,
> +		mod->init_ro_size,
> +		mod->init_size);
> +#endif
>  }
> 
>  static void set_license(struct module *mod, const char *license)
> @@ -1898,6 +1973,12 @@ static noinline struct module *load_module(void
> __user *umod,
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
>  	unsigned long *mseg;
>  	mm_segment_t old_fs;
> +#ifdef CONFIG_DEBUG_RODATA
> +	/* these variables are used to set RO and NX regions */
> +	unsigned long total_pages;
> +	unsigned long text_pages;
> +	unsigned long ro_pages;
> +#endif
> 
>  	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
>  	       umod, len, uargs);
> @@ -2291,6 +2372,73 @@ static noinline struct module *load_module(void
> __user *umod,
>  	/* Get rid of temporary copy */
>  	vfree(hdr);
> 
> +#ifdef CONFIG_DEBUG_RODATA
> +	/* In this section we calculate the number of pages for
> +	 * each part of core and init: code, ro data, rw data.
> +	 * Then we set code as RO+X, ro data as RO+NX, and rw data as RW+NX
> +	 * Siarhei Liakh
> +	 * Xuxian Jiang  */
> +	DEBUGP(	"module_core: 0x%lx %lu\n"
> +		"module_init: 0x%lx %lu\n",
> +		(unsigned long)mod->module_core,
> +		(unsigned long)mod->core_size,
> +		(unsigned long)mod->module_init,
> +		(unsigned long)mod->init_size);
> +
> +	/* calculate RO and NX regions for core */
> +	total_pages = NUMBER_OF_PAGES( mod->module_core, mod->core_size);
> +	text_pages = NUMBER_OF_PAGES( mod->module_core, mod->core_text_size);
> +	ro_pages = NUMBER_OF_PAGES( mod->module_core, mod->core_ro_size);
> +
> +	DEBUGP(	"CORE:\n  text_pages: %lu\n"
> +		"  ro_pages: %lu\n  total_pages: %lu\n",
> +		text_pages, ro_pages,total_pages);
> +
> +	/* Set text and RO data as RO */
> +	DEBUGP(	"  RO: 0x%lx %lu\n",
> +		(unsigned long)mod->module_core, ro_pages);
> +
> +	if(ro_pages>0)
> +		set_memory_ro( (unsigned long)mod->module_core, ro_pages);
> +
> +	/* Set all data as NX */
> +	DEBUGP(	"  NX: 0x%lx %lu\n",
> +		(unsigned long)mod->module_core +
> +		(text_pages << PAGE_SHIFT) ,
> +		total_pages - text_pages );
> +
> +	if(total_pages > text_pages)
> +		set_memory_nx( (unsigned long)mod->module_core +
> +			  	(text_pages << PAGE_SHIFT) ,
> +				 total_pages - text_pages );
> +
> +	/* calculate RO and NX regions for init */
> +	total_pages = NUMBER_OF_PAGES( mod->module_init, mod->init_size);
> +	text_pages = NUMBER_OF_PAGES( mod->module_init, mod->init_text_size);
> +	ro_pages = NUMBER_OF_PAGES( mod->module_init, mod->init_ro_size);
> +	
> +	DEBUGP(	"INIT:\n  text_pages: %lu\n"
> +		"  ro_pages: %lu\n  total_pages: %lu\n",
> +		text_pages, ro_pages, total_pages);
> +
> +	/* Set text and RO data as RO */
> +	DEBUGP(	"  RO: 0x%lx %lu\n",
> +		(unsigned long)mod->module_init, ro_pages);
> +
> +	if(ro_pages>0)
> +		set_memory_ro( (unsigned long)mod->module_init, ro_pages);
> +
> +	/* Set all data as NX */
> +	DEBUGP(	"  NX: 0x%lx %lu\n",
> +		(unsigned long)mod->module_init + (text_pages << PAGE_SHIFT),
> +		total_pages - text_pages );
> +
> +	if(total_pages > text_pages)
> +		set_memory_nx( (unsigned long)mod->module_init +
> +			  	(text_pages << PAGE_SHIFT) ,
> +				 total_pages - text_pages );
> +#endif
> +
>  	/* Done! */
>  	return mod;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
