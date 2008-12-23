Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYLWINt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYLWINt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 03:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYLWINk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 03:13:40 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:40599 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbYLWINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 03:13:39 -0500
Date: Tue, 23 Dec 2008 09:13:32 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: schmitz@opal.biophys.uni-duesseldorf.de,
       linux-fbdev-devel@lists.sourceforge.net, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] fbdev: c2p - Cleanups
In-Reply-To: <20081222152206.707c3214.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812230908330.17497@anakin>
References: <20081221150059.844577615@mail.of.borg> <20081221150122.473385775@mail.of.borg>
 <20081222152206.707c3214.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Andrew Morton wrote:
> On Sun, 21 Dec 2008 16:01:02 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> >   - Improve comments and naming
> >   - Use void * for arbitrary pointers
> >   - Use a union to represent pixels/words, to avoid casts
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  drivers/video/c2p.c |   80 +++++++++++++++++++++++++++-------------------------
> >  drivers/video/c2p.h |    6 +--
> >  2 files changed, 45 insertions(+), 41 deletions(-)
> > 
> > --- a/drivers/video/c2p.c
> > +++ b/drivers/video/c2p.c
> > @@ -54,7 +54,7 @@ static inline u32 get_mask(int n)
> >      return 0;
> >  }
> >  
> > -#define transp_nx1(d, n)				\
> > +#define transp8_nx1(d, n)				\
> >      do {						\
> >  	u32 mask = get_mask(n);				\
> >  	/* First block */				\
> > @@ -67,7 +67,7 @@ static inline u32 get_mask(int n)
> >  	_transp(d, 6, 7, n, mask);			\
> >      } while (0)
> > -#define transp_nx2(d, n)				\
> > +#define transp8_nx2(d, n)				\
> >      do {						\
> >  	u32 mask = get_mask(n);				\
> >  	/* First block */				\
> > @@ -78,40 +78,41 @@ static inline u32 get_mask(int n)
> 
> I was going to say:
> 
> - these don't need to be implemented as macros
> 
> - these reference their arguments multiple times and will cause
>   problems when passed an expression with side-effects.

You're right. These could be inline functions.

> - they should be converted to inlined C function, but those functions
>   will be waaaaaaaay to big to inline.

They're actually not _that_ big. And "n" is known at compile-time.

> but happily, they appear to not have any callers?
> 
> >  	_transp(d, 5, 7, n, mask);			\
> >      } while (0)
> >  
> > -#define transp_nx4(d, n)				\
> > +#define transp8_nx4(d, n)				\
> >      do {						\
> >  	u32 mask = get_mask(n);				\
> > +	/* Single block */				\
> >  	_transp(d, 0, 4, n, mask);			\
> >  	_transp(d, 1, 5, n, mask);			\
> >  	_transp(d, 2, 6, n, mask);			\
> >  	_transp(d, 3, 7, n, mask);			\
> >      } while (0)
> >  
> > -#define transp(d, n, m)	transp_nx ## m(d, n)
> > +#define transp8(d, n, m)	transp8_nx ## m(d, n)
> 
> ah, yes they do.  Tricky!

But this macro exist to provide one single transp8(d, n, m) API.
Perhaps it'll work as one big inline function too. I'll check if gcc
is smart enough to optimize it ("m" is known at compile-time, too).

> >      /*
> > @@ -130,12 +131,12 @@ static inline unsigned long comp(unsigne
> >       *  Store a full block of planar data after c2p conversion
> >       */
> >  
> > -static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
> > +static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
> >  {
> >      int i;
> >  
> >      for (i = 0; i < bpp; i++, dst += dst_inc)
> > -	*(u32 *)dst = d[perm_c2p_8bpp[i]];
> > +	*(u32 *)dst = d[perm_c2p_32x8[i]];
> >  }
> >  
> >  
> > @@ -143,13 +144,13 @@ static inline void store_planar(char *ds
> >       *  Store a partial block of planar data after c2p conversion
> >       */
> >  
> > -static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
> > +static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
> >  				       u32 d[8], u32 mask)
> >  {
> >      int i;
> >  
> >      for (i = 0; i < bpp; i++, dst += dst_inc)
> > -	*(u32 *)dst = comp(d[perm_c2p_8bpp[i]], *(u32 *)dst, mask);
> > +	*(u32 *)dst = comp(d[perm_c2p_32x8[i]], *(u32 *)dst, mask);
> >  }
> 
> This driver needs a inlineectomy.

I actually want it to be inlined.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
