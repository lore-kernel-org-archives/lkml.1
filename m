Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZK3Rqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZK3Rqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZK3Rqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:46:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52881 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbZK3Rqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:46:51 -0500
Date: Mon, 30 Nov 2009 18:46:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130174638.GA9782@elte.hu>
References: <20091123145409.GA29627@wotan.suse.de>
 <alpine.LFD.2.00.0911280927180.2561@localhost>
 <20091130100041.GA29610@infradead.org>
 <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 30 Nov 2009, Christoph Hellwig wrote:
> > 
> > How long will this use be around?  I've seen some slow progress toward
> > replacing most read side uses of the task list lock with RCU.  While we
> > still have lots of read side users now I wonder when they'll go away.
> 
> tasklist_lock is pretty nasty. I threw out "replace it with RCU" 
> because it would be nice, but the data structures used are not just 
> simple linked lists that we have RCU helpers for traversing.
> 
> There are various real exclusion rules about things like 
> 'tsk->exit_state' etc, which do not translate directly to RCU usage. 
> Of course, _maybe_ all the places that care already take the thing for 
> writing and would just automatically have exclusion anyway.
> 
> So I'd love to see somebody try to do the conversion. To a first 
> approximation, you probably could do
> 
>  - turn tasklist_lock into a spinlock
> 
>  - sed 's/write_lock_irq(&tasklist_lock)/spin_lock(&tasklist_lock)/g'
>    sed 's/write_unlock_irq(&tasklist_lock)/spin_unlock(&tasklist_lock)/g'
> 
>  - sed 's/read_lock(&tasklist_lock)/rcu_read_lock()/g'
>    sed 's/read_unlock(&tasklist_lock)/rcu_read_unlock()/g'
> 
>  - make all the task lists use the RCU versions of the list routines
> 
>  - free the task structure using RCU
> 
> and you'd be _pretty_ close to a working system.

In -rt we've got that in essence, and it's indeed working fine (with a 
few caveats). A few RCU conversions of tasklist_lock usage in that area 
even trickled upstream, because the simple lock would hurt so much under 
-rt.

	Ingo
