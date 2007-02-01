Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbXBAWBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbXBAWBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXBAWBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:01:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37458 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXBAWBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:01:42 -0500
Date: Thu, 1 Feb 2007 13:55:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
Message-Id: <20070201135547.4149dc15.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 22:20:09 +0100 (MET) Jan Engelhardt wrote:

> ___The kernel patch___
> 
> Just a few notes here.
> 
> 
> Comments welcome.

Good idea.

A diffstat summary would have been nice.
  (See Documentation/SubmittingPatches)

Use a space between "if" and "(" below (multiple times):
  see Documentation/CodingStyle.


> Index: linux-2.6.20-rc7/kernel/module.c
> ===================================================================
> --- linux-2.6.20-rc7.orig/kernel/module.c
> +++ linux-2.6.20-rc7/kernel/module.c
> @@ -1389,10 +1389,21 @@ static void layout_sections(struct modul
>  	}
>  }
>  
> -static void set_license(struct module *mod, const char *license)
> +static int set_license(struct module *mod, Elf_Shdr *sechdr)
>  {
> -	if (!license)
> -		license = "unspecified";
> +	const char *license = "unspecified";
> +
> +	if(sechdr != NULL) {
> +		license = (const char *)sechdr->sh_addr;
> +
> +		/* Allow both non-terminated strings and NUL-terminated
> +		strings, as long as no string termination trick is done. */
> +		if(strnlen(license, sechdr->sh_size) + 1 != sechdr->sh_size) {
> +			printk(KERN_WARNING "Module \"%s\" has invalid "
> +			       ".modlicense section\n", mod->name);
> +			return -EINVAL;
> +		}
> +	}
>  
>  	if (!license_is_gpl_compatible(license)) {
>  		if (!(tainted & TAINT_PROPRIETARY_MODULE))
> @@ -1400,6 +1411,8 @@ static void set_license(struct module *m
>  				"kernel.\n", mod->name, license);
>  		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
>  	}
> +
> +	return 0;
>  }
>  
>  /* Parse tag=value strings from .modinfo section */
> @@ -1549,6 +1562,7 @@ static struct module *load_module(void _
>  	unsigned int modindex;
>  	unsigned int obsparmindex;
>  	unsigned int infoindex;
> +	unsigned int license_index;
>  	unsigned int gplindex;
>  	unsigned int crcindex;
>  	unsigned int gplcrcindex;
> @@ -1653,6 +1667,7 @@ static struct module *load_module(void _
>  	obsparmindex = find_sec(hdr, sechdrs, secstrings, "__obsparm");
>  	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
>  	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
> +	license_index = find_sec(hdr, sechdrs, secstrings, ".modlicense");
>  	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
>  #ifdef ARCH_UNWIND_SECTION_NAME
>  	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
> @@ -1660,6 +1675,8 @@ static struct module *load_module(void _
>  
>  	/* Don't keep modinfo section */
>  	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
> +	if(license_index)
> +		sechdrs[license_index].sh_flags &= ~SHF_ALLOC;
>  #ifdef CONFIG_KALLSYMS
>  	/* Keep symbol and string tables for decoding later. */
>  	sechdrs[symindex].sh_flags |= SHF_ALLOC;
> @@ -1769,7 +1786,10 @@ static struct module *load_module(void _
>  	module_unload_init(mod);
>  
>  	/* Set up license info based on the info section */
> -	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
> +	err = set_license(mod, (license_index != 0) ?
> +	      &sechdrs[license_index] : NULL);
> +	if(err)
> +		goto cleanup;
>  
>  	if (strcmp(mod->name, "ndiswrapper") == 0)
>  		add_taint(TAINT_PROPRIETARY_MODULE);


---
~Randy
