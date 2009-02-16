Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZBPSGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZBPSGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZBPSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:05:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZBPSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n1oJ/FUnqgm2RNjWWUjdCUawOJa2RdAdlioy4w9L3fbAMpmex13c9J21X92G9S8VI2
         P0Gako2E1HRwDsRAzZzGZeLRGElCCFEzgDyRR5mTws5LbvmaoCGqUyXo49mghPNsbxAK
         LKThG7ee64NRhgTL8rbo0m60tQBycWztz4mPY=
Date: Mon, 16 Feb 2009 18:59:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Message-ID: <20090216175907.GA4582@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215193522.GA5790@nowhere> <200902162040.44178.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902162040.44178.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 08:40:43PM +1030, Rusty Russell wrote:
> On Monday 16 February 2009 06:05:23 Frederic Weisbecker wrote:
> > So the problem seems not related to mac80211 but actually to module parameter management.
> > I'm not sure what is the right fix.
> 
> Good spotting.  And in fact this bug has been here for quite a while...
> 
> The "simple" fix is to kstrdup, but that leaks.
> 
> How's this?


Simple solution, and fixes the problem :-)
I've tested the string parameter change and the mac80211 module unloading as well.
No obvious problem.

Tested-by: Frederic Weisbecker <fweisbec@gmail.com>

And also, Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Just one last little thing, it would be good to strip the ending newline
while using echo without -n
ie:

root@nowhere:/sys/module/mac80211/parameters# echo heh_look_at_my_newline > ieee80211_default_rc_algo 
root@nowhere:/sys/module/mac80211/parameters# cat ieee80211_default_rc_algo 
heh_look_at_my_newline

root@nowhere:/sys/module/mac80211/parameters# echo -n heh_look_at_hum_nothing > ieee80211_default_rc_algo 
root@nowhere:/sys/module/mac80211/parameters# cat ieee80211_default_rc_algo 
heh_look_at_hum_nothing
root@nowhere:/sys/module/mac80211/parameters#

Because I guess modules don't expect this newline on their strcmp.

Thanks :-)

 
> param: fix charp parameters set via sysfs (eg. ieee80211_default_rc_algo)
> 
> The module_param type "charp" simply sets a char * pointer in the
> module to the parameter in the commandline string: this is why we keep
> the (mangled) module command line around.  But when set via sysfs (as
> about 11 charp parameters can be) this memory is freed on the way
> out of the write().
> 
> So we kstrdup instead: this is fine, but it means we have to note when
> we've used it so we can reliably kfree the parameter when it's next
> overwritten, and also on module unload.
> 
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -247,6 +247,10 @@ struct module
>  	const struct kernel_symbol *syms;
>  	const unsigned long *crcs;
>  	unsigned int num_syms;
> +
> +	/* Kernel parameters. */
> +	struct kernel_param *kp;
> +	unsigned int num_kp;
>  
>  	/* GPL-only exported symbols. */
>  	unsigned int num_gpl_syms;
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -138,6 +138,9 @@ extern int parse_args(const char *name,
>  		      unsigned num,
>  		      int (*unknown)(char *param, char *val));
>  
> +/* Called by module remove. */
> +extern void destroy_params(const struct kernel_param *params, unsigned num);
> +
>  /* All the helper functions */
>  /* The macros to do compile-time type checking stolen from Jakub
>     Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1457,6 +1457,9 @@ static void free_module(struct module *m
>  	/* Module unload stuff */
>  	module_unload_free(mod);
>  
> +	/* Free any allocated parameters. */
> +	destroy_params(mod->kp, mod->num_kp);
> +
>  	/* release any pointers to mcount in this module */
>  	ftrace_release(mod->module_core, mod->core_size);
>  
> @@ -1870,8 +1873,7 @@ static noinline struct module *load_modu
>  	unsigned int symindex = 0;
>  	unsigned int strindex = 0;
>  	unsigned int modindex, versindex, infoindex, pcpuindex;
> -	unsigned int num_kp, num_mcount;
> -	struct kernel_param *kp;
> +	unsigned int num_mcount;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> @@ -2116,8 +2118,8 @@ static noinline struct module *load_modu
>  
>  	/* Now we've got everything in the final locations, we can
>  	 * find optional sections. */
> -	kp = section_objs(hdr, sechdrs, secstrings, "__param", sizeof(*kp),
> -			  &num_kp);
> +	mod->kp = section_objs(hdr, sechdrs, secstrings, "__param",
> +			       sizeof(*mod->kp), &mod->num_kp);
>  	mod->syms = section_objs(hdr, sechdrs, secstrings, "__ksymtab",
>  				 sizeof(*mod->syms), &mod->num_syms);
>  	mod->crcs = section_addr(hdr, sechdrs, secstrings, "__kcrctab");
> @@ -2262,11 +2264,11 @@ static noinline struct module *load_modu
>  	 */
>  	list_add_rcu(&mod->list, &modules);
>  
> -	err = parse_args(mod->name, mod->args, kp, num_kp, NULL);
> +	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
>  	if (err < 0)
>  		goto unlink;
>  
> -	err = mod_sysfs_setup(mod, kp, num_kp);
> +	err = mod_sysfs_setup(mod, mod->kp, mod->num_kp);
>  	if (err < 0)
>  		goto unlink;
>  	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> diff --git a/kernel/params.c b/kernel/params.c
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -23,6 +23,9 @@
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> +
> +/* We abuse the high bits of "perm" to record whether we kmalloc'ed. */
> +#define KPARAM_KMALLOCED	0x80000000
>  
>  #if 0
>  #define DEBUGP printk
> @@ -217,7 +220,13 @@ int param_set_charp(const char *val, str
>  		return -ENOSPC;
>  	}
>  
> -	*(char **)kp->arg = (char *)val;
> +	if (kp->perm & KPARAM_KMALLOCED)
> +		kfree(*(char **)kp->arg);
> +
> +	kp->perm |= KPARAM_KMALLOCED;
> +	*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
> +	if (!kp->arg)
> +		return -ENOMEM;
>  	return 0;
>  }
>  
> @@ -571,6 +580,15 @@ void module_param_sysfs_remove(struct mo
>  }
>  #endif
>  
> +void destroy_params(const struct kernel_param *params, unsigned num)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < num; i++)
> +		if (params[i].perm & KPARAM_KMALLOCED)
> +			kfree(*(char **)params[i].arg);
> +}
> +
>  static void __init kernel_add_sysfs_param(const char *name,
>  					  struct kernel_param *kparam,
>  					  unsigned int name_skip)

