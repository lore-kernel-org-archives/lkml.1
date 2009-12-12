Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbZLLAtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbZLLAtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbZLLAtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:49:10 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45984
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZLLAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:49:09 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Fri, 11 Dec 2009 18:49:00 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <200912080317.08254.rob@landley.net> <4B2265D2.6000400@suse.cz> <4B2299E3.8020903@zytor.com>
In-Reply-To: <4B2299E3.8020903@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912111849.01745.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009 13:13:39 H. Peter Anvin wrote:
> On 12/11/2009 07:31 AM, Michal Marek wrote:
> > OK, that's valid point, indeed. Peter, would you ack Rob's patch with
> > the oneline fix added (http://lkml.org/lkml/2009/12/8/94 plus
> > http://lkml.org/lkml/2009/12/9/435)?
>
> I strongly dislike his patch, as he open-codes specific multiprecision
> arithmetic.  This makes it hard for other people to maintain, and makes
> it prone to errors

It's always easier to understand code that you wrote, doubly so with perl.  
The perl code this is replacing has comments, function names like fmul() and 
fmuls() with no way to distinguish what they do except by reading their 
implementation, and half of it is devoting to cacheing the output of the other 
half for reasons which are never explained in the code.

The few comments the perl code does have are sometimes actually misleading.  
For example, bignum_hex() has the comment "generate a hex value if the result 
fits in 64 bits; otherwise skip".  What would skpping mean in this context?  
Would it silently emit a broken header, or would it break the build?  (My first 
guess is that "undef" without an expr would be a build break, but maybe this 
is perl's way of saying "None"?  I do know that whatever happened the result 
wouldn't be a usable kernel, so "skip" is disingenous.)

That said, I read through and managed to understand the perl code.  But it 
took me more than a day, and I was motivated by the desire to replace it.

> -- as evidenced by the fact that it didn't even
> replicate the known-good results.

Actually I had noticed the difference back at the time I wrote the script, but 
the value plus shift were functionally equivalent, and at the time (a year 
ago) I vaguely recall working through the math (and looking at the kernel code 
using the output) convinced me that that integer overflow couldn't actually 
happen for real inputs.  But I don't remember why (perhaps the value to be 
converted is range checked somewhere so ffffffff couldn't actually make it to this 
code, I don't remember) and thus my version would give more precision to the 
result (which seemed to be the whole point of the exercise).

No point in trying to reconstruct my reasoning from a year ago when it's a one 
line change to make it non-controversial, and the "value always fits in 32 bits 
so you can safely multiply by an unsigned int due to LP64" is easier to 
explain/document anyway.  (On the other end of things, I do remember that the 
admittedly insane HZ of ffffffff would have a GCD of 5 with 1000 and thus not be 
saved as that.  That came up because I was worried an ffffffff value times ffffffff 
might _round_ up to overflow when adj32 was added.  I did attempt to document 
some of the edge cases in the shell script comments...)

> I have made my position clear on this and other patches several times
> before: I consider it a fool's errand,

I.E. your fundamental objection is to removing perl form the build.

You are the one who added this perl to the build system.  You're also the one 
who added perl to all the other projects you maintain (klibc and syslinux I 
noticed) at approximately the same time, after years of those not requiring 
perl.  I don't know why you suddenly decided perl needed to be everywhere, but 
the Linux kernel is not the only project you simultaneously applied this 
philosophy to.

I strongly suspect the other objections you've raised in the past two years 
are a proxy for the objection to removing perl.  However, your central 
objection to removing perl hasn't convinced people like Alan Cox, who called 
Perl "a bad candidate for our toolchain dependencies" here:

  http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/02108.html

Thus you raise other issues, which seem to be proxies for that fundamental 
objection.  I've tried to address the ones that look like they were actually 
intended to be addressed, but I note that your current objection is to the 
something like the seventh submission of this patch, and I believe this is the 
first time you've raised this particular issue.  I believe I first submitted an 
ancestor of this patch on February 15, 2008.  Just this year I've submitted 
previous versions of this patch (more or less in its current form) on January 
2, 2009 (with a resubmit on January 3 in response to feedback), on June 22, 
and on September 18.  And again now.  The patch hasn't changed much, your 
objections to it have.

I don't even remember you previously complaining about the output differing.  
(At a guess, you never actually tried my patch?)  But it has been a while, I 
could easily be forgetting details by now.

I'm posting these here because they're useful to other people, not because I 
expect you to ever stop objecting to them no matter what changes I make.  
You've made it clear you object to the _goal_ of the patch.  The 
implementation seems to be a side issue.

> and a result of a completely
> pointless crusade to make a particular science fair-type project a wee
> bit easier.

Embedded developers' desire to restrict their build environment to something 
controllable seems to strike you as weird, yes.  Would it help to explain that 
it's the same general theory behind Linux From Scratch making a temporary 
system, chrooting into it, and then building in there in Chapter 5?

Leaking random crap from the host is bad, often in subtle ways you don't 
immediately catch.  Some programs (perl, libtool, syscfg) are champions at 
leaking context, and to be avoided if at all possible.  (I suppose you could 
always suggest setting up a different build environment for the kernel as for 
userspace, the way Red Hat used to do with kgcc.  Doesn't strike me as a good 
idea, though.)

> We have already seen real damage caused by it, since people
> have used awk instead, and have gotten bitten by incompatibilities
> between awk implementations.

I'm not using AWK, and I'm sticking with POSIX shell constructs that were 
there in susv3, let alone susv4.

Since I wasn't the one proposing any patches extensively using awk (I need the 
man page open to make awk do anything more complicated than '{print $2}'), and 
this patch isn't using awk at all, I guess you're once again objecting to the 
removal of perl in general, not to the patch in front of you.  And in doing 
so, you're providing evidence that I'm not the only one motivated to submit 
perl removal patches, which might undermine your "particular science fair 
project" argument a bit.

I am motivated to follow up on this.  I've been maintaining perl removal 
patches for a couple years now because I personally need them, but I'm not the 
only one using these patches, and I've been thanked for tackling this problem 
by a dozen embedded developers.  I wasn't the one who first noticed the perl 
dependency when it went in back in .25, David Anders notified me of the issue 
before I'd tested the -rc that introduced it.  The most recent guy to say, and 
I quote, "Thanks for eliminating the perl dependency." to me in private email 
was Joe Perches (on Tuesday).

Embedded developers tend to do stuff off-list.  This is because every new kernel 
breaks random stuff on non-x86 targets.  For example, I finally got powerpc's 
pmac_zilog fixed a few days ago (allowing me to use the serial console on 
qemu's mac99 target), after a thread stretching back two months (it broke 
after 2.6.28).  The "works for me" fix is here:

  http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-December/078700.html

The most recent arm breakage turned out to be simple (a new CONFIG_MMU symbol 
showed up between 2.6.31 and 2.6.32 and needed to be switched on), but 
diagnosing "it doesn't boot, no console messages" is always a pain.

The most recent mips breakage was fixed by commit 
d71789b6fa37c21ce5eb588d279f57904a62e7e2 which I asked to be backported to 
2.6.31 in the stable series and Greg KH acknowledged on November 5th.  (I'd 
link to my submission to stable@kernel.org but there's no entry for that in 
vger lists and googling doesn't seem to come up with a public archive.)

That's just in the past month or so.  Trying to git bisect each of those 
problems found huge ranges of "it doesn't even compile" in the repository, 
because that's the _norm_ for non-x86 targets during development.

Most embedded developers don't want to deal with this, so they stay a year or 
three behind the bleeding edge and only upgrade after crazy people like me 
have gotten it working.  Since even the ones who _don't_ start their messages 
by apologizing about their English know they'll be flamed or ignored if they 
raise an issue about an 18 month old kernel here, they develop a fear of 
posting on linux-kernel at all because it's an "unfriendly" place.  (I try to 
talk them out of it, but it's a cultural thing at this point.  The new kernel 
embedded list hasn't really helped more than 10% of this problem.)

I regularly tackle these issues anyway, am generally friendly to newbies on 
the lists I follow, and apparently have no shame, so people sometimes forward 
issues to me and hope I'll push them upstream so they don't have to.  (And 
then go away again once they've managed to upgrade to whatever snapshot 
they'll be using for the next 3 years, leaving me to follow up.)

*shrug*  I'm used to it.  You feed stray issues patches and they wind up 
adopting you...

> As such, no, I will not ack this patch, and will consider myself
> released of any obligation to maintain the code if this goes in anyway.

I've been maintaining this patch series for 2 years already.  I would be happy 
to maintain my changed version in future if it gets in.  I expected that.

>  I would consider acking a C program which does proper multiprecision
> arithmetic, but I'm also not going to spend my time on it.

Hmmm, "would consider acking" (not "would ack", not even "could ack"), with 
the additional caveat that the multiprecision arithmetic must be an unspecified 
"proper", whatever that means.  The "proxy objections" thesis stated above 
would label this an obvious delaying tactic, but if I promise to call your 
bluff, then the current patch gets dropped on the floor for another development 
cycle...

Well played, sir.  I must plead the 5th for now.

> 	-hpa

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
