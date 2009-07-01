Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZGAGQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZGAGQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZGAGQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:16:20 -0400
Received: from ozlabs.org ([203.10.76.45]:40011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZGAGQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:16:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH 1/2] reduce symbol table for loaded modules
Date: Wed, 1 Jul 2009 15:46:21 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A4A1C6C0200007800008369@vpn.id2.novell.com>
In-Reply-To: <4A4A1C6C0200007800008369@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011546.21597.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 09:38:43 pm Jan Beulich wrote:
> Discard all symbols not interesting for kallsyms use: absolute,
> section, and in the common case (!KALLSYMS_ALL) data ones.

I like the idea, but implementation could probably be polished a little bit.

> +static unsigned int filter_symbols(Elf_Sym *dst,
> +				   const Elf_Sym *src, unsigned int nsrc,
> +				   const Elf_Shdr *sechdrs, unsigned int shnum)

How about splitting the test out to an:

	bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs, unsigned int shnum)

Then split filter_symbols into num_core_symbols() and copy_core_symbols().

> +static unsigned long layout_symtab(struct module *mod,

How about append_symbols() instead?

> +				   Elf_Shdr *sechdrs,
> +				   unsigned int symindex,
> +				   const Elf_Ehdr *hdr,
> +				   const char *secstrings)
> +{
> +	unsigned long symoffs;
> +	Elf_Shdr *symsect = sechdrs + symindex;
> +

Comment would help me here:

/* Put symbol section at end of init part of module. */
> +	symsect->sh_flags |= SHF_ALLOC;
> +	symsect->sh_entsize = get_offset(mod, &mod->init_size, symsect,
> +					 symindex) | INIT_OFFSET_MASK;
> +	DEBUGP("\t%s\n", secstrings + symsect->sh_name);
> +

Here too:
/* Append room for core symbols at end of core part. */
> +	symoffs = ALIGN(mod->core_size, symsect->sh_addralign ?: 1);
> +	mod->core_size = symoffs
> +			 + filter_symbols(NULL,
> +			 		  (void *)hdr + symsect->sh_offset,
> +					  symsect->sh_size / sizeof(Elf_Sym),
> +					  sechdrs, hdr->e_shnum)
> +			 * sizeof(Elf_Sym);
> +
> +	return symoffs;
> +}
> +
>  static void add_kallsyms(struct module *mod,
>  			 Elf_Shdr *sechdrs,
> +			 unsigned int shnum,
>  			 unsigned int symindex,
>  			 unsigned int strindex,
> +			 unsigned long symoffs,
>  			 const char *secstrings)
>  {
>  	unsigned int i;
> @@ -1857,12 +1914,26 @@ static void add_kallsyms(struct module *
>  	for (i = 0; i < mod->num_symtab; i++)
>  		mod->symtab[i].st_info
>  			= elf_type(&mod->symtab[i], sechdrs, secstrings, mod);
> +
> +	mod->core_symtab = mod->module_core + symoffs;
> +	mod->core_num_syms = filter_symbols(mod->core_symtab,
> +					    mod->symtab, mod->num_symtab,
> +					    sechdrs, shnum);

Hmm, could avoid symoffs if copy_core_symbols worked backwards.  Probably
not worthwhile tho.

>  	trim_init_extable(mod);
> +#ifdef CONFIG_KALLSYMS
> +	mod->num_symtab = mod->core_num_syms;
> +	mod->symtab = mod->core_symtab;
> +#endif
>  	module_free(mod, mod->module_init);
>  	mod->module_init = NULL;
>  	mod->init_size = 0;

core_num_syms/core_symtab is really a temporary; we should note that in
the module.h header next to those fields.

Thanks!
Rusty.

