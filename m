Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZKDI2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZKDI2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZKDI2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:28:31 -0500
Received: from ozlabs.org ([203.10.76.45]:40360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZKDI2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:28:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 06/10] module: refactor symbol tables and try to reduce code size of each_symbol()
Date: Wed, 4 Nov 2009 18:58:28 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-7-git-send-email-alan-jenkins@tuffmail.co.uk>
In-Reply-To: <1257242782-10496-7-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041858.28285.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 08:36:18 pm Alan Jenkins wrote:
> find_symbol() will use bsearch() instead of each_symbol(). each_symbol()
> is still desired by Ksplice (although it is not in-tree yet).  Let's try
> to minimize the code which will be duplicated between these two
> functions, by changing how the symbol tables are declared.

Alan, this is a particularly neat cleanup.  Thanks!

> +typedef bool each_symbol_fn_t (enum export_type type,
> +			       const struct kernel_symbol *sym,
> +			       const unsigned long *crc,
> +			       struct module *owner,
> +			       void *data);
> +
>  /* Walk the exported symbol table */
> -bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
> -			    unsigned int symnum, void *data), void *data);
> +bool each_symbol(each_symbol_fn_t *fn, void *data);

I really hate throwaway typedefs like this.  But it's used in two other
places, so I'll suppress my distaste :)

> +static struct ksymtab ksymtab[EXPORT_TYPE_MAX];
> +
> +static int __init init_ksymtab(void)
> +{
> +	struct ksymtab tmp[EXPORT_TYPE_MAX] = {
> +		[EXPORT_TYPE_PLAIN] = {
> +			__start___ksymtab, __start___kcrctab,
> +			__stop___ksymtab - __start___ksymtab,
> +		},
> +		[EXPORT_TYPE_GPL] = {
> +			__start___ksymtab_gpl, __start___kcrctab_gpl,
> +			__stop___ksymtab_gpl - __start___ksymtab_gpl,
> +		},
> +#ifdef CONFIG_UNUSED_EXPORTS
> +		[EXPORT_TYPE_UNUSED] = {
> +			__start___ksymtab_unused, __start___kcrctab_unused,
> +			__stop___ksymtab_unused - __start___ksymtab_unused,
> +		},
> +		[EXPORT_TYPE_UNUSED_GPL] = {
> +			__start___ksymtab_unused_gpl,
> +			__start___kcrctab_unused_gpl,
> +			__stop___ksymtab_unused_gpl -
> +				__start___ksymtab_unused_gpl,
> +		},
> +#endif
> +		[EXPORT_TYPE_GPL_FUTURE] = {
> +			__start___ksymtab_gpl_future,
> +			__start___kcrctab_gpl_future,
> +			__stop___ksymtab_gpl_future -
> +				__start___ksymtab_gpl_future,
> +		},
> +	};
> +
> +	memcpy(ksymtab, tmp, sizeof(ksymtab));

This works, but I'd prefer you to open-code the assignments.  Simpler and
marginally more efficient.

> @@ -322,9 +322,9 @@ static bool find_symbol_in_section(const struct symsearch *syms,
>  	}
>  #endif
>  
> +	fsa->sym = sym;
> +	fsa->crc = crc;
>  	fsa->owner = owner;
> -	fsa->crc = symversion(syms->crcs, symnum);
> -	fsa->sym = &syms->start[symnum];
>  	return true;

Strange gratuitous reorder here?

> +static const char *export_section_names[EXPORT_TYPE_MAX] = {
> +	[EXPORT_TYPE_PLAIN] = "__ksymtab",
> +	[EXPORT_TYPE_GPL] = "__ksymtab_gpl",
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +	[EXPORT_TYPE_UNUSED] = "__ksymtab_unused",
> +	[EXPORT_TYPE_UNUSED_GPL] = "__ksymtab_unused_gpl",
> +#endif
> +	[EXPORT_TYPE_GPL_FUTURE] = "__ksymtab_gpl_future",
> +};
> +
> +static const char *crc_section_names[EXPORT_TYPE_MAX] = {
> +	[EXPORT_TYPE_PLAIN] = "__kcrctab",
> +	[EXPORT_TYPE_GPL] = "__kcrctab_gpl",
> +#ifdef CONFIG_UNUSED_SYMBOLS
> +	[EXPORT_TYPE_UNUSED] = "__kcrctab_unused",
> +	[EXPORT_TYPE_UNUSED_GPL] = "__kcrctab_unused_gpl",
> +#endif
> +	[EXPORT_TYPE_GPL_FUTURE] = "__kcrctab_gpl_future",
> +};

You can use [] here for size instead of explicit EXPORT_TYPE_MAX.  We should
have named these sections better :(

> +	for (export_type = 0; export_type < EXPORT_TYPE_MAX; export_type++) {

Then use ARRAY_SIZE(export_section_names) here.

> +	for (export_type = 0; export_type < EXPORT_TYPE_MAX; export_type++) {
> +		if (mod->syms[export_type].syms &&

Similar ARRAY_SIZE(mod->syms).  It's less indirect, IMHO.

But all minor nitpicks; code is excellent!

Thanks,
Rusty.
