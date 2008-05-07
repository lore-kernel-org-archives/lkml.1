Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbYEGRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbYEGRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYEGRJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:09:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657AbYEGRJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:09:09 -0400
Date: Wed, 7 May 2008 10:08:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org>
 <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Linus Torvalds wrote:
>
> Which, btw, is probably true. The BKL is normally held for short times, 
> and released (by that thread) for relatively much longer times. Which 
> is when spinlocks tend to work the best, even when they are fair (because 
> it's not so much a fairness issue, it's simply a cost-of-taking-the-lock 
> issue!)

.. and don't get me wrong: the old semaphores (and the new mutexes) should 
also have this property when lucky: taking the lock is often a hot-path 
case.

And the spinlock+generic semaphore thing probably makes that "lucky" 
behavior be exponentially less likely, because now to hit the lucky case, 
rather than the hot path having just *one* access to the interesting cache 
line, it has basically something like 4 accesses (spinlock, count test, 
count decrement, spinunlock), in addition to various serializing 
instructions, so I suspect it quite often gets serialized simply because 
even the "fast path" is actually about ten times as long!

As a result, a slow "fast path" means that the thing gets saturated much 
more easily, and that in turn means that the "fast path" turns into a 
"slow path" more easily, which is how you end up in the scheduler rather 
than just taking the fast path.

This is why sleeping locks are more expensive in general: they have a 
*huge* cost from when they get contended. Hundreds of times higher than a 
spinlock. And the faster they are, the longer it takes for them to get 
contended under load. So slowing them down in the fast path is a double 
whammy, in that it shows their bad behaviour much earlier.

And the generic semaphores really are slower than the old optimized ones 
in that fast path. By a *big* amount.

Which is why I'm 100% convinced it's not even worth saving the old code. 
It needs to use mutexes, or spinlocks. I bet it has *nothing* to do with 
"slow path" other than the fact that it gets to that slow path much more 
these days.

			Linus
