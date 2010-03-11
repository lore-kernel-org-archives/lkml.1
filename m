Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0CKHSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:18:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:4132 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0CKHSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:18:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,618,1262592000"; 
   d="scan'208";a="548051658"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
Date: Thu, 11 Mar 2010 15:20:22 +0800
Message-Id: <1268292022-31352-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we can only get the cpu_stat of whole guest as one. This patch
enhanced cpu_stat with more detail, has guest_system and guest_user cpu time
statistics with a little overhead.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---

This draft patch based on KVM upstream to show the idea. I would split it into
more kernel friendly version later.

The overhead is, the cost of get_cpl() after each exit from guest.

Comments are welcome!

 arch/x86/kvm/x86.c          |   10 ++++++++++
 fs/proc/stat.c              |   22 ++++++++++++++++------
 include/linux/kernel_stat.h |    2 ++
 include/linux/kvm_host.h    |    1 +
 include/linux/sched.h       |    1 +
 kernel/sched.c              |    6 ++++++
 6 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 703f637..c8ea6e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4290,6 +4290,14 @@ static void inject_pending_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvm_update_guest_mode(struct kvm_vcpu *vcpu)
+{
+	int cpl = kvm_x86_ops->get_cpl(vcpu);
+
+	if (cpl != 0)
+		current->flags |= PF_VCPU_USER;
+}
+
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -4377,6 +4385,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	trace_kvm_entry(vcpu->vcpu_id);
 	kvm_x86_ops->run(vcpu);
 
+	kvm_update_guest_mode(vcpu);
+
 	/*
 	 * If the guest has used debug registers, at least dr7
 	 * will be disabled while returning to the host.
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index b9b7aad..d07640a 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,7 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest, guest_nice;
+	cputime64_t guest, guest_nice, guest_user, guest_system;
 	u64 sum = 0;
 	u64 sum_softirq = 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
@@ -36,7 +36,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
-	guest = guest_nice = cputime64_zero;
+	guest = guest_nice = guest_user = guest_system = cputime64_zero;
 	getboottime(&boottime);
 	jif = boottime.tv_sec;
 
@@ -53,6 +53,10 @@ static int show_stat(struct seq_file *p, void *v)
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		guest_nice = cputime64_add(guest_nice,
 			kstat_cpu(i).cpustat.guest_nice);
+		guest_user = cputime64_add(guest_user,
+			kstat_cpu(i).cpustat.guest_user);
+		guest_system = cputime64_add(guest_system,
+			kstat_cpu(i).cpustat.guest_system);
 		for_each_irq_nr(j) {
 			sum += kstat_irqs_cpu(j, i);
 		}
@@ -68,7 +72,7 @@ static int show_stat(struct seq_file *p, void *v)
 	sum += arch_irq_stat();
 
 	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-		"%llu\n",
+		"%llu %llu %llu\n",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -78,7 +82,9 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(softirq),
 		(unsigned long long)cputime64_to_clock_t(steal),
 		(unsigned long long)cputime64_to_clock_t(guest),
-		(unsigned long long)cputime64_to_clock_t(guest_nice));
+		(unsigned long long)cputime64_to_clock_t(guest_nice),
+		(unsigned long long)cputime64_to_clock_t(guest_user),
+		(unsigned long long)cputime64_to_clock_t(guest_system));
 	for_each_online_cpu(i) {
 
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -93,9 +99,11 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kstat_cpu(i).cpustat.steal;
 		guest = kstat_cpu(i).cpustat.guest;
 		guest_nice = kstat_cpu(i).cpustat.guest_nice;
+		guest_user = kstat_cpu(i).cpustat.guest_user;
+		guest_system = kstat_cpu(i).cpustat.guest_system;
 		seq_printf(p,
 			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-			"%llu\n",
+			"%llu %llu %llu\n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -106,7 +114,9 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(softirq),
 			(unsigned long long)cputime64_to_clock_t(steal),
 			(unsigned long long)cputime64_to_clock_t(guest),
-			(unsigned long long)cputime64_to_clock_t(guest_nice));
+			(unsigned long long)cputime64_to_clock_t(guest_nice),
+			(unsigned long long)cputime64_to_clock_t(guest_user),
+			(unsigned long long)cputime64_to_clock_t(guest_system));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index c059044..e43b2f7 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -26,6 +26,8 @@ struct cpu_usage_stat {
 	cputime64_t steal;
 	cputime64_t guest;
 	cputime64_t guest_nice;
+	cputime64_t guest_user;
+	cputime64_t guest_system;
 };
 
 struct kernel_stat {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a3fd0f9..497e795 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -496,6 +496,7 @@ static inline void kvm_guest_exit(void)
 {
 	account_system_vtime(current);
 	current->flags &= ~PF_VCPU;
+	current->flags &= ~PF_VCPU_USER;
 }
 
 static inline gpa_t gfn_to_gpa(gfn_t gfn)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..49bf81d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1759,6 +1759,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_VCPU_USER	0x00000020	/* I'm a virtual CPU in usermode */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..9cfc288 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5092,6 +5092,12 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	} else {
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		if (p->flags & PF_VCPU_USER)
+			cpustat->guest_user =
+				cputime64_add(cpustat->guest_user, tmp);
+		else
+			cpustat->guest_system =
+				cputime64_add(cpustat->guest_system, tmp);
 	}
 }
 
-- 
1.7.0.1

