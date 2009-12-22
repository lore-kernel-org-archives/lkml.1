Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZLVSbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZLVSbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 13:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZLVSbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 13:31:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbZLVSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 13:31:11 -0500
Date: Tue, 22 Dec 2009 10:28:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
In-Reply-To: <1261504042.4937.59.camel@laptop>
Message-ID: <alpine.LFD.2.00.0912221004540.6879@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>  <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>   <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>   <4B2F57E6.7020504@linux.intel.com>
 <4B2F768C.1040704@kernel.org>   <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>   <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>  <1261480220.4937.24.camel@laptop>  <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
 <1261504042.4937.59.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Dec 2009, Peter Zijlstra wrote:
> 
> Which in turn would imply we cannot carry fwd the current lockdep
> annotations, right?
> 
> Which means we'll be stuck in a situation where A flushes B and B
> flushes A will go undetected until we actually hit it.

No, lockdep should still work. It just means that waiting for an 
individual work should be seen as a matter of only waiting for the locks 
that work itself has done - rather than waiting for all the locks that any 
worker has taken.

And the way the workqueue lockdep stuff is done, I'd assume this just 
automatically fixes itself when rewritten.

> Where exactly does the tty thing live in the code?

I think I worked around it all, but I cursed the workqueues while I did 
it. The locking problem is tty->ldisc_mutex vs flushing the ldisc buffers. 
The flushing itself doesn't even care about the ldisc_mutex, but if it 
happens to be behind a the hangup work - which does care about that mutex 
- you still can't wait for it.

Happily, it turns out that you can synchronously _cancel_ the damn thing 
despite this problem, because the cancel can take it off the list if it is 
waiting for something else (eg another workqueue entry in front of it), 
and if it's actively running we know that it's not blocked waiting for 
that hangup work that needs the lock, so for that particular case we can 
even wait for it to finish running - even if we couldn't do that in 
general.

And I 
