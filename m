Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbZELOEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbZELOEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZELOEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:04:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39515 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZELOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:04:08 -0400
Date: Tue, 12 May 2009 15:03:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090512140344.GO8633@ZenIV.linux.org.uk>
References: <20090508184838.GA11157@havoc.gtf.org> <200905101819.41765.rusty@rustcorp.com.au> <20090510150954.GA21561@havoc.gtf.org> <200905122304.52395.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905122304.52395.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 11:04:51PM +0930, Rusty Russell wrote:
> On Mon, 11 May 2009 12:39:54 am Jeff Garzik wrote:
> > On Sun, May 10, 2009 at 06:19:40PM +0930, Rusty Russell wrote:
> > > Yeah, it's kinda nasty.  Generally, sched_group is dynamically allocated,
> > > so we just allocate sizeof(struct sched_group) + size of nr_cpu_ids bits.
> > >
> > > These ones are static, and it was easier to put this hack in than make
> > > them dynamic.  There's nothing wrong with it, until we really want
> > > NR_CPUS == bignum, or we want to get rid of NR_CPUS altogether for
> > > CONFIG_CPUMASKS_OFFSTACK (which would be very clean, but not clearly
> > > worthwhile).
> >
> > Nothing wrong with it, except
> >
> > - C99 only defines variable-length automatic arrays
> > - VLA in the middle of a struct are difficult to optimize
> > - gcc's VLA handling WILL change, as gcc docs state
> > - other compilers -- and sparse -- puke all over VLAs, making
> >   static analysis impossible for all code with this weirdism
> 
> Jeff, you seem confused.  In my copy of the standard, you'd know this is called 
> a "flexible array member"; it's not a variable length array.  The only GCC 
> specific issue I can find here is that you're not normally allowed to embed 
> structs with them in another struct (according to the gcc docs; I can't 
> actually find this clearly stated in the standard).

6.7.2.1p2.  It's a separate issue from revolting gcc extension that *do*
allow VLA-in-the-middle-of-struct.  And I mean real VLA, not flex array
member :-/

> Anyway, since [] is C99, I thought it preferable to [0] which is a gcc 
> extension.  However, if C99 is really so braindead as to disallow this fairly 
> standard trick, so I'm happy to go with the gcc extension.[1]

No.  There's a standard way to do that in C99; you can put a struct with
that thing into a union.  So correct way to force enought storage for
such an object is

union {
	struct has_flex_array_member foo;
	char [how_much_space_do_I_want];
} bar;

Unions with overlapping members are fine.  Structures are not.
