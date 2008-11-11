Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYKKRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYKKRf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKKRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:35:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52609 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYKKRfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:35:10 -0500
Date: Tue, 11 Nov 2008 09:34:51 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to
	chanes in stop_machine
Message-ID: <20081111173451.GA24720@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081110120401.GA15518@osiris.boeblingen.de.ibm.com> <200811101547.21325.rjw@sisk.pl> <200811102355.42389.rjw@sisk.pl> <20081111105214.GA15645@elte.hu> <20081111113134.GA5653@osiris.boeblingen.de.ibm.com> <20081111124201.GA9459@osiris.boeblingen.de.ibm.com> <20081111143505.GA6923@linux.vnet.ibm.com> <20081111150225.GA10743@linux.vnet.ibm.com> <20081111161401.GC9459@osiris.boeblingen.de.ibm.com> <20081111164523.GB6736@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111164523.GB6736@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 08:45:23AM -0800, Paul E. McKenney wrote:
> On Tue, Nov 11, 2008 at 05:14:01PM +0100, Heiko Carstens wrote:
> > > > Could you please apply the following debug patch (due to Jiangshan and
> > > > myself)?  Then you should be able to build with CONFIG_RCU_TRACE,
> > > > then mount debugfs after boot, for example, on /debug.  This will
> > > > create a /debug/rcu directory with three files, "rcucb", "rcu_data",
> > > > and "rcu_bh_data".  Since you are still able to log in, could you
> > > > please send the contents of these three files?
> > > > 
> > > > 							Thanx, Paul
> > > 
> > > This time with the patch actually attached...  Thanks to Peter Z.
> > > for alerting me to my omission.
> > 
> > Well, your patch doesn't apply on git head. However I used preemptible
> > RCU instead and had tracing enabled.
> 
> Were you using preemptible RCU earlier as well?  Raphael was using
> classic RCU.  Don't get me wrong, all problems need fixing, just trying
> to make sure I understand where the problems are occurring.

And here is a version of the patch rebased to linux-2.6 git head.

This adds tracing to classic RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---

 include/linux/rcuclassic.h |    4 
 kernel/Kconfig.preempt     |    1 
 kernel/Makefile            |    2 
 kernel/rcuclassic.c        |    5 -
 kernel/rcuclassic_trace.c  |  198 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 207 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..ce183a8 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -63,6 +63,9 @@ struct rcu_ctrlblk {
 				 /* for current batch to proceed.        */
 } ____cacheline_internodealigned_in_smp;
 
+extern struct rcu_ctrlblk rcu_ctrlblk;
+extern struct rcu_ctrlblk rcu_bh_ctrlblk;
+
 /* Is batch a before batch b ? */
 static inline int rcu_batch_before(long a, long b)
 {
@@ -81,6 +84,7 @@ struct rcu_data {
 	long		quiescbatch;     /* Batch # for grace period */
 	int		passed_quiesc;	 /* User-mode/idle loop etc. */
 	int		qs_pending;	 /* core waits for quiesc state */
+	bool		beenonline;	 /* CPU online at least once */
 
 	/* 2) batch handling */
 	/*
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 9fdba03..ba32338 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -68,7 +68,6 @@ config PREEMPT_RCU
 
 config RCU_TRACE
 	bool "Enable tracing for RCU - currently stats in debugfs"
-	depends on PREEMPT_RCU
 	select DEBUG_FS
 	default y
 	help
diff --git a/kernel/Makefile b/kernel/Makefile
index 9a3ec66..9771050 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -79,6 +79,8 @@ obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
+else
+obj-$(CONFIG_RCU_TRACE) += rcuclassic_trace.o
 endif
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 37f72e5..54bd23b 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -58,14 +58,14 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 
 
 /* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
+struct rcu_ctrlblk rcu_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
 	.pending = -300,
 	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
 	.cpumask = CPU_MASK_NONE,
 };
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
+struct rcu_ctrlblk rcu_bh_ctrlblk = {
 	.cur = -300,
 	.completed = -300,
 	.pending = -300,
@@ -725,6 +725,7 @@ static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 	rdp->donetail = &rdp->donelist;
 	rdp->quiescbatch = rcp->completed;
 	rdp->qs_pending = 0;
+	rdp->beenonline = 1;
 	rdp->cpu = cpu;
 	rdp->blimit = blimit;
 	spin_unlock_irqrestore(&rcp->lock, flags);
diff --git a/kernel/rcuclassic_trace.c b/kernel/rcuclassic_trace.c
new file mode 100644
index 0000000..612170c
--- /dev/null
+++ b/kernel/rcuclassic_trace.c
@@ -0,0 +1,198 @@
+/*
+ * Read-Copy Update tracing for classic implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Updated to use seqfile by Lai Jiangshan.
+ *
+ * Papers:  http://www.rdrop.com/users/paulmck/RCU
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ */
+#include <linux/rcupdate.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+/* Print out rcu_data structures using seqfile facility. */
+
+static struct rcu_data *get_rcu_data_bh(int cpu)
+{
+	return &per_cpu(rcu_bh_data, cpu);
+}
+
+static struct rcu_data *get_rcu_data(int cpu)
+{
+	return &per_cpu(rcu_data, cpu);
+}
+
+static int show_rcu_data(struct seq_file *m, void *v)
+{
+	struct rcu_data *rdp = v;
+
+	if (!rdp->beenonline)
+		return 0;
+
+	seq_printf(m, "processor\t: %d", rdp->cpu);
+	if (cpu_is_offline(rdp->cpu))
+		seq_puts(m, "!\n");
+	else
+		seq_puts(m, "\n");
+	seq_printf(m, "quiescbatch\t: %ld\n", rdp->quiescbatch);
+	seq_printf(m, "batch\t\t: %ld\n", rdp->batch);
+	seq_printf(m, "passed_quiesc\t: %d\n", rdp->passed_quiesc);
+	seq_printf(m, "qs_pending\t: %d\n", rdp->qs_pending);
+	seq_printf(m, "qlen\t\t: %ld\n", rdp->qlen);
+	seq_printf(m, "blimit\t\t: %ld\n", rdp->blimit);
+	seq_puts(m, "\n");
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	typedef struct rcu_data *(*get_data_func)(int);
+
+	if (*pos == 0)  /* just in case, cpu 0 is not the first */
+		*pos = first_cpu(cpu_possible_map);
+	else
+		*pos = next_cpu_nr(*pos - 1, cpu_possible_map);
+	if ((*pos) < nr_cpu_ids)
+		return ((get_data_func)m->private)(*pos);
+	return NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations rcu_data_seq_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_rcu_data,
+};
+
+static int rcu_data_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &rcu_data_seq_op);
+
+	if (ret)
+		return ret;
+	((struct seq_file *)file->private_data)->private = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations rcu_data_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rcu_data_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/* Print out rcu_ctrlblk structures using seqfile facility. */
+
+static void print_one_rcu_ctrlblk(struct seq_file *m, struct rcu_ctrlblk *rcp)
+{
+	seq_printf(m, "cur=%ld  completed=%ld   pending=%d  s=%d\n\t",
+		   rcp->cur, rcp->completed, rcp->pending, rcp->signaled);
+	seq_cpumask(m, &rcp->cpumask);
+	seq_puts(m, "\n");
+}
+
+static int show_rcucb(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "rcu: ");
+	print_one_rcu_ctrlblk(m, &rcu_ctrlblk);
+	seq_puts(m, "rcu_bh: ");
+	print_one_rcu_ctrlblk(m, &rcu_bh_ctrlblk);
+	seq_puts(m, "online: ");
+	seq_cpumask(m, &cpu_online_map);
+	seq_puts(m, "\n");
+	return 0;
+}
+
+static int rcucb_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcucb, NULL);
+}
+
+static struct file_operations rcucb_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rcucb_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static struct dentry *rcudir, *rcu_bh_data_file, *rcu_data_file, *rcucb_file;
+
+static int __init rcuclassic_trace_init(void)
+{
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto out;
+
+	rcu_bh_data_file = debugfs_create_file("rcu_bh_data", 0444, rcudir,
+					       get_rcu_data_bh, &rcu_data_fops);
+	if (!rcu_bh_data_file)
+		goto out_rcudir;
+
+	rcu_data_file = debugfs_create_file("rcu_data", 0444, rcudir,
+					    get_rcu_data, &rcu_data_fops);
+	if (!rcu_data_file)
+		goto out_rcudata_bh_file;
+
+	rcucb_file = debugfs_create_file("rcucb", 0444, rcudir,
+					 NULL, &rcucb_fops);
+	if (!rcucb_file)
+		goto out_rcudata_file;
+	return 0;
+
+out_rcudata_file:
+	debugfs_remove(rcu_data_file);
+out_rcudata_bh_file:
+	debugfs_remove(rcu_bh_data_file);
+out_rcudir:
+	debugfs_remove(rcudir);
+out:
+	return 1;
+}
+
+static void __exit rcuclassic_trace_cleanup(void)
+{
+	debugfs_remove(rcucb_file);
+	debugfs_remove(rcu_data_file);
+	debugfs_remove(rcu_bh_data_file);
+	debugfs_remove(rcudir);
+}
+
+module_init(rcuclassic_trace_init);
+module_exit(rcuclassic_trace_cleanup);
+
+MODULE_AUTHOR("Paul E. McKenney");
+MODULE_DESCRIPTION("Read-Copy Update tracing for classic implementation");
+MODULE_LICENSE("GPL");
+
