Return-Path: <linux-kernel-owner+w=401wt.eu-S1761789AbYEGRr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761789AbYEGRr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYEGRrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:47:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbYEGRrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:47:43 -0400
Date: Wed, 7 May 2008 10:47:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805071032280.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org>
 <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Linus Torvalds wrote:
> 
> All the "normal" mutex code use fine-grained locking, so even if you slow 
> down the fast path, that won't cause the same kind of fastpath->slowpath 
> increase.

Put another way: let's say that the "good fastpath" is basically a single 
locked instruction - ~12 cycles on AMD, ~35 Core 2. That's the 
no-bouncing, no-contention case.

Doing it with debugging (call overhead, spinlocks, local irq saving rtc) 
will probably easily triple it or more, but we're not changing anything 
else. There's no "downstream" effect: the behaviour itself doesn't change. 
It doesn't get more bouncing, it doesn't start sleeping.

But what happens if the lock has the *potential* for conflicts is 
different.

There, a "longish pause + fast lock + short average code sequece + fast 
unlock" is quite likely to stay uncontended for a fair amount of time, and 
while it will be much slower than the no-contention-at-all case (because 
you do get a pretty likely cacheline event at the "fast lock" part), with 
a fairly low number of CPU's and a long enough pause, you *also* easily 
get into a pattern where the thing that got the lock will likely also get 
to unlock without dropping the cacheline.

So far so good.

But that basically depends on the fact that "lock + work + unlock" is 
_much_ shorter than the "longish pause" in between, so that even if you 
have <n> CPU's all doing the same thing, their pauses between the locked 
section are still bigger than <n> times that short time.

Once that is no longer true, you now start to bounce both at the lock 
*and* the unlock, and now that whole sequence got likely ten times slower. 
*AND* because it now actually has real contention, it actually got even 
worse: if the lock is a sleeping one, you get *another* order of magnitude 
just because you now started doing scheduling overhead too!

So the thing is, it just breaks down very badly. A spinlock that gets 
contention probably gets ten times slower due to bouncing the cacheline. A 
semaphore that gets contention probably gets a *hundred* times slower, or 
more.

And so my bet is that both the old and the new semaphores had the same bad 
break-down situation, but the new semaphores just are a lot easier to 
trigger it because they are at least three times costlier than the old 
ones, so you just hit the bad behaviour with much lower loads (or fewer 
number of CPU's).

But spinlocks really do behave much better when contended, because at 
least they don't get the even bigger hit of also hitting the scheduler. So 
the old semaphores would have behaved badly too *eventually*, they just 
needed a more extreme case to show that bad behavior.

		Linus
