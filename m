Return-Path: <linux-kernel-owner+w=401wt.eu-S1422651AbXCBAaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422651AbXCBAaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422652AbXCBAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:30:35 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59502 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651AbXCBAae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:30:34 -0500
Date: Thu, 1 Mar 2007 16:26:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
In-Reply-To: <20070301145204.GA25304@elte.hu>
Message-ID: <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk>
 <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk>
 <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk>
 <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu>
 <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Mar 2007, Ingo Molnar wrote:
> 
> git-bisect gets royally confused on those ACPI merge branches around 
> commit c0cd79d11412969b6b8fa1624cdc1277db82e2fe. Here are my test 
> results so far:

Looks like git bisect worked for you, and wasn't confused at all. You 
started out with 2931 commits between your first known-bad and known-good 
commits, which means that you usually end up having to check "log2(n)+1" 
kernels, ie I'd have expected you to have to do 12-13 bisection attempts 
to cut it down to one.

You seem to have done 14 (you list 16 commits, two of which are the 
starting points), which is right in that range. The reason you sometimes 
get more is:

 - you "help" git bisect by choosing other commits than the optimal ones. 

 - with bad luck, it can be hard to get really close to "half the commits" 
   in the reachability analysis, especially if you have lots of merges 
   (and *especially* if you have octopus merges that merge more than two 
   branches of development). For example, say that you have something like

	           a
	           |
	   +---+---+---+---+
	   |   |   |   |   |
	   b   c   d   e   f

   where you have six commits - you can't test any "combinations" at all, 
   since they are all independent, so "git bisect" cannot test them three 
   and three to cut down the time, so if you don't know which one is bad, 
   you'll basically end up testing them all.

The bad luck case never really happens to that extreme in practice, and 
even when it does you can sometimes be lucky and just hit on the bug early 
(so "bad luck" may end up being "good luck" after all), but it explains 
why you can get more - or less - than log2(n)+1 attempts. More commonly 
one more.

A much *bigger* problem is if you mark something good or bad that isn't 
really. Ie if the bug comes and goes (it might be timing-dependent, for 
example), the problem will be that you'll always narrow things down 
(that's what bisection does), but you may not narrow it down to the right 
thing!

We've had that happen several times. If the bug (for example) means that 
suspend *often* breaks, but sometimes works just by luck, you might mark a 
kernel "good" when it really wasn't and then "git bisect" will *really* go 
out in the weeds, and won't even try to test the commits that may have 
introduced the bug, because you told it that those commits resulted in a 
good kernel..

>  commit 01363220f5d23ef68276db8974e46a502e43d01d: bad
>  commit 255f0385c8e0d6b9005c0e09fffb5bd852f3b506: bad
>  commit c0cd79d11412969b6b8fa1624cdc1277db82e2fe: bad
>  commit c24e912b61b1ab2301c59777134194066b06465c: good
>  commit e9e2cdb412412326c4827fc78ba27f410d837e6e: bad
>  commit 79bf2bb335b85db25d27421c798595a2fa2a0e82: bad
>  commit fc955f670c0a66aca965605dae797e747b2bef7d: good
>  commit 70c0846e430881967776582e13aefb81407919f1: good
>  commit 414f827c46973ba39320cfb43feb55a0eeb9b4e8: bad
>  commit f3ccb06f3b8e0cf42b579db21f3ca7f17fcc3f38: good
>  commit 5f0b1437e0708772b6fecae5900c01c3b5f9b512: bad
>  commit b878ca5d37953ad1c4578b225a13a3c3e7e743b7: bad
>  commit c2902c8ae06762d941fab64198467f78cab6f8cd: bad
>  commit 12e74f7d430655f541b85018ea62bcd669094bd7: bad
>  commit 3388c37e04ec0e35ebc1b4c732fdefc9ea938f3b: bad
>  commit 9f4bd5dde81b5cb94e4f52f2f05825aa0422f1ff: bad

Looks like it's claiming that 9f4bd5dde81b5cb94e4f52f2f05825aa0422f1ff is 
the bad commit. Which is extremely unlikely, since it only seems to affect 
the emu10k sound driver, which I don't think even exists on any ThinkPad 
laptops (correct me if I'm wrong). 

Btw, you seem to have re-ordered the commits - the above is not the order 
you did the bisection in. The known-good commit (f3ccb06..) is in the 
middle. That's totally bogus. Please use the git bisection log (see 
.git/BISECT_LOG), and don't think that you know some "better" order. You 
really don't.

> the results are totally reproducible (i re-tried a few of both the good 
> and the bad commits), i.e. it's not a sporadic condition. Also, a number 
> of the 'bad' commits have no dynticks stuff in them at all, so i'd 
> exclude dynticks.
> 
> could someone suggest a sane way to go with this? Perhaps suggest 
> specific commit IDs to test?

You claim that 9f4bd5dd is bad, but you indirectly claim that its direct 
parent (5986a2ec) is good by saying that f3ccb06f is good. This is why 
"git bisect" will claim that 9f4bd5dd must be the bad commit.

I would suggest testing commit 5986a2ec explicitly. If that one is good, 
then, since you claim that 9f4bd5dd is bad, then yes, 9f4bd5dd *is* the 
bad commit (because 5986a2ec is its direct parent).

But most likely, 9f4bd5dd is actually already bad, and what you are seeing 
is two *different* bugs that just have the same symptoms ("suspend doesn't 
work").

What happens is that you've chased them *both*, and you cannot bisect that 
kind of behaviour totally automatically and mindlessly, simply because 
when you say "git bisect bad", that means that *one* of the bugs is 
active, but not necessarily both of them. So you may well be marking 
kernels that are "good" (as far as the other bug is concerned) as bad - 
and that just means that bisection won't even test them.

When that happens, you need to basically

 - be able to separate the bugs out some way (so that you can still mark a 
   non-working kernel "good" if it's good *with*respect*to* the particular 
   bug you're chasing)

   This is often practically impossible, _especially_ with suspend, where 
   the behaviour is so unhelpful that it's usually not possible to 
   separate out "ACPI is broken" from "one particular device driver is 
   broken", because they both have exactly the same symptoms: the machine 
   doesn't resume.

HOWEVER. Even if you can't actually separate the bugs out, you can usually 
find where *one* of the bugs starts, and that point you can generally find 
the fix for it too. In this case, we already know one of the bugs: it's 
the ACPI bug that was apparently fixed by f3ccb06f3 (or maybe another one 
in that series).

Once you have that, you now actually have a way to "correct" for that 
known bug, and by correcting for the known bug, you now *can* separate the 
behaviour of the two bugs:

 - You can now re-do a totally mindless git bisection for the *other* bug, 
   but what you now need to do is that at each bisection step, you look at 
   whether the bisection point has the known bug, and if so, you apply the 
   known fix for that known bug, and thus you can test the kernel 
   *without* the interaction of the bug you already found.

This makes bisection a lot less automated (you have to apply the "fix" for 
the other bug at each step), but it still allows "total automation" in the 
sense that you don't actually need to know at all what you're looking for: 
you're just following a known pattern, and you're basically just 
correcting for the effects of another bug that you're no longer interested 
in, since you already know what the fix for that bug was.

The other alternative is to actually have a clue what you're searching 
for, and/or look deeply at where the fix was merged, and trying to narrow 
things down by actually understanding the problem. But at that point, 
bisection won't much help you, except perhaps as a way to find a mid-way 
point to test out theories with ("which drivers that I actually use have 
changed in between" kinds of experiments where you simply undo part of 
the changes entirely, and bisection ends up being just a way to pick 
points that are hopefully "interestingly far apart").

			Linus
