Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbYHAX1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbYHAX1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYHAX1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:27:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbYHAX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:27:31 -0400
Date: Fri, 1 Aug 2008 16:26:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: hugh@veritas.com, jeremy@goop.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's
 subclass
In-Reply-To: <20080801.162013.06459319.davem@davemloft.net>
Message-ID: <alpine.LFD.1.10.0808011623040.6819@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808011113530.3277@nehalem.linux-foundation.org> <48935FA4.5010804@goop.org> <Pine.LNX.4.64.0808012051380.6485@blonde.site> <20080801.162013.06459319.davem@davemloft.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, David Miller wrote:
> 
> Taking more than a few locks of the same class at once is bad
> news and it's better to find an alternative method.

It's not always wrong.

If you can guarantee that anybody that takes more than one lock of a 
particular class will always take a single top-level lock _first_, then 
that's all good. You can obviously screw up and take the same lock _twice_ 
(which will deadlock), but at least you cannot get into ABBA situations.

So maybe the right thing to do is to just teach lockdep about "lock 
protection locks". That would have solved the multi-queue issues for 
networking too - all the actual network drivers would still have taken 
just their single queue lock, but the one case that needs to take all of 
them would have taken a separate top-level lock first.

Never mind that the multi-queue locks were always taken in the same order: 
it's never wrong to just have some top-level serialization, and anybody 
who needs to take <n> locks might as well do <n+1>, because they sure as 
hell aren't going to be on _any_ fastpaths.

So the simplest solution really sounds like just teaching lockdep about 
that one special case. It's not "nesting" exactly, although it's obviously 
related to it.

			Linus
