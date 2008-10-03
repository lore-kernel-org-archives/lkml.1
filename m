Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbYJCGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbYJCGRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 02:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYJCGRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 02:17:17 -0400
Received: from ozlabs.org ([203.10.76.45]:42061 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbYJCGRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 02:17:16 -0400
Date: Fri, 3 Oct 2008 16:17:13 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: perfmon3 interface overview
Message-ID: <20081003061713.GL3002@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 11:48:27PM +0200, stephane eranian wrote:
> Hello,
> 
> A few months ago, I started posting on this list a highly simplified version
> of the perfmon2 version which was providing only per-thread counting on X86
> processors.
> 
> The feedback I got was generally positive but people raised two more issues:
> 
>     - too many system calls for a single subsystem (12 calls)
> 
>     - how to ensure syscalls could be extended without necessarily
>       adding new ones.
> 
> 
> Since then, I have been working hard on addressing those two issues,
> in other words redesign of the perfmon2 syscall API. This message is
> to announce that I now have a new proposal for the API. As expected
> it is called perfmon3 and it addresses the two issues above while
> allowing backward compatibility with the existing v2.81 version
> through a user level glue layer which could be implemented by a
> library such as libpfm.

> The new API now has 8 system calls in its fully-featured
> version. Many data structures shared with user level have been
> abandoned in favor of explicit syscall parameters.  Each syscall has

Ah, excellent, big structures passed through an interface are often a
pain to deal with, so I'm glad these are going.

> a flags parameters which allows the syscalls to be extended with new
> parameters when we need them. Most structures passed to the kernel
> have reserved fields for future extensions.
> 
> The initial patchset will only support per-thread counting as I did
> previously. However, here I am presenting the details for the fully
> featured version so people can get a feel for it. For each call I
> show the old way and the new way.
> 
> Note that when the syscall is shown twice with a different number of
> parameters, this variation is handled by the user library. The
> kernel implements the full call. This is the same technique used for
> the open(2) syscall.

I, at least, like the changes that have been made here.  I do have a
few suggestions for further simplifications along the same lines
though, see below.

[snip]
>  II) programming the registers
> 
>  With v2.81:
>       int pfm_write_pmcs(int fd, pfarg_pmc_t *pmds, int  n);
>       int pfm_write_pmds(int fd, pfarg_pmd_t *pmcs, int n);
>       int pfm_read_pmds(int fd, parg_pmd_t *pmds, int n);
> 
>  With v3.0:
>       int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
>       int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n,
>                                       pfarg_pmd_attr_t *pmas);
> 
>       int pfm_read_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
>       int pfm_read_pmrs(int fd, int flags, parg_pmr_t *pmrs, int n,
>                                      pfarg_pmd_attr_t *pmas);

I would suggest adding 'type' and 'size' (int) parameters, and folding
the pmrs and pmas arrays into one freeform array.  'size' gives the
size in bytes of the array elements, 'type' selects the structure of
each array element.  This means:
	- if you ever have some sort of registers to access that are
neither PMCs nor PMDs, you can access those two, using a new type
value.
	- if a new method of operation wants to supply different
information for PMCs or PMDs, you can define a new structure and type
value (one obvious example would be a minimal (num,value) only
structure for minimum latency on simple applications).
	- an explicit size value means things can marshal / copy /
whatnot the parameters without having to know what size each type
implies -  the code will stay valid when new types / structures are
defined.

[snip]
> III) attaching and detaching
> 
>   With v2.81:
>      int pfm_load_context(int fd, pfarg_load_t *load);
>      int pfm_unload_context(int fd);
> 
>   With v3.0:
>      int pfm_attach_session(int fd, int flags, int target);
>      int pfm_detach_session(int fd, int flags);

Couldn't you get rid of one more syscall here by making detach a
special case of attach with a special "null" value for target, or a
special flag?

>  IV) starting and stopping
> 
>    With v2.81:
>       int pfm_start(int fd, pfarg_start_t *st);
>       int pfm_stop(int fd);
>       int pfm_restart(int fd);
> 
>    With v3.0:
>       int pfm_start_session(int fd, int flags);
>       int pfm_stop_session(int fd, int flags);

Likewise, couldn't you cut this down by one more syscall by making it
	int pfm_set_session_state(int fd, int flags);
and having a 'RUNNING' flag, which selects start or stop behaviour?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
