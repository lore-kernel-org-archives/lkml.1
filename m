Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZDNKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZDNKCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZDNKBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:01:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbZDNKBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:01:40 -0400
Date: Tue, 14 Apr 2009 10:00:49 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, anton@au1.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, anton@au1.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239683479943-git-send-email->
References: <1239683479943-git-send-email->
Subject: [tip:core/rcu] rcu: Add __rcu_pending tracing to hierarchical RCU
Message-ID: <tip-7ba5c840e64d4a967379f1ae3eca73278180b11d@git.kernel.org>
Git-Commit-ID: 7ba5c840e64d4a967379f1ae3eca73278180b11d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:00:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ba5c840e64d4a967379f1ae3eca73278180b11d
Gitweb:     http://git.kernel.org/tip/7ba5c840e64d4a967379f1ae3eca73278180b11d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 13 Apr 2009 21:31:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:33:43 +0200

rcu: Add __rcu_pending tracing to hierarchical RCU

Add tracing to __rcu_pending() to provide information on why RCU
processing was kicked off.  This is helpful for debugging hierarchical
RCU, and might also be helpful in learning how hierarchical RCU operates.

Located-by: Anton Blanchard <anton@au1.ibm.com>
Tested-by: Anton Blanchard <anton@au1.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: anton@samba.org
Cc: akpm@linux-foundation.org
Cc: dipankar@in.ibm.com
Cc: manfred@colorfullife.com
Cc: cl@linux-foundation.org
Cc: josht@linux.vnet.ibm.com
Cc: schamp@sgi.com
Cc: niv@us.ibm.com
Cc: dvhltc@us.ibm.com
Cc: ego@in.ibm.com
Cc: laijs@cn.fujitsu.com
Cc: rostedt@goodmis.org
Cc: peterz@infradead.org
Cc: penberg@cs.helsinki.fi
Cc: andi@firstfloor.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
LKML-Reference: <1239683479943-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcutree.h |    9 ++++++-
 kernel/rcutree.c        |   25 ++++++++++++++----
 kernel/rcutree_trace.c  |   64 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 58b2aa5..5a51538 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -161,8 +161,15 @@ struct rcu_data {
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
-	/* 5) For future __rcu_pending statistics. */
+	/* 5) __rcu_pending() statistics. */
 	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rp_qs_pending;
+	long n_rp_cb_ready;
+	long n_rp_cpu_needs_gp;
+	long n_rp_gp_completed;
+	long n_rp_gp_started;
+	long n_rp_need_fqs;
+	long n_rp_need_nothing;
 
 	int cpu;
 };
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d2a372f..0dccfbb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1259,31 +1259,44 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	check_cpu_stall(rsp, rdp);
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	if (rdp->qs_pending)
+	if (rdp->qs_pending) {
+		rdp->n_rp_qs_pending++;
 		return 1;
+	}
 
 	/* Does this CPU have callbacks ready to invoke? */
-	if (cpu_has_callbacks_ready_to_invoke(rdp))
+	if (cpu_has_callbacks_ready_to_invoke(rdp)) {
+		rdp->n_rp_cb_ready++;
 		return 1;
+	}
 
 	/* Has RCU gone idle with this CPU needing another grace period? */
-	if (cpu_needs_another_gp(rsp, rdp))
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		rdp->n_rp_cpu_needs_gp++;
 		return 1;
+	}
 
 	/* Has another RCU grace period completed?  */
-	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
+	if (ACCESS_ONCE(rsp->completed) != rdp->completed) { /* outside lock */
+		rdp->n_rp_gp_completed++;
 		return 1;
+	}
 
 	/* Has a new RCU grace period started? */
-	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
+	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) { /* outside lock */
+		rdp->n_rp_gp_started++;
 		return 1;
+	}
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
 	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
-	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0))
+	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
+		rdp->n_rp_need_fqs++;
 		return 1;
+	}
 
 	/* nothing to do */
+	rdp->n_rp_need_nothing++;
 	return 0;
 }
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b1875b..fe1dcdb 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -213,7 +213,63 @@ static struct file_operations rcugp_fops = {
 	.release = single_release,
 };
 
-static struct dentry *rcudir, *datadir, *datadir_csv, *hierdir, *gpdir;
+static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
+{
+	seq_printf(m, "%3d%cnp=%ld "
+		   "qsp=%ld cbr=%ld cng=%ld gpc=%ld gps=%ld nf=%ld nn=%ld\n",
+		   rdp->cpu,
+		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
+		   rdp->n_rcu_pending,
+		   rdp->n_rp_qs_pending,
+		   rdp->n_rp_cb_ready,
+		   rdp->n_rp_cpu_needs_gp,
+		   rdp->n_rp_gp_completed,
+		   rdp->n_rp_gp_started,
+		   rdp->n_rp_need_fqs,
+		   rdp->n_rp_need_nothing);
+}
+
+static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
+{
+	int cpu;
+	struct rcu_data *rdp;
+
+	for_each_possible_cpu(cpu) {
+		rdp = rsp->rda[cpu];
+		if (rdp->beenonline)
+			print_one_rcu_pending(m, rdp);
+	}
+}
+
+static int show_rcu_pending(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "rcu:\n");
+	print_rcu_pendings(m, &rcu_state);
+	seq_puts(m, "rcu_bh:\n");
+	print_rcu_pendings(m, &rcu_bh_state);
+	return 0;
+}
+
+static int rcu_pending_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcu_pending, NULL);
+}
+
+static struct file_operations rcu_pending_fops = {
+	.owner = THIS_MODULE,
+	.open = rcu_pending_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir;
+static struct dentry *datadir;
+static struct dentry *datadir_csv;
+static struct dentry *gpdir;
+static struct dentry *hierdir;
+static struct dentry *rcu_pendingdir;
+
 static int __init rcuclassic_trace_init(void)
 {
 	rcudir = debugfs_create_dir("rcu", NULL);
@@ -238,6 +294,11 @@ static int __init rcuclassic_trace_init(void)
 						NULL, &rcuhier_fops);
 	if (!hierdir)
 		goto free_out;
+
+	rcu_pendingdir = debugfs_create_file("rcu_pending", 0444, rcudir,
+						NULL, &rcu_pending_fops);
+	if (!rcu_pendingdir)
+		goto free_out;
 	return 0;
 free_out:
 	if (datadir)
@@ -257,6 +318,7 @@ static void __exit rcuclassic_trace_cleanup(void)
 	debugfs_remove(datadir_csv);
 	debugfs_remove(gpdir);
 	debugfs_remove(hierdir);
+	debugfs_remove(rcu_pendingdir);
 	debugfs_remove(rcudir);
 }
 
