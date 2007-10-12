Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXJLJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXJLJ02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933067AbXJLJVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:21:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44567 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXJLJVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:21:10 -0400
Date: Fri, 12 Oct 2007 14:50:44 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Paul E McKenney <paulmck@us.ibm.com>, josh@freedesktop.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Dipankar Sarma <dipankar@in.ibm.com>,
       rostedt@goodmis.org
Subject: [PATCH] Use raw_smp_processor_id() in rcu_random()
Message-ID: <20071012092044.GA1138@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With CONFIG_PREEMPT=y on 2.6.23-rc8-mm2, rcu_random() calls 
smp_processor_id() from a preemptible context, triggering the
following kernel error.

BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5155
caller is rcu_random+0x16/0x39 [rcutorture]
 [<c010612f>] dump_trace+0x68/0x1d2
 [<c01062b1>] show_trace_log_lvl+0x18/0x2c
 [<c0106c23>] show_trace+0xf/0x11
 [<c0106d33>] dump_stack+0x12/0x14
 [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
 [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
 [<f8870cdf>] <3>BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5156
rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]
 [<c0139b32>] caller is rcu_random+0x16/0x39 [rcutorture]
kthread+0x38/0x5e
 [<c0105ca7>] kernel_thread_helper+0x7/0x10
 =======================
 [<c010612f>] dump_trace+0x68/0x1d2
 [<c01062b1>] show_trace_log_lvl+0x18/0x2c
 [<c0106c23>] show_trace+0xf/0x11
 [<c0106d33>] dump_stack+0x12/0x14
 [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
 [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
 [<f8870cdf>] rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]

rcu_random() can do with raw_smp_processor_id() as a parameter to cpu_clock()
in this particular context.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

---
 kernel/rcutorture.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc8/kernel/rcutorture.c
===================================================================
--- linux-2.6.23-rc8.orig/kernel/rcutorture.c
+++ linux-2.6.23-rc8/kernel/rcutorture.c
@@ -170,7 +170,8 @@ static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
 	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
+		rrsp->rrs_state +=
+			(unsigned long)cpu_clock(raw_smp_processor_id());
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
