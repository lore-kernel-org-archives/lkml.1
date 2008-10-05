Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbYJEFxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbYJEFxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 01:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJEFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 01:53:48 -0400
Received: from ozlabs.org ([203.10.76.45]:34444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYJEFxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 01:53:47 -0400
Date: Sun, 5 Oct 2008 16:53:39 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Message-ID: <20081005055339.GC469@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org,
	perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com> <20081003061713.GL3002@yookeroo.seuss> <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com> <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 12:58:12PM +0200, stephane eranian wrote:
> David,
> 
> On Fri, Oct 3, 2008 at 8:17 AM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> >
> > > The new API now has 8 system calls in its fully-featured
> > > version. Many data structures shared with user level have been
> > > abandoned in favor of explicit syscall parameters.  Each syscall has
> >
> > Ah, excellent, big structures passed through an interface are often a
> > pain to deal with, so I'm glad these are going.

[snip]
>  So you are suggesting something along the lines:
> 
>    int pfm_read_pmrs(int fd, int flags, int type, void *tab, size_t sz);
>    int pfm_write_pmrs(int fd, int flags, int type, void *tab, size_t sz);

Uh.. maybe.. there are actually several possible variants all of which
would meet the general idea I had in mind.

>  I have already introduced a type flag (PFM_RWFL_PMD, PFM_RWFL_PMC).
>  Why separate the type into its own parameter?

Combining the type into the flags is certainly a possibility.  I was
just a bit worried that if you eventually have enough actual flag
flags, in addition to the type values, you might start running out of
bits.

>  As for the freeform array, isn't that what people do not like because
> of  void *
>  and thus weak type checking?

Yeah; this is an interesting tradeoff of flexibility versus
predictability.  Actually, what I originally had in mind was
seperately passing both 'n' and a per-element size.  That provides a
bit more defined structure to the void * - it must be an array of n
identical, fixed-size elements.  The internal structure of each
element is defined only by type, but it is assumed to contain no
pointers to further chained structures (i.e. its safe for wrapper code
to do shallow copies of the array).

>  I will look at switching to size instead of count. I think it does
>  make sense.

Yeah.  As I said I was originally thinking of keeping the 'n'
parameter, and adding an element size parameter.  But just having an
overall size is also a possibility - it gives less definition to the
internal structure but at least things can marshal or copy the whole
array parameter without having to know its internals.

[snip]
> > > III) attaching and detaching
> > >
> > >   With v2.81:
> > >      int pfm_load_context(int fd, pfarg_load_t *load);
> > >      int pfm_unload_context(int fd);
> > >
> > >   With v3.0:
> > >      int pfm_attach_session(int fd, int flags, int target);
> > >      int pfm_detach_session(int fd, int flags);
> >
> > Couldn't you get rid of one more syscall here by making detach a
> > special case of attach with a special "null" value for target, or a
> > special flag?
> 
>  We could combine the two and use the flag field to indicate attach/detach.
>  The target is not a pointer but an int. Some people suggested I use an
>  unsigned long instead. In anycase, we could not use 0 to indicate "detach"
>  because CPU0 is a valid choice for system-wide. Thus we would have to
>  pick another value to mean "nothing", e.g, -1.

Sorry, I didn't express myself well.  I realise it's an integer, and
didn't mean an actual NULL, but as you say a special integer value
with a function similar to NULL.  -1 is the most obvious choice.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
