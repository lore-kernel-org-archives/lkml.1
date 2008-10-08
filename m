Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYJHAyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYJHAyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYJHAyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:54:08 -0400
Received: from ozlabs.org ([203.10.76.45]:42173 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbYJHAyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:54:06 -0400
Date: Wed, 8 Oct 2008 11:53:56 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Message-ID: <20081008005356.GA13615@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org,
	perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com> <20081003061713.GL3002@yookeroo.seuss> <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com> <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com> <20081005055339.GC469@yookeroo.seuss> <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com> <20081007035616.GB19037@yookeroo.seuss> <7c86c4470810070246x7ab8cc32k82177c7fdcf72b3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810070246x7ab8cc32k82177c7fdcf72b3f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:46:53AM +0200, stephane eranian wrote:
> David,
> 
> On Tue, Oct 7, 2008 at 5:56 AM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> > On Sun, Oct 05, 2008 at 11:23:15PM +0200, stephane eranian wrote:
> >> I see, so you were just decoupling to double the number of available bits.
> >> I guess we have a minimum of 32 bits. It seems overkill to support up to
> >> 32 'types'. We could force flags to uint64_t. But then we would have to do
> >> the same for all other syscalls to be consistent. Defining flags as long
> >> won't work because of 32-bit vs. 64-bit ABI compatibility issues.
> >
> > I guess so.  I guess there's also the possibility that you might later
> > have some flags that can apply to many of the syscalls, and it would
> > be nice to have them in a standard bit position for all calls.  That
> > might make bit allocation a bit interesting if you're squeezing type
> > into the same field.
> >
> I can see that for subsets of the calls, e.g., read and write of registers.
> It is not clear to me what kind of 'service' would apply to all calls.
> 
> As Corey suggested yesteday, the flags for read and write operations
> are not just single bit. A portion of the 64 bits, 8 in his proposal, are used
> to encode the 'type' of register (PMD, PMC, PMD_ATTR). That simplifies
> checking for valid bits in this portion of flags.

Yes, that was always what I had in mind if flags and type were
combined.

> OTOH, if I go back to your original proposal:
>    int pfm_write_pmrs(int fd, int flags, int type, void *v, size_t);
> 
> The 'type' field would have the same encoding as proposed by Corey.
> 32 bits would be plentyful for types. Flags could remain at 32-bits
> across the board, thereby avoiding the problems outlined by Arnd
> in his follow-up message. Separating the type also makes it look
> less like an ioctl(). So I think we should go with that proposal.

Works for me.

> [snip]
> >>
> >> If I summarize our discussion. It seems we can define the API as follows:
> >>
> >>     int pfm_create_session(int fd, uint64_t flags, pfarg_sinfo_t *sif,
> >> [ char *smpl_name, void *smpl_arg, size_t arg_size]);
> >>     int pfm_read_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
> >>     int pfm_write_pmrs(int fd, uint64_t flags, void *tab, size_t sz);
> >>     int pfm_attach_session(int fd, uint64_t flags, int target);   /*
> >> attach, detach with target=-1 */
> >>     int pfm_control_session(int fd, uint64_t flags);   /* for start/stop */
> >
> > Unless you have other functions in mind for this, I'd suggest a name
> > that's a little less generic here.  pfm_set_running() maybe.
> >
> What about pfm_set_state() or pfm_set_session_state()?

I guess so.

> >>     int pfm_control_sets(int fd, uint64_t flags, void *sets, size_t
> >>     sz);
> >
> > Hrm.  This now has identical signature to the {read,write}_pmrs.  I
> > wonder if these could be sensibly combined.  Maybe have
> > pfm_get_info(), pfm_set_info() which can get/set control structures
> > for several different namespaces: PMCs PMDs and now event sets.
> >
> I think this would be too generic as it would be mixing very different
> data types. This is not the case for pfm_write_pmrs() and pfm_read_pmrs()
> because you are always passing 'register descriptions'.
> 
> There is a fundamental difference between pfm_control_sets() and
> pfm_write_pmrs()/pfm_read_pmrs(). For the latter, the 'action' is hardcoded
> in the name of the syscall, i.e., read or write, what varies is whether or not
> we are passing PMD or PMC. For the former, the 'action', i.e., create new
> set or get info about a set, is hardcoded in the flags, and it determines the

Uh.. I was assuming if combined we'd drop the selecting flag from
control_sets() and instead make the pfm_read_stuff() call be the
get_info() equivalent when used on the eventsets space and
pfm_write_stuff() be the create/modify sets call.

The fact that the structure is different for read/write in this case
is a bit funny.  In fact it would probably be best to have different
'type' fields for read and write too (EVTSET_INFOm only usable for
reads , and EVTSET_CONTROL only for writes, maybe).


I'm not dead-set on combining these calls, but it seems to me we've
already just about made the read/write calls into a read/write array
of control structures in some namespace call, which pretty much is
what the event set call is too.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
