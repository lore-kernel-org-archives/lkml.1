Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYEFEWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYEFEWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYEFEVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:21:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYEFEVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:21:19 -0400
Date: Mon, 5 May 2008 21:19:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 1/6] kernel: call constructors
Message-Id: <20080505211942.3945d01c.akpm@linux-foundation.org>
In-Reply-To: <481F2694.5090601@de.ibm.com>
References: <481F2694.5090601@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 17:24:04 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:

> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Call constructors during kernel init and module load. Required by the
> gcov profiling infrastructure: gcc's profiling code uses constructors
> to register profiling data structures.
> 

Looks sane.

> ---
>  arch/powerpc/kernel/vmlinux.lds.S |    3 +++
>  include/asm-generic/sections.h    |    1 +
>  include/asm-generic/vmlinux.lds.h |    8 ++++++++
>  include/linux/module.h            |    5 +++++
>  init/main.c                       |   10 ++++++++++
>  kernel/module.c                   |   13 +++++++++++++
>  6 files changed, 40 insertions(+)
> 
> Index: linux-2.6.26-rc1/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux-2.6.26-rc1.orig/include/asm-generic/vmlinux.lds.h
> +++ linux-2.6.26-rc1/include/asm-generic/vmlinux.lds.h
> @@ -352,3 +352,11 @@
>  		*(.data.percpu.shared_aligned)				\
>  	}								\
>  	__per_cpu_end = .;
> +
> +#define CONSTRUCTORS							\
> +		__CTOR_LIST__ = .;					\
> +		*(.ctors)						\
> +		__CTOR_END__ = .;					\
> +		__DTOR_LIST__ = .;					\
> +		*(.dtors)						\
> +		__DTOR_END__ = .;
> Index: linux-2.6.26-rc1/arch/powerpc/kernel/vmlinux.lds.S
> ===================================================================
> --- linux-2.6.26-rc1.orig/arch/powerpc/kernel/vmlinux.lds.S
> +++ linux-2.6.26-rc1/arch/powerpc/kernel/vmlinux.lds.S
> @@ -193,6 +193,9 @@ SECTIONS
>  		*(.toc)
>  	}
>  #endif
> +	.data.gcov : {
> +		CONSTRUCTORS
> +	}

Why did powerpc (and only powerpc) need this touchup?  It already includes
asm-generic/vmlinux.lds.h?

>  	. = ALIGN(PAGE_SIZE);
>  	_edata  =  .;
> Index: linux-2.6.26-rc1/include/asm-generic/sections.h
> ===================================================================
> --- linux-2.6.26-rc1.orig/include/asm-generic/sections.h
> +++ linux-2.6.26-rc1/include/asm-generic/sections.h
> @@ -13,5 +13,6 @@ extern char __per_cpu_start[], __per_cpu
>  extern char __kprobes_text_start[], __kprobes_text_end[];
>  extern char __initdata_begin[], __initdata_end[];
>  extern char __start_rodata[], __end_rodata[];
> +extern char __CTOR_LIST__[], __CTOR_END__[];
>  
>  #endif /* _ASM_GENERIC_SECTIONS_H_ */
> Index: linux-2.6.26-rc1/include/linux/module.h
> ===================================================================
> --- linux-2.6.26-rc1.orig/include/linux/module.h
> +++ linux-2.6.26-rc1/include/linux/module.h
> @@ -229,6 +229,8 @@ enum module_state
>  	MODULE_STATE_GOING,
>  };
>  
> +typedef void (*ctorcall_t)(void);
> +
>  struct module
>  {
>  	enum module_state state;
> @@ -342,6 +344,9 @@ struct module
>  	struct marker *markers;
>  	unsigned int num_markers;
>  #endif
> +	/* Constructor calls. */
> +	ctorcall_t *ctors;
> +	unsigned long num_ctors;
>  };
>  #ifndef MODULE_ARCH_INIT
>  #define MODULE_ARCH_INIT {}
> Index: linux-2.6.26-rc1/kernel/module.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/kernel/module.c
> +++ linux-2.6.26-rc1/kernel/module.c
> @@ -1736,6 +1736,7 @@ static struct module *load_module(void _
>  	unsigned int unusedgplcrcindex;
>  	unsigned int markersindex;
>  	unsigned int markersstringsindex;
> +	unsigned int ctorsindex;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> @@ -1832,6 +1833,7 @@ static struct module *load_module(void _
>  #ifdef ARCH_UNWIND_SECTION_NAME
>  	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
>  #endif
> +	ctorsindex = find_sec(hdr, sechdrs, secstrings, ".ctors");
>  
>  	/* Don't keep modinfo and version sections. */
>  	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
> @@ -2041,6 +2043,8 @@ static struct module *load_module(void _
>  	mod->num_markers =
>  		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
>  #endif
> +	mod->ctors = (void *) sechdrs[ctorsindex].sh_addr;
> +	mod->num_ctors = sechdrs[ctorsindex].sh_size / sizeof(*mod->ctors);
>  
>          /* Find duplicate symbols */
>  	err = verify_export_symbols(mod);
> @@ -2153,6 +2157,14 @@ static struct module *load_module(void _
>  	goto free_hdr;
>  }
>  
> +static void do_mod_ctors(struct module *mod)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < mod->num_ctors; i++)
> +		mod->ctors[i]();
> +}
> +
>  /* This is where the real work happens */
>  asmlinkage long
>  sys_init_module(void __user *umod,
> @@ -2183,6 +2195,7 @@ sys_init_module(void __user *umod,
>  	blocking_notifier_call_chain(&module_notify_list,
>  			MODULE_STATE_COMING, mod);
>  
> +	do_mod_ctors(mod);
>  	/* Start the module */
>  	if (mod->init != NULL)
>  		ret = mod->init();
> Index: linux-2.6.26-rc1/init/main.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/init/main.c
> +++ linux-2.6.26-rc1/init/main.c
> @@ -683,6 +683,15 @@ asmlinkage void __init start_kernel(void
>  	rest_init();
>  }
>  
> +static void __init do_ctors(void)
> +{
> +	ctorcall_t *call;
> +
> +	for (call = (ctorcall_t *) __CTOR_LIST__;
> +	     call < (ctorcall_t *) __CTOR_END__; call++)
> +		(*call)();
> +}
> +
>  static int __initdata initcall_debug;
>  
>  static int __init initcall_debug_setup(char *str)
> @@ -760,6 +769,7 @@ static void __init do_basic_setup(void)
>  	usermodehelper_init();
>  	driver_init();
>  	init_irq_proc();
> +	do_ctors();
>  	do_initcalls();
>  }
>  
> 
