Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZAMQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZAMQWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZAMQWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:22:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZAMQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:22:20 -0500
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 17:21:50 +0100
Message-Id: <1231863710.7141.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 08:16 -0800, Linus Torvalds wrote:
> 
> On Tue, 13 Jan 2009, Peter Zijlstra wrote:
> > 
> > Change mutex contention behaviour such that it will sometimes busy wait on
> > acquisition - moving its behaviour closer to that of spinlocks.
> 
> Okey, dokey. Looks reasonable, but I wonder if this part came from v8 and 
> wasn't intentional:
> 
> > +		if (atomic_xchg(&lock->count, -1) == 1) {
> > +			lock_acquired(&lock->dep_map, ip);
> > +			mutex_set_owner(lock);
> > +			preempt_enable();
> > +			return 0;
> > +		}
> 
> Now you're forcing the slow-path on unlock. Maybe it was intentional, 
> maybe it wasn't. Did you perhaps mean
> 
> 	if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
> 
> here? I thought we agreed it was safe, if only because it should be 
> equivalent to just having done "mutex_trylock()" instead of a "real" lock 
> sequence.

Yes, that was an 'accident' from -v8, yes we did think the cmpxchg was
good, however I did get some spurious lockups on -v7, and I only noticed
the thing after I'd done most of the testing, so I decided to let it be
for now.

Let me put the cmpxchg back in and see if this is all still good (only
3*2*2 configs to test :-).
