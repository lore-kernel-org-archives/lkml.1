Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYKEOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYKEOhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYKEOh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:37:26 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:58977 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKEOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:37:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nV8Sr6WHRFQoiOUeaYYkdPCOBode96vuThme3Owg7hVcv8UmnFbhzlR2O8ugXjwrz7
         8zs/HRnt8HGQMcceTsz0/fKi6ckSpdDWhyl52JCqLVVyEuursU2+D1eFwJjKklrVgPlF
         7W0qpQA/wRQJ7yk5R3TZwqeJGYb7sFARDdtkI=
Message-ID: <c4e36d110811050637h54dca04fk43bda1a3a01b8a44@mail.gmail.com>
Date: Wed, 5 Nov 2008 15:37:24 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <200811051505.16145.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com>
	 <20081105130113.GB29548@elte.hu>
	 <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
	 <200811051505.16145.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Arnd Bergmann <arnd@arndb.de>:
> On Wednesday 05 November 2008, Zdenek Kabelac wrote:
>> > is this some special warning you added? The stock kernel certainly
>> > does not emit this warning.
>>
>> Yes - it's my personal debug checker that tries to watch wether irq &
>> irqsafe are running in pair.
>> So it shows a warning if there is a call of spin_lock_irq and irq is
>> already dissabled.
>
> I've done such a checker before as well, but back then it showed
> far too many false positives. If you have a working version, can you
> post your patch here? I think that would be very useful in the kernel.

It's really nothing 'perfect' and has no aspiration to be a part of
kernel at all - I'm just using it for checking correctness  of my own
development. Also to avoid lots of weird positives I've added couple
'fixes' where I'm using irqsave() instead of plain 'irq()' lock - but
it's mostly codepath, where kernel prints some oopses....

So here is my simple patch - which is most probably horribly broken :)
but it helps in some cases to detect potential problem.

diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 5787249..2fe0846 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -121,11 +121,12 @@ static void tty_audit_buf_push_current(struct
tty_audit_buf *buf)
 void tty_audit_exit(void)
 {
 	struct tty_audit_buf *buf;
+	unsigned long flags;

-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	buf = current->signal->tty_audit_buf;
 	current->signal->tty_audit_buf = NULL;
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 	if (!buf)
 		return;

diff --git a/kernel/acct.c b/kernel/acct.c
index f6006a6..1a03be3 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -598,6 +598,7 @@ void acct_collect(long exitcode, int group_dead)
 {
 	struct pacct_struct *pacct = &current->signal->pacct;
 	unsigned long vsize = 0;
+	unsigned long flags;

 	if (group_dead && current->mm) {
 		struct vm_area_struct *vma;
@@ -610,7 +611,7 @@ void acct_collect(long exitcode, int group_dead)
 		up_read(&current->mm->mmap_sem);
 	}

-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irqsave(&current->sighand->siglock, flags);
 	if (group_dead)
 		pacct->ac_mem = vsize / 1024;
 	if (thread_group_leader(current)) {
@@ -628,7 +629,7 @@ void acct_collect(long exitcode, int group_dead)
 	pacct->ac_stime = cputime_add(pacct->ac_stime, current->stime);
 	pacct->ac_minflt += current->min_flt;
 	pacct->ac_majflt += current->maj_flt;
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }

 static void acct_process_in_ns(struct pid_namespace *ns)
diff --git a/kernel/exit.c b/kernel/exit.c
index 80137a5..104cbfc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -158,11 +158,12 @@ void release_task(struct task_struct * p)
 {
 	struct task_struct *leader;
 	int zap_leader;
+	unsigned long flags;
 repeat:
 	tracehook_prepare_release_task(p);
 	atomic_dec(&p->user->processes);
 	proc_flush_task(p);
-	write_lock_irq(&tasklist_lock);
+	write_lock_irqsave(&tasklist_lock, flags);
 	tracehook_finish_release_task(p);
 	__exit_signal(p);

@@ -194,7 +195,7 @@ repeat:
 			leader->exit_state = EXIT_DEAD;
 	}

-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);

@@ -873,10 +874,11 @@ static struct task_struct
*find_new_reaper(struct task_struct *father)

 static void forget_original_parent(struct task_struct *father)
 {
+	unsigned long flags;
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(ptrace_dead);

-	write_lock_irq(&tasklist_lock);
+	write_lock_irqsave(&tasklist_lock, flags);
 	reaper = find_new_reaper(father);
 	/*
 	 * First clean up ptrace if we were using it.
@@ -892,7 +894,7 @@ static void forget_original_parent(struct
task_struct *father)
 		reparent_thread(p, father);
 	}

-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	BUG_ON(!list_empty(&father->children));

 	ptrace_exit_finish(father, &ptrace_dead);
@@ -906,6 +908,7 @@ static void exit_notify(struct task_struct *tsk,
int group_dead)
 {
 	int signal;
 	void *cookie;
+	unsigned long flags;

 	/*
 	 * This does two things:
@@ -918,7 +921,7 @@ static void exit_notify(struct task_struct *tsk,
int group_dead)
 	forget_original_parent(tsk);
 	exit_task_namespaces(tsk);

-	write_lock_irq(&tasklist_lock);
+	write_lock_irqsave(&tasklist_lock, flags);
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);

@@ -954,7 +957,7 @@ static void exit_notify(struct task_struct *tsk,
int group_dead)
 	    tsk->signal->notify_count < 0)
 		wake_up_process(tsk->signal->group_exit_task);

-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);

 	tracehook_report_death(tsk, signal, cookie, group_dead);

diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 29ab207..342bec6 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -98,6 +98,10 @@ EXPORT_SYMBOL(_spin_lock_irqsave);

 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
+	if (raw_irqs_disabled()) {
+		printk("SPIN IRQ ALREADY DISABLED\n");
+		dump_stack();
+	}
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -128,6 +132,10 @@ EXPORT_SYMBOL(_read_lock_irqsave);

 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
+	if (raw_irqs_disabled()) {
+		printk("READ IRQ ALREADY DISABLED\n");
+		dump_stack();
+	}
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
@@ -158,6 +166,10 @@ EXPORT_SYMBOL(_write_lock_irqsave);

 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
+	if (raw_irqs_disabled()) {
+		printk("WRITE IRQ ALREADY DISABLED\n");
+		dump_stack();
+	}
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -350,6 +362,10 @@ EXPORT_SYMBOL(_read_unlock);

 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
+	if (!raw_irqs_disabled()) {
+		printk("SPIN IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_restore(flags);
@@ -359,6 +375,10 @@ EXPORT_SYMBOL(_spin_unlock_irqrestore);

 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
+	if (!raw_irqs_disabled()) {
+		printk("SPIN IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_enable();
@@ -377,6 +397,10 @@ EXPORT_SYMBOL(_spin_unlock_bh);

 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
+	if (!raw_irqs_disabled()) {
+		printk("READ IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_restore(flags);
@@ -386,6 +410,10 @@ EXPORT_SYMBOL(_read_unlock_irqrestore);

 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
+	if (!raw_irqs_disabled()) {
+		printk("READ IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_enable();
@@ -404,6 +432,10 @@ EXPORT_SYMBOL(_read_unlock_bh);

 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
+	if (!raw_irqs_disabled()) {
+		printk("WRITE IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_restore(flags);
@@ -413,6 +445,10 @@ EXPORT_SYMBOL(_write_unlock_irqrestore);

 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
+	if (!raw_irqs_disabled()) {
+		printk("WRITE IRQ ALREADY ENABLED\n");
+		dump_stack();
+	}
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_enable();
