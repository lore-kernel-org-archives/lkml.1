Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbXHWNvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbXHWNvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXHWNu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:50:58 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:41689 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbXHWNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:50:57 -0400
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 09:50:56 EDT
Message-ID: <46CD8C10.8000004@grupopie.com>
Date: Thu, 23 Aug 2007 14:30:56 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] make kobject dynamic allocation check use kallsyms_lookup()
References: <20070822220341.7926F241@kernel>
In-Reply-To: <20070822220341.7926F241@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> One of the top ten sysfs problems is that users use statically
> allocated kobjects.  This patch reminds them that this is a
> naughty thing.
> 
> One _really_ nice thing this patch does, is us the kallsyms
> mechanism to print out exactly which symbol is being complained
> about:
> 
> 	The kobject at, or inside 'statickobj.2'@(0xc040d020) is not dynamically allocated.
> 
> This patch replaces the previous implementation's use of a
> _sdata symbol in favor of using kallsyms_lookup().  If a
> kobject's address is a resolvable symbol, then it isn't
> dynamically allocated.

Just a few concerns that I'm not sure of having been addressed:

  - doing a kallsyms_lookup() is more expensive then just a simple range 
test. This might be a concern if this is called very often. In this case 
you could keep the range check and only do the lookup for symbols that 
fail that check

  - kallsyms_lookup() never finds a symbol if CONFIG_KALLSYMS is not 
selected

  - more comments below

> The one exception to this is init symbols.  The patch also
> checks to see whether __init memory has been freed and if
> it has will allow kobjects in those sections. 
> 
> Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
> ---
> 
>  lxc-dave/arch/i386/kernel/vmlinux.lds.S |    2 --
>  lxc-dave/include/linux/init.h           |    1 +
>  lxc-dave/init/main.c                    |    9 +++++++++
>  lxc-dave/lib/kobject.c                  |   31 ++++++++++++++++++++++---------
>  4 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff -puN lib/kobject.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup lib/kobject.c
> --- lxc/lib/kobject.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup	2007-08-22 14:51:50.000000000 -0700
> +++ lxc-dave/lib/kobject.c	2007-08-22 14:51:50.000000000 -0700
> @@ -139,23 +139,36 @@ static int ptr_in_range(void *ptr, void 
>  	return 0;
>  }
>  
> -static void verify_dynamic_kobject_allocation(struct kobject *kobj)
> +void verify_dynamic_kobject_allocation(struct kobject *kobj)
>  {
> -	if (ptr_in_range(kobj, &_sdata[0], &_edata[0]))
> -		goto warn;
> -	if (ptr_in_range(kobj, &__bss_start[0], &__bss_stop[0]))
> -		goto warn;
> -	return;
> -warn:
> +	char *namebuf;
> +	const char *ret;
> +
> +	namebuf = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);

You don't need kzalloc here. kmalloc will do just fine.

> +	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL,
> +			namebuf);
> +	/*
> +	 * This is the X86_32-only part of this function.
> +	 * This is here because it is valid to have a kobject
> +	 * in an __init section, but only after those
> +	 * sections have been freed back to the dynamic pool.
> +	 */
> +	if (!initmem_now_dynamic &&
> +	    ptr_in_range(kobj, __init_begin, __init_end))
> +		goto out;
> +	if (!ret || !strlen(ret))

The "!strlen(ret)" is not only weird (why not write as "!ret[0] or 
!*ret) but is also unnecessary. When kallsyms_lookup fails to find a 
symbol it should always return NULL.

> +		goto out;
>  	pr_debug("---- begin silly warning ----\n");
>  	pr_debug("This is a janitorial warning, not a kernel bug.\n");
>  #ifdef CONFIG_DEBUG_KOBJECT
> -	print_symbol("The kobject at, or inside %s is not dynamically allocated.\n",
> -			(unsigned long)kobj);
> +	pr_debug("The kobject at, or inside '%s'@(0x%p) is not dynamically allocated.\n",
> +			namebuf, kobj);
>  #endif
>  	pr_debug("kobjects must be dynamically allocated, not static\n");
>  	/* dump_stack(); */
>  	pr_debug("---- end silly warning ----\n");
> +out:
> +	kfree(namebuf);
>  }
>  #else
> [...]

-- 
Paulo Marques - www.grupopie.com

"You're just jealous because the voices only talk to me."
