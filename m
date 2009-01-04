Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbZADTlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbZADTlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZADTlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:41:17 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35254 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZADTlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:41:16 -0500
Date: Sun, 4 Jan 2009 11:41:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dhaval@linux.vnet.ibm.com, jens.axboe@oracle.com, mingo@elte.hu,
       snakebyte@gmx.de, andi@firstfloor.org, akpm@linux-foundation.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, rostedt@goodmis.org,
       tglx@linutronix.de, manfred@colorfullife.com
Subject: [PATCH] Make treercu safe for suspend and resume
Message-ID: <20090104194111.GA16398@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Kudos to both Dhaval Giani and Jens Axboe for finding a bug in treercu
that causes warnings after suspend-resume cycles in Dhaval's case and
during stress tests in Jens's case.  It would also probably cause failures
if heavily stressed.  The solution, ironically enough, is to revert to
rcupreempt's code for initializing the dynticks state.  And the patch
even results in smaller code -- so what was I thinking???

This is 2.6.29 material, given that people really do suspend and resume
Linux these days.  ;-)

Located-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Located-by: Jens Axboe <jens.axboe@oracle.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Tested-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutree.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a342b03..e0a347f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -79,7 +79,10 @@ struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 #ifdef CONFIG_NO_HZ
-DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks);
+DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
+	.dynticks_nesting = 1,
+	.dynticks = 1,
+};
 #endif /* #ifdef CONFIG_NO_HZ */
 
 static int blimit = 10;		/* Maximum callbacks per softirq. */
@@ -1379,13 +1382,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	rdtp->dynticks_nesting = 1;
-	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
-	rdtp->dynticks_nmi = (rdtp->dynticks_nmi + 1) & ~0x1;
-#endif /* #ifdef CONFIG_NO_HZ */
 	rcu_init_percpu_data(cpu, &rcu_state);
 	rcu_init_percpu_data(cpu, &rcu_bh_state);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
