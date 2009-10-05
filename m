Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZJEGjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZJEGjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbZJEGjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:39:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53626 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZJEGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:39:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99483.7020100@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:38:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On larger systems the global 32 size buffer for mcelog easily overflow,
lose events.  And there's a known livelock, now hit by more people,
under high error rate.

This patch fixes these issues by making MCE log buffer to per-CPU:

  + MCEs are added to corresponding local per-CPU buffer, instead of
    one big global buffer.  Contention/unfairness between CPUs is
    eliminated.

Reader/Writer convention is unchanged (= Lock-less for writer side):

  + MCE log writer may come from NMI, so the writer side must be
    lock-less.  For per-CPU buffer of one CPU, writers may come from
    process, IRQ or NMI context, so cmpxchg_local() is used to allocate
    buffer space.

  + MCE records are read out and removed from per-CPU buffers by mutex
    protected global reader function.  Because there are no many
    readers in system to contend in most cases.  In other words,
    reader side is protected with a mutex to guarantee only one reader
    is active in the whole system.

As the result now each CPU has its local 32 size buffer.

HS: Add a member header_len to struct mce_log to help debugger to know
    where the array of record is.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h       |   37 ++++++----
 arch/x86/kernel/cpu/mcheck/mce.c |  139 +++++++++++++++++++++++++++-----------
 2 files changed, 120 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 2f1c0ef..c5d4144 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -52,7 +52,7 @@
 #define MCE_INJ_NMI_BROADCAST	(1 << 2)	/* do NMI broadcasting */
 #define MCE_INJ_EXCEPTION	(1 << 3)	/* raise as exception */
 
-/* Fields are zero when not available */
+/* MCE log entry. Fields are zero when not available. */
 struct mce {
 	__u64 status;
 	__u64 misc;
@@ -63,12 +63,12 @@ struct mce {
 	__u64 time;	/* wall time_t when error was detected */
 	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
 	__u8  inject_flags;	/* software inject flags */
-	__u16  pad;
+	__u16 pad;
 	__u32 cpuid;	/* CPUID 1 EAX */
-	__u8  cs;		/* code segment */
+	__u8  cs;	/* code segment */
 	__u8  bank;	/* machine check bank */
 	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
-	__u8  finished;   /* entry is valid */
+	__u8  finished;	/* 1 if write to entry is finished & entry is valid */
 	__u32 extcpu;	/* linux cpu number that detected the error */
 	__u32 socketid;	/* CPU socket ID */
 	__u32 apicid;	/* CPU initial apic ID */
@@ -76,26 +76,33 @@ struct mce {
 };
 
 /*
- * This structure contains all data related to the MCE log.  Also
- * carries a signature to make it easier to find from external
- * debugging tools.  Each entry is only valid when its finished flag
- * is set.
+ * This structure contains all data related to the MCE log.  Also carries
+ * a signature to make it easier to find from external debugging tools.
+ * Each entry is only valid when its finished flag is set.
  */
 
-#define MCE_LOG_LEN 32
+#define MCE_LOG_LEN		32
+
+struct mce_log_cpu;
 
 struct mce_log {
-	char signature[12]; /* "MACHINECHECK" */
-	unsigned len;	    /* = MCE_LOG_LEN */
-	unsigned next;
+	char signature[12];		/* "MACHINECHEC2" */
+
+	/* points the table of per-CPU buffers */
+	struct mce_log_cpu **mcelog_cpus;
+	unsigned int nr_mcelog_cpus;	/* = num_possible_cpus() */
+
+	/* spec of per-CPU buffer */
+	unsigned int header_len; 	/* offset of array "entry" */
+	unsigned int nr_record;		/* array size (= MCE_LOG_LEN) */
+	unsigned int record_len;	/* length of struct mce */
+
 	unsigned flags;
-	unsigned recordlen;	/* length of struct mce */
-	struct mce entry[MCE_LOG_LEN];
 };
 
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
 
-#define MCE_LOG_SIGNATURE	"MACHINECHECK"
+#define MCE_LOG_SIGNATURE	"MACHINECHEC2"
 
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 684b42e..ad2eb89 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -122,21 +122,30 @@ EXPORT_PER_CPU_SYMBOL_GPL(mce_fake_banks);
  * separate MCEs from kernel messages to avoid bogus bug reports.
  */
 
+struct mce_log_cpu {
+	unsigned next;
+	struct mce entry[MCE_LOG_LEN];
+};
+
+DEFINE_PER_CPU(struct mce_log_cpu, mce_log_cpus);
+
 static struct mce_log mcelog = {
 	.signature	= MCE_LOG_SIGNATURE,
-	.len		= MCE_LOG_LEN,
-	.recordlen	= sizeof(struct mce),
+	.header_len	= offsetof(struct mce_log_cpu, entry),
+	.nr_record	= MCE_LOG_LEN,
+	.record_len	= sizeof(struct mce),
 };
 
 void mce_log(struct mce *mce)
 {
+	struct mce_log_cpu *mcelog_cpu = &__get_cpu_var(mce_log_cpus);
 	unsigned next, entry;
 
 	mce->finished = 0;
 	wmb();
 
 	do {
-		entry = rcu_dereference(mcelog.next);
+		entry = mcelog_cpu->next;
 		for (;;) {
 			/*
 			 * When the buffer fills up discard new entries.
@@ -149,7 +158,7 @@ void mce_log(struct mce *mce)
 				return;
 			}
 			/* Old left over entry. Skip: */
-			if (mcelog.entry[entry].finished) {
+			if (mcelog_cpu->entry[entry].finished) {
 				entry++;
 				continue;
 			}
@@ -157,12 +166,12 @@ void mce_log(struct mce *mce)
 		}
 		smp_rmb();
 		next = entry + 1;
-	} while (cmpxchg(&mcelog.next, entry, next) != entry);
+	} while (cmpxchg_local(&mcelog_cpu->next, entry, next) != entry);
 
-	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
+	memcpy(mcelog_cpu->entry + entry, mce, sizeof(struct mce));
 
 	wmb();
-	mcelog.entry[entry].finished = 1;
+	mcelog_cpu->entry[entry].finished = 1;
 	wmb();
 	mce->finished = 1;
 	set_bit(0, &mce_need_notify);
@@ -210,6 +219,26 @@ static void print_mce_tail(void)
 	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
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
@@ -232,7 +261,7 @@ static void wait_for_panic(void)
 
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
-	int i;
+	int cpu;
 
 	if (!fake_panic) {
 		/*
@@ -251,23 +280,12 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
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
@@ -1234,6 +1252,22 @@ static int __cpuinit mce_cap_init(void)
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
@@ -1404,6 +1438,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 		mce_disabled = 1;
 		return;
 	}
+	mce_log_init();
 
 	machine_check_vector = do_machine_check;
 
@@ -1452,13 +1487,16 @@ static int mce_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t mce_read_buf(char __user *inubuf, size_t usize)
+static ssize_t mce_read_cpu(int cpu, char __user *inubuf, size_t usize)
 {
+	struct mce_log_cpu *mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
 	char __user *ubuf = inubuf;
 	unsigned prev, next;
 	int i, err;
 
-	next = rcu_dereference(mcelog.next);
+	next = mcelog_cpu->next;
+	if (!next)
+		return 0;
 
 	err = 0;
 	prev = 0;
@@ -1466,9 +1504,9 @@ static ssize_t mce_read_buf(char __user *inubuf, size_t usize)
 		for (i = prev; i < next; i++) {
 			int timeout = WRITER_TIMEOUT_NS;
 
-			while (!mcelog.entry[i].finished) {
+			while (!mcelog_cpu->entry[i].finished) {
 				if (timeout-- <= 0) {
-					memset(mcelog.entry + i, 0,
+					memset(mcelog_cpu->entry + i, 0,
 					       sizeof(struct mce));
 					printk(KERN_WARNING "mcelog: timeout "
 					     "waiting for writer to finish!\n");
@@ -1477,27 +1515,33 @@ static ssize_t mce_read_buf(char __user *inubuf, size_t usize)
 				ndelay(1);
 			}
 			smp_rmb();
-			err |= copy_to_user(ubuf, mcelog.entry + i,
+			err |= copy_to_user(ubuf, mcelog_cpu->entry + i,
 					    sizeof(struct mce));
 			ubuf += sizeof(struct mce);
 timeout:
 			;
 		}
 
-		memset(mcelog.entry + prev, 0,
+		memset(mcelog_cpu->entry + prev, 0,
 		       (next - prev) * sizeof(struct mce));
 		prev = next;
-		next = cmpxchg(&mcelog.next, prev, 0);
+		next = cmpxchg(&mcelog_cpu->next, prev, 0);
 	} while (next != prev);
 
-	synchronize_sched();
-
 	return err ? -EFAULT : ubuf - inubuf;
 }
 
 static int mce_empty(void)
 {
-	return !rcu_dereference(mcelog.next);
+	int cpu;
+	struct mce_log_cpu *mcelog_cpu;
+
+	for_each_possible_cpu(cpu) {
+		mcelog_cpu = &per_cpu(mce_log_cpus, cpu);
+		if (mcelog_cpu->next)
+			return 0;
+	}
+	return 1;
 }
 
 static DEFINE_MUTEX(mce_read_mutex);
@@ -1506,7 +1550,7 @@ static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
 			loff_t *off)
 {
 	char __user *ubuf = inubuf;
-	int err;
+	int cpu, err = 0;
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < sizeof(struct mce) * MCE_LOG_LEN)
@@ -1514,12 +1558,25 @@ static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usize,
 
 	mutex_lock(&mce_read_mutex);
 
-	err = mce_read_buf(ubuf, usize);
-	if (err > 0) {
-		ubuf += err;
-		err = 0;
+	while (!mce_empty()) {
+		for_each_possible_cpu(cpu) {
+			if (usize < MCE_LOG_LEN * sizeof(struct mce))
+				goto out;
+			err = mce_read_cpu(cpu, ubuf, sizeof(struct mce));
+			if (err > 0) {
+				ubuf += sizeof(struct mce);
+				usize -= sizeof(struct mce);
+				err = 0;
+			} else if (err < 0)
+				goto out;
+		}
+		if (need_resched()) {
+			mutex_unlock(&mce_read_mutex);
+			cond_resched();
+			mutex_lock(&mce_read_mutex);
+		}
 	}
-
+out:
 	mutex_unlock(&mce_read_mutex);
 
 	return err ? err : ubuf - inubuf;
-- 
1.6.4.3


