Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYKBUL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYKBUL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKBULV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:11:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:21494 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYKBULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:11:19 -0500
Message-ID: <490E094F.7090007@colorfullife.com>
Date: Sun, 02 Nov 2008 21:10:55 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com>
In-Reply-To: <20081010160930.GA9777@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------010103020806080306010305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010103020806080306010305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Paul E. McKenney wrote:
> --- /dev/null
> +++ b/Documentation/RCU/trace.txt
> @@ -0,0 +1,398 @@
> +CONFIG_RCU_TRACE debugfs Files and Formats
> +
> +
> +The rcupreempt and rcutree implementations of RCU provide debugfs trace
> +output that summarizes counters and state.  This information is useful for
> +debugging RCU itself, and can sometimes also help to debug abuses of RCU.
> +Note that the rcuclassic implementation of RCU does not provide debugfs
> +trace output.
> +
>   

What about some generic files, with the same content for all rcu backends?
The implementation could be in rcupdate.c. At least counting the rcu 
callbacks could be done from generic code, the grace periods could be 
queried [Do all backends implement rcu_batches_completed?]

Attached is a hack that I use right now for myself.
Btw - on my 4-cpu system, the average latency from call_rcu() to the rcu 
callback is 4-5 milliseconds, (CONFIG_HZ_1000).

--
    Manfred

--------------010103020806080306010305
Content-Type: text/plain;
 name="patch-rcu-generic-trace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-rcu-generic-trace"

rom bf385caf2484d41157a9bef1550cdbefecdefa1b Mon Sep 17 00:00:00 2001
rom: Manfred Spraul <manfred@colorfullife.com>
Date: Sun, 2 Nov 2008 20:38:11 +0100
Subject: [PATCH] kernel/rcupdate.c: add generic rcu statistics

The patch adds a generic file to debugfs that contains a statistic about
the performance of the rcu subsystem.
The code adds a noticeable overhead, thus do not enable it unless you
are interested in measuring the rcu performance.

The patch is a hack, for example it doesn't differentiate between
call_rcu() and call_rcu_bh()

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

---
 include/linux/rcupdate.h |   24 ++++++++
 init/Kconfig             |    9 +++
 kernel/rcuclassic.c      |    6 +-
 kernel/rcupdate.c        |  133 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcupreempt.c      |    6 +-
 5 files changed, 172 insertions(+), 6 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 69c81e2..fa23572 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -49,6 +49,9 @@
  */
 struct rcu_head {
 	struct rcu_head *next;
+#ifdef CONFIG_RCU_BENCHMARK
+	unsigned long long time;
+#endif
 	void (*func)(struct rcu_head *head);
 };
 
@@ -66,6 +69,27 @@ struct rcu_head {
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+#ifdef CONFIG_RCU_BENCHMARK
+extern void rcu_mark_start(struct rcu_head *head);
+extern void rcu_mark_completed(struct rcu_head *head);
+#endif
+
+static inline void rcu_inithead(struct rcu_head *head, void (*func)(struct rcu_head *head))
+{
+	head->func = func;
+#ifdef CONFIG_RCU_BENCHMARK
+	rcu_mark_start(head);
+#endif
+}
+
+static inline void rcu_callback(struct rcu_head *head)
+{
+#ifdef CONFIG_RCU_BENCHMARK
+	rcu_mark_completed(head);
+#endif
+	head->func(head);
+}
+
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
diff --git a/init/Kconfig b/init/Kconfig
index 2227bad..ceeec8c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -924,6 +924,15 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+config RCU_BENCHMARK
+	bool
+	default y
+	depends on STOP_MACHINE
+	help
+	  This option adds per-rcu head statistics about the latency
+	  of the rcu callbacks.
+	  If unsure, say N.
+
 config STATE_RCU
 	bool
 	default y
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index e14e6b2..6774fcf 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -261,7 +261,7 @@ void call_rcu(struct rcu_head *head,
 {
 	unsigned long flags;
 
-	head->func = func;
+	rcu_inithead(head, func);
 	local_irq_save(flags);
 	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
 	local_irq_restore(flags);
@@ -289,7 +289,7 @@ void call_rcu_bh(struct rcu_head *head,
 {
 	unsigned long flags;
 
-	head->func = func;
+	rcu_inithead(head, func);
 	local_irq_save(flags);
 	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
 	local_irq_restore(flags);
@@ -343,7 +343,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
-		list->func(list);
+		rcu_callback(list);
 		list = next;
 		if (++count >= rdp->blimit)
 			break;
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ad63af8..1b4eca5 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,6 +44,9 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/stop_machine.h>
 
 enum rcu_barrier {
 	RCU_BARRIER_STD,
@@ -163,6 +166,136 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
+#ifdef CONFIG_RCU_BENCHMARK
+
+DEFINE_PER_CPU(unsigned long long, rcu_time_entries);
+DEFINE_PER_CPU(unsigned long long, rcu_time_val);
+DEFINE_PER_CPU(unsigned long long, rcu_time_square);
+
+#define RCU_TIME_SCALING	1000
+
+void rcu_mark_start(struct rcu_head *head)
+{
+	struct timespec tv;
+
+	getnstimeofday(&tv);
+
+	head->time = tv.tv_sec;
+	head->time *= NSEC_PER_SEC;
+	head->time += tv.tv_nsec;
+}
+static DEFINE_RATELIMIT_STATE(rcumark_rs, DEFAULT_RATELIMIT_INTERVAL,
+				DEFAULT_RATELIMIT_BURST);
+void rcu_mark_completed(struct rcu_head *head)
+{
+	unsigned long flags;
+	struct timespec tv;
+	unsigned long long now;
+
+	getnstimeofday(&tv);
+	now = tv.tv_sec;
+	now *= NSEC_PER_SEC;
+	now += tv.tv_nsec;
+	now -= head->time;
+	/* safety check, against uninitialized rcu heads */
+	WARN_ON_RATELIMIT(now > 600*NSEC_PER_SEC, &rcumark_rs);
+
+	now /= RCU_TIME_SCALING;
+	local_irq_save(flags);
+	__get_cpu_var(rcu_time_entries)++;
+	__get_cpu_var(rcu_time_val) += now;
+	now = now*now;
+	__get_cpu_var(rcu_time_square) += now;
+	local_irq_restore(flags);
+}
+
+#define RCUMARK_BUFSIZE (256*NR_CPUS)
+
+static char rcumark_buf[RCUMARK_BUFSIZE];
+static DEFINE_MUTEX(rcumark_mutex);
+
+static ssize_t rcumark_read(struct file *filp, char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	int i;
+	ssize_t bcount;
+	char *buf = rcumark_buf;
+	char *ebuf = &rcumark_buf[RCUMARK_BUFSIZE];
+	unsigned long long entries, val, square;
+
+	mutex_lock(&rcumark_mutex);
+
+	entries = val = square = 0;
+	for_each_possible_cpu(i) {
+		buf += snprintf(buf, ebuf - buf,
+			"rcu: cpu %d completed=%Ld  val=%Ld square %Ld\n",
+			i, per_cpu(rcu_time_entries, i),
+			per_cpu(rcu_time_val, i), per_cpu(rcu_time_square, i));
+		entries += per_cpu(rcu_time_entries, i);
+		val += per_cpu(rcu_time_val, i);
+		square += per_cpu(rcu_time_square, i);
+	}
+	buf += snprintf(buf, ebuf - buf, "total: completed=%Ld  val=%Ld square %Ld (scale %d)\n",
+			entries, val, square, RCU_TIME_SCALING);
+
+	/* avg */
+	val = val/entries;
+	square = int_sqrt(square/entries - val*val);
+	buf += snprintf(buf, ebuf - buf, "total: avg=%Ld stddev=%Ld steps/sec %ld\n",
+			val, square, NSEC_PER_SEC/RCU_TIME_SCALING);
+
+	bcount = simple_read_from_buffer(buffer, count, ppos,
+			rcumark_buf, strlen(rcumark_buf));
+	mutex_unlock(&rcumark_mutex);
+	return bcount;
+}
+
+static int __rcumark_reset(void *unused)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		per_cpu(rcu_time_entries, i) = 0;
+		per_cpu(rcu_time_val, i) = 0;
+		per_cpu(rcu_time_square, i) = 0;
+	}
+	return 0;
+}
+
+static ssize_t rcumark_write(struct file *filp, const char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	mutex_lock(&rcumark_mutex);
+	stop_machine(__rcumark_reset, NULL, NULL);
+	mutex_unlock(&rcumark_mutex);
+
+	return count;
+}
+
+static struct file_operations rcumark_fops = {
+	.owner = THIS_MODULE,
+	.read = rcumark_read,
+	.write = rcumark_write
+};
+
+static struct dentry *rcudir, *mdata;
+
+static int __init rcu_mark_init(void)
+{
+	rcudir = debugfs_create_dir("rcumark", NULL);
+	if (!rcudir)
+		goto out;
+	mdata = debugfs_create_file("markdata", 0444, rcudir,
+						NULL, &rcumark_fops);
+
+out:
+	return 0;
+}
+
+module_init(rcu_mark_init);
+
+#endif /* CONFIG_RCU_BENCHMARK */
+
 void __init rcu_init(void)
 {
 	__rcu_init();
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 7a8849b..54326c0 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1100,7 +1100,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	spin_unlock_irqrestore(&rdp->lock, flags);
 	while (list) {
 		next = list->next;
-		list->func(list);
+		rcu_callback(list);
 		list = next;
 		RCU_TRACE_ME(rcupreempt_trace_invoke);
 	}
@@ -1111,7 +1111,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	unsigned long flags;
 	struct rcu_data *rdp;
 
-	head->func = func;
+	rcu_inithead(head, func);
 	head->next = NULL;
 	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
@@ -1130,7 +1130,7 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	struct rcu_data *rdp;
 	int wake_gp = 0;
 
-	head->func = func;
+	rcu_inithead(head, func);
 	head->next = NULL;
 	local_irq_save(flags);
 	rdp = RCU_DATA_ME();
-- 
1.5.6.5


--------------010103020806080306010305--
