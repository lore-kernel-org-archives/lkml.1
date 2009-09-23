Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZIWRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZIWRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZIWReb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:34:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47519 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZIWRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:34:30 -0400
Date: Wed, 23 Sep 2009 13:29:43 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-modules@vger.org
Subject: Re: [PATCH 3/4] module: unexport each_symbol()
In-Reply-To: <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk>
Message-ID: <alpine.DEB.1.10.0909231112490.15822@dr-wily.mit.edu>
References: <1253626718-18887-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1253626718-18887-4-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I really like what you're doing with this patch series; using a binary 
search for the symbol table has been something I've wanted to do in the 
kernel's module loader ever since I optimized Ksplice's symbol resolution 
code to use binary rather than linear searches.

While Ksplice is not in-tree yet, Ksplice is a user of each_symbol (and in 
fact was the reason why each_symbol was originally exported).  Is it easy 
to modify your patch series so that you don't have to remove each_symbol?

	Best regards,
	-Tim Abbott

On Tue, 22 Sep 2009, Alan Jenkins wrote:

> find_symbol() is about to be re-written to avoid traversing every single
> exported symbol.  each_symbol() has acquired no other in-tree user, so
> let us remove it.
> 
> Also struct symsearch is useless outside of module.c, so move it there
> instead of cluttering up module.h.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  include/linux/module.h |   15 ---------------
>  kernel/module.c        |   14 ++++++++++++--
>  2 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 65b62e9..df25f99 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -348,17 +348,6 @@ static inline int within_module_init(unsigned long addr, struct module *mod)
>  /* Search for module by name: must hold module_mutex. */
>  struct module *find_module(const char *name);
>  
> -struct symsearch {
> -	const struct kernel_symbol *start, *stop;
> -	const unsigned long *crcs;
> -	enum {
> -		NOT_GPL_ONLY,
> -		GPL_ONLY,
> -		WILL_BE_GPL_ONLY,
> -	} licence;
> -	bool unused;
> -};
> -
>  /* Search for an exported symbol by name. */
>  const struct kernel_symbol *find_symbol(const char *name,
>  					struct module **owner,
> @@ -366,10 +355,6 @@ const struct kernel_symbol *find_symbol(const char *name,
>  					bool gplok,
>  					bool warn);
>  
> -/* Walk the exported symbol table */
> -bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
> -			    unsigned int symnum, void *data), void *data);
> -
>  /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
>     symnum out of range. */
>  int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
> diff --git a/kernel/module.c b/kernel/module.c
> index 2d53718..b24fc55 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -186,6 +186,17 @@ extern const unsigned long __start___kcrctab_unused[];
>  extern const unsigned long __start___kcrctab_unused_gpl[];
>  #endif
>  
> +struct symsearch {
> +	const struct kernel_symbol *start, *stop;
> +	const unsigned long *crcs;
> +	enum {
> +		NOT_GPL_ONLY,
> +		GPL_ONLY,
> +		WILL_BE_GPL_ONLY,
> +	} licence;
> +	bool unused;
> +};
> +
>  #ifndef CONFIG_MODVERSIONS
>  #define symversion(base, idx) NULL
>  #else
> @@ -212,7 +223,7 @@ static bool each_symbol_in_section(const struct symsearch *arr,
>  }
>  
>  /* Returns true as soon as fn returns true, otherwise false. */
> -bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
> +static bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
>  			    unsigned int symnum, void *data), void *data)
>  {
>  	struct module *mod;
> @@ -266,7 +277,6 @@ bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
>  	}
>  	return false;
>  }
> -EXPORT_SYMBOL_GPL(each_symbol);
>  
>  struct find_symbol_arg {
>  	/* Input */
> -- 
> 1.6.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
