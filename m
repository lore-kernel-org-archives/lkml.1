Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbXELRoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbXELRoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXELRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:43:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:56404 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbXELRn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:43:57 -0400
Date: Sat, 12 May 2007 21:43:55 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512174355.GA304@tv-sign.ru>
References: <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl> <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org> <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org> <20070511234819.GA508@tv-sign.ru> <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org> <20070512004057.GA540@tv-sign.ru> <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess I should just shut up and listen to experts... ok, just my
0.02 roubles.

Again, I can't comment things like "we just should never touch kernel",
because I don't even remotely undestand the things which actually use
freezer. I can only talk about the current implementation of freezer.

On 05/11, Linus Torvalds wrote:
> 
> So, here's a summary:
> 
>  - we should not take the lock inside the function, because taking it 
>    there is fundamentally wrong, and leaves all the *other* races in 
>    place.
> 
>  - if you actually want to solve the other races, the lock needs to be 
>    taken by the caller, in which case taking it in the callee is obviously 
>    (again) wrong.
> 
>  - or then, we accept that the race wasn't fixed AT ALL, and you add other 
>    code to _other_ places to handle the case where you froze the wrong 
>    thread (or didn't freeze the right one).
> 
>    And I'm not making that up. Look at most of the other patches in that 
>    series: they are _exactly_ about the scenario I'm outlining.
> 
>  - the whole "kernel thread vs user thread" thing is the wrong thing to 
>    check in the first place, since we just should never touch kernel 
>    threads in the first place, and anything that wants to freeze user 
>    space should have disabled exec_usermodehelper() at a higher level
>
> That's why I'm so unhappy. The "fix" is going in the wrong direction. Each 
> fix on their own may be an "improvement", but the end result of many of 
> the fixes is a total mess!
> 
> We can continue to add bandaids to something broken, until it "works". But 
> the end result, while "working", is not actually any better. Quite the 
> reverse - the end result of something like that is that you add all these 
> magic rules and special cases.
> 
> So in the end one ugly design decision leads to broken locking, which in 
> turn leads to other cases where you add more broken code, which just leads 
> to a situation where nobody actually understands what the *design* is, 
> because there simply *isn't* any design - it's just a hodge-podge of "but 
> this fixes a bug" ad-hoc "fixes".

Yes, the current design has many limitations. The major problem is that it
can't solve the dependencies: say T1 is frozen, and T2 can't be freezed
because it waits for T1. And I don't see how we can solve this problem
in general. And this is imho the source of most uglifications.

Let's look at the code. try_to_freeze_tasks() which can choose between
user/kernel threads is static. The exported freeze_processes() freeze
all of them. So why do we need is_user_space() at all? I am not sure
I know the right answer, but I think this was done to prevent the case
when user-space needs some kthread to make a progress and notice the
signal (TIF_FREEZE).

So yes, this is ugly, and is_user_space() is not reliable, and most
fixes are "let's fix this particular case", and each fix doesn't make
the code prettier.

But, on the other hand, the freezer is very simple and not intrusive.
When I first looked at the code 2 months ago, I thought we should do
something better. Since then, I have no ideas how to do this.

Oleg.

