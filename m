Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZAIPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZAIPM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZAIPMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:12:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:49808 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZAIPMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:12:45 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Chris Mason <chris.mason@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <1231513614.442.11.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
	 <1231498062.11687.608.camel@twins>  <1231513614.442.11.camel@twins>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 10:11:50 -0500
Message-Id: <1231513910.21333.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49676942.011C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 16:06 +0100, Peter Zijlstra wrote:
> On Fri, 2009-01-09 at 11:47 +0100, Peter Zijlstra wrote:
> 
> > > So I think the bug is still there, we just hid it better by breaking out 
> > > of the loop with that "if (need_resched())" always eventually triggering. 
> > > And it would be ok if it really is guaranteed to _eventually_ trigger, and 
> > > I guess with timeslices it eventually always will, but I suspect we could 
> > > have some serious latency spikes.
> > 
> > Yes, the owner getting preempted after acquiring the lock, but before
> > setting the owner can give some nasties :-(
> > 
> > I initially did that preempt_disable/enable around the fast path, but I
> > agree that slowing down the fast path is unwelcome.
> > 
> > Alternatively we could go back to block on !owner, with the added
> > complexity of not breaking out of the spin on lock->owner != owner
> > when !lock->owner, so that the premature owner clearing of the unlock
> > fast path will not force a schedule right before we get a chance to
> > acquire the lock.
> > 
> > Let me do that..
> 
> Ok a few observations..
> 
> Adding that need_resched() in the outer loop utterly destroys the
> performance gain for PREEMPT=y. Voluntary preemption is mostly good, but
> somewhat unstable results.

How about if (!owner && need_resched()) break; instead of the
unconditional need_resched().  That should solve the race that Linus saw
without and hurt PREEMPT less.

> 
> Adding that blocking on !owner utterly destroys everything.
> 
> Going to look into where that extra preemption comes from.

-chris


