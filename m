Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZAIPHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZAIPHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZAIPHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:07:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:49922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbZAIPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:07:16 -0500
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <1231498062.11687.608.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
	 <1231498062.11687.608.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Jan 2009 16:06:54 +0100
Message-Id: <1231513614.442.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 11:47 +0100, Peter Zijlstra wrote:

> > So I think the bug is still there, we just hid it better by breaking out 
> > of the loop with that "if (need_resched())" always eventually triggering. 
> > And it would be ok if it really is guaranteed to _eventually_ trigger, and 
> > I guess with timeslices it eventually always will, but I suspect we could 
> > have some serious latency spikes.
> 
> Yes, the owner getting preempted after acquiring the lock, but before
> setting the owner can give some nasties :-(
> 
> I initially did that preempt_disable/enable around the fast path, but I
> agree that slowing down the fast path is unwelcome.
> 
> Alternatively we could go back to block on !owner, with the added
> complexity of not breaking out of the spin on lock->owner != owner
> when !lock->owner, so that the premature owner clearing of the unlock
> fast path will not force a schedule right before we get a chance to
> acquire the lock.
> 
> Let me do that..

Ok a few observations..

Adding that need_resched() in the outer loop utterly destroys the
performance gain for PREEMPT=y. Voluntary preemption is mostly good, but
somewhat unstable results.

Adding that blocking on !owner utterly destroys everything.

Going to look into where that extra preemption comes from.
