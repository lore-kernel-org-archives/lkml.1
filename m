Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbXE3HGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbXE3HGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXE3HGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:06:13 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:56195 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXE3HGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:06:11 -0400
Date: Wed, 30 May 2007 09:06:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
In-Reply-To: <465D1020.3030605@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705300903030.31930@anakin>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg>
 <20070529173818.fd94ae81.akpm@linux-foundation.org> <465D1020.3030605@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-478399368-1180508768=:31930"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-478399368-1180508768=:31930
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 30 May 2007, Eric Dumazet wrote:
> Andrew Morton a écrit :
> > On Mon, 28 May 2007 21:16:31 +0200
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > 
> > > --- a/include/asm-m68k/module.h
> > > +++ b/include/asm-m68k/module.h
> > > @@ -1,7 +1,38 @@
> > >  #ifndef _ASM_M68K_MODULE_H
> > >  #define _ASM_M68K_MODULE_H
> > > -struct mod_arch_specific { };
> > > +
> > > +struct mod_arch_specific {
> > > +	struct m68k_fixup_info *fixup_start, *fixup_end;
> > > +};
> > 
> > Here we use struct m68k_fixup_info.
> > 
> > > +#define MODULE_ARCH_INIT {				\
> > > +	.fixup_start		= __start_fixup,	\
> > > +	.fixup_end		= __stop_fixup,		\
> > > +}
> > > +
> > >  #define Elf_Shdr Elf32_Shdr
> > >  #define Elf_Sym Elf32_Sym
> > >  #define Elf_Ehdr Elf32_Ehdr
> > > +
> > > +
> > > +enum m68k_fixup_type {
> > > +	m68k_fixup_memoffset,
> > > +};
> > > +
> > > +struct m68k_fixup_info {
> > > +	enum m68k_fixup_type type;
> > > +	void *addr;
> > > +};
> > 
> > and later we define it.
> > 
> > How come it doesn't spit warnings?
> > 
> > I think it could be tightened up even if it happens not to warn?
> 
> 
> struct a {
> 	struct not_yet_defined *start, *end;
> };
> 
> struct not_yet_defined {
> 	void *foo;
> };
> 
> Is a valid and gives no warnings.

I was puzzled by this as well, as there were no compiler warnings...

Apparently you get a warning only if the _first_ occurrence of a struct
is declared inside a parameter list of a function.

So even

    struct a {
	struct not_yet_defined *start, *end;
    };

    extern void f(struct not_yet_defined *start);

    struct not_yet_defined {
	void *foo;
    };

doesn't give a warning, because the first occurence is inside the
definition of struct a.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808512-478399368-1180508768=:31930--
