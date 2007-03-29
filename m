Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbXC2Bgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbXC2Bgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965865AbXC2Bgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:36:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:58334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965815AbXC2Bgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:36:53 -0400
Date: Thu, 29 Mar 2007 03:36:52 +0200
From: Nick Piggin <npiggin@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nikita Danilov <nikita@clusterfs.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070329013652.GB2390@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu> <20070323103243.GE11577@wotan.suse.de> <17925.18904.820106.145029@gargle.gargle.HOWL> <20070324172959.GB542@elte.hu> <20070328064318.GA12508@wotan.suse.de> <Pine.LNX.4.64.0703281224030.21150@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703281452130.21150@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703281452130.21150@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 03:00:21PM -0700, Davide Libenzi wrote:
> On Wed, 28 Mar 2007, Davide Libenzi wrote:
> 
> > The method you propose is otherwise called "Ticket Lock":
> > 
> > http://en.wikipedia.org/wiki/Ticket_lock
> > http://www.cs.rochester.edu/research/synchronization/pseudocode/ss.html#ticket
> 
> That this work prio-art dates to 1991:
> 
> http://www.cs.rochester.edu/u/scott/papers/1991_TOCS_synch.pdf
> 
> So I would not worry to much about patents here. At least W2K MS ones ;)
> What I would worry though, is to add another class of locks. There's no 

No, as you see from my patch I just change the spinlock implementation
to a queued one. I agree it doesn't make sense to add a new type of lock.


> reason why Ticket Locks would perform worse than our spinlock, in both 
> contended and not-contended case, AFAICS. And they have a nice FIFO 
> behaviour.

In most cases, no. For the uncontended case they should be about the
same. They have the same spinning behaviour. However there is a little
window where they might be a bit slower I think... actually perhaps I'm
wrong!

Currently if you have 4 CPUs spinning and the lock is released, all 4
CPU cachelines will be invalidated, then they will be loaded again, and
found to be 0, so they all try to atomic_dec_return the counter, each
one invalidating others' cachelines. 1 gets through.

With my queued locks, all 4 cachelines are invalidated and loaded, but
only one will be allowed to proceed, and there are 0 atomic operations
or stores of any kind.

So I take that back: our current spinlocks have a worse thundering herd
behaviour under contention than my queued ones. So I'll definitely
push the patch through.
