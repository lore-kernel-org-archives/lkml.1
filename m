Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZAAMCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZAAMCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 07:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbZAAMCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 07:02:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:52081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755926AbZAAMCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 07:02:41 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/WC/dA1TzW8ztVeFuGY8Q+QOJj5yKVSN0bDKmKEI
	9thqFgy2x84WRQ
Message-ID: <495CB0E3.70509@gmx.de>
Date: Thu, 01 Jan 2009 13:02:43 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel modules
 (take 4)
References: <4959346E.7060600@gmx.de> <200901010002.41477.rusty@rustcorp.com.au> <495B7E24.9010802@gmx.de> <200901011122.01109.rusty@rustcorp.com.au>
In-Reply-To: <200901011122.01109.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thursday 01 January 2009 00:43:56 Helge Deller wrote:
>> Rusty Russell wrote:
>>> Not quite what I had in mind... let me show you:
>>> ...
>>> Otherwise I'd have called it "arch_module_extra_size()".
>> This would mean that I can increase the section size in the arch-specific function
>> by returning a bigger value than sh_size.
>> This would give me space at the end of the section, but not at the beginning 
>> (which is what I need), as sh_entsize (the offset into memory) will stay the 
>> same as before.
> 
> Ah, OK.  I assumed that extra room at the end was sufficient.
> 
> So I've taken your previous patch and renamed the function to
> arch_mod_section_prepend().  

Thanks a lot !!!!
Patch below is ok and I'll adjust the parisc-specific patch
acordingly.

> If we decide not to kill those bad gcc versions,
> I'll stick it in some other random file (lib/weak.c?  Blech...)

Andrew has pulled in the patch from Adrian in his -mm tree, so we should
be safe now.

> BTW, this is very late for this merge window.  I would have liked to see
> this a month ago :(

Yes, sorry, I didn't had a patch available earlier.
I hope it's still in-time though, esp. as this will fix one of our longest
outstanding bugs on parisc and is quite important for us.

Thanks,
Helge


> Subject: module: fix module loading failure of large kernel modules for parisc
> Date: Wed, 31 Dec 2008 12:31:18 +0100
> From: Helge Deller <deller@gmx.de>
> 
> When creating the final layout of a kernel module in memory, allow the
> module loader to reserve some additional memory in front of a given section.
> This is currently only needed for the parisc port which needs to put the
> stub entries there to fulfill the 17/22bit PCREL relocations with large
> kernel modules like xfs.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (renamed fn)
> 
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -12,6 +12,9 @@ int module_frob_arch_sections(Elf_Ehdr *
>  			      Elf_Shdr *sechdrs,
>  			      char *secstrings,
>  			      struct module *mod);
> +
> +/* Additional bytes needed by arch in front of individual sections */
> +unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
>  
>  /* Allocator used for allocating struct module, core sections and init
>     sections.  Returns NULL on failure. */
> diff --git a/kernel/module.c b/kernel/module.c
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1588,11 +1588,21 @@ static int simplify_symbols(Elf_Shdr *se
>  	return ret;
>  }
>  
> +/* Additional bytes needed by arch in front of individual sections */
> +unsigned int __weak arch_mod_section_prepend(struct module *mod,
> +					     unsigned int section)
> +{
> +	/* default implementation just returns zero */
> +	return 0;
> +}
> +
>  /* Update size with this section: return offset. */
> -static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
> +static long get_offset(struct module *mod, unsigned int *size,
> +		       Elf_Shdr *sechdr, unsigned int section)
>  {
>  	long ret;
>  
> +	*size += arch_mod_section_prepend(mod, section);
>  	ret = ALIGN(*size, sechdr->sh_addralign ?: 1);
>  	*size = ret + sechdr->sh_size;
>  	return ret;
> @@ -1632,7 +1642,7 @@ static void layout_sections(struct modul
>  			    || strncmp(secstrings + s->sh_name,
>  				       ".init", 5) == 0)
>  				continue;
> -			s->sh_entsize = get_offset(&mod->core_size, s);
> +			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
>  			DEBUGP("\t%s\n", secstrings + s->sh_name);
>  		}
>  		if (m == 0)
> @@ -1650,7 +1660,7 @@ static void layout_sections(struct modul
>  			    || strncmp(secstrings + s->sh_name,
>  				       ".init", 5) != 0)
>  				continue;
> -			s->sh_entsize = (get_offset(&mod->init_size, s)
> +			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
>  					 | INIT_OFFSET_MASK);
>  			DEBUGP("\t%s\n", secstrings + s->sh_name);
>  		}
> 

