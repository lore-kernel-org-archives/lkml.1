Return-Path: <linux-kernel-owner+w=401wt.eu-S937109AbXHIBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937109AbXHIBka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbXHIBkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:40:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:48873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbXHIBkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:40:17 -0400
Date: Thu, 9 Aug 2007 03:40:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86_64: ticket lock spinlock
Message-ID: <20070809014012.GA12539@wotan.suse.de>
References: <20070808042234.GE11018@wotan.suse.de> <20070808042444.GF11018@wotan.suse.de> <20906.1186594318@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20906.1186594318@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 01:31:58PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 08 Aug 2007 06:24:44 +0200, Nick Piggin said:
> 
> > After this, we can no longer spin on any locks with preempt enabled,
> > and cannot reenable interrupts when spinning on an irq safe lock, because
> > at that point we have already taken a ticket and the would deadlock if
> > the same CPU tries to take the lock again.  These are hackish anyway: if
> > the lock happens to be called under a preempt or interrupt disabled section,
> > then it will just have the same latency problems. The real fix is to keep
> > critical sections short, and ensure locks are reasonably fair (which this
> > patch does).
> 
> Any guesstimates how often we do that sort of hackish thing currently, and
> how hard it will be to debug each one?  "Deadlock if the same CPU tries to
> take the lock again" is pretty easy to notice - are there more subtle failure
> modes (larger loops of locks, etc)?

I'll try to explain better:

The old spinlocks re-enable preemption and interrupts while they spin
waiting for a held lock. This was done because people noticed some
long latencies while spinning. The problem however is that preemption
and interrupts can only be re-enabled if they were enabled before the
spin_lock call. So if you have code that perhaps takes nested locks,
or locks while interrupts are already disabled, then you get the latency
problems back.

So the non-hack fix is to keep critical sections short (which is what
we've been working at forever), and to have relatively fair locks
(which is what this patch does).

A side-effect of this patch is that it can no longer enable preemption
or ints while spinning, so my changelog is a rationale of why that
shouldn't be a big problem.


