Return-Path: <linux-kernel-owner+w=401wt.eu-S1762382AbXELBZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762382AbXELBZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbXELBY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:24:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015AbXELBY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:24:57 -0400
Date: Fri, 11 May 2007 18:24:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
In-Reply-To: <20070512004057.GA540@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0705111812270.3986@woody.linux-foundation.org>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl>
 <20070511123959.190adfaf.akpm@linux-foundation.org> <200705112240.54304.rjw@sisk.pl>
 <alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
 <20070511232024.GA489@tv-sign.ru> <alpine.LFD.0.98.0705111629390.3986@woody.linux-foundation.org>
 <20070511234819.GA508@tv-sign.ru> <alpine.LFD.0.98.0705111656240.3986@woody.linux-foundation.org>
 <20070512004057.GA540@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 May 2007, Oleg Nesterov wrote:
> 
> However, in my opininon THAT PATCH has nothing to do with this problem.
> It just improves the code that we already have.

Sure. 

However, I think it does it THE WRONG WAY, and doesn't actually fix the 
much deeper problems with the freezer, as shown by the fact that the lock 
is *still* broken for other cases.

So, here's a summary:

 - we should not take the lock inside the function, because taking it 
   there is fundamentally wrong, and leaves all the *other* races in 
   place.

 - if you actually want to solve the other races, the lock needs to be 
   taken by the caller, in which case taking it in the callee is obviously 
   (again) wrong.

 - or then, we accept that the race wasn't fixed AT ALL, and you add other 
   code to _other_ places to handle the case where you froze the wrong 
   thread (or didn't freeze the right one).

   And I'm not making that up. Look at most of the other patches in that 
   series: they are _exactly_ about the scenario I'm outlining.

 - the whole "kernel thread vs user thread" thing is the wrong thing to 
   check in the first place, since we just should never touch kernel 
   threads in the first place, and anything that wants to freeze user 
   space should have disabled exec_usermodehelper() at a higher level

That's why I'm so unhappy. The "fix" is going in the wrong direction. Each 
fix on their own may be an "improvement", but the end result of many of 
the fixes is a total mess!

We can continue to add bandaids to something broken, until it "works". But 
the end result, while "working", is not actually any better. Quite the 
reverse - the end result of something like that is that you add all these 
magic rules and special cases.

So in the end one ugly design decision leads to broken locking, which in 
turn leads to other cases where you add more broken code, which just leads 
to a situation where nobody actually understands what the *design* is, 
because there simply *isn't* any design - it's just a hodge-podge of "but 
this fixes a bug" ad-hoc "fixes".

			Linus
