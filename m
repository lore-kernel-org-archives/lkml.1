Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbXHKAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbXHKAlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 20:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbXHKAlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 20:41:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59935 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbXHKAlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 20:41:31 -0400
Date: Fri, 10 Aug 2007 17:41:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, josht@linux.vnet.ibm.com,
       dipankar@in.ibm.com, bunk@kernel.org
Subject: [PATCH] Make rcutorture RNG use locally grown entropy
Message-ID: <20070811004129.GA26356@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts rcutorture's random-number generator from
get_random_bytes() (which has locking issues in some builds with patches)
to instead use local-to-rcutorture statistical counters.  This involves
reading other CPUs' statistics, so the frequency of entropy addition
is simultaneously decreased by an order of magnitude.

This patch is an alternative to adding an EXPORT_SYMBOL_GPL() for the new
cpu_clock() API.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22.1-rt4/kernel/rcutorture.c linux-2.6.22.1-rt4-rcutorturesched/kernel/rcutorture.c
--- linux-2.6.22.1-rt4/kernel/rcutorture.c	2007-07-21 16:58:22.000000000 -0700
+++ linux-2.6.22.1-rt4-rcutorturesched/kernel/rcutorture.c	2007-08-10 08:42:41.000000000 -0700
@@ -155,26 +155,27 @@ rcu_torture_free(struct rcu_torture *p)
 struct rcu_random_state {
 	unsigned long rrs_state;
 	long rrs_count;
+	int rrs_cpu;
 };
 
 #define RCU_RANDOM_MULT 39916801  /* prime */
 #define RCU_RANDOM_ADD	479001701 /* prime */
-#define RCU_RANDOM_REFRESH 10000
+#define RCU_RANDOM_REFRESH 100000
 
 #define DEFINE_RCU_RANDOM(name) struct rcu_random_state name = { 0, 0 }
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from other CPUs' fast-running statistics.
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_cpu = next_cpu(rrsp->rrs_cpu, cpu_online_map);
+		if (rrsp->rrs_cpu >= NR_CPUS)
+			rrsp->rrs_cpu = 0;
+		rrsp->rrs_state += per_cpu(rcu_torture_count, rrsp->rrs_cpu)[0];
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
