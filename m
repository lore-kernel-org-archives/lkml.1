Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZCLGI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZCLGI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 02:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZCLGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 02:08:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbZCLGIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 02:08:49 -0400
Date: Wed, 11 Mar 2009 23:07:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-Id: <20090311230713.d4710050.akpm@linux-foundation.org>
In-Reply-To: <200903112238.55864.phillips@phunq.net>
References: <200903110925.37614.phillips@phunq.net>
	<20090311114211.89eed5b8.akpm@linux-foundation.org>
	<200903112238.55864.phillips@phunq.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 22:38:55 -0700 Daniel Phillips <phillips@phunq.net> wrote:

> On Wednesday 11 March 2009, Andrew Morton wrote:
> > On Wed, 11 Mar 2009 09:25:37 -0700
> > Daniel Phillips <phillips@phunq.net> wrote:
> > 
> > > The full patch is 191KB.  We could try patchbombing lkml with that, one
> > > patch per file, say.
> > 
> > One patch per file is OK.
> 
> OK, the next iteration will be that.  For today there is a new patch
> here:
> 
>    http://tux3.org/patches/tux3-2.6.29-rc7-2
> 
> and the Git repository is updated:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git
> 
> Any idea how I make this appear on the web interface at git.kernel.org?

Sorry, my git cluelessness is epic.

> > - count_range() is an unsuitable identifier for a kernel-wide symbol.
> >   Please review all global symbols in the fs, ensure that they are
> >   prefixed with "tux3_".  Or make them static, of course.
> 
> This symbol is only supposed to be shared between separate compilation
> units within fs/tux3, not be visible outside our module.  How do we do
> that?

You can't.  Bear in mind that we want the allyesconfig kernel to link
and run, and that includes tux3.  So do it manually by prefixing
everything with tux3_ or whatever.  (does it need the "3"?)

> Anyway, this isn't used by kernel code at all right now, though it
> should be.  For now, it has been made #ifndef __KERNEL__ until we
> figure out what to do about this general class of symbols.
> 
> > - It uses printf() and assert()?  Kernel code uses printk() and
> >   BUG_ON().  Confused.
> 
> That is the dual userspace/kernel personality showing.  Userspace code
> really looks odd when filled with printfs, and BUG_ON is essentially a
> nontraditional incarnation of Posix assert.  So please just declare on
> this: assert and printf are banned from kernel code or not?  I have a
> slight preference for not banned, given the prior art of the Posix
> flavors, but however you want it is how it will be.  Not changed for
> now.

Don't care much.  There's heaps of value in being able to
run/develop/test the fs code in userspace.  I expect that this
capability will eventually bitrot, so it'd be best to plan for that in
some fashion.

umm, it _is_ primarily kernel code, after all.  So it seems appropriate
to use BUG_ON() and printk(), etc and to provide versions of those for
the userspace incarnation?

> > - There's a lot of this:
> > 
> > 	int ended = 0, any = 0;
> > 	struct buffer_head *buffer = blockread(mapping(inode), block);
> > 	if (!buffer)
> > 		return -1;
> > 	unsigned bytes = blocksize - offset;
> > 	if (bytes > tail)
> > 		bytes = tail;
> > 	unsigned char *p = bufdata(buffer) + offset, *top = p + bytes;
> > 
> >   Which will spew compilation warnings due to local variable
> >   definitions coming after code.
> 
> We compile without warnings in kernel by putting this in our Makefile:
> 
>    EXTRA_CFLAGS += -Werror -std=gnu99 -Wno-declaration-after-statement
> 
> Obviously, that raises the question of whether C99 syntax is banned in
> kernel.

It is banned ;)

I'm not sure why, really - I have vague memories of Linus having an
episode...  It seems an OK construct if used tastefully.  Although it
does make it easy to hide nasty surprises.

>  Well, C99 comments have a long tradition of attracting flames,
> so all those are on their way out of Tux3 code (though not out yet) but
> inline declarations actually serve a useful purpose in code that is in
> process of continuous refactoring.  So I think we would like to keep
> these in some files for the time being, that are in heavy development,
> and change some of the "traditional" usage like VFS glue to K&R style.
> 
> Naturally I would prefer that this matter be left up to the individual
> artist for non-core kernel code, but please just make a ruling on it.
> If the ruling is "we don't brook none of that filthy new C syntax"
> then we will start converting all the kernel code.  Not started yet.

Well.  As I say, it doesn't bother me much (but I like C++, so ignore
me).  But it will make merge/review life harder for you at the outset.
How much harder I cannot predict.  People will fixate on this issue
at the expense of everything else..

> >   Maybe this code is never to be compiled into the kernel image, but
> >   we might as well be consistent.
> 
> Almost all of it is compiled by both userspace and kernel.
>  
> > - What's "L"?
> > 
> > 		printf("%Lx-", (L)begin);
> 
> A very handy way of working around 32/64 bit format string issues.  We
> just cast all the messy cases to (long long), aka (L).  All other
> solutions to this messy problem are worse in my opinion, but whatever
> the ruling is, is what we will do.  This is used heavily in tracing and
> dumping code, which can all be turned off with ifdefs, so it doesn't
> affect production kernel text.

What format string issues are we talking about here?

See, a number of them will be fixed real soon now (geologically
speaking) when various 64-bit architectures switch their s64/u64
implementation from `long' to `long long'.

But if "L" is being used for (say) sector_t then that problem will
remain.  It would be conventional to just use the open-coded cast.

> > - link_entry() looks dangerous.
> 
> Live fast, die young.  It's an evolving interface.  Suggestions?

It looks like it can be passed almost any pointer at all (I forget). 
Perhaps work out which types this is really to be used on, split it up
into a number of fully-C-typed helper functions and call those rather
than diving straight into the lower-level link_entry().

Something like that..

> > Generally: the code is _very_ namespace-piggy.  Lots and lots of very
> > generic-sounding identifiers.
> 
> Righto.  A way of sandboxing external symbols just to our own module
> would be very helpful, otherwise we will get busy tux3_ing those.

tux3_ away ;)
