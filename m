Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYIPADv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYIPADv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 20:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYIPADo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 20:03:44 -0400
Received: from ozlabs.org ([203.10.76.45]:51189 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYIPADn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 20:03:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Date: Tue, 16 Sep 2008 10:03:34 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213108.GB23331@redhat.com>
In-Reply-To: <20080715213108.GB23331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161003.35983.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 07:31:08 Jason Baron wrote:
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -359,6 +359,10 @@ struct module
>  	struct marker *markers;
>  	unsigned int num_markers;
>  #endif
> +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> +	struct mod_debug *start_verbose;
> +	unsigned int num_verbose;
> +#endif

Hi Jason,

   Couple of nit-picks about the module part of this patch.  First, this could 
just be called "verbose" rather than "start_verbose"...

> @@ -1717,6 +1718,9 @@ static struct module *load_module(void __user *umod,
>  	unsigned int unusedgplcrcindex;
>  	unsigned int markersindex;
>  	unsigned int markersstringsindex;
> +	unsigned int verboseindex;
> +	struct mod_debug *iter;
> +	unsigned long value;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> @@ -1993,6 +1997,7 @@ static struct module *load_module(void __user *umod,
>  	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
>   	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
>  					"__markers_strings");
> +	verboseindex = find_sec(hdr, sechdrs, secstrings, "__verbose");
>
>  	/* Now do relocations. */
>  	for (i = 1; i < hdr->e_shnum; i++) {
> @@ -2020,6 +2025,11 @@ static struct module *load_module(void __user *umod,
>  	mod->num_markers =
>  		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
>  #endif
> +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> +	mod->start_verbose = (void *)sechdrs[verboseindex].sh_addr;
> +	mod->num_verbose = sechdrs[verboseindex].sh_size /
> +				sizeof(*mod->start_verbose);
> +#endif
>
>          /* Find duplicate symbols */
>  	err = verify_export_symbols(mod);
> @@ -2043,6 +2053,19 @@ static struct module *load_module(void __user *umod,
>  		marker_update_probe_range(mod->markers,
>  			mod->markers + mod->num_markers);
>  #endif
> +#ifdef CONFIG_DYNAMIC_PRINTK_DEBUG
> +	for (value = (unsigned long)mod->start_verbose;
> +		value < (unsigned long)mod->start_verbose +
> +		(unsigned long)(mod->num_verbose * sizeof(struct mod_debug));
> +		value += sizeof(struct mod_debug)) {
> +			iter = (struct mod_debug *)value;
> +			register_debug_module(iter->modname,
> +				simple_strtoul(iter->type, NULL, 10),
> +				iter->logical_modname,
> +				simple_strtoul(iter->num_flags, NULL, 10),
> +				iter->flag_names);
> +	}
> +#endif

This loop seems way more complex than it needs to be.  Perhaps pull these two 
out into a setup_verbose_debug() func which is a noop 
for !CONFIG_DYNAMIC_PRINTK_DEBUG, and drop all the casts?

Thanks,
Rusty.
