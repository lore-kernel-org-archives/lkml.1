Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZKJW3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZKJW3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbZKJW3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:29:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:34962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZKJW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:28:56 -0500
Date: Tue, 10 Nov 2009 22:28:29 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12578890421011-git-send-email->
References: <12578890421011-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Simplify association of quiescent states with grace periods
Message-ID: <tip-c64ac3ce06558e534aec62b1fadeb0a3f111dac1@git.kernel.org>
Git-Commit-ID: c64ac3ce06558e534aec62b1fadeb0a3f111dac1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c64ac3ce06558e534aec62b1fadeb0a3f111dac1
Gitweb:     http://git.kernel.org/tip/c64ac3ce06558e534aec62b1fadeb0a3f111dac1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 10 Nov 2009 13:37:22 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 22:48:50 +0100

rcu: Simplify association of quiescent states with grace periods

The rdp->passed_quiesc_completed fields are used to properly
associate the recorded quiescent state with a grace period.  It
is OK to wrongly associate a given quiescent state with a
preceding grace period, but it is fatal to associate a given
quiescent state with a grace period that begins after the
quiescent state occurred.  Grace periods are numbered, and the
following fields track them:

o	->gpnum is the number of the grace period currently in
	progress, or the number of the last grace period to
	complete if no grace period is currently in progress.

o	->completed is the number of the last grace period to
	have completed.

These two fields are equal if there is no grace period in
progress, otherwise ->gpnum is one greater than ->completed.
But the rdp->passed_quiesc_completed field compared against
->completed, and if equal, the quiescent state is presumed to
count against the current grace period.

The earlier code copied rdp->completed to
rdp->passed_quiesc_completed, which has been made to work, but
is error-prone.  In contrast, copying one less than rdp->gpnum
is guaranteed safe, because rdp->gpnum is not incremented until
after the start of the corresponding grace period. At the end of
the grace period, when ->completed has incremented, then any
quiescent periods recorded previously will be discarded.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12578890421011-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcutree.c        |    4 ++--
 kernel/rcutree_plugin.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 26fc780..d802419 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -100,7 +100,7 @@ void rcu_sched_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_sched_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 	rcu_preempt_note_context_switch(cpu);
@@ -111,7 +111,7 @@ void rcu_bh_qs(int cpu)
 	struct rcu_data *rdp;
 
 	rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c03edf7..52075da 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -67,7 +67,7 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-	rdp->passed_quiesc_completed = rdp->completed;
+	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
 }
