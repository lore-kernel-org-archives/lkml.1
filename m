Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXBEMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXBEMyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXBEMyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:54:19 -0500
Received: from brick.kernel.dk ([62.242.22.158]:20736 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbXBEMyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:54:18 -0500
Date: Mon, 5 Feb 2007 13:56:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070205125643.GG4487@kernel.dk>
References: <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com> <20070201202646.GR10305@kernel.dk> <Pine.LNX.4.64.0702011435060.4632@schroedinger.engr.sgi.com> <20070205120253.GC4487@kernel.dk> <20070205121735.GD4487@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205121735.GD4487@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05 2007, Jens Axboe wrote:
> On Mon, Feb 05 2007, Jens Axboe wrote:
> > On Thu, Feb 01 2007, Christoph Lameter wrote:
> > > On Thu, 1 Feb 2007, Jens Axboe wrote:
> > > 
> > > > That looks like barriers, could you try with those disabled? Sorry for
> > > > making you go through this, I can't debug and fix it myself before
> > > > monday.
> > > 
> > > Disabling barriers + your patch works. Modified /etc/fstab and added a 
> > > nobarrier option to the root filesystem. If I take your patch out then the 
> > > systems hangs again.
> > 
> > I can't reproduce this. Can you see if this debug patch catches
> > anything? You need to enable barriers again.
> 
> Nevermind, that was too aggressive. I'll come up with a better debug
> patch.

Alright, try this one. It should show whether this is a missing unplug
or not (which I think it is, hence the stall in qrcu sync). A process
may legitimately block with plugged requests, that sometimes happens for
bio/rq allocation etc. In that case we do want to unplug anyway though,
as I don't think we should hold requests plugged even for a merge if we
are going to block. And the below means we can move this out of
io_schedule() and eliminate the io_schedule() requirement that I'm not
too fond of, as I don't want to reintroduce all the problems we had with
missing unplugs in the 2.4 kernels.

But for now this is just a debug test, can you see if xfs with barriers
for that kernel now works as expected?

diff --git a/kernel/sched.c b/kernel/sched.c
index e209901..6a54e4d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3434,6 +3434,8 @@ asmlinkage void __sched schedule(void)
 			print_irqtrace_events(current);
 		dump_stack();
 	}
+	if (unlikely(current->io_context && current->io_context->plugged))
+		blk_replug_current_nested();
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 need_resched:

-- 
Jens Axboe

