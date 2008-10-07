Return-Path: <linux-kernel-owner+w=401wt.eu-S1752914AbYJGECv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbYJGECv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbYJGECm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:02:42 -0400
Received: from ozlabs.org ([203.10.76.45]:51926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYJGECl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:02:41 -0400
Date: Tue, 7 Oct 2008 14:56:16 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Message-ID: <20081007035616.GB19037@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org,
	perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com> <20081003061713.GL3002@yookeroo.seuss> <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com> <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com> <20081005055339.GC469@yookeroo.seuss> <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 11:23:15PM +0200, stephane eranian wrote:
> David,
> 
> On Sun, Oct 5, 2008 at 7:53 AM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> > [snip]
> >>  So you are suggesting something along the lines:
> >>
> >>    int pfm_read_pmrs(int fd, int flags, int type, void *tab, size_t sz);
> >>    int pfm_write_pmrs(int fd, int flags, int type, void *tab, size_t sz);
> >
> > Uh.. maybe.. there are actually several possible variants all of which
> > would meet the general idea I had in mind.
> >
> >>  I have already introduced a type flag (PFM_RWFL_PMD, PFM_RWFL_PMC).
> >>  Why separate the type into its own parameter?
> >
> > Combining the type into the flags is certainly a possibility.  I was
> > just a bit worried that if you eventually have enough actual flag
> > flags, in addition to the type values, you might start running out of
> > bits.
> >
> I see, so you were just decoupling to double the number of available bits.
> I guess we have a minimum of 32 bits. It seems overkill to support up to
> 32 'types'. We could force flags to uint64_t. But then we would have to do
> the same for all other syscalls to be consistent. Defining flags as long
> won't work because of 32-bit vs. 64-bit ABI compatibility issues.

I guess so.  I guess there's also the possibility that you might later
have some flags that can apply to many of the syscalls, and it would
be nice to have them in a standard bit position for all calls.  That
might make bit allocation a bit interesting if you're squeezing type
into the same field.

My opinion is not really strong either way though.

> >>  As for the freeform array, isn't that what people do not like because
> >> of  void *
> >>  and thus weak type checking?
> >
> > Yeah; this is an interesting tradeoff of flexibility versus
> > predictability.  Actually, what I originally had in mind was
> > seperately passing both 'n' and a per-element size.  That provides a
> > bit more defined structure to the void * - it must be an array of n
> > identical, fixed-size elements.  The internal structure of each
> > element is defined only by type, but it is assumed to contain no
> > pointers to further chained structures (i.e. its safe for wrapper code
> > to do shallow copies of the array).
> 
> Ok, that reminds me of the API of calloc(). It certainly forces you to
> think it terms of 'array of elements'. Yet it can be perverted very easily
> with the number of elements at 1.

That's true.  Like I say, it's a tradeoff.

> >>  I will look at switching to size instead of count. I think it does
> >>  make sense.
> >
> > Yeah.  As I said I was originally thinking of keeping the 'n'
> > parameter, and adding an element size parameter.  But just having an
> > overall size is also a possibility - it gives less definition to the
> > internal structure but at least things can marshal or copy the whole
> > array parameter without having to know its internals.
> >
> Yes, that it true. It also simplifies the checking on size. With count
> we had to check for multiply overflow because internall we had to
> check the size anyway.

That's a nice extra bonus, yes.

> > [snip]
> >> > > III) attaching and detaching
> >> > >
> >> > >   With v2.81:
> >> > >      int pfm_load_context(int fd, pfarg_load_t *load);
> >> > >      int pfm_unload_context(int fd);
> >> > >
> >> > >   With v3.0:
> >> > >      int pfm_attach_session(int fd, int flags, int target);
> >> > >      int pfm_detach_session(int fd, int flags);
> >> >
> >> > Couldn't you get rid of one more syscall here by making detach a
> >> > special case of attach with a special "null" value for target, or a
> >> > special flag?
> >>
> >>  We could combine the two and use the flag field to indicate attach/detach.
> >>  The target is not a pointer but an int. Some people suggested I use an
> >>  unsigned long instead. In anycase, we could not use 0 to indicate "detach"
> >>  because CPU0 is a valid choice for system-wide. Thus we would have to
> >>  pick another value to mean "nothing", e.g, -1.
> >
> > Sorry, I didn't express myself well.  I realise it's an integer, and
> > didn't mean an actual NULL, but as you say a special integer value
> > with a function similar to NULL.  -1 is the most obvious choice.
> >
> Yes, -1 would work.
> 
> If I summarize our discussion. It seems we can define the API as follows:
> 
>     int pfm_create_session(int fd, uint64_t flags, pfarg_sinfo_t *sif,
> [ char *smpl_name, void *smpl_arg, size_t arg_size]);
>     int pfm_read_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
>     int pfm_write_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
>     int pfm_attach_session(int fd, uint64_t flags, int target);   /*
> attach, detach with target=-1 */
>     int pfm_control_session(int fd, uint64_t flags);   /* for start/stop */

Unless you have other functions in mind for this, I'd suggest a name
that's a little less generic here.  pfm_set_running() maybe.

>     int pfm_control_sets(int fd, uint64_t flags, void *sets, size_t
>     sz);

Hrm.  This now has identical signature to the {read,write}_pmrs.  I
wonder if these could be sensibly combined.  Maybe have
pfm_get_info(), pfm_set_info() which can get/set control structures
for several different namespaces: PMCs PMDs and now event sets.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
