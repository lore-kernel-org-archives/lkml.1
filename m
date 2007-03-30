Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbXC3Bxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbXC3Bxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 21:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXC3Bxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 21:53:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:39314 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbXC3Bxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 21:53:37 -0400
Date: Fri, 30 Mar 2007 03:53:21 +0200
From: Nick Piggin <npiggin@suse.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, Ingo Molnar <mingo@elte.hu>,
       Nikita Danilov <nikita@clusterfs.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] queued spinlocks (i386)
Message-ID: <20070330015321.GB19407@wotan.suse.de>
References: <20070325155407.GA497@tv-sign.ru> <20070328070459.GC12508@wotan.suse.de> <20070329184213.GA83@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329184213.GA83@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 10:42:13PM +0400, Oleg Nesterov wrote:
> On 03/28, Nick Piggin wrote:
> >
> > Well with my queued spinlocks, all that lockbreak stuff can just come out
> > of the spin_lock, break_lock out of the spinlock structure, and
> > need_lockbreak just becomes (lock->qhead - lock->qtail > 1).
> 
> Q: queued spinlocks are not CONFIG_PREEMPT friendly,

I consider the re-enabling of preemption and interrupts to be a hack
anyway. Because if you already have interrupts or preemption disabled
at entry time, they will remain disabled.

IMO the real solution is to ensure spinlock critical sections don't get
too large, and perhaps use fair spinlocks to prevent starvation.

> 
> > +       asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
> > +                    : "+r" (pos), "+m" (lock->qhead) : : "memory");
> > +       while (unlikely(pos != lock->qtail))
> > +               cpu_relax();
> 
> once we incremented lock->qhead, we have no optiion but should spin with
> preemption disabled until pos == lock->qtail, yes?

Correct. For the purposes of deadlock behaviour, we have effectively
taken the lock at that point.
