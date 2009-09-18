Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZIRKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZIRKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZIRKUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:20:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:57357 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZIRKUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,408,1249282800"; 
   d="scan'208";a="189084673"
Subject: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 18:20:41 +0800
Message-Id: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MCE log ring buffer has following bugs and issues:

- On larger systems the 32 size buffer easily overflow, losing events.

- We had some reports of events getting corrupted which were also
  blamed on the ring buffer.

- There's a known livelock, now hit by more people, under high error
  rate.

We fix these bugs and issues via making MCE log ring buffer as
lock-less per-CPU ring buffer.

- One ring buffer for each CPU

  + MCEs are added to corresponding local per-CPU buffer, instead of
    one big global buffer. Contention/unfairness between CPUs is
    eleminated.

  + MCE records are read out and removed from per-CPU buffers by mutex
    protected global reader function. Because there are no many
    readers in system to contend in most cases.

- Per-CPU ring buffer data structure

  + An array is used to hold MCE records. integer "head" indicates
    next writing position and integer "tail" indicates next reading
    position.

  + To distinguish buffer empty and full, head and tail wrap to 0 at
    MCE_LOG_LIMIT instead of MCE_LOG_LEN. Then the real next writing
    position is head % MCE_LOG_LEN, and real next reading position is
    tail % MCE_LOG_LEN. If buffer is empty, head == tail, if buffer is
    full, head % MCE_LOG_LEN == tail % MCE_LOG_LEN and head != tail.

- Lock-less for writer side

  + MCE log writer may come from NMI, so the writer side must be
    lock-less. For per-CPU buffer of one CPU, writers may come from
    process, IRQ or NMI context, so "head" is increased with
    cmpxchg_local() to allocate buffer space.

  + Reader side is protected with a mutex to guarantee only one reader
    is active in the whole system.


Performance test show that the throughput of per-CPU mcelog buffer can
reach 430k records/s compared with 5.3k records/s for original
implementation on a 2-core 2.1GHz Core2 machine.


ChangeLog:

v7:

- Rebased on latest x86-tip.git/x86/mce

- Revise mce print code.

v6:

- Rebased on latest x86-tip.git/x86/mce + x86/tip

v5:

- Rebased on latest x86-tip.git/mce4.

- Fix parsing mce_log data structure in dumping kernel.

v4:

- Rebased on x86-tip.git x86/mce3 branch

- Fix a synchronization issue about mce.finished

- Fix comment style

v3:

- Use DEFINE_PER_CPU to allocate per_cpu mcelog buffer.

- Use cond_resched() to prevent possible system not reponsing issue
  for large user buffer.

v2:

- Use alloc_percpu() to allocate per_cpu mcelog buffer.

- Use ndelay to implement witer timeout.


Signed-off-by: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |   18 +-
 arch/x86/kernel/cpu/mcheck/mce.c |  295 +++++++++++++++++++++++----------------
 2 files changed, 190 insertions(+), 123 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -76,20 +76,28 @@ struct mce {
  * is set.
  */
 
-#define MCE_LOG_LEN 32
+#define MCE_LOG_LEN		32
+#define MCE_LOG_LIMIT		(MCE_LOG_LEN * 2 - 1)
+
+static inline int mce_log_index(int n)
+{
+	return n >= MCE_LOG_LEN ? n - MCE_LOG_LEN : n;
+}
+
+struct mce_log_cpu;
 
 struct mce_log {
-	char signature[12]; /* "MACHINECHECK" */
+	char signature[12]; /* "MACHINECHEC2" */
 	unsigned len;	    /* = MCE_LOG_LEN */
-	unsigned next;
 	unsigned flags;
 	unsigned recordlen;	/* length of struct mce */
-	struct mce entry[MCE_LOG_LEN];
+	unsigned nr_mcelog_cpus;
+	struct mce_log_cpu **mcelog_cpus;
 };
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
-#define MCE_LOG_SIGNATURE	"MACHINECHECK"
+#define MCE_LOG_SIGNATURE	"MACHINECHEC2"
 
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -52,6 +52,9 @@ int mce_disabled __read_mostly;
 
 #define SPINUNIT 100	/* 100ns */
 
+/* Timeout log reader to wait writer to finish */
+#define WRITER_TIMEOUT_NS	NSEC_PER_MSEC
+
 atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
@@ -125,42 +128,50 @@ static struct mce_log mcelog = {
 	.recordlen	= sizeof(struct mce),
 };
 
+struct mce_log_cpu {
+	int head;
+	int tail;
+	unsigned long flags;
+	struct mce entry[MCE_LOG_LEN];
+};
+
+DEFINE_PER_CPU(struct mce_log_cpu, mce_log_cpus);
+
 void mce_log(struct mce *mce)
 {
-	unsigned next, entry;
+	struct mce_log_cpu *mcelog_cpu = &__get_cpu_var(mce_log_cpus);
+	int head, ihead, tail, next;
 
 	mce->finished = 0;
-	wmb();
-	for (;;) {
-		entry = rcu_dereference(mcelog.next);
-		for (;;) {
-			/*
-			 * When the buffer fills up discard new entries.
-			 * Assume that the earlier errors are the more
-			 * interesting ones:
-			 */
-			if (entry >= MCE_LOG_LEN) {
-				set_bit(MCE_OVERFLOW,
-					(unsigned long *)&mcelog.flags);
-				return;
-			}
-			/* Old left over entry. Skip: */
-			if (mcelog.entry[entry].finished) {
-				entry++;
-				continue;
-			}
-			break;
+	/*
+	 * mce->finished must be set to 0 before written to ring
+	 * buffer
+	 */
+	smp_wmb();
+	do {
+		head = mcelog_cpu->head;
+		tail = mcelog_cpu->tail;
+		ihead = mce_log_index(head);
+		/*
+		 * When the buffer fills up discard new entries.
+		 * Assume that the earlier errors are the more
+		 * interesting.
+		 */
+		if (ihead == mce_log_index(tail) && head != tail) {
+			set_bit(MCE_OVERFLOW, &mcelog_cpu->flags);
+			return;
 		}
-		smp_rmb();
-		next = entry + 1;
-		if (cmpxchg(&mcelog.next, entry, next) == entry)
-			break;
-	}
-	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
-	wmb();
-	mcelog.entry[entry].finished = 1;
-	wmb();
-
+		next = head == MCE_LOG_LIMIT ? 0 : head + 1;
+	} while (cmpxchg_local(&mcelog_cpu->head, head, next) != head);
+	memcpy(mcelog_cpu->entry + ihead, mce, sizeof(struct mce));
+	/*
+	 * ".finished" of MCE record in ring buffer must be set after
+	 * copy
+	 */
+	smp_wmb();
+	mcelog_cpu->entry[ihead].finished = 1;
+	/* bit 0 of notify_user should be set after finished be set */
+	smp_wmb();
 	mce->finished = 1;
 	set_bit(0, &mce_need_notify);
 }
@@ -200,6 +211,26 @@ static void print_mce_tail(void)
 	       KERN_EMERG "Run through mcelog --ascii to decode and contact your hardware vendor\n");
 }
 
+static void print_mce_cpu(int cpu, struct mce *final, u64 mask, u64 res)
+{
+	int i;
+	struct mce_log_cpu *mcelog_cpu;
+
+	mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
+	for (i = 0; i < MCE_LOG_LEN; i++) {
+		struct mce *m = &mcelog_cpu->entry[i];
+		if (!m->finished)
+			continue;
+		if (!(m->status & MCI_STATUS_VAL))
+			continue;
+		if ((m->status & mask) != res)
+			continue;
+		if (final && !memcmp(m, final, sizeof(struct mce)))
+			continue;
+		print_mce(m);
+	}
+}
+
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
 static atomic_t mce_paniced;
@@ -222,7 +253,7 @@ static void wait_for_panic(void)
 
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
-	int i;
+	int cpu;
 
 	if (!fake_panic) {
 		/*
@@ -241,23 +272,12 @@ static void mce_panic(char *msg, struct 
 	}
 	print_mce_head();
 	/* First print corrected ones that are still unlogged */
-	for (i = 0; i < MCE_LOG_LEN; i++) {
-		struct mce *m = &mcelog.entry[i];
-		if (!(m->status & MCI_STATUS_VAL))
-			continue;
-		if (!(m->status & MCI_STATUS_UC))
-			print_mce(m);
-	}
-	/* Now print uncorrected but with the final one last */
-	for (i = 0; i < MCE_LOG_LEN; i++) {
-		struct mce *m = &mcelog.entry[i];
-		if (!(m->status & MCI_STATUS_VAL))
-			continue;
-		if (!(m->status & MCI_STATUS_UC))
-			continue;
-		if (!final || memcmp(m, final, sizeof(struct mce)))
-			print_mce(m);
-	}
+	for_each_online_cpu(cpu)
+		print_mce_cpu(cpu, final, MCI_STATUS_UC, 0);
+	/* Print uncorrected but without the final one */
+	for_each_online_cpu(cpu)
+		print_mce_cpu(cpu, final, MCI_STATUS_UC, MCI_STATUS_UC);
+	/* Finally print the final mce */
 	if (final)
 		print_mce(final);
 	if (cpu_missing)
@@ -1207,6 +1227,22 @@ static int __cpuinit mce_cap_init(void)
 	return 0;
 }
 
+/*
+ * Initialize MCE per-CPU log buffer
+ */
+static __cpuinit void mce_log_init(void)
+{
+	int cpu;
+
+	if (mcelog.mcelog_cpus)
+		return;
+	mcelog.nr_mcelog_cpus = num_possible_cpus();
+	mcelog.mcelog_cpus = kzalloc(sizeof(void *) * num_possible_cpus(),
+				     GFP_KERNEL);
+	for_each_possible_cpu(cpu)
+		mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
+}
+
 static void mce_init(void)
 {
 	mce_banks_t all_banks;
@@ -1367,6 +1403,7 @@ void __cpuinit mcheck_init(struct cpuinf
 		return;
 	}
 	mce_cpu_quirks(c);
+	mce_log_init();
 
 	machine_check_vector = do_machine_check;
 
@@ -1415,94 +1452,116 @@ static int mce_release(struct inode *ino
 	return 0;
 }
 
-static void collect_tscs(void *data)
+static ssize_t mce_read_cpu(struct mce_log_cpu *mcelog_cpu,
+			    char __user *inubuf, size_t usize)
 {
-	unsigned long *cpu_tsc = (unsigned long *)data;
+	char __user *ubuf = inubuf;
+	int head, tail, pos, i, err = 0;
 
-	rdtscll(cpu_tsc[smp_processor_id()]);
-}
+	head = mcelog_cpu->head;
+	tail = mcelog_cpu->tail;
 
-static DEFINE_MUTEX(mce_read_mutex);
+	if (head == tail)
+		return 0;
 
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
-{
-	char __user *buf = ubuf;
-	unsigned long *cpu_tsc;
-	unsigned prev, next;
-	int i, err;
+	for (pos = tail; pos != head && usize >= sizeof(struct mce);
+	     pos = pos == MCE_LOG_LIMIT ? 0 : pos+1) {
+		i = mce_log_index(pos);
+		if (!mcelog_cpu->entry[i].finished) {
+			int timeout = WRITER_TIMEOUT_NS;
+			while (!mcelog_cpu->entry[i].finished) {
+				if (timeout-- <= 0) {
+					memset(mcelog_cpu->entry + i, 0,
+					       sizeof(struct mce));
+					head = mcelog_cpu->head;
+					printk(KERN_WARNING "mcelog: timeout "
+					       "waiting for writer to finish!\n");
+					goto timeout;
+				}
+				ndelay(1);
+			}
+		}
+		/*
+		 * finished field should be checked before
+		 * copy_to_user()
+		 */
+		smp_rmb();
+		err |= copy_to_user(ubuf, mcelog_cpu->entry + i,
+				   sizeof(struct mce));
+		ubuf += sizeof(struct mce);
+		usize -= sizeof(struct mce);
+		mcelog_cpu->entry[i].finished = 0;
+timeout:
+		;
+	}
+	/*
+	 * mcelog_cpu->tail must be updated after ".finished" of
+	 * corresponding MCE records are clear.
+	 */
+	smp_wmb();
+	mcelog_cpu->tail = pos;
 
-	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
-	if (!cpu_tsc)
-		return -ENOMEM;
+	return err ? -EFAULT : ubuf - inubuf;
+}
 
-	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
+static int mce_empty_cpu(struct mce_log_cpu *mcelog_cpu)
+{
+	return mcelog_cpu->head == mcelog_cpu->tail;
+}
 
-	/* Only supports full reads right now */
-	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
+static int mce_empty(void)
+{
+	int cpu;
+	struct mce_log_cpu *mcelog_cpu;
 
-		return -EINVAL;
+	for_each_possible_cpu(cpu) {
+		mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
+		if (!mce_empty_cpu(mcelog_cpu))
+			return 0;
 	}
+	return 1;
+}
 
-	err = 0;
-	prev = 0;
-	do {
-		for (i = prev; i < next; i++) {
-			unsigned long start = jiffies;
+static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
+			loff_t *off)
+{
+	char __user *ubuf = inubuf;
+	struct mce_log_cpu *mcelog_cpu;
+	int cpu, new_mce, err = 0;
+	static DEFINE_MUTEX(mce_read_mutex);
 
-			while (!mcelog.entry[i].finished) {
-				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
-					       sizeof(struct mce));
-					goto timeout;
-				}
-				cpu_relax();
-			}
-			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
-			buf += sizeof(struct mce);
-timeout:
-			;
+	mutex_lock(&mce_read_mutex);
+	do {
+		new_mce = 0;
+		for_each_possible_cpu(cpu) {
+			if (usize < sizeof(struct mce))
+				goto out;
+			mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
+			err = mce_read_cpu(mcelog_cpu, ubuf,
+					   sizeof(struct mce));
+			if (err > 0) {
+				ubuf += sizeof(struct mce);
+				usize -= sizeof(struct mce);
+				new_mce = 1;
+				err = 0;
+			} else if (err < 0)
+				goto out;
 		}
-
-		memset(mcelog.entry + prev, 0,
-		       (next - prev) * sizeof(struct mce));
-		prev = next;
-		next = cmpxchg(&mcelog.next, prev, 0);
-	} while (next != prev);
-
-	synchronize_sched();
-
-	/*
-	 * Collect entries that were still getting written before the
-	 * synchronize.
-	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1);
-
-	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
-			smp_rmb();
-			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
+		if (need_resched()) {
+			mutex_unlock(&mce_read_mutex);
+			cond_resched();
+			mutex_lock(&mce_read_mutex);
 		}
-	}
+	} while (new_mce || !mce_empty());
+out:
 	mutex_unlock(&mce_read_mutex);
-	kfree(cpu_tsc);
-
-	return err ? -EFAULT : buf - ubuf;
+	return err ? err : ubuf - inubuf;
 }
 
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (!mce_empty())
 		return POLLIN | POLLRDNORM;
 	return 0;
 }


