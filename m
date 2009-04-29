Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZD2HYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZD2HYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZD2HYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:24:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:51644 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZD2HYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,265,1239001200"; 
   d="asc'?scan'208";a="137139425"
Subject: [PATCH -v3] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PzabbQWdwLYSxaLIU6pM"
Date: Wed, 29 Apr 2009 15:24:41 +0800
Message-Id: <1240989881.6842.1213.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PzabbQWdwLYSxaLIU6pM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

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
    tail % MCE_LOG_LEN. If buffer is empty, head =3D=3D tail, if buffer is
    full, head % MCE_LOG_LEN =3D=3D tail % MCE_LOG_LEN and head !=3D tail.

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
 arch/x86/include/asm/mce.h          |   17 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |  258 ++++++++++++++++++++++---------=
-----
 2 files changed, 172 insertions(+), 103 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -50,20 +50,27 @@ struct mce {
  * is set.
  */
=20
-#define MCE_LOG_LEN 32
+#define MCE_LOG_LEN		32
+#define MCE_LOG_LIMIT		(MCE_LOG_LEN * 2 - 1)
+
+static inline int mce_log_index(int n)
+{
+	return n >=3D MCE_LOG_LEN ? n - MCE_LOG_LEN : n;
+}
+
+struct mce_log_cpu;
=20
 struct mce_log {
-	char signature[12]; /* "MACHINECHECK" */
+	char signature[12]; /* "MACHINECHEC2" */
 	unsigned len;	    /* =3D MCE_LOG_LEN */
-	unsigned next;
 	unsigned flags;
 	unsigned pad0;
-	struct mce entry[MCE_LOG_LEN];
+	struct mce_log_cpu *mcelog_cpus;
 };
=20
 #define MCE_OVERFLOW 0		/* bit 0 in flags means overflow */
=20
-#define MCE_LOG_SIGNATURE	"MACHINECHECK"
+#define MCE_LOG_SIGNATURE	"MACHINECHEC2"
=20
 #define MCE_GET_RECORD_LEN   _IOR('M', 1, int)
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -38,6 +38,9 @@
=20
 #define MISC_MCELOG_MINOR 227
=20
+/* Timeout log reader to wait writer to finish */
+#define WRITER_TIMEOUT_NS	NSEC_PER_MSEC
+
 atomic_t mce_entry;
=20
 static int mce_dont_init;
@@ -86,38 +89,44 @@ static struct mce_log mcelog =3D {
 	MCE_LOG_LEN,
 };
=20
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
+	struct mce_log_cpu *mcelog_cpu =3D &__get_cpu_var(mce_log_cpus);
+	int head, ihead, tail, next;
+
 	atomic_inc(&mce_events);
 	mce->finished =3D 0;
-	wmb();
-	for (;;) {
-		entry =3D rcu_dereference(mcelog.next);
-		for (;;) {
-			/* When the buffer fills up discard new entries. Assume
-			   that the earlier errors are the more interesting. */
-			if (entry >=3D MCE_LOG_LEN) {
-				set_bit(MCE_OVERFLOW, (unsigned long *)&mcelog.flags);
-				return;
-			}
-			/* Old left over entry. Skip. */
-			if (mcelog.entry[entry].finished) {
-				entry++;
-				continue;
-			}
-			break;
+	/* mce->finished must be set to 0 before written to ring
+	 * buffer */
+	smp_wmb();
+	do {
+		head =3D mcelog_cpu->head;
+		tail =3D mcelog_cpu->tail;
+		ihead =3D mce_log_index(head);
+		/* When the buffer fills up discard new entries. Assume
+		   that the earlier errors are the more interesting. */
+		if (ihead =3D=3D mce_log_index(tail) && head !=3D tail) {
+			set_bit(MCE_OVERFLOW, &mcelog_cpu->flags);
+			return;
 		}
-		smp_rmb();
-		next =3D entry + 1;
-		if (cmpxchg(&mcelog.next, entry, next) =3D=3D entry)
-			break;
-	}
-	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
-	wmb();
-	mcelog.entry[entry].finished =3D 1;
-	wmb();
-
+		next =3D head =3D=3D MCE_LOG_LIMIT ? 0 : head + 1;
+	} while (cmpxchg_local(&mcelog_cpu->head, head, next) !=3D head);
+	memcpy(mcelog_cpu->entry + ihead, mce, sizeof(struct mce));
+	/* ".finished" of MCE record in ring buffer must be set after
+	 * copy */
+	smp_wmb();
+	mcelog_cpu->entry[ihead].finished =3D 1;
+	/* bit 0 of notify_user should be set after finished be set */
+	smp_wmb();
 	set_bit(0, &notify_user);
 }
=20
@@ -147,21 +156,37 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
=20
-static void mce_panic(char *msg, struct mce *backup, unsigned long start)
+static int mce_print_cpu(int cpu, struct mce *backup, unsigned long start)
 {
 	int i;
+	struct mce_log_cpu *mcelog_cpu;
=20
-	oops_begin();
+	mcelog_cpu =3D &__get_cpu_var(mce_log_cpus);
 	for (i =3D 0; i < MCE_LOG_LEN; i++) {
-		unsigned long tsc =3D mcelog.entry[i].tsc;
+		unsigned long tsc =3D mcelog_cpu->entry[i].tsc;
=20
 		if (time_before(tsc, start))
 			continue;
-		print_mce(&mcelog.entry[i]);
-		if (backup && mcelog.entry[i].tsc =3D=3D backup->tsc)
+		print_mce(&mcelog_cpu->entry[i]);
+		if (backup && mcelog_cpu->entry[i].tsc =3D=3D backup->tsc)
+			backup =3D NULL;
+	}
+	return backup =3D=3D NULL;
+}
+
+static void mce_panic(char *msg, struct mce *backup, u64 start)
+{
+	int cpu, cpu_self;
+
+	oops_begin();
+	cpu_self =3D smp_processor_id();
+	for_each_online_cpu(cpu) {
+		if (cpu =3D=3D cpu_self)
+			continue;
+		if (mce_print_cpu(cpu, backup, start))
 			backup =3D NULL;
 	}
-	if (backup)
+	if (!mce_print_cpu(cpu_self, backup, start))
 		print_mce(backup);
 	panic(msg);
 }
@@ -574,6 +599,16 @@ static int mce_cap_init(void)
 	return 0;
 }
=20
+/*
+ * Initialize MCE per-CPU log buffer
+ */
+static __cpuinit void mce_log_init(void)
+{
+	if (mcelog.mcelog_cpus)
+		return;
+	mcelog.mcelog_cpus =3D &per_cpu_var(mce_log_cpus);
+}
+
 static void mce_init(void *dummy)
 {
 	u64 cap;
@@ -656,6 +691,7 @@ void __cpuinit mcheck_init(struct cpuinf
 		mce_dont_init =3D 1;
 		return;
 	}
+	mce_log_init();
 	mce_cpu_quirks(c);
=20
 	mce_init(NULL);
@@ -704,90 +740,116 @@ static int mce_release(struct inode *ino
 	return 0;
 }
=20
-static void collect_tscs(void *data)
-{
-	unsigned long *cpu_tsc =3D (unsigned long *)data;
-
-	rdtscll(cpu_tsc[smp_processor_id()]);
-}
-
-static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize=
,
-			loff_t *off)
+static ssize_t mce_read_cpu(struct mce_log_cpu *mcelog_cpu,
+			    char __user *inubuf, size_t usize)
 {
-	unsigned long *cpu_tsc;
-	static DEFINE_MUTEX(mce_read_mutex);
-	unsigned prev, next;
-	char __user *buf =3D ubuf;
-	int i, err;
-
-	cpu_tsc =3D kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
-	if (!cpu_tsc)
-		return -ENOMEM;
-
-	mutex_lock(&mce_read_mutex);
-	next =3D rcu_dereference(mcelog.next);
+	char __user *ubuf =3D inubuf;
+	int head, tail, pos, i, err =3D 0;
=20
-	/* Only supports full reads right now */
-	if (*off !=3D 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
-		return -EINVAL;
-	}
+	head =3D mcelog_cpu->head;
+	tail =3D mcelog_cpu->tail;
=20
-	err =3D 0;
-	prev =3D 0;
-	do {
-		for (i =3D prev; i < next; i++) {
-			unsigned long start =3D jiffies;
+	if (head =3D=3D tail)
+		return 0;
=20
-			while (!mcelog.entry[i].finished) {
-				if (time_after_eq(jiffies, start + 2)) {
-					memset(mcelog.entry + i, 0,
+	for (pos =3D tail; pos !=3D head && usize >=3D sizeof(struct mce);
+	     pos =3D pos =3D=3D MCE_LOG_LIMIT ? 0 : pos+1) {
+		i =3D mce_log_index(pos);
+		if (!mcelog_cpu->entry[i].finished) {
+			int timeout =3D WRITER_TIMEOUT_NS;
+			while (!mcelog_cpu->entry[i].finished) {
+				if (timeout-- <=3D 0) {
+					memset(mcelog_cpu->entry + i, 0,
 					       sizeof(struct mce));
+					head =3D mcelog_cpu->head;
+					printk(KERN_WARNING "mcelog: timeout "
+					       "waiting for writer to finish!\n");
 					goto timeout;
 				}
-				cpu_relax();
+				ndelay(1);
 			}
-			smp_rmb();
-			err |=3D copy_to_user(buf, mcelog.entry + i,
-					    sizeof(struct mce));
-			buf +=3D sizeof(struct mce);
-timeout:
-			;
 		}
+		/* finished field should be checked before
+		 * copy_to_user() */
+		smp_rmb();
+		err |=3D copy_to_user(ubuf, mcelog_cpu->entry + i,
+				   sizeof(struct mce));
+		ubuf +=3D sizeof(struct mce);
+		usize -=3D sizeof(struct mce);
+timeout:
+		;
+	}
+	/* mcelog_cpu->tail must be updated after corresponding MCE
+	 * records are copied out */
+	smp_wmb();
+	mcelog_cpu->tail =3D pos;
=20
-		memset(mcelog.entry + prev, 0,
-		       (next - prev) * sizeof(struct mce));
-		prev =3D next;
-		next =3D cmpxchg(&mcelog.next, prev, 0);
-	} while (next !=3D prev);
+	return err ? -EFAULT : ubuf - inubuf;
+}
=20
-	synchronize_sched();
+static int mce_empty_cpu(struct mce_log_cpu *mcelog_cpu)
+{
+	int head, tail;
=20
-	/*
-	 * Collect entries that were still getting written before the
-	 * synchronize.
-	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1);
-	for (i =3D next; i < MCE_LOG_LEN; i++) {
-		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
-			err |=3D copy_to_user(buf, mcelog.entry+i,
-					    sizeof(struct mce));
-			smp_rmb();
-			buf +=3D sizeof(struct mce);
-			memset(&mcelog.entry[i], 0, sizeof(struct mce));
-		}
+	head =3D mcelog_cpu->head;
+	tail =3D mcelog_cpu->tail;
+
+	return head =3D=3D tail;
+}
+
+static int mce_empty(void)
+{
+	int cpu;
+	struct mce_log_cpu *mcelog_cpu;
+
+	for_each_possible_cpu(cpu) {
+		mcelog_cpu =3D &per_cpu(mce_log_cpus, cpu);
+		if (!mce_empty_cpu(mcelog_cpu))
+			return 0;
 	}
+	return 1;
+}
+
+static ssize_t mce_read(struct file *filp, char __user *inubuf, size_t usi=
ze,
+			loff_t *off)
+{
+	char __user *ubuf =3D inubuf;
+	struct mce_log_cpu *mcelog_cpu;
+	int cpu, new_mce, err =3D 0;
+	static DEFINE_MUTEX(mce_read_mutex);
+
+	mutex_lock(&mce_read_mutex);
+	do {
+		new_mce =3D 0;
+		for_each_possible_cpu(cpu) {
+			if (usize < sizeof(struct mce))
+				goto out;
+			mcelog_cpu =3D &per_cpu(mce_log_cpus, cpu);
+			err =3D mce_read_cpu(mcelog_cpu, ubuf,
+					   sizeof(struct mce));
+			if (err > 0) {
+				ubuf +=3D sizeof(struct mce);
+				usize -=3D sizeof(struct mce);
+				new_mce =3D 1;
+				err =3D 0;
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
 	mutex_unlock(&mce_read_mutex);
-	kfree(cpu_tsc);
-	return err ? -EFAULT : buf - ubuf;
+	return err ? : ubuf - inubuf;
 }
=20
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (!mce_empty())
 		return POLLIN | POLLRDNORM;
 	return 0;
 }


--=-PzabbQWdwLYSxaLIU6pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn4ALYACgkQKhFGF+eHlpjBRQCfUY2tNSjB683cxdQf9UlbGX3f
dtEAn14fz82BSJhpKqtYvOg6c7ShnQhi
=BOKq
-----END PGP SIGNATURE-----

--=-PzabbQWdwLYSxaLIU6pM--

