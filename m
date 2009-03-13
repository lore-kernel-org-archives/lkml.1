Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZCMMpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZCMMpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZCMMox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:44:53 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:31478 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZCMMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:44:52 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18874.20538.785519.824803@cargo.ozlabs.ibm.com>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
	 <1236939816.22914.3714.camel@twins>
	 <18874.20538.785519.824803@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 13:44:43 +0100
Message-Id: <1236948283.22447.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 23:23 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > The former case however, you seem to say we should keep software
> > counters active even though their associated task is scheduled out? That
> > doesn't appear to make sense to me.
> > 
> > Why would you want to do that?
> 
> Because the things that they are based on can get incremented when the
> task is scheduled out.  This is most noticeable in the case of the
> context switch counter and also happens with the task migrations
> counter.  These *always* get incremented when the task is scheduled
> out from the perf_counter subsystem's point of view, i.e. after
> perf_counter_task_sched_out is called for the task and before the next
> perf_counter_task_sched_in call.

Ah, I would rather special case these two counters than do what you did.

The issue I have with your approach is two-fold:
 - it breaks the symmetry between software and hardware counters by
   treating them differently.
 - it doesn't make much conceptual sense to me

For the context switch counter, we could count the event right before we
schedule out, which would make it behave like expected.

The same for task migration, most migrations happen when they are in
fact running, so there too we can account the migration either before we
rip it off the src cpu, or after we place it on the dst cpu.

There are a few places where this isn't quite so, like affine wakeups,
but there we can account after the placement.

>   I believe page faults can also
> happen while the task is scheduled out, via access_process_vm.

Very rare, and once could conceivably argue that the fault would then
belong to the task doing access_process_vm().

> I also originally thought that software counters should only count
> while their task is scheduled in, which is why I introduced the bug
> that I fixed in c07c99b67233ccaad38a961c17405dc1e1542aa4.  That commit
> however left us with software counters that counted even when their
> group wasn't on; hence the current patch.

Right.

Anyway, I would like to keep the behaviour that software and hardware
counters are symmetric, that means disable them when their associated
task goes.

Like stated above, we can fix these special cases by accounting in
different places.

