Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYH3LIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYH3LIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 07:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYH3LIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 07:08:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYH3LIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 07:08:31 -0400
Subject: Re: [PATCH] seqlock: serialize against writers
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
In-Reply-To: <20080829154237.1196.66825.stgit@dev.haskins.net>
References: <20080829154237.1196.66825.stgit@dev.haskins.net>
Content-Type: text/plain
Date: Sat, 30 Aug 2008 13:08:17 +0200
Message-Id: <1220094497.8426.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 11:44 -0400, Gregory Haskins wrote:
> *Patch submitted for inclusion in PREEMPT_RT 26-rt4.  Applies to 2.6.26.3-rt3*
> 
> Hi Ingo, Steven, Thomas,
>   Please consider for -rt4.  This fixes a nasty deadlock on my systems under
>   heavy load.
> 
> -Greg
> 
> ----
> 
> Seqlocks have always advertised that readers do not "block", but this was
> never really true.  Readers have always logically blocked at the head of
> the critical section under contention with writers, regardless of whether
> they were allowed to run code or not.
> 
> Recent changes in this space (88a411c07b6fedcfc97b8dc51ae18540bd2beda0)
> have turned this into a more explicit blocking operation in mainline.
> However, this change highlights a short-coming in -rt because the
> normal seqlock_ts are preemptible.  This means that we can potentially
> deadlock should a reader spin waiting for a write critical-section to end
> while the writer is preempted.

I think the technical term is livelock.

So the problem is that the write side gets preempted, and the read side
spins in a non-preemptive fashion?

Looking at the code, __read_seqbegin() doesn't disable preemption, so
even while highly inefficient when spinning against a preempted lock, it
shouldn't livelock, since the spinner can get preempted giving the
writer a chance to finish.

> This patch changes the internal implementation to use a rwlock and forces
> the readers to serialize with the writers under contention.  This will
> have the advantage that -rt seqlocks_t will sleep the reader if deadlock
> were imminent, and it will pi-boost the writer to prevent inversion.
> 
> This fixes a deadlock discovered under testing where all high prioritiy
> readers were hogging the cpus and preventing a writer from releasing the
> lock.
> 
> Since seqlocks are designed to be used as rarely-write locks, this should
> not affect the performance in the fast-path

Not quite, seqlocks never suffered the cacheline bounce rwlocks have -
which was they strongest point - so I very much not like this change.

As to the x86_64 gtod-vsyscall, that uses a raw_seqlock_t on -rt, which
is still non-preemptable and should thus not be affected by this
livelock scenario.

