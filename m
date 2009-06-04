Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZFDDLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZFDDLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZFDDLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:11:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:58416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZFDDLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,301,1241420400"; 
   d="scan'208";a="521624129"
Subject: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 11:11:30 +0800
Message-Id: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-implement MCE log ring buffer as per-CPU ring buffer for better
scalability. Basic design is as follow:

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
 arch/x86/include/asm/mce.h       |   17 +-
 arch/x86/kernel/cpu/mcheck/mce.c |  277 ++++++++++++++++++++++++---------------
 2 files changed, 183 insertions(+), 111 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -52,20 +52,27 @@ struct mce {
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
 	unsigned pad0;
-	struct mce entry[MCE_LOG_LEN];
+	struct mce_log_cpu *mcelog_cpus;
 };
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
-#define MCE_LOG_SIGNATURE	"MACHINECHECK"
+#define MCE_LOG_SIGNATURE	"MACHINECHEC2"
 
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -55,6 +55,9 @@ int				mce_disabled;
 
 #define MISC_MCELOG_MINOR	227
 
+/* Timeout log reader to wait writer to finish */
+#define WRITER_TIMEOUT_NS	NSEC_PER_MSEC
+
 atomic_t mce_entry;
 
 /*
@@ -110,42 +113,50 @@ static struct mce_log mcelog = {
 	MCE_LOG_LEN,
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
 	set_bit(0, &notify_user);
 }
 
@@ -175,22 +186,38 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *backup, u64 start)
+static int mce_print_cpu(int cpu, struct mce *backup, u64 start)
 {
 	int i;
+	struct mce_log_cpu *mcelog_cpu;
 
-	bust_spinlocks(1);
-	console_verbose();
+	mcelog_cpu = &__get_cpu_var(mce_log_cpus);
 	for (i = 0; i < MCE_LOG_LEN; i++) {
-		u64 tsc = mcelog.entry[i].tsc;
+		u64 tsc = mcelog_cpu->entry[i].tsc;
 
 		if ((s64)(tsc - start) < 0)
 			continue;
-		print_mce(&mcelog.entry[i]);
-		if (backup && mcelog.entry[i].tsc == backup->tsc)
+		print_mce(&mcelog_cpu->entry[i]);
+		if (backup && mcelog_cpu->entry[i].tsc == backup->tsc)
 			backup = NULL;
 	}
-	if (backup)
+	return backup == NULL;
+}
+
+static void mce_panic(char *msg, struct mce *backup, u64 start)
+{
+	int cpu, cpu_self;
+
+	bust_spinlocks(1);
+	console_verbose();
+	cpu_self = smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (cpu == cpu_self)
+			continue;
+		if (mce_print_cpu(cpu, backup, start))
+			backup = NULL;
+	}
+	if (!mce_print_cpu(cpu_self, backup, start))
 		print_mce(backup);
 	panic(msg);
 }
@@ -642,6 +669,16 @@ static int mce_cap_init(void)
 	return 0;
 }
 
+/*
+ * Initialize MCE per-CPU log buffer
+ */
+static __cpuinit void mce_log_init(void)
+{
+	if (mcelog.mcelog_cpus)
+		return;
+	mcelog.mcelog_cpus = &per_cpu_var(mce_log_cpus);
+}
+
 static void mce_init(void)
 {
 	mce_banks_t all_banks;
@@ -771,6 +808,7 @@ void __cpuinit mcheck_init(struct cpuinf
 		mce_disabled = 1;
 		return;
 	}
+	mce_log_init();
 	mce_cpu_quirks(c);
 
 	machine_check_vector = do_machine_check;
@@ -819,94 +857,121 @@ static int mce_release(struct inode *ino
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
-
-static DEFINE_MUTEX(mce_read_mutex);
-
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
-			loff_t *off)
-{
-	char __user *buf = ubuf;
-	unsigned long *cpu_tsc;
-	unsigned prev, next;
-	int i, err;
+	head = mcelog_cpu->head;
+	tail = mcelog_cpu->tail;
 
-	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
-	if (!cpu_tsc)
-		return -ENOMEM;
-
-	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
-
-	/* Only supports full reads right now */
-	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
-
-		return -EINVAL;
-	}
-
-	err = 0;
-	prev = 0;
-	do {
-		for (i = prev; i < next; i++) {
-			unsigned long start = jiffies;
+	if (head == tail)
+		return 0;
 
-			while (!mcelog.entry[i].finished) {
-				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
+	for (pos = tail; pos != head && usize >= sizeof(struct mce);
+	     pos = pos == MCE_LOG_LIMIT ? 0 : pos+1) {
+		i = mce_log_index(pos);
+		if (!mcelog_cpu->entry[i].finished) {
+			int timeout = WRITER_TIMEOUT_NS;
+			while (!mcelog_cpu->entry[i].finished) {
+				if (timeout-- <= 0) {
+					memset(mcelog_cpu->entry + i, 0,
 					       sizeof(struct mce));
+					head = mcelog_cpu->head;
+					printk(KERN_WARNING "mcelog: timeout "
+					       "waiting for writer to finish!\n");
 					goto timeout;
 				}
-				cpu_relax();
+				ndelay(1);
 			}
-			smp_rmb();
-			err |= copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
-			buf += sizeof(struct mce);
-timeout:
-			;
 		}
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
+
+	return err ? -EFAULT : ubuf - inubuf;
+}
 
-		memset(mcelog.entry + prev, 0,
-		       (next - prev) * sizeof(struct mce));
-		prev = next;
-		next = cmpxchg(&mcelog.next, prev, 0);
-	} while (next != prev);
+static int mce_empty_cpu(struct mce_log_cpu *mcelog_cpu)
+{
+	int head, tail;
 
-	synchronize_sched();
+	head = mcelog_cpu->head;
+	tail = mcelog_cpu->tail;
 
-	/*
-	 * Collect entries that were still getting written before the
-	 * synchronize.
-	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1);
+	return head == tail;
+}
 
-	for (i = next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |= copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
-			smp_rmb();
-			buf += sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
-		}
+static int mce_empty(void)
+{
+	int cpu;
+	struct mce_log_cpu *mcelog_cpu;
+
+	for_each_possible_cpu(cpu) {
+		mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
+		if (!mce_empty_cpu(mcelog_cpu))
+			return 0;
 	}
-	mutex_unlock(&mce_read_mutex);
-	kfree(cpu_tsc);
+	return 1;
+}
 
-	return err ? -EFAULT : buf - ubuf;
+static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
+			loff_t *off)
+{
+	char __user *ubuf = inubuf;
+	struct mce_log_cpu *mcelog_cpu;
+	int cpu, new_mce, err = 0;
+	static DEFINE_MUTEX(mce_read_mutex);
+
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
+		}
+		if (need_resched()) {
+			mutex_unlock(&mce_read_mutex);
+			cond_resched();
+			mutex_lock(&mce_read_mutex);
+		}
+	} while (new_mce || !mce_empty());
+out:
+	mutex_unlock(&mce_read_mutex);
+	return err ? : ubuf - inubuf;
 }
 
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (!mce_empty())
 		return POLLIN | POLLRDNORM;
 	return 0;
 }


