Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbXIQBXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbXIQBXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 21:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXIQBWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 21:22:55 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:30774 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXIQBWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 21:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ueC+8xw9VmptEWL34L7RvWnWcDvslJ9L3wn7wHh0E2BErKc2tIgNFrp2R6A4EmJJLeplkY2XBgFHAngv/dBaq5eGpuwUiSI5amxoI9NVVWG84Rm8OtmKAER7T7saXFFWl5wlNNeSgC0KzabW9XdCifkdGlA0u8TgkbEifJqOInw=
Message-ID: <a781481a0709161822m3b1c09f8l33e70579707e9023@mail.gmail.com>
Date: Mon, 17 Sep 2007 06:52:52 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kees Cook" <kees@ubuntu.com>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Cc: "Greg KH" <greg@kroah.com>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Michael Wu" <flamingice@sourmilk.net>,
       "Ben Collins" <bcollins@ubuntu.com>
In-Reply-To: <20070913004937.GM8183@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org>
	 <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	 <20070912215356.GC23294@kroah.com> <20070913004937.GM8183@outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,


On 9/13/07, Kees Cook <kees@ubuntu.com> wrote:
>
> This patch against 2.6.23-rc6 will cause modpost to fail if any device
> id lists are incorrectly terminated, after reporting the offender.
>
> Signed-off-by: Kees Cook <kees@ubuntu.com>

Nice! :-)

BTW a very similar idea (but for a different problem) was discussed in:
http://lkml.org/lkml/2007/8/23/48

I tried doing something about that, but gave up in between. For the
device_id tables, a lot of infrastructure/code already exists in modpost,
but no such luck for kobjects :-( Still, if you can do something about
that, as he mentioned, I bet Greg would gladly accept such a patch :-)


> --- linux-2.6.23-rc6~/scripts/mod/file2alias.c  2007-09-11 23:17:49.000000000 -0700
> +++ linux-2.6.23-rc6/scripts/mod/file2alias.c   2007-09-12 17:41:30.000000000 -0700
> @@ -55,10 +55,13 @@ do {
>   * Check that sizeof(device_id type) are consistent with size of section
>   * in .o file. If in-consistent then userspace and kernel does not agree
>   * on actual size which is a bug.
> + * Also verify that the final entry in the table is all zeros.
>   **/
> -static void device_id_size_check(const char *modname, const char *device_id,
> -                                unsigned long size, unsigned long id_size)
> +static void device_id_check(const char *modname, const char *device_id,
> +                           unsigned long size, unsigned long id_size,
> +                           void *symval)

If you pass the Elf_Sym *sym all the way from handle_moddevtable() (which
means you can get rid of the sym->st_size argument in the call chain), then
it would be possible to print out the *symbol name* too here ...


>  {
> +       int i;

uint8_t *p;


>         if (size % id_size || size < id_size) {
>                 fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
>                       "of the size of section __mod_%s_device_table=%lu.\n"
> @@ -66,6 +69,18 @@ static void device_id_size_check(const c
>                       "in mod_devicetable.h\n",
>                       modname, device_id, id_size, device_id, size, device_id);
>         }

> +       /* Verify last one is a terminator */
> +       for (i = 0; i < id_size; i++ ) {
> +               if ( *(uint8_t*)(symval+size-id_size+i) ) {

... and:

        for (p = symval+size-id_size; p < symval+size; p++) {
                if (*p) {

is probably clearer ?


> +                       fprintf(stderr,"%s: struct %s_device_id is %lu bytes.  The last of
> %lu is:\n", modname, device_id, id_size, size / id_size);

As I just said, printing out just the modname and device_id "type" sounds
insufficient here. Note that they were sufficient before your patch, because
previously, this function only checked if the device_id *type* itself was
incorrectly defined. But here we're talking about a specific errant *symbol*.


> +                       for (i = 0; i < id_size; i++ ) {
> +                               fprintf(stderr,"0x%02x ", *(uint8_t*)(symval+size-id_size+i) );
> +                       }

Again, "for (p = symval+size-id_size; p < symval+size; p++) {"
and then "fprintf(..., *p);" would be cleaner.


> +                       fprintf(stderr,"\n");
> +                       fatal("%s: struct %s_device_id is not terminated "
> +                               "with a NULL entry!\n", modname, device_id);

Subtle nit, but it's not really a "NULL" entry. It's an "empty object" entry,
not a "NULL" pointer ... how about replacing "a NULL" with "an empty" ?


> +               }
> +       }
>  }
>
>  /* USB is special because the bcdDevice can be matched against a numeric range */
> @@ -168,7 +183,7 @@ static void do_usb_table(void *symval, u
>         unsigned int i;
>         const unsigned long id_size = sizeof(struct usb_device_id);
>
> -       device_id_size_check(mod->name, "usb", size, id_size);
> +       device_id_check(mod->name, "usb", size, id_size, symval);
>
>         /* Leave last one: it's the terminator. */
>         size -= id_size;
> @@ -505,7 +520,7 @@ static void do_table(void *symval, unsig
>         char alias[500];
>         int (*do_entry)(const char *, void *entry, char *alias) = function;
>
> -       device_id_size_check(mod->name, device_id, size, id_size);
> +       device_id_check(mod->name, device_id, size, id_size, symval);
>         /* Leave last one: it's the terminator. */
>         size -= id_size;
>
> @@ -527,14 +542,22 @@ void handle_moddevtable(struct module *m
>                         Elf_Sym *sym, const char *symname)
>  {
>         void *symval;
> +       char *zeros = NULL;
>
>         /* We're looking for a section relative symbol */
>         if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
>                 return;
>
> -       symval = (void *)info->hdr
> -               + info->sechdrs[sym->st_shndx].sh_offset
> -               + sym->st_value;
> +       /* Handle all-NULL symbols allocated into .bss */
> +       if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
> +               zeros = calloc(1, sym->st_size);
> +               symval = zeros;
> +       }

Hmm, I don't quite grok this case. Care to explain?


> +       else {
> +               symval = (void *)info->hdr
> +                       + info->sechdrs[sym->st_shndx].sh_offset
> +                       + sym->st_value;
> +       }
>
>         if (sym_is(symname, "__mod_pci_device_table"))
>                 do_table(symval, sym->st_size,
> @@ -599,6 +622,8 @@ void handle_moddevtable(struct module *m
>                 do_table(symval, sym->st_size,
>                          sizeof(struct parisc_device_id), "parisc",
>                          do_parisc_entry, mod);
> +
> +       if (zeros) free(zeros);
>  }
>
>  /* Now add out buffered information to the generated C source */


Satyam
