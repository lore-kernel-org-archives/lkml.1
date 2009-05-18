Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZERQu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZERQu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZERQuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:50:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZERQut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:50:49 -0400
Date: Mon, 18 May 2009 18:49:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
Message-ID: <20090518164921.GA6903@elte.hu>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 18 May 2009, Ingo Molnar wrote:
> > 
> > Rusty Russell (1):
> >       sched: avoid flexible array member inside struct (gcc extension)
> 
> I'm not pulling this one either.
> 
> It makes no sense what-so-ever. It's uglier code, so calling it a 
> cleanup is just wrong.

hm - i've Cc:-ed Jeff & Viro. The background is that Sparse and LLVM 
barfed on the current construct and Al strongly advocated this 
solution, see:

  "[RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct"

See that particular reply below.

	Ingo

----- Forwarded message from Al Viro <viro@ZenIV.linux.org.uk> -----

Date: Tue, 12 May 2009 15:03:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com

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

----- End forwarded message -----
