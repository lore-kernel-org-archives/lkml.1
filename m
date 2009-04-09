Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbZDIRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbZDIRif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbZDIRhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:37:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:59330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765947AbZDIRhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:37:23 -0400
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Avi Kivity <avi@redhat.com>
In-Reply-To: <1239296031.21985.28.camel@twins>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
	 <1239292496.7647.607.camel@twins>
	 <20090409181404.71ac2988@osiris.boeblingen.de.ibm.com>
	 <20090409184834.7a0df7b2@osiris.boeblingen.de.ibm.com>
	 <1239296031.21985.28.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Apr 2009 19:38:54 +0200
Message-Id: <1239298734.21985.113.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 18:53 +0200, Peter Zijlstra wrote:

> I was looking at how an monitor-wait could be used here, but that
> appears non-trivial, there's two variables we're watching, lock->owner
> and rq->curr, either could change.
> 
> Reducing that to 1 seems an interesting problem :-)

How about something like this?

Does it make sense to implement an monitor-wait spinlock for the virt
case as well? Avi, Jeremy?

---
 arch/Kconfig                     |    3 +++
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/processor.h |   21 +++++++++++++++++++++
 include/linux/sched.h            |    2 ++
 kernel/mutex.h                   |    1 +
 kernel/sched.c                   |   27 ++++++++++++++++++++++++++-
 6 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dc81b34..67aa9f9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -109,3 +109,6 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_MUTEX_MWAIT
+	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2560fff..62d378b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_MUTEX_MWAIT
 
 config ARCH_DEFCONFIG
 	string
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7c39de7..c2617e4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -727,6 +727,27 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 		     :: "a" (eax), "c" (ecx));
 }
 
+#ifdef CONFIG_SMP
+static inline void mutex_spin_monitor(void *addr)
+{
+	if (!boot_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+		return;
+
+	__monitor(addr, 0, 0);
+	smp_mb();
+}
+
+static inline void mutex_spin_monitor_wait(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+		cpu_relax();
+		return;
+	}
+
+	__mwait(0, 0);
+}
+#endif
+
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25bdac7..87f945e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -342,7 +342,9 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
+
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern void mutex_spin_unlock(void);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex.h b/kernel/mutex.h
index 67578ca..c4d2d7a 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -25,6 +25,7 @@ static inline void mutex_set_owner(struct mutex *lock)
 static inline void mutex_clear_owner(struct mutex *lock)
 {
 	lock->owner = NULL;
+	mutex_spin_unlock();
 }
 #else
 static inline void mutex_set_owner(struct mutex *lock)
diff --git a/kernel/sched.c b/kernel/sched.c
index f2cf383..f15af61 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5184,6 +5184,28 @@ need_resched_nonpreemptible:
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_SMP
+
+#ifndef CONFIG_HAVE_MUTEX_MWAIT
+static inline void mutex_spin_monitor(void *addr)
+{
+}
+
+static inline void mutex_spin_monitor_wait(void)
+{
+	cpu_relax();
+}
+#endif
+
+void mutex_spin_unlock(void)
+{
+	/*
+	 * XXX fix the below to now require as many ins
+	 */
+	preempt_disable();
+	this_rq()->curr = current;
+	preempt_enable();
+}
+
 /*
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
@@ -5225,6 +5247,9 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 	rq = cpu_rq(cpu);
 
 	for (;;) {
+
+		mutex_spin_monitor(&rq->curr);
+
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
@@ -5237,7 +5262,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 		if (task_thread_info(rq->curr) != owner || need_resched())
 			return 0;
 
-		cpu_relax();
+		mutex_spin_monitor_wait();
 	}
 out:
 	return 1;

