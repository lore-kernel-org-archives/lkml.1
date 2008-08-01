Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYHAUIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYHAUIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYHAUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:08:43 -0400
Received: from gw.goop.org ([64.81.55.164]:58468 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873AbYHAUIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:08:42 -0400
Message-ID: <48936D45.2030500@goop.org>
Date: Fri, 01 Aug 2008 13:08:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's subclass
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins> <489350AE.1030609@goop.org> <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org> <48935FA4.5010804@goop.org> <alpine.LFD.1.10.0808011216360.3277@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808011216360.3277@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Hmm. 
>
> With hashed locks, that is _not_ safe in general. Now, it may well be safe 
> in your case, so I'm not going to say you have a bug, but even if you do 
> them in vaddr order, the thing is, we don't guarantee that the _locks_ are 
> ordered in virtual address order.
>   

Yes, it's current simplicity definitely relies on a simple relationship 
between pte pages and locks.

> Right now, I think the pte locks are either a single one per mm (in which 
> case I assume you don't take any lock at all), or it's a lock that is 
> embedded in the pmd page iirc.
>   

Actually the locks in the pte page, so it's already fairly 
fine-grained.  If it were made coarser - at the pmd level - then I'd 
simply move my lock-taking out a level in the pagetable traversal.

But making it finer - by hashing individual pte entries to their own 
locks - would work badly for me.  I'm taking the lock specifically to 
protect against updates to any pte within the pte page, so I'd have to 
manually take all the locks that the ptes could possibly hash to.  
Presumably in that eventuality we could define correct order for taking 
the hashed pte locks, independent of how the ptes actually map to them 
(for example, always take locks in low->high order of *lock* address).

> What if you have pmd sharing through some shared area being mapped at two 
> different processes at different addresses? Yeah, I don't think we share 
> pmd's at all (except if you use hugetables and for the kernel), but it's 
> one of those things where subtle changes in how the pte lock allocation 
> could cause problems.
>   

In this particular case it isn't an issue.  The traversal is performing 
first/last use init/deinit, so any shared parts of the pagetable can be 
skipped with no action because they're already done.  Presumably there'd 
be separate lifetime management for whatever parts of the pagetable can 
be shared, so I'd need to hook in there, rather than the wholesale 
pagetable create/destroy as I do now.

> Eg, I could easily see somebody doing the pte lock as a hash over not just 
> the address, but the "struct mm" pointer too. At which point different 
> parts of the address space might even share the PTE lock, and you'd get 
> deadlocks even without any ABBA behavior, just because the pte lock might 
> be A B C A or something inside the same process.
>   

Yep.  That would be awkward.  A function which says "here's a pte page, 
return the set of all pte locks these ptes map to in correct locking 
order" would be useful in that case.  Ugh, but still unpleasant.

    J
