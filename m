Return-Path: <linux-kernel-owner+w=401wt.eu-S1030812AbXENLFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812AbXENLFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXENLFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:05:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:51891 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXENLFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:05:40 -0400
Date: Mon, 14 May 2007 13:06:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Li Yang <leoli@freescale.com>
Cc: Linus <torvalds@linux-foundation.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for powerpc
Message-ID: <20070514110636.GB10143@uranus.ravnborg.org>
References: <46483FAC.60503@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46483FAC.60503@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 06:53:32PM +0800, Li Yang wrote:
> This patch fixes the following "Section mismatch" warnings when
> build powerpc platforms.
> 
> -------------
> WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to 
> .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at 
> offset 0xc68) and 'pte_alloc_one'
> WARNING: mm/built-in.o - Section mismatch: reference to 
> .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 
> 0x20300) and 'cache_reap'
> -------------
> 
> Massive warnings represented by:
> -------------
> WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to 
> .init.data:.got2 from prom_entry (offset 0x0)
> WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to 
> .init.text:mpc8313_rdb_probe from .machine.desc after 'mach_mpc8313_rdb' 
> (at offset 0x4)
> -------------
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
> ---
> scripts/mod/modpost.c |   16 ++++++++++++----
> 1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index c89cb71..aa3a881 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -649,9 +649,10 @@ static int strrcmp(const char *s, const char *sub)
>  *  tosec    = .init.text
>  *
>  * Pattern 10:
> - *  ia64 has machvec table for each platform. It is mixture of function
> - *  pointer of .init.text and .text.
> - *  fromsec  = .machvec
> + *  ia64 has machvec table and powerpc has machine desc table for each
> + *  platform. It is mixture of function pointer of .init.text and .text.
> + *  fromsec  = .machvec | .machine.desc
> + *
>  **/
> static int secref_whitelist(const char *modname, const char *tosec,
> 			    const char *fromsec, const char *atsym,
> @@ -681,6 +682,8 @@ static int secref_whitelist(const char *modname, const 
> char *tosec,
> 	const char *pat4sym[] = {
> 		"sparse_index_alloc",
> 		"zone_wait_table_init",
> +		"pte_alloc_one_kernel",
> +		"kmem_cache_create",
> 		NULL
> 	};
> 
> @@ -750,7 +753,8 @@ static int secref_whitelist(const char *modname, const 
> char *tosec,
> 				return 1;
> 
> 	/* Check for pattern 10 */
> -	if (strcmp(fromsec, ".machvec") == 0)
> +	if ((strcmp(fromsec, ".machvec") == 0) ||
> +	    (strcmp(fromsec, ".machine.desc") == 0))
> 		return 1;
> 
> 	return 0;
> @@ -883,6 +887,10 @@ static void warn_sec_mismatch(const char *modname, 
> const char *fromsec,
> 	    secref_whitelist(modname, secname, fromsec,
> 			     elf->strtab + before->st_name, refsymname))
> 		return;
> +	/* fromsec whitelist - without a valid 'before' */
> +	/* powerpc has a GOT table in .got2 section */
> +	if (strcmp(fromsec, ".got2") == 0)
> +		return;
> 
> 	if (before && after) {
> 		warn("%s - Section mismatch: reference to %s:%s from %s "
> 
