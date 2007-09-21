Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbXIUS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbXIUS4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbXIUS4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:56:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39463 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760030AbXIUS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:56:32 -0400
Date: Fri, 21 Sep 2007 20:54:14 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070921205414.33d51aae@lappy>
In-Reply-To: <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
References: <46B10BB7.60900@redhat.com>
	<20070803113407.0b04d44e.akpm@linux-foundation.org>
	<20070804084426.GA20464@kobayashi-maru.wspse.de>
	<20070809095943.GA7763@kobayashi-maru.wspse.de>
	<20070809095534.25ae1c42.akpm@linux-foundation.org>
	<46F2E103.8000907@redhat.com>
	<20070920142927.d87ab5af.akpm@linux-foundation.org>
	<20070921093914.GB4750@shadowen.org>
	<Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 16:58:15 +0100 (BST) Hugh Dickins
<hugh@veritas.com> wrote:

> But once I look harder at it, I wonder what would have kept
> 2.6.18 to 2.6.23 safe from the same issue: per-cpu deltas from
> the global vm stats too low to get synched back to global, yet
> adding up to something which misleads balance_dirty_pages into
> an indefinite loop e.g. total nr_writeback actually 0, but
> appearing more than dirty_thresh in the global approximation.

This could only happen when: dirty_thresh < nr_cpus * per_cpu_max_delta

> Looking at the 2.6.18-2.6.23 code, I'm uncertain what to try instead.
> There is a refresh_vm_stats function which we could call (then retest
> the break condition) just before resorting to congestion_wait.  But
> the big NUMA people might get very upset with me calling that too
> often: causing a thundering herd of bouncing cachelines which that
> was all designed to avoid.  And it's not obvious to me what condition
> to test for dirty_thresh "too low".

That could be modeled on the error limit I have. For this particular
case that would end up looking like:

  nr_online_cpus * pcp->stat_threshold.

> I believe Peter gave all this quite a lot of thought when he was
> making the rc6-mm1 changes, and I'd rather defer to him for a
> suggestion of what best to do in earlier releases.  Or maybe he'll
> just point out how this couldn't have been a problem before.

As outlined above, and I don't think we'll ever have such a low
dirty_limit. But who knows :-)

> Or there is is Richard's patch, which I haven't considered, but
> Andrew was not quite satisfied with it - partly because he'd like
> to understand how the situation could come about first, perhaps
> we have now got an explanation.

I'm with Andrew on this, that is, quite puzzled on how all this arises.

Testing those writeback-fix-* patches might help rule out (or point to)
a mis-function of pdflush.

The theory that one task will spin in balance_dirty_pages() on a
bdi that does not actually have many dirty pages, doesn't sound
plausible because eventually the total dirty count (well, actually
dirty+unstable+writeback) should subside again. This theory can
cause crappy latencies, but should not 'hang' the machine.

> (The original bug report was indeed on SMP, but I haven't seen
> anyone say that's a necessary condition for the hang: it would
> be if this is the issue.  And Richard writes at one point of the
> system only responding to AltSysRq: that would be surprising for
> this issue, though it's possible that a task in balance_dirty_pages
> is holding an i_mutex that everybody else comes to need.)

Are we actually holding i_mutex on paths that lead into
balance_dirty_pages? that does (from my admittedly limited knowledge of
the vfs) sound like trouble, since we'd need it to complete writeback.

All quite puzzling.
