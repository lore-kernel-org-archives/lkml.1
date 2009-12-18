Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZLRPeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZLRPeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZLRPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:34:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502AbZLRPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:34:18 -0500
Date: Fri, 18 Dec 2009 07:30:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
In-Reply-To: <1261143924.20899.169.camel@laptop>
Message-ID: <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Peter Zijlstra wrote:

> >    r1. The first design goal of cmwq is solving the issues the current
> >        workqueue implementation has including hard to detect
> >        deadlocks, 
> 
> lockdep is quite proficient at finding these these days.

I don't think so.

The reason it is not is that workqueues fundamentally do _different_ 
things in the same context, adn lockdep has no clue what-so-ever.

IOW, if you hold a lock, and then do 'flush_workqueue()', lockdep has no 
idea that maybe one of the entries on a workqueue might need the lock that 
you are holding. But I don't think lockdep sees the dependency that gets 
created by the flush - because it's not a direct code execution 
dependency.

It's not a deadlock _directly_ due to lock ordering, but indirectly due to 
waiting for unrelated code that needs locks.

Now, maybe lockdep could be _taught_ to consider workqueues themselves to 
be 'locks', and ordering those pseudo-locks wrt the real locks they take. 
So if workqueue Q takes lock A, the fact that it is _taken_ in a workqueue 
makes the ordering be Q->A. Then, if somebody does a "flush_workqueue" 
while holding lock B, the flush implies a "lock ordering" of B->Q (where 
"Q" is the set of all workqueues that could be flushed).

		Linus
