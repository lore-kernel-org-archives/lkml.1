Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXKUNnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXKUNnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXKUNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:43:41 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:46507 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119AbXKUNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:43:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAO/EQ0dMROHU/2dsb2JhbACBWw
Date: Wed, 21 Nov 2007 08:38:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Modules: Handle symbols that have a zero value
Message-ID: <20071121133821.GA26686@Krystal>
References: <Pine.LNX.4.64.0711202154430.31617@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711202154430.31617@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:37:09 up 17 days, 18:42,  4 users,  load average: 1.09, 1.13,
	0.91
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> Another issue that I encountered with the cpu_alloc stuff.
> 
> 
> 
> The module subsystem cannot handle symbols that are zero. If symbols are
> present that have a zero value then the module resolver prints out
> a message that these symbols are unresolved.
> 
> Use ERR_PTR to return an error code instead of 0. This is a bit awkward
> since the addresses are handled as unsigned longs. So we need to convert
> them everywhere.
> 
> The idea top use ERR_PTR is from Mathieu.
> 

I thought these functions were returning a pointer. Well, since they are
simply returning an unsigned long, why not use :

return -ENOENT;

directly ?

(ERR_PTR() in linux/err.h is a simple cast from long to void*).

Mathieu

> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  kernel/module.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/kernel/module.c
> ===================================================================
> --- linux-2.6.orig/kernel/module.c	2007-11-20 21:06:29.856965949 -0800
> +++ linux-2.6/kernel/module.c	2007-11-20 21:16:53.001715887 -0800
> @@ -285,7 +285,7 @@ static unsigned long __find_symbol(const
>  		}
>  	}
>  	DEBUGP("Failed to find symbol %s\n", name);
> -	return 0;
> +	return (unsigned long)ERR_PTR(-ENOENT);
>  }
>  
>  /* Search for module by name: must hold module_mutex. */
> @@ -648,7 +648,7 @@ void __symbol_put(const char *symbol)
>  	const unsigned long *crc;
>  
>  	preempt_disable();
> -	if (!__find_symbol(symbol, &owner, &crc, 1))
> +	if (IS_ERR((void *)__find_symbol(symbol, &owner, &crc, 1)))
>  		BUG();
>  	module_put(owner);
>  	preempt_enable();
> @@ -792,7 +792,8 @@ static inline int check_modstruct_versio
>  	const unsigned long *crc;
>  	struct module *owner;
>  
> -	if (!__find_symbol("struct_module", &owner, &crc, 1))
> +	if (IS_ERR((void *)__find_symbol("struct_module",
> +						&owner, &crc, 1)))
>  		BUG();
>  	return check_version(sechdrs, versindex, "struct_module", mod,
>  			     crc);
> @@ -845,7 +846,7 @@ static unsigned long resolve_symbol(Elf_
>  		/* use_module can fail due to OOM, or module unloading */
>  		if (!check_version(sechdrs, versindex, name, mod, crc) ||
>  		    !use_module(mod, owner))
> -			ret = 0;
> +			ret = (unsigned long)ERR_PTR(-EINVAL);
>  	}
>  	return ret;
>  }
> @@ -1238,14 +1239,16 @@ static int verify_export_symbols(struct 
>  	const unsigned long *crc;
>  
>  	for (i = 0; i < mod->num_syms; i++)
> -		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
> +		if (!IS_ERR((void *)__find_symbol(mod->syms[i].name,
> +							&owner, &crc, 1))) {
>  			name = mod->syms[i].name;
>  			ret = -ENOEXEC;
>  			goto dup;
>  		}
>  
>  	for (i = 0; i < mod->num_gpl_syms; i++)
> -		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
> +		if (!IS_ERR((void *)__find_symbol(mod->gpl_syms[i].name,
> +							&owner, &crc, 1))) {
>  			name = mod->gpl_syms[i].name;
>  			ret = -ENOEXEC;
>  			goto dup;
> @@ -1295,7 +1298,7 @@ static int simplify_symbols(Elf_Shdr *se
>  					   strtab + sym[i].st_name, mod);
>  
>  			/* Ok if resolved.  */
> -			if (sym[i].st_value != 0)
> +			if (!IS_ERR((void *)sym[i].st_value))
>  				break;
>  			/* Ok if weak.  */
>  			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
