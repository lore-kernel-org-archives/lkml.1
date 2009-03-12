Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZCLKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZCLKP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZCLKPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:15:15 -0400
Received: from phunq.net ([64.81.85.152]:33693 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbZCLKPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:15:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 03:15:06 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120200.18910.phillips@phunq.net> <200903122010.31282.nickpiggin@yahoo.com.au>
In-Reply-To: <200903122010.31282.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120315.07610.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Nick Piggin wrote:
> On Thursday 12 March 2009 20:00:18 Daniel Phillips wrote:
> > Hi Nick,
> >
> > On Thursday 12 March 2009, Nick Piggin wrote:
> > > On Thursday 12 March 2009 19:33:02 Daniel Phillips wrote:
> > > > On Wednesday 11 March 2009, Andrew Morton wrote:
> > > > > > Obviously, that raises the question of whether C99 syntax is banned
> > > > > > in kernel.
> > > > >
> > > > > It is banned ;)
> > > > >
> > > > > I'm not sure why, really - I have vague memories of Linus having an
> > > > > episode...  It seems an OK construct if used tastefully.  Although it
> > > > > does make it easy to hide nasty surprises.
> > > > > ...
> > > > > Well.  As I say, it doesn't bother me much (but I like C++, so ignore
> > > > > me).  But it will make merge/review life harder for you at the
> > > > > outset. How much harder I cannot predict.  People will fixate on this
> > > > > issue at the expense of everything else..
> > > >
> > > > Well, I suppose we will do something in the middle for now: change some
> > > > to K&R, and leave some of it as is where we expect it to be developed
> > > > heavily, like dleaf.c which is going to see whole bunch of work to
> > > > integrate versioning, so it really makes little sense to make it harder
> > > > to factor just before starting that work.  Anyway, the C++ comments are
> > > > on their way out and after all that is the one people love to hate.
> > >
> > > I think they need to be fixed before merge. If the function is easier
> > > to follow when you use this feature, IMO it indicates the function is
> > > too big or badly written anyway.
> >
> > It's not about being easier to follow as being easier to factor.  Putting
> > the variables far away from point of use increases the busy work in
> > moving code around significantly, with a corresponding reduction in code
> > quality in the long run, because time is spent fiddling with declarations
> > instead of improving structure.  That said, it no doubt will be changed
> 
> Again, I would say if it takes so much more work to maintain, then the
> functions are too big or badly written. But I guess it is a matter of
> opinion, so...

It's not maintaining, it's developing.

Yes, this is a religious issue, pure and simple.  So when in Rome...

By the way, I just spotted your fsblock effort on LWN, and I should
mention there is a lot of commonality with a side project we have
going in Tux3, called "block handles", which aims to get rid of buffers
entirely, leaving a tiny structure attached to the page->private that
just records the block states.  Currently, four bits per block.  This
can be done entirely _within_ a filesystem.  We are already running
some of the code that has to be in place before switching over to this
model.

Tux3 block handles (as prototyped, not in the current code base) are
16 bytes per page, which for 1K block size on a 32 bit arch is a factor
of 14 savings, more on 64 bit arch.  More importantly, it saves lots of
individual slab allocations, a feature I gather is part of fsblock as
well.

We represent up to 8 block states in one 16 byte object.  To make this
work, we don't try to emulate the behavior of the venerable block
library, but first refactor the filesystem data flow so that we are
only using the parts of buffer_head that will be emulated by the block
handle.  For example, no caching of physical block address.  It keeps
changing in Tux3 anyway, so this is really a useless thing to do.

Anyway, that is more than I meant to write about it.  Good luck to you,
you will need it.  Keep in mind that some of the nastiest kernel bugs
ever arose from interactions between page and buffer state bits.  You
may run into understandable reluctance to change stable filesystems
over to the new model.  Even if it reduces the chance for confusion,
the fact that it touches cache state at all is going to make people
jumpy.  I would suggest that you get Ext3 working perfectly to prove
your idea, no small task.  One advantage: Ext3 uses block handles for
directories, as opposed to Ext2 which operates on pages.  So Ext3 will
be easier to deal with in that one area.  But with Ext3 you have to
deal with jbd too, which is going to keep you busy for a while.

The block handles patch is one of those fun things we have on hold for
the time being while we get the more mundane, but essential issues out
of the way, like whether we are going to run that commie C99 mindrot
filth out of town on a rail.

Regards,

Daniel
