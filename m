Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbXELI5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbXELI5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 04:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXELI45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 04:56:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXELI44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 04:56:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 11:01:39 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <20070512004057.GA540@tv-sign.ru> <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121101.40795.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 03:24, Linus Torvalds wrote:
> 
> On Sat, 12 May 2007, Oleg Nesterov wrote:
> > 
> > However, in my opininon THAT PATCH has nothing to do with this problem.
> > It just improves the code that we already have.
> 
> Sure. 
> 
> However, I think it does it THE WRONG WAY, and doesn't actually fix the 
> much deeper problems with the freezer, as shown by the fact that the lock 
> is *still* broken for other cases.

The other cases don't lead to the specific issue this patch is meant to
prevent.  Namely, that if a kernel thread is identified as a user space task by
the freezer it may be frozen prematurely.

And yes, this only is a problem because we freeze kernel threads, which may be
avoidable, but we've been doing that for more than two years and it's a big
change to stop doing so.  We can't just say overnight that we won't be freezing
kernel threads from now on without al least checking if that doesn't lead to
user-visible problems.

Thus IMO it's reasonable to fix the potential issue with the current code and
think about changing the design *later*.  Still, I'm not so attached to this
patch and if you think that it should be dropped (which IMO is wrong), then so
be it.

That said:

> So, here's a summary:
> 
>  - we should not take the lock inside the function, because taking it 
>    there is fundamentally wrong, and leaves all the *other* races in 
>    place.

The other races don't lead to the same (wrong) result.

>  - if you actually want to solve the other races, the lock needs to be 
>    taken by the caller, in which case taking it in the callee is obviously 
>    (again) wrong.
> 
>  - or then, we accept that the race wasn't fixed AT ALL, and you add other 
>    code to _other_ places to handle the case where you froze the wrong 
>    thread (or didn't freeze the right one).

There are no other cases, AFAICS, in which we can freeze a wrong thead.
That's, in fact, the point here.  The not freezing of the right one (when a
kernel thread does execve() and becomes a user land process) is a totally
separate issue unrelated to this patch.

>    And I'm not making that up. Look at most of the other patches in that 
>    series: they are _exactly_ about the scenario I'm outlining.
> 
>  - the whole "kernel thread vs user thread" thing is the wrong thing to 
>    check in the first place, since we just should never touch kernel 
>    threads in the first place, and anything that wants to freeze user 
>    space should have disabled exec_usermodehelper() at a higher level

Very well, but then, how are we supposed to know which is a kernel thread so
that we won't touch it?

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

You have already said for several times that in your opinion kernel threads
should not be frozen (for suspend, but I'm not sure about the CPU hotplug).
As far as I'm concerned, that's sufficient.  However, the reality is that we do
freeze kernel threads and we can't just stop doing that overnight.  At least,
we need to check what problems that will lead to before we decide to do this in
a stable kernel.

Greetings,
Rafael
