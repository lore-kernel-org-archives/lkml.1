Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZJNR3k (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 14 Oct 2009 13:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZJNR3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:29:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43680 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZJNR2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:28:53 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
        jens.axboe@oracle.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcu: add rnp->blocked_tasks to tracing
Date: Wed, 14 Oct 2009 10:15:58 -0700
Message-Id: <1255540559475-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091014171517.GA13635@linux.vnet.ibm.com>
References: <20091014171517.GA13635@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b31c77..f9d01a3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -155,12 +155,13 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
+	long gpnum;
 	int level = 0;
 	struct rcu_node *rnp;
 
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
-		   rsp->completed, rsp->gpnum, rsp->signaled,
+		   rsp->completed, gpnum = rsp->gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
@@ -171,8 +172,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		seq_printf(m, "%lx/%lx %d:%d ^%d    ",
+		seq_printf(m, "%lx/%lx %c>%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
+			   "T."[list_empty(&rnp->blocked_tasks[gpnum & 1])],
+			   "T."[list_empty(&rnp->blocked_tasks[!(gpnum & 1)])],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
-- 
1.5.2.5

