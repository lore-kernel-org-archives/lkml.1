Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbZLaVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbZLaVPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 16:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZLaVPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 16:15:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:59959 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751605AbZLaVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 16:15:15 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+HN9YTdMyHJ3/VP24gGZoqRM0Aph0rpIK7EdpjBA
	Sx+9RGdSiBqDql
Message-ID: <4B3D145C.2080106@gmx.de>
Date: Thu, 31 Dec 2009 22:15:08 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ben@decadent.org.uk, tbm@cyrius.com
CC: Kalle Valo <kalle.valo@iki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, roland@redhat.com,
       dave@hiauly1.hia.nrc.ca, Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
References: <87k4w4wux9.fsf@purkki.valot.fi> <1262188157.2749.21.camel@mulgrave.site>
In-Reply-To: <1262188157.2749.21.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 04:49 PM, James Bottomley wrote:
> A better, and more comprehensive patch would be to try not to count the
> empty text sections when we're building the notes section (and actually
> anywhere else in the file).  This patch actually relies on the fact that
> if sh_size is zero for the text section it should be for the
> corresponding notes section.  If that doesn't work, we'd actually have
> to do the matching in the construction piece.
>
> Can you try it to see if it works for you?  If it doesn't, I'll try
> matching notes to text.  It works fine on parisc, but as we don't have a
> notes section, that's not saying much ...
>
> Thanks,
>
> James


Ben Hutchings already sent a similar patch.
See: http://patchwork.kernel.org/patch/68925/

IMHO James patch below seems better since it
checks if a section will be allocated at a few more
places...

Helge


> ---
>
> diff --git a/kernel/module.c b/kernel/module.c
> index e96b8ed..957f912 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -132,6 +132,11 @@ void __module_put_and_exit(struct module *mod, long code)
>   }
>   EXPORT_SYMBOL(__module_put_and_exit);
>
> +static inline int section_allocated(Elf_Shdr hdr)
> +{
> +	return (hdr.sh_flags&  SHF_ALLOC)&&  hdr.sh_size != 0;
> +}
> +
>   /* Find a module section: 0 means not found. */
>   static unsigned int find_sec(Elf_Ehdr *hdr,
>   			     Elf_Shdr *sechdrs,
> @@ -142,7 +147,7 @@ static unsigned int find_sec(Elf_Ehdr *hdr,
>
>   	for (i = 1; i<  hdr->e_shnum; i++)
>   		/* Alloc bit cleared means "ignore it." */
> -		if ((sechdrs[i].sh_flags&  SHF_ALLOC)
> +		if (section_allocated(sechdrs[i])
>   		&&  strcmp(secstrings+sechdrs[i].sh_name, name) == 0)
>   			return i;
>   	return 0;
> @@ -1051,8 +1056,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
>
>   	/* Count loaded sections and allocate structures */
>   	for (i = 0; i<  nsect; i++)
> -		if (sechdrs[i].sh_flags&  SHF_ALLOC
> -		&&  sechdrs[i].sh_size)
> +		if (section_allocated(sechdrs[i]))
>   			nloaded++;
>   	size[0] = ALIGN(sizeof(*sect_attrs)
>   			+ nloaded * sizeof(sect_attrs->attrs[0]),
> @@ -1070,9 +1074,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
>   	sattr =&sect_attrs->attrs[0];
>   	gattr =&sect_attrs->grp.attrs[0];
>   	for (i = 0; i<  nsect; i++) {
> -		if (! (sechdrs[i].sh_flags&  SHF_ALLOC))
> -			continue;
> -		if (!sechdrs[i].sh_size)
> +		if (!section_allocated(sechdrs[i]))
>   			continue;
>   		sattr->address = sechdrs[i].sh_addr;
>   		sattr->name = kstrdup(secstrings + sechdrs[i].sh_name,
> @@ -1156,7 +1158,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
>   	/* Count notes sections and allocate structures.  */
>   	notes = 0;
>   	for (i = 0; i<  nsect; i++)
> -		if ((sechdrs[i].sh_flags&  SHF_ALLOC)&&
> +		if (section_allocated(sechdrs[i])&&
>   		(sechdrs[i].sh_type == SHT_NOTE))
>   			++notes;
>
> @@ -1172,7 +1174,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
>   	notes_attrs->notes = notes;
>   	nattr =&notes_attrs->attrs[0];
>   	for (loaded = i = 0; i<  nsect; ++i) {
> -		if (!(sechdrs[i].sh_flags&  SHF_ALLOC))
> +		if (!section_allocated(sechdrs[i]))
>   			continue;
>   		if (sechdrs[i].sh_type == SHT_NOTE) {
>   			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
> @@ -1720,7 +1722,7 @@ static char elf_type(const Elf_Sym *sym,
>   		return '?';
>   	if (sechdrs[sym->st_shndx].sh_flags&  SHF_EXECINSTR)
>   		return 't';
> -	if (sechdrs[sym->st_shndx].sh_flags&  SHF_ALLOC
> +	if (section_allocated(sechdrs[sym->st_shndx])
>   	&&  sechdrs[sym->st_shndx].sh_type != SHT_NOBITS) {
>   		if (!(sechdrs[sym->st_shndx].sh_flags&  SHF_WRITE))
>   			return 'r';
> @@ -1751,7 +1753,7 @@ static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
>   		return false;
>
>   	sec = sechdrs + src->st_shndx;
> -	if (!(sec->sh_flags&  SHF_ALLOC)
> +	if (!section_allocated(*sec)
>   #ifndef CONFIG_KALLSYMS_ALL
>   	    || !(sec->sh_flags&  SHF_EXECINSTR)
>   #endif
> @@ -1913,7 +1915,7 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
>   	kmemleak_scan_area(mod, sizeof(struct module), GFP_KERNEL);
>
>   	for (i = 1; i<  hdr->e_shnum; i++) {
> -		if (!(sechdrs[i].sh_flags&  SHF_ALLOC))
> +		if (!section_allocated(sechdrs[i]))
>   			continue;
>   		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
>   		&&  strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
> @@ -2139,7 +2141,7 @@ static noinline struct module *load_module(void __user *umod,
>   	for (i = 0; i<  hdr->e_shnum; i++) {
>   		void *dest;
>
> -		if (!(sechdrs[i].sh_flags&  SHF_ALLOC))
> +		if (!section_allocated(sechdrs[i]))
>   			continue;
>
>   		if (sechdrs[i].sh_entsize&  INIT_OFFSET_MASK)
> @@ -2287,7 +2289,7 @@ static noinline struct module *load_module(void __user *umod,
>   			continue;
>
>   		/* Don't bother with non-allocated sections */
> -		if (!(sechdrs[info].sh_flags&  SHF_ALLOC))
> +		if (!section_allocated(sechdrs[info]))
>   			continue;
>
>   		if (sechdrs[i].sh_type == SHT_REL)
>
>

