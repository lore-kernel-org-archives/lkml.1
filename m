Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZLRPlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZLRPlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZLRPlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:41:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZLRPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:41:34 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>
	 <alpine.LFD.2.00.0912180724580.3712@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 16:39:48 +0100
Message-ID: <1261150788.20899.299.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 07:30 -0800, Linus Torvalds wrote:
> 
> On Fri, 18 Dec 2009, Peter Zijlstra wrote:
> 
> > >    r1. The first design goal of cmwq is solving the issues the current
> > >        workqueue implementation has including hard to detect
> > >        deadlocks, 
> > 
> > lockdep is quite proficient at finding these these days.
> 
> I don't think so.
> 
> The reason it is not is that workqueues fundamentally do _different_ 
> things in the same context, adn lockdep has no clue what-so-ever.
> 
> IOW, if you hold a lock, and then do 'flush_workqueue()', lockdep has no 
> idea that maybe one of the entries on a workqueue might need the lock that 
> you are holding. But I don't think lockdep sees the dependency that gets 
> created by the flush - because it's not a direct code execution 
> dependency.
> 
> It's not a deadlock _directly_ due to lock ordering, but indirectly due to 
> waiting for unrelated code that needs locks.
> 
> Now, maybe lockdep could be _taught_ to consider workqueues themselves to 
> be 'locks', and ordering those pseudo-locks wrt the real locks they take. 
> So if workqueue Q takes lock A, the fact that it is _taken_ in a workqueue 
> makes the ordering be Q->A. Then, if somebody does a "flush_workqueue" 
> while holding lock B, the flush implies a "lock ordering" of B->Q (where 
> "Q" is the set of all workqueues that could be flushed).

That's exactly what it does..

4e6045f134784f4b158b3c0f7a282b04bd816887
eb13ba873881abd5e15af784756a61af635e665e
a67da70dc0955580665f5444f318b92e69a3c272




