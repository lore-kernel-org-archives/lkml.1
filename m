Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZBSLGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZBSLGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZBSLGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:06:35 -0500
Received: from brick.kernel.dk ([93.163.65.50]:7286 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZBSLGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:06:35 -0500
Date: Thu, 19 Feb 2009 12:04:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Message-ID: <20090219110408.GU30821@kernel.dk>
References: <20090216163847.431174825@chello.nl> <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu> <200902191501.47564.rusty@rustcorp.com.au> <1235034629.4612.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235034629.4612.35.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19 2009, Peter Zijlstra wrote:
> On Thu, 2009-02-19 at 15:01 +1030, Rusty Russell wrote:
> > On Thursday 19 February 2009 02:35:35 Ingo Molnar wrote:
> > > 
> > > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > 
> > > > On Tuesday 17 February 2009 20:13:59 Ingo Molnar wrote:
> > > > > We should not bend backwards trying to preserve that kmalloc() 
> > > > > [and prove that it's safe and race-free] - i.e. the burden of 
> > > > > proof is on the person insisting that it's needed, not on the 
> > > > > person wanting to remove it.
> > > > 
> > > > Respectfully disagree.  The kmalloc has been there for a very long time,
> > > > and doing fine AFAICT.
> > > 
> > > The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half 
> > > a year
> > 
> > Oops, yes.
> > 
> > So if we care about the kmalloc, why didn't we see benchmarks when we
> > switched from the x86 smp_call_function_mask to the generic one?  Or did
> > I just miss them (there's nothing in the git commit).
> > 
> > Now, I think the current patch is quite neat and may not been benchmarks to
> > justify it, but it'd still be nice if it were faster, but noone seems to know.
> 
> I think the problem is that even on a lively machine these routines just
> aren't called that often:
> 
> CAL:         74        104         93        116   Function call interrupts
> make clean; make -j8 bzImage
> CAL:         74        104         93        116   Function call interrupts
> 
> We could of course construct some artificial ubench to stress it...

An easy way to stress it would be to enable request cpu affinity in the
block layer, that get you tons of call function single interrupts. If
sda is the drive of interest, do:

# echo 1 > /sys/block/sda/queue/rq_affinity

and then generate some IO, the block layer will use single ipi calls to
reschedule completions to the submitting CPU.

-- 
Jens Axboe

