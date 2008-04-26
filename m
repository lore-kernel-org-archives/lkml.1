Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYDZOtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYDZOtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYDZOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:48:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYDZOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:48:52 -0400
Date: Sat, 26 Apr 2008 07:43:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix rcu_try_flip_waitack_needed() to prevent
 grace-period stall
Message-Id: <20080426074327.28db1bfc.akpm@linux-foundation.org>
In-Reply-To: <20080321203821.GA16316@linux.vnet.ibm.com>
References: <20080321203821.GA16316@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 13:38:21 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> The comment was correct -- need to make the code match the comment.
> Without this patch, if a CPU goes dynticks idle (and stays there forever)
> in just the right phase of preemptible-RCU grace-period processing,
> grace periods stall.  The offending sequence of events (courtesy
> of Promela/spin, at least after I got the liveness criterion coded
> correctly...) is as follows:
> 
> o	CPU 0 is in dynticks-idle mode.  Its dynticks_progress_counter
> 	is (say) 10.
> 
> o	CPU 0 takes an interrupt, so rcu_irq_enter() increments CPU 0's
> 	dynticks_progress_counter to 11.
> 
> o	CPU 1 is doing RCU grace-period processing in rcu_try_flip_idle(),
> 	sees rcu_pending(), so invokes dyntick_save_progress_counter(),
> 	which in turn takes a snapshot of CPU 0's dynticks_progress_counter
> 	into CPU 0's rcu_dyntick_snapshot -- now set to 11.  CPU 1 then
> 	updates the RCU grace-period state to rcu_try_flip_waitack().
> 
> o	CPU 0 returns from its interrupt, so rcu_irq_exit() increments
> 	CPU 0's dynticks_progress_counter to 12.
> 
> o	CPU 1 later invokes rcu_try_flip_waitack(), which notices that
> 	CPU 0 has not yet responded, and hence in turn invokes
> 	rcu_try_flip_waitack_needed().  This function examines the
> 	state of CPU 0's dynticks_progress_counter and rcu_dyntick_snapshot
> 	variables, which it copies to curr (== 12) and snap (== 11),
> 	respectively.
> 
> 	Because curr!=snap, the first condition fails.
> 
> 	Because curr-snap is only 1 and snap is odd, the second
> 	condition fails.
> 
> 	rcu_try_flip_waitack_needed() therefore incorrectly concludes
> 	that it must wait for CPU 0 to explicitly acknowledge the
> 	counter flip.
> 
> o	CPU 0 remains forever in dynticks-idle mode, never taking
> 	any more hardware interrupts or any NMIs, and never running
> 	any more tasks.  (Of course, -something- will usually eventually
> 	happen, which might be why we haven't seen this one in the
> 	wild.  Still should be fixed!)
> 
> Therefore the grace period never ends.  Fix is to make the code match
> the comment, as shown below.  With this fix, the above scenario
> would be satisfied with curr being even, and allow the grace period
> to proceed.

Am having a ton of fun here putting my tree back together after a week's
worth of whee-look-at-all-the-stuff-ive-never-seen-before-which-just-got-merged
discoveries. (Which are not too bad actually)

This patch ran afoul of this change in Linus's tree:

--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1007,10 +1007,10 @@ void __synchronize_sched(void)
 	if (sched_getaffinity(0, &oldmask) < 0)
 		oldmask = cpu_possible_map;
 	for_each_online_cpu(cpu) {
-		sched_setaffinity(0, cpumask_of_cpu(cpu));
+		sched_setaffinity(0, &cpumask_of_cpu(cpu));
 		schedule();
 	}
-	sched_setaffinity(0, oldmask);
+	sched_setaffinity(0, &oldmask);
 }
 EXPORT_SYMBOL_GPL(__synchronize_sched);
 

I fixed it by simply removing the above changed lines.  Please check that
the result makes sense and that we don't need to carry the above change
forward in any way?

I also removed the Cc:stable from this patch based on your followup
discussion with Peter.

Thanks.



From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The comment was correct -- need to make the code match the comment.
Without this patch, if a CPU goes dynticks idle (and stays there forever)
in just the right phase of preemptible-RCU grace-period processing,
grace periods stall.  The offending sequence of events (courtesy
of Promela/spin, at least after I got the liveness criterion coded
correctly...) is as follows:

o	CPU 0 is in dynticks-idle mode.  Its dynticks_progress_counter
	is (say) 10.

o	CPU 0 takes an interrupt, so rcu_irq_enter() increments CPU 0's
	dynticks_progress_counter to 11.

o	CPU 1 is doing RCU grace-period processing in rcu_try_flip_idle(),
	sees rcu_pending(), so invokes dyntick_save_progress_counter(),
	which in turn takes a snapshot of CPU 0's dynticks_progress_counter
	into CPU 0's rcu_dyntick_snapshot -- now set to 11.  CPU 1 then
	updates the RCU grace-period state to rcu_try_flip_waitack().

o	CPU 0 returns from its interrupt, so rcu_irq_exit() increments
	CPU 0's dynticks_progress_counter to 12.

o	CPU 1 later invokes rcu_try_flip_waitack(), which notices that
	CPU 0 has not yet responded, and hence in turn invokes
	rcu_try_flip_waitack_needed().  This function examines the
	state of CPU 0's dynticks_progress_counter and rcu_dyntick_snapshot
	variables, which it copies to curr (== 12) and snap (== 11),
	respectively.

	Because curr!=snap, the first condition fails.

	Because curr-snap is only 1 and snap is odd, the second
	condition fails.

	rcu_try_flip_waitack_needed() therefore incorrectly concludes
	that it must wait for CPU 0 to explicitly acknowledge the
	counter flip.

o	CPU 0 remains forever in dynticks-idle mode, never taking
	any more hardware interrupts or any NMIs, and never running
	any more tasks.  (Of course, -something- will usually eventually
	happen, which might be why we haven't seen this one in the
	wild.  Still should be fixed!)

Therefore the grace period never ends.  Fix is to make the code match
the comment, as shown below.  With this fix, the above scenario
would be satisfied with curr being even, and allow the grace period
to proceed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Josh Triplett <josh@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall
+++ a/kernel/rcupreempt.c
@@ -567,7 +567,7 @@ rcu_try_flip_waitack_needed(int cpu)
 	 * that this CPU already acknowledged the counter.
 	 */
 
-	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+	if ((curr - snap) > 2 || (curr & 0x1) == 0)
 		return 0;
 
 	/* We need this CPU to explicitly acknowledge the counter flip. */
_

