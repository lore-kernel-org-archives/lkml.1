Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZAOAu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZAOAu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZAOAur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:50:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:42977 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbZAOAup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:50:45 -0500
Date: Thu, 15 Jan 2009 01:50:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Message-ID: <20090115005042.GC32044@wotan.suse.de>
References: <1231774622.4371.96.camel@laptop> <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop> <496B7EBC.6020208@redhat.com> <1231951599.14825.18.camel@laptop> <20090114170445.GA18964@wotan.suse.de> <496E1F80.20009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E1F80.20009@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 07:23:12PM +0200, Avi Kivity wrote:
> Nick Piggin wrote:
> >>(no they're not, Nick's ticket locks still spin on a shared cacheline
> >>IIRC -- the MCS locks mentioned could fix this)
> >>    
> >
> >It reminds me. I wrote a basic variation of MCS spinlocks a while back. And
> >converted dcache lock to use it, which showed large dbench improvements on
> >a big machine (of course for different reasons than the dbench improvements
> >in this threaed).
> >
> >http://lkml.org/lkml/2008/8/28/24
> >
> >Each "lock" object is sane in size because given set of spin-local queues 
> >may
> >only be used once per lock stack. But any spinlocks within a mutex 
> >acquisition
> >will always be at the bottom of such a stack anyway, by definition.
> >
> >If you can use any code or concept for your code, that would be great.
> >  
> 
> Does it make sense to replace 'nest' with a per-cpu counter that's 
> incremented on each lock?  I guest you'd have to search for the value of 
> nest on unlock, but it would a very short search (typically length 1, 2 
> if lock sorting is used to avoid deadlocks).
> 
> I think you'd need to make the lock store the actual node pointer, not 
> the cpu number, since the values of nest would be different on each cpu.
> 
> That would allow you to replace spinlocks with mcs_locks wholesale.

nest could get quite large (and basically is unbounded), though. I
think there would definitely be variations (NMCS locks is interesting).
But OTOH I think that for _most_ spinlocks, optimising for spinning
case is wrong. For some really tricky global spinlocks, yes I think
MCS is a good idea. But moreso as a stopgap until hopefully more
scalable algorithms are written.

