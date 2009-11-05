Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZKEG6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZKEG6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbZKEG6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:58:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:60806 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbZKEG6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:58:10 -0500
Date: Thu, 5 Nov 2009 06:57:55 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090929122533.402715150@de.ibm.com>
References: <20090929122533.402715150@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] nohz: Introduce arch_needs_cpu
Message-ID: <tip-3c5d92a0cfb5103c0d5ab74d4ae6373d3af38148@git.kernel.org>
Git-Commit-ID: 3c5d92a0cfb5103c0d5ab74d4ae6373d3af38148
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c5d92a0cfb5103c0d5ab74d4ae6373d3af38148
Gitweb:     http://git.kernel.org/tip/3c5d92a0cfb5103c0d5ab74d4ae6373d3af38148
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Tue, 29 Sep 2009 14:25:16 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 5 Nov 2009 07:53:53 +0100

nohz: Introduce arch_needs_cpu

Allow the architecture to request a normal jiffy tick when the system
goes idle and tick_nohz_stop_sched_tick is called . On s390 the hook is
used to prevent the system going fully idle if there has been an
interrupt other than a clock comparator interrupt since the last wakeup.

On s390 the HiperSockets response time for 1 connection ping-pong goes
down from 42 to 34 microseconds. The CPU cost decreases by 27%.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20090929122533.402715150@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/include/asm/cputime.h |    8 ++++++++
 arch/s390/kernel/s390_ext.c     |    2 ++
 arch/s390/kernel/vtime.c        |    2 ++
 drivers/s390/cio/cio.c          |    1 +
 include/linux/tick.h            |    3 +++
 kernel/time/tick-sched.c        |   13 ++++++++-----
 6 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 24b1244..95f3561 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -183,6 +183,7 @@ struct s390_idle_data {
 	unsigned long long idle_count;
 	unsigned long long idle_enter;
 	unsigned long long idle_time;
+	int nohz_delay;
 };
 
 DECLARE_PER_CPU(struct s390_idle_data, s390_idle);
@@ -198,4 +199,11 @@ static inline void s390_idle_check(void)
 		vtime_start_cpu();
 }
 
+static inline int s390_nohz_delay(int cpu)
+{
+	return per_cpu(s390_idle, cpu).nohz_delay != 0;
+}
+
+#define arch_needs_cpu(cpu) s390_nohz_delay(cpu)
+
 #endif /* _S390_CPUTIME_H */
diff --git a/arch/s390/kernel/s390_ext.c b/arch/s390/kernel/s390_ext.c
index 0de305b..59618bc 100644
--- a/arch/s390/kernel/s390_ext.c
+++ b/arch/s390/kernel/s390_ext.c
@@ -126,6 +126,8 @@ void __irq_entry do_extint(struct pt_regs *regs, unsigned short code)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
 	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
+	if (code != 0x1004)
+		__get_cpu_var(s390_idle).nohz_delay = 1;
         index = ext_hash(code);
 	for (p = ext_int_hash[index]; p; p = p->next) {
 		if (likely(p->code == code))
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index c41bb0d..b59a812 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -167,6 +167,8 @@ void vtime_stop_cpu(void)
 	/* Wait for external, I/O or machine check interrupt. */
 	psw.mask = psw_kernel_bits | PSW_MASK_WAIT | PSW_MASK_IO | PSW_MASK_EXT;
 
+	idle->nohz_delay = 0;
+
 	/* Check if the CPU timer needs to be reprogrammed. */
 	if (vq->do_spt) {
 		__u64 vmax = VTIMER_MAX_SLICE;
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 138124f..126f240 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -618,6 +618,7 @@ void __irq_entry do_IRQ(struct pt_regs *regs)
 	old_regs = set_irq_regs(regs);
 	s390_idle_check();
 	irq_enter();
+	__get_cpu_var(s390_idle).nohz_delay = 1;
 	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0482229..8dc0821 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -98,6 +98,9 @@ extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
 extern void tick_check_idle(int cpu);
 extern int tick_oneshot_mode_active(void);
+#  ifndef arch_needs_cpu
+#   define arch_needs_cpu(cpu) (0)
+#  endif
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7378e2c..3840f6d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -264,12 +264,15 @@ void tick_nohz_stop_sched_tick(int inidle)
 		last_jiffies = jiffies;
 	} while (read_seqretry(&xtime_lock, seq));
 
-	/* Get the next timer wheel timer */
-	next_jiffies = get_next_timer_interrupt(last_jiffies);
-	delta_jiffies = next_jiffies - last_jiffies;
-
-	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu))
+	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
+	    arch_needs_cpu(cpu)) {
+		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
+	} else {
+		/* Get the next timer wheel timer */
+		next_jiffies = get_next_timer_interrupt(last_jiffies);
+		delta_jiffies = next_jiffies - last_jiffies;
+	}
 	/*
 	 * Do not stop the tick, if we are only one off
 	 * or if the cpu is required for rcu
