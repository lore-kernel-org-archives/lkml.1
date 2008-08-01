Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYHATZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYHATZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYHATZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:25:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbYHATZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:25:43 -0400
Date: Fri, 1 Aug 2008 12:24:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's
 subclass
In-Reply-To: <48935FA4.5010804@goop.org>
Message-ID: <alpine.LFD.1.10.0808011216360.3277@nehalem.linux-foundation.org>
References: <20080731.155504.167792984.davem@davemloft.net>  <20080801.011122.32782916.davem@davemloft.net>  <20080801090100.GA25142@elte.hu>  <20080801.021348.233313767.davem@davemloft.net> <1217588920.9686.6.camel@twins> <489350AE.1030609@goop.org>
 <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org> <48935FA4.5010804@goop.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Jeremy Fitzhardinge wrote:
> 
> I have a function traversing a pagetable in vaddr order (low to high), taking
> pte locks as it builds up batches of pte page updates.  When the batch is
> issued, it releases all the locks, and won't end up holding more than ~16 at a
> time.

Hmm. 

With hashed locks, that is _not_ safe in general. Now, it may well be safe 
in your case, so I'm not going to say you have a bug, but even if you do 
them in vaddr order, the thing is, we don't guarantee that the _locks_ are 
ordered in virtual address order.

Right now, I think the pte locks are either a single one per mm (in which 
case I assume you don't take any lock at all), or it's a lock that is 
embedded in the pmd page iirc.

What if you have pmd sharing through some shared area being mapped at two 
different processes at different addresses? Yeah, I don't think we share 
pmd's at all (except if you use hugetables and for the kernel), but it's 
one of those things where subtle changes in how the pte lock allocation 
could cause problems.

Eg, I could easily see somebody doing the pte lock as a hash over not just 
the address, but the "struct mm" pointer too. At which point different 
parts of the address space might even share the PTE lock, and you'd get 
deadlocks even without any ABBA behavior, just because the pte lock might 
be A B C A or something inside the same process.

			Linus
