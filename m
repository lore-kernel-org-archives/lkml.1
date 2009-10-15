Return-Path: <linux-kernel-owner+w=401wt.eu-S934911AbZJOJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911AbZJOJ0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933205AbZJOJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:26:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45717 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761786AbZJOJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:44 -0400
Date: Thu, 15 Oct 2009 09:25:22 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josh@joshtriplett.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, josh@joshtriplett.org,
       mingo@elte.hu
In-Reply-To: <20091014233638.GE6763@linux.vnet.ibm.com>
References: <20091014233638.GE6763@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add rnp->blocked_tasks to tracing
Message-ID: <tip-3397e040dfacbb303498ced1baa96be983dcea06@git.kernel.org>
Git-Commit-ID: 3397e040dfacbb303498ced1baa96be983dcea06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:25:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3397e040dfacbb303498ced1baa96be983dcea06
Gitweb:     http://git.kernel.org/tip/3397e040dfacbb303498ced1baa96be983dcea06
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 14 Oct 2009 16:36:38 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:20:22 +0200

rcu: Add rnp->blocked_tasks to tracing

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: npiggin@suse.de
Cc: jens.axboe@oracle.com
Cc: Josh Triplett <josh@joshtriplett.org>
LKML-Reference: <20091014233638.GE6763@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
 kernel/rcutree_trace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)
---
 kernel/rcutree_trace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b31c77..1984cdc 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -155,12 +155,14 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
+	long gpnum;
 	int level = 0;
 	struct rcu_node *rnp;
 
+	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
-		   rsp->completed, rsp->gpnum, rsp->signaled,
+		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
@@ -171,8 +173,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
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
