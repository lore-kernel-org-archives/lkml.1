Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbZHYVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbZHYVeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZHYVeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:34:21 -0400
Received: from THUNK.ORG ([69.25.196.29]:46718 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZHYVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:34:19 -0400
Date: Tue, 25 Aug 2009 17:33:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090825213337.GX17684@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Paul Mackerras <paulus@samba.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	johnstul@us.ibm.com, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org
References: <19088.47213.327897.703458@cargo.ozlabs.ibm.com> <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com> <20090824082318.GD2424@elte.hu> <19091.24374.210127.155521@drongo.ozlabs.ibm.com> <20090825082612.GA17692@elte.hu> <19091.46451.893720.573893@cargo.ozlabs.ibm.com> <20090825101742.GA26801@elte.hu> <19091.52205.222449.441072@cargo.ozlabs.ibm.com> <20090825135017.GA31340@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825135017.GA31340@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:50:17PM +0200, Ingo Molnar wrote:
> > [...]  It's like making changes inside #ifdef CONFIG_FOO but never 
> > testing with CONFIG_FOO turned on.  You'd complain, and rightly, 
> > if someone did that.
> 
> You again seem to ignore the very valid case i pointed out: if i 
> change generic code (or an include, an inline function or a define) 
> which somehow affects an architecture, by your logic i'd be 
> compelled to test it on that architecture - because it affects it. 
> That's not reasonable overhead.

Paul, Ingo, it seems like the two of you are talking past each other.
He's said he's OK with generic code which somehow affects an
architecture only being tested on one architecture, so what you're
proposing is a straw man.  What he has requested it would be nice that
each line of code be compile-tested on at least *one* architecture.
If it's generic code, then by definition when you compile on x86, it's
met the criterion he has proposed.

On the other hand, your claim that it would slow down development too
much is based on the assumption that if you make a change in generic
code that breaks architecture-specific code, it's good manners to at
least *attempt* to fix up the architecture-specific code, as opposed
to leaving it broken.  So you could meet Paul's request of "not
committing code that hasn't been compile-tested" by simply leaving
that particular architecture broken when you change generic code.

Personally, I think that would be worse, since that exchanges the risk
that a generic change might break the PowerPC architecture, with the
*certainty* that the PowerPC architecture would be broken by said
change.  :-)  So it may very well be that you are doing the right
thing.

It's the combination of Paul's request that it be good manners that
all architecture specific code be compile-tested at least once, and
the generally accepted criterion that when someone makes a change in
generic code, that all in-tree users should be converted to use the
new calling convention --- after all, that's one of the benefits that
we tout to device driver writers for merging code into the mainline.


I will note, by the way, that in the file system space, where we have
almost 70 filesystems, I doubt very much that every single generic
change in the core VM or FS code that might have a potential to affect
every single filesystem gets compile-tested using allyesconfig.  Maybe
it should, but I suspect it's not all that uncommon for people to
assume that simple syntactical change of adding an extra parameter to
a function signature (for example) can be addressed using a global
search and replace, and not necesarily tested on every single
filesystem.  Maybe it *should* in the ideal world, but I'm guessing
that sometimes that doesn't happen...

In the case of architecture code where compile-testing on every single
architecture would require keeping very large number of
cross-compilers, and a non-trivial amount of time, it's much less
reasonable.  Doing a full test on all architectures before pushing to
Linus (as opposed to publication in a -tip git branch) may be the best
that can be expected.

						- Ted

