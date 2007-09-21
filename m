Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbXIUQAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbXIUQAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbXIUP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:59:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49471 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXIUP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:59:55 -0400
Date: Fri, 21 Sep 2007 16:58:15 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Matthias Hensler <matthias@wspse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
In-Reply-To: <20070921093914.GB4750@shadowen.org>
Message-ID: <Pine.LNX.4.64.0709211623190.16442@blonde.wat.veritas.com>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org>
 <20070804084426.GA20464@kobayashi-maru.wspse.de> <20070809095943.GA7763@kobayashi-maru.wspse.de>
 <20070809095534.25ae1c42.akpm@linux-foundation.org> <46F2E103.8000907@redhat.com>
 <20070920142927.d87ab5af.akpm@linux-foundation.org> <20070921093914.GB4750@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Andy Whitcroft wrote:
> This sounds an awful lot like the same problem I reported with fsck
> hanging.  I believe that Hugh had a candidate patch for that, which was
> related to dirty tracking limits.  It seems that that patch tested, and
> acked by Peter.  All on lkml under:
> 
> 	2.6.23-rc6-mm1 -- mkfs stuck in 'D'

You may well be right.

My initial reaction was to point out that my patch was to a 
2.6.23-rc6-mm1 implementation detail, whereas this thread is
about a problem seen since 2.6.20 or perhaps earlier.

But once I look harder at it, I wonder what would have kept
2.6.18 to 2.6.23 safe from the same issue: per-cpu deltas from
the global vm stats too low to get synched back to global, yet
adding up to something which misleads balance_dirty_pages into
an indefinite loop e.g. total nr_writeback actually 0, but
appearing more than dirty_thresh in the global approximation.

Certainly my rc6-mm1 patch won't work here, and all it was doing
was apply some safety already added by Peter to one further case.

Looking at the 2.6.18-2.6.23 code, I'm uncertain what to try instead.
There is a refresh_vm_stats function which we could call (then retest
the break condition) just before resorting to congestion_wait.  But
the big NUMA people might get very upset with me calling that too
often: causing a thundering herd of bouncing cachelines which that
was all designed to avoid.  And it's not obvious to me what condition
to test for dirty_thresh "too low".

I believe Peter gave all this quite a lot of thought when he was
making the rc6-mm1 changes, and I'd rather defer to him for a
suggestion of what best to do in earlier releases.  Or maybe he'll
just point out how this couldn't have been a problem before.

Or there is is Richard's patch, which I haven't considered, but
Andrew was not quite satisfied with it - partly because he'd like
to understand how the situation could come about first, perhaps
we have now got an explanation.

(The original bug report was indeed on SMP, but I haven't seen
anyone say that's a necessary condition for the hang: it would
be if this is the issue.  And Richard writes at one point of the
system only responding to AltSysRq: that would be surprising for
this issue, though it's possible that a task in balance_dirty_pages
is holding an i_mutex that everybody else comes to need.)

Hugh
