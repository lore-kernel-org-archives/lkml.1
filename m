Return-Path: <linux-kernel-owner+w=401wt.eu-S1762455AbYBVSyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762455AbYBVSyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbYBVSye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:54:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbYBVSyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:54:31 -0500
Date: Fri, 22 Feb 2008 19:54:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222185359.GA29945@elte.hu>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
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

> I'm personally of the opinion that a lot of checkpatch "fixes" are 
> anything but. That mainly concerns fixing overlong lines (where the 
> "fixed" version is usually worse than the original), but it's been 
> true for some other warnings too.

that was certainly the case for the earlier checkpatch releases which 
treated overlong lines as an error.

So here's a quick list of negative and positive aspects of current 
versions of checkpatch, as i see them.

But let me first declare it that when scripts/checkpatch.pl was 
initially merged last year i immediately ran it over my own files and 
became a deep sceptic of it. (check the lkml archives, i complained alot 
about it)

Now i've got more than half a year of experience with using checkpatch 
as an integral part of scheduler maintenance, and we've now got 4 months 
of experience with using checkpatch in arch/x86 maintenance.

Based on this first hand experience, my opinion about checkpatch has 
changed, rather radically: i now believe that checkpatch is almost as 
important to the long term health of our kernel development process as 
BitKeeper/Git turned out to be. If i had to stop using it today, it 
would be almost as bad of a step backwards to me as if we had to migrate 
the kernel source code control to CVS.

Lets see the Bad Side of checkpatch:

 1) checkpatch "errors" shouldnt be taken too seriously for newly 
    introduced "leaf" driver code, which code we dont at all know 
    whether we'll be maintaining in any serious manner in the future. 
    Slowing down a submission by requirig it to pass checkpatch is not 
    as clear-cut as it is for core infrastructure and architecture code.
    It's far more important to get _any_ code to users (as long as it's 
    not outright harmful) than to nitpick about style details.

 2) it still has some false positives. (They are quite rare in the 
    latest versions, about 1 out of 100 for code that is already 
    "clean". I send them over to Andy whenever i see them, and they get 
    fixed quickly. The false positives were a big annoyance in early 
    checkpatch.pl versions, these days they are not - to me at least.)

 3) it's _really_ annoying when sometimes i stumble over some old, 
    crufty piece of code that according to checkpatch is in high need of 
    some good, thorough cleanup - and when i take a look at the code it 
    turns out that the original author of that crap piece of code turns 
    out to be ... me. Those moments can be pretty embarrasing and 
    sobering ;-)

The Good Side of checkpatch (and here i'll only list the non-obvious 
advantages):

 1) 90% of the scheduler related checkpatch fixes today you'll never 
    recognize in a commit! The fixes all happen before code is 
    submitted, and the fixes are seemlessly embedded in nice looking 
    patches. (in that sense checkpatch is a bit like lockdep: 90% of the 
    errors they detect wont hit lkml, ever.)

 2) you might know that Deja-Vu moment when you look at a new patch that 
    has been submitted to lkml and you have a strange, weird "feeling" 
    that there's something wrong about the patch.

    It's totally subconscious, and you take a closer look and a few
    seconds later you find a real bug in the code.

    That "feeling" i believe comes from a fundamental property of how 
    human vision is connected to the human brain: pattern matching. 
    Really good programmers have built a "library" of patterns of "good" 
    and "bad" looking coding practices.

    If a patch or if a file has a clean _style_, bugs and deeper 
    structural problems often stand out like a sore thumb. But if the 
    code is peppered with random style noise, it's a lot harder (for me 
    at least) to notice real bugs. I can notice bugs in a squeeky clean 
    code base about 5 times easier than in a noisy codebase. This effect
    alone makes checkpatch indispensible for the scheduler and for 
    arch/x86.

    Sidenote: i dont really need fancy metrics trying to tell me how 
    good an algorithm _truly_ is (although it certainly would be 
    interesting to have). I can _see_ that at a glance - provided the
    code follows common kernel practices and a common, consistent style.
    Checkpatch makes visual code patterns universal and eases the human
    maintainance work enormously, for a 150+ KLOC subsystem like
    arch/x86. I'm not distracted (visually and mentally) by the thick
    fog of small silly details and quirks in coding style. Others might
    have radar eyes and radar brains, i dont :-)

 3) checkpatch also keeps _my_ bugs out of the kernel in an interesting
    way. I'm sure many of you are like me: i've got "weaker" moments
    when i write rather crappy code, and i've got "stronger" moments
    when i'm in the flow and can write a few thousand lines of code with
    nary a hickup. What makes things worse is it's really hard to tell
    the two apart.

    It turns out - and this surprised me a lot - that when i write new
    code that is "weaker", i tend to make more "style mistakes", without
    noticing them. Later on, when i do a checkpatch run, i see some
    weird looking code and find that it's also buggy!

    This concept also works with code written by others: when i get a
    careless patch written in a hurry, it is much more likely to have
    style errors in it, and as a maintainer i'm warned about that fact. 

    The best programmers are the ones who have a good eye for details - 
    and that subconsciously extends to "style details" too. I've yet to
    see a _single_ example of a good, experienced kernel programmer who 
    writes code that looks absolutely careless and sloppy, but which is 
    top-notch otherwise. (Newbies will make style mistakes a lot more 
    often - and for them checkpatch is a nice and easy experience at 
    reading other people's code and trying to learn the style of the 
    kernel.)

 4) there's a psychological effect as well: clean _looking_ code is 
    more attractive to coders to improve upon. Once the code _looks_ 
    clean (mechanically), the people with the real structural cleanups 
    are not far away either. Code that just looks nice is simply more of 
    a pleasure to work with and to improve, so there's a strong 
    psychological relationship between the "small, seemingly unimportant 
    details" cleanups and the real, structural cleanups.

    On the other hand, bad looking, unaesthetic code is avoided by 
    kernel developers like the pest. That is a constant skewing force 
    that is very harmful to Linux, because the "current style" of 
    subsystems is a pretty random property at the moment, and there are 
    _many_ important codebases in the kernel that are avoided by most of 
    us purely just because they look so awful.

 5) cleanups were rather hard to get upstream before, because there was 
    never any true "objective basis" for the cleanups, giving an easy 
    excuse for flames over stupid taste differences, and making it easy 
    for maintainers to reject 90%-good cleanups just based on taste
    differences. Checkpatch gives the right tool to people to write 
    consistently clean code and makes it harder for maintainers to find 
    the arguments to keep keep code unclean.

After this list of rather subjective impressions, i've also got some 
historic raw data as well about how arch/x86 cleanups progressed over 
the past 4 months.

  ( NOTE: the "errors" count below does _not_ include "lines longer than 
    80 chars" warnings nor any of the other checkpatch warnings - only 
    checkpatch "errors" which are real bona fide style errors in 99%+ of 
    the cases. )

                                          errors  lines of code  errors/KLOC
 ........................................................................
 v2.6.24-rc1      arch/x86/ [23 Oct 2007]  8695      117423         74.0
 v2.6.24-x86.git  arch/x86/ [21 Nov 2007]  5190      117156         44.2
 v2.6.24-x86.git  arch/x86/ [18 Dec 2007]  4057      117213         34.6
 v2.6.24-x86.git  arch/x86/ [ 8 Jan 2008]  3650      117987         30.9
 v2.6.24-x86.git  arch/x86/ [ 4 Feb 2008]  3334      133542         24.9
 v2.6.25-x86.git  arch/x86/ [21 Feb 2008]  2724      136963         19.8

 [ See: http://redhat.com/~mingo/x86.git/code-quality - although i guess 
   i should rename it to "style-quality" - because there is no direct
   mapping of style quality to real code quality. NOTE: some of the 
   reductions in the error count above are mechanic from things like 
   really long arrays or the math-emu changes - but most of the real
   reductions are genuine. ]

v2.6.24-rc1 was the raw arch/x86 code how we inherited it after we did 
the mechanic unification without changing any of the files. After that 
point you can see a marked reduction in the total count of style errors.

While many of the fixes are just small details and may all seem 
insignificant in isolation, IMO the sum of those small details matters 
_a lot_: in the past 4 months the code has become a lot more hackable to 
us and that process was driven in large part by checkpatch.

	Ingo
