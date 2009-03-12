Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZCLId1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZCLId1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZCLIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:33:11 -0400
Received: from phunq.net ([64.81.85.152]:57290 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753827AbZCLIdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:33:06 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 01:33:02 -0700
User-Agent: KMail/1.9.9
Cc: tux3@tux3.org, linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903112238.55864.phillips@phunq.net> <20090311230713.d4710050.akpm@linux-foundation.org>
In-Reply-To: <20090311230713.d4710050.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120133.02645.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Andrew Morton wrote:
> > > - count_range() is an unsuitable identifier for a kernel-wide symbol.
> > >   Please review all global symbols in the fs, ensure that they are
> > >   prefixed with "tux3_".  Or make them static, of course.
> > 
> > This symbol is only supposed to be shared between separate compilation
> > units within fs/tux3, not be visible outside our module.  How do we do
> > that?
> 
> You can't.  Bear in mind that we want the allyesconfig kernel to link
> and run, and that includes tux3.  So do it manually by prefixing
> everything with tux3_ or whatever.  (does it need the "3"?)

It doesn't need the 3, and sometimes we leave the _ off as well.  OK,
this project is now underway.  (Actually, has been underway for a
while, the code was much more free form a few months ago.)

> > Anyway, this isn't used by kernel code at all right now, though it
> > should be.  For now, it has been made #ifndef __KERNEL__ until we
> > figure out what to do about this general class of symbols.
> > 
> > > - It uses printf() and assert()?  Kernel code uses printk() and
> > >   BUG_ON().  Confused.
> > 
> > That is the dual userspace/kernel personality showing.  Userspace code
> > really looks odd when filled with printfs, and BUG_ON is essentially a
> > nontraditional incarnation of Posix assert.  So please just declare on
> > this: assert and printf are banned from kernel code or not?  I have a
> > slight preference for not banned, given the prior art of the Posix
> > flavors, but however you want it is how it will be.  Not changed for
> > now.
> 
> Don't care much.  There's heaps of value in being able to
> run/develop/test the fs code in userspace.  I expect that this
> capability will eventually bitrot, so it'd be best to plan for that in
> some fashion.
> 
> umm, it _is_ primarily kernel code, after all.  So it seems appropriate
> to use BUG_ON() and printk(), etc and to provide versions of those for
> the userspace incarnation?

Will do.

> > Obviously, that raises the question of whether C99 syntax is banned in
> > kernel.
> 
> It is banned ;)
> 
> I'm not sure why, really - I have vague memories of Linus having an
> episode...  It seems an OK construct if used tastefully.  Although it
> does make it easy to hide nasty surprises.
> ...
> Well.  As I say, it doesn't bother me much (but I like C++, so ignore
> me).  But it will make merge/review life harder for you at the outset.
> How much harder I cannot predict.  People will fixate on this issue
> at the expense of everything else..

Well, I suppose we will do something in the middle for now: change some
to K&R, and leave some of it as is where we expect it to be developed
heavily, like dleaf.c which is going to see whole bunch of work to
integrate versioning, so it really makes little sense to make it harder
to factor just before starting that work.  Anyway, the C++ comments are
on their way out and after all that is the one people love to hate.

> > > - What's "L"?
> > > 
> > > 		printf("%Lx-", (L)begin);
> > 
> > A very handy way of working around 32/64 bit format string issues.  We
> > just cast all the messy cases to (long long), aka (L).  All other
> > solutions to this messy problem are worse in my opinion, but whatever
> > the ruling is, is what we will do.  This is used heavily in tracing and
> > dumping code, which can all be turned off with ifdefs, so it doesn't
> > affect production kernel text.
> 
> What format string issues are we talking about here?
> 
> See, a number of them will be fixed real soon now (geologically
> speaking) when various 64-bit architectures switch their s64/u64
> implementation from `long' to `long long'.

Ah, that would be helpful.  But not done yet?  How long until it
happens, and does it make sense to wait, so we can reduce the number
of problems cases?  And... will it be all 64 bit arches or just some?
Because this issue isn't solved if it isn't fixed for all arches.

There are a couple of issues, one is u64 being (long) instead of
(long long) as you say, and the other is variable type sizes like
loff_t.  That specific one isn't actually a problem, we can just refuse
to support 32 bit libc file ops, but there may be others.  We had a
world of pain before (L) arrived, then with (L) it was easy.  Maybe
just edit them all to (long long) for now, and damn the line length.

> But if "L" is being used for (say) sector_t then that problem will
> remain.  It would be conventional to just use the open-coded cast.

Sector_t is probably the biggest issue.  I really think we should
continue to support 32 bit sector_t, after all it 64 bit sector_t
makes zero sense on a cell phone, at least this year's cell phone,
and there is a real possibility that Tux3 could make a lot of sense
on a cell phone if we don't lose sight of the downward scaling
considerations.

> > > - link_entry() looks dangerous.
> > 
> > Live fast, die young.  It's an evolving interface.  Suggestions?
> 
> It looks like it can be passed almost any pointer at all (I forget). 
> Perhaps work out which types this is really to be used on, split it up
> into a number of fully-C-typed helper functions and call those rather
> than diving straight into the lower-level link_entry().
> 
> Something like that..

Well it's exactly as dangerous as list_entry.  In fs/tux3 we only have
a single use of it, which is another non-type-safe wrapper, which is
only used twice in the same file.  So ok, these will be changed to a
type safe wrapper.

Thanks much for the driveby lovin.  See you again in a few days, same
bat time, same bat channel.

Regards,

Daniel
