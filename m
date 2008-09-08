Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYIHG5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYIHG5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 02:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYIHG45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 02:56:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbYIHG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 02:56:56 -0400
Date: Sun, 7 Sep 2008 23:56:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Paulo Marques <pmarques@grupopie.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exclude h8300 local symbols (Re: kallsyms exclude local
 symbols)
Message-Id: <20080907235627.293b0a4b.akpm@linux-foundation.org>
In-Reply-To: <87zlnotn2l.wl%ysato@users.sourceforge.jp>
References: <87fxphzan5.wl%ysato@users.sourceforge.jp>
	<489AE3C5.2000807@grupopie.com>
	<87zlnotn2l.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 19:36:18 -0400 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> At Thu, 07 Aug 2008 13:00:05 +0100,
> Paulo Marques wrote:
> > 
> > Yoshinori Sato wrote:
> > > h8300's nm output include '.Lfoo' local symbols.
> > > [...]
> > >  	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
> > > -	else if (str[0] == '$')
> > > +	else if (str[0] == '$' || str[0] == '.')
> > 
> > The comment above needs some updating too. Something along these lines:
> > 
> > /* exclude also MIPS ELF local symbols (eg. $L123) and h8300 (eg .LM10) */
> > 
> > Other than that, the patch seems fine.
> > 
> > -- 
> > Paulo Marques - www.grupopie.com
> > 
> > "...so she told me it was either her or the ham radio, over."
> 
> Thanks reply.
> 
> Update comment.
> And same problem in modpost.
> 
> Warning message dirty.
> WARNING: vmlinux.o(.text+0x304b): Section mismatch in reference from the variable .LM10 to the variable .init.text:_free_area_init
> The function .LM10() references
> the variable __init _free_area_init.
> This is often because .LM10 lacks a __init
> annotation or the annotation of _free_area_init is wrong.
> 
> fix it.
> WARNING: vmlinux.o(.text+0x304b): Section mismatch in reference from the variable _paging_init to the variable .init.text:___alloc_bootmem
> The function _paging_init() references
> the variable __init ___alloc_bootmem.
> This is often because _paging_init lacks a __init
> annotation or the annotation of ___alloc_bootmem is wrong.
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
> ---
>  scripts/kallsyms.c    |    5 +++--
>  scripts/mod/modpost.c |    4 +++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index ad2434b..64ad9cf 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -105,8 +105,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
>  	else if (toupper(stype) == 'U' ||
>  		 is_arm_mapping_symbol(sym))
>  		return -1;
> -	/* exclude also MIPS ELF local symbols ($L123 instead of .L123) */
> -	else if (str[0] == '$')
> +	/* exclude also MIPS ELF (e.g. $L123) and h8300 elf (e.g. .LM123)
> +	   local symbols */
> + 	else if (str[0] == '$' || str[0] == '.')
>  		return -1;
>  	/* exclude debugging symbols */
>  	else if (stype == 'N')
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 418cd7d..e07f4ba 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1042,7 +1042,9 @@ static inline int is_valid_name(struct elf_info *elf, Elf_Sym *sym)
>  {
>  	const char *name = elf->strtab + sym->st_name;
>  
> -	if (!name || !strlen(name))
> +	if (!name || !strlen(name) ||
> +	/* exclude h8300 elf local symbols (e.g. .LM123) */
> +	    name[0] == '.')
>  		return 0;
>  	return !is_arm_mapping_symbol(name);
>  }

This patch broke kallsyms on powerpc.  Please see
http://ozlabs.org/pipermail/linuxppc-dev/2008-September/062549.html
