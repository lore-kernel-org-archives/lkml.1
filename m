Return-Path: <linux-kernel-owner+w=401wt.eu-S1761843AbYGaAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761843AbYGaAKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbYGaAJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:09:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:36310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319AbYGaAJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:09:19 -0400
Date: Wed, 30 Jul 2008 16:58:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Josh Triplett <josh@kernel.org>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 16/62] rcu: fix rcu_try_flip_waitack_needed() to prevent
	grace-period stall
Message-ID: <20080730235821.GP12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rcu-fix-rcu_try_flip_waitack_needed-to-prevent-grace-period-stall.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit d7c0651390b6a03ad53f99faec0ba88109d7191d upstream

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
Cc: Josh Triplett <josh@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/rcupreempt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -567,7 +567,7 @@ rcu_try_flip_waitack_needed(int cpu)
 	 * that this CPU already acknowledged the counter.
 	 */
 
-	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+	if ((curr - snap) > 2 || (curr & 0x1) == 0)
 		return 0;
 
 	/* We need this CPU to explicitly acknowledge the counter flip. */

-- 
