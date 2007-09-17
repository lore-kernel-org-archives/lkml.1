Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXIQDqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXIQDqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 23:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXIQDqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 23:46:36 -0400
Received: from mylar.outflux.net ([69.93.193.226]:41050 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbXIQDqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 23:46:35 -0400
Date: Sun, 16 Sep 2007 20:45:54 -0700
From: Kees Cook <kees@ubuntu.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Greg KH <greg@kroah.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Michael Wu <flamingice@sourmilk.net>,
       Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Message-ID: <20070917034554.GO17546@outflux.net>
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org> <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com> <20070912215356.GC23294@kroah.com> <20070913004937.GM8183@outflux.net> <a781481a0709161822m3b1c09f8l33e70579707e9023@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0709161822m3b1c09f8l33e70579707e9023@mail.gmail.com>
Organization: Ubuntu
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

On Mon, Sep 17, 2007 at 06:52:52AM +0530, Satyam Sharma wrote:
> On 9/13/07, Kees Cook <kees@ubuntu.com> wrote:
> >
> > This patch against 2.6.23-rc6 will cause modpost to fail if any device
> > id lists are incorrectly terminated, after reporting the offender.
> >
> > Signed-off-by: Kees Cook <kees@ubuntu.com>
> 
> Nice! :-)
> 
> BTW a very similar idea (but for a different problem) was discussed in:
> http://lkml.org/lkml/2007/8/23/48
> 
> I tried doing something about that, but gave up in between. For the
> device_id tables, a lot of infrastructure/code already exists in modpost,
> but no such luck for kobjects :-( Still, if you can do something about
> that, as he mentioned, I bet Greg would gladly accept such a patch :-)

Thanks!  Hmm, perhaps I'll take that on when I learn kobjects better.  :)

> > +static void device_id_check(const char *modname, const char *device_id,
> > +                           unsigned long size, unsigned long id_size,
> > +                           void *symval)
> 
> If you pass the Elf_Sym *sym all the way from handle_moddevtable() (which
> means you can get rid of the sym->st_size argument in the call chain), then
> it would be possible to print out the *symbol name* too here ...

That's true.  I actually threw away an earlier version of this patch
that made some extensive changes to the elf parser (due to the NOBITS
thing I explain below), but instead opted for the smaller version that
stayed out of there.

>         for (p = symval+size-id_size; p < symval+size; p++) {
>                 if (*p) {
> 
> is probably clearer ?

Ah, yeah, that's much nicer.  I think I must have still have my ELF
parser hat on when I wrote that.  ;)

> As I just said, printing out just the modname and device_id "type" sounds
> insufficient here. Note that they were sufficient before your patch, because
> previously, this function only checked if the device_id *type* itself was
> incorrectly defined. But here we're talking about a specific errant *symbol*.

That's true, yeah.

> > +                       fprintf(stderr,"\n");
> > +                       fatal("%s: struct %s_device_id is not terminated "
> > +                               "with a NULL entry!\n", modname, device_id);
> 
> Subtle nit, but it's not really a "NULL" entry. It's an "empty object" entry,
> not a "NULL" pointer ... how about replacing "a NULL" with "an empty" ?

Yeah, that bugged me when I put that in too.  :)  Yes, "an empty" is
better.

> > @@ -527,14 +542,22 @@ void handle_moddevtable(struct module *m
> >                         Elf_Sym *sym, const char *symname)
> >  {
> >         void *symval;
> > +       char *zeros = NULL;
> >
> >         /* We're looking for a section relative symbol */
> >         if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
> >                 return;
> >
> > -       symval = (void *)info->hdr
> > -               + info->sechdrs[sym->st_shndx].sh_offset
> > -               + sym->st_value;
> > +       /* Handle all-NULL symbols allocated into .bss */
> > +       if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
> > +               zeros = calloc(1, sym->st_size);
> > +               symval = zeros;
> > +       }
> 
> Hmm, I don't quite grok this case. Care to explain?

In the ELF format, the .bss segment is initialized by the loader to all
zeros, but it contains no in-file representation (since it's all zeros
and would be a waste of space).  Such segments are flags as "SHT_NOBITS"
meaning that the loader must allocate cleared memory instead of loading
the segment from the file.

In the case of modules that have a totally empty *_device_id list (?!),
the compiler optimizes this into the .bss segment, since there is no need
to store an all-zero-contents object in a segment that would be loaded
from the file itself.

As a result, attempting to dereference such a symbol without noticing
the SHT_NOBITS flag lands you somewhere in uninitialized memory.  So,
the above code basically side-steps the incorrect symbol location
calculation and just aims it at a cleared part of memory.

As I mentioned, there was a larger patch that attempted to sort this
out in the elf parser, but I didn't like it; it was big, not 100%
correct, and the above approach seemed like a much less invasive change.

The cleanups you suggested, who should I send those to?  Or will you (or
Sam?) make them directly to the kbuild.git tree?  (I've never poked at
this part of the kernel source before... I'm unclear on the processes
surrounding it maintainership.)

Thanks!

-Kees

-- 
Kees Cook
