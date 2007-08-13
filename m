Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbXHMPq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbXHMPq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939916AbXHMOFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:05:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:16737 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945859AbXHMOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:05:45 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
Date: Mon, 13 Aug 2007 16:05:40 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, cotte@de.ibm.com
References: <46BC8B39.6050202@bull.net>
In-Reply-To: <46BC8B39.6050202@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131605.40479.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. August 2007 schrieb Laurent Vivier:
> The aim of these two patches is to measure the CPU time used by a virtual
> machine. All comments are welcome... I'm not sure it's the good way to do 
that.

I did something similar for or s390guest prototype, that Carsten posted in 
May.  I decided to account guest time to the user process instead of adding a 
new field to avoid hazzle with old top. As you can read in the patch comment, 
I personally prefer a new field if we can get one.

My implementation uses a similar mechanism like hard and softirq. So I have an 
sie_enter an sie_exit and a task_is_in_sie function - like irq_enter and 
irq_exit. The main difference is based on the fact, that s390 has precise 
accouting for irq, steal, user and system time, and therefore my patch is 
based on architecture specifc code using CONFIG_VIRT_CPU_ACCOUNT. 

In general my patch has the same idea as your patch, so I am going to review 
your patch and see if it would fit for s390.

For reference this is the (never posted) old patch for our virtualisation 
prototype. It wont work with kvm but it gives you the idea what we had in 
mind on s390.

----------- snip old PATCH GPLv2 ----------

Subject: [PATCH/RFC] Fix system<->user misaccount of interpreted execution

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patches fixes the accouting of guest cpu time. As sie is executed via a
system call, all guest operations were accounted as system time. To fix this
we define a per thread "sie context". Before issuing the sie instruction we
enter this context and leave the context afterwards. sie_enter and sie_exit
call account_system_vtime, which now checks for being in sie_context. We 
define the sie_context to be accounted as user time.

Possible future enhancement: We could add an additional field: "interpretion
time" to cpu stat and process time. Thus we could differentiate between user
time in the host and host user time spent for guests. The main challenge is
the necessary user space change. Therefore, we could export the interpretion
time with a new interface. To be defined.

Signed-off-By: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-By: Carsten Otte <cotte@de.ibm.com>

---
 arch/s390/Kconfig              |    1 +
 arch/s390/host/s390host.c      |   15 +++++++++++++++
 arch/s390/kernel/process.c     |    1 +
 arch/s390/kernel/vtime.c       |   12 +++++++++++-
 include/asm-s390/thread_info.h |    2 ++
 5 files changed, 30 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.22.orig/arch/s390/kernel/vtime.c
+++ linux-2.6.22/arch/s390/kernel/vtime.c
@@ -97,6 +97,11 @@ void account_vtime(struct task_struct *t
 	account_system_time(tsk, 0, cputime);
 }
 
+static inline int task_is_in_sie(struct thread_info *thread)
+{
+	return thread->in_sie;
+}
+
 /*
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
@@ -114,7 +119,12 @@ void account_system_vtime(struct task_st
 	cputime =  S390_lowcore.system_timer >> 12;
 	S390_lowcore.system_timer -= cputime << 12;
 	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, 0, cputime);
+
+	if (task_is_in_sie(task_thread_info(tsk)) && !hardirq_count() &&
+							!softirq_count())
+		account_user_time(tsk, cputime);
+	else
+		account_system_time(tsk, 0, cputime);
 }
 
 static inline void set_vtimer(__u64 expires)
Index: linux-2.6.22/arch/s390/host/s390host.c
===================================================================
--- linux-2.6.22.orig/arch/s390/host/s390host.c
+++ linux-2.6.22/arch/s390/host/s390host.c
@@ -27,6 +27,19 @@ static int s390host_do_action(unsigned l
 
 static DEFINE_MUTEX(s390host_init_mutex);
 
+static void enter_sie(void)
+{
+	account_system_vtime(current);
+	current_thread_info()->in_sie = 1;
+}
+
+static void exit_sie(void)
+{
+	account_system_vtime(current);
+	current_thread_info()->in_sie = 0;
+}
+
+
 static void s390host_get_data(struct s390host_data *data)
 {
 	atomic_inc(&data->count);
@@ -297,7 +310,9 @@ again:
 		schedule();
 
 	sie_kernel->sie_block.icptcode = 0;
+	enter_sie();
 	ret = sie64a(sie_kernel);
+	exit_sie();
 	if (ret)
 		goto out;
 
Index: linux-2.6.22/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6.22.orig/include/asm-s390/thread_info.h
+++ linux-2.6.22/include/asm-s390/thread_info.h
@@ -55,6 +55,7 @@ struct thread_info {
 	struct restart_block	restart_block;
 	struct s390host_data	*s390host_data;	/* s390host data */
 	int			sie_cpu;	/* sie cpu number */
+	int			in_sie;		/* 1 => cpu is in sie*/
 };
 
 /*
@@ -72,6 +73,7 @@ struct thread_info {
 	},					\
 	.s390host_data	= NULL,			\
 	.sie_cpu	= 0,			\
+	.in_sie		= 0,			\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
Index: linux-2.6.22/arch/s390/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/s390/kernel/process.c
+++ linux-2.6.22/arch/s390/kernel/process.c
@@ -277,6 +277,7 @@ int copy_thread(int nr, unsigned long cl
         memset(&p->thread.per_info,0,sizeof(p->thread.per_info));
 	task_thread_info(p)->s390host_data = NULL;
 	task_thread_info(p)->sie_cpu = -1;
+	task_thread_info(p)->in_sie = 0;
         return 0;
 }
 
Index: linux-2.6.22/arch/s390/Kconfig
===================================================================
--- linux-2.6.22.orig/arch/s390/Kconfig
+++ linux-2.6.22/arch/s390/Kconfig
@@ -524,6 +524,7 @@ config S390_HOST
 	bool "s390 host support (EXPERIMENTAL)"
 	depends on 64BIT && EXPERIMENTAL
 	select S390_SWITCH_AMODE
+	select VIRT_CPU_ACCOUNTING
 	help
 	  Select this option if you want to host guest Linux images
 

