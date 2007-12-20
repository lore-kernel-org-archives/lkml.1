Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbXLTNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbXLTNkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbXLTNfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:35:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbXLTNff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:35:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 13/16] per-vcpu lguest task management
Date: Thu, 20 Dec 2007 11:33:53 -0200
Message-Id: <11981577021091-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576972655-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com> <11981576884121-git-send-email-gcosta@redhat.com> <1198157692575-git-send-email-gcosta@redhat.com> <11981576972655-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lguest uses tasks to control its running behaviour (like sending
breaks, controlling halted state, etc). In a per-vcpu environment,
each vcpu will have its own underlying task. So this patch
makes the infrastructure for that possible

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/core.c                 |    4 +-
 drivers/lguest/hypercalls.c           |    2 +-
 drivers/lguest/interrupts_and_traps.c |    8 ++--
 drivers/lguest/lg.h                   |   14 ++++----
 drivers/lguest/lguest_user.c          |   56 ++++++++++++++++++--------------
 5 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 4d0102d..285a465 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -197,7 +197,7 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 			return -ERESTARTSYS;
 
 		/* If Waker set break_out, return to Launcher. */
-		if (lg->break_out)
+		if (vcpu->break_out)
 			return -EAGAIN;
 
 		/* Check if there are any interrupts which can be delivered
@@ -217,7 +217,7 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 
 		/* If the Guest asked to be stopped, we sleep.  The Guest's
 		 * clock timer or LHCALL_BREAK from the Waker will wake us. */
-		if (lg->halted) {
+		if (vcpu->halted) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			continue;
diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 4364bc2..41ea2e2 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -86,7 +86,7 @@ static void do_hcall(struct lguest_vcpu *vcpu, struct hcall_args *args)
 		break;
 	case LHCALL_HALT:
 		/* Similarly, this sets the halted flag for run_guest(). */
-		lg->halted = 1;
+		vcpu->halted = 1;
 		break;
 	case LHCALL_NOTIFY:
 		lg->pending_notify = args->arg1;
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index b3d444a..10c9aea 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -163,11 +163,11 @@ void maybe_do_interrupt(struct lguest_vcpu *vcpu)
 		return;
 
 	/* If they're halted, interrupts restart them. */
-	if (lg->halted) {
+	if (vcpu->halted) {
 		/* Re-enable interrupts. */
 		if (put_user(X86_EFLAGS_IF, &lg->lguest_data->irq_enabled))
 			kill_guest(lg, "Re-enabling interrupts");
-		lg->halted = 0;
+		vcpu->halted = 0;
 	} else {
 		/* Otherwise we check if they have interrupts disabled. */
 		u32 irq_enabled;
@@ -500,8 +500,8 @@ static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
 	/* Remember the first interrupt is the timer interrupt. */
 	set_bit(0, vcpu->irqs_pending);
 	/* If the Guest is actually stopped, we need to wake it up. */
-	if (vcpu->lg->halted)
-		wake_up_process(vcpu->lg->tsk);
+	if (vcpu->halted)
+		wake_up_process(vcpu->tsk);
 	return HRTIMER_NORESTART;
 }
 
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index f9429ff..b23694e 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -43,6 +43,8 @@ struct lguest;
 struct lguest_vcpu {
 	int vcpu_id;
 	struct lguest *lg;
+	struct task_struct *tsk;
+	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
 
 	/* At end of a page shared mapped over lguest_pages in guest.  */
 	unsigned long regs_page;
@@ -55,6 +57,11 @@ struct lguest_vcpu {
 	/* Virtual clock device */
 	struct hrtimer hrt;
 
+	/* Do we need to stop what we're doing and return to userspace? */
+	int break_out;
+	wait_queue_head_t break_wq;
+	int halted;
+
 	/* Pending virtual interrupts */
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 
@@ -65,8 +72,6 @@ struct lguest_vcpu {
 struct lguest
 {
 	struct lguest_data __user *lguest_data;
-	struct task_struct *tsk;
-	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
 	struct lguest_vcpu vcpus[NR_CPUS];
 	unsigned int nr_vcpus;
 
@@ -76,15 +81,10 @@ struct lguest
 	void __user *mem_base;
 	unsigned long kernel_address;
 	u32 cr2;
-	int halted;
 	int ts;
 	u32 esp1;
 	u8 ss1;
 
-	/* Do we need to stop what we're doing and return to userspace? */
-	int break_out;
-	wait_queue_head_t break_wq;
-
 	/* Bitmap of what has changed: see CHANGED_* above. */
 	int changed;
 	struct lguest_pages *last_pages;
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 4f51e25..d081db4 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -13,7 +13,8 @@
  * LHREQ_BREAK and the value "1" to /dev/lguest to do this.  Once the Launcher
  * has done whatever needs attention, it writes LHREQ_BREAK and "0" to release
  * the Waker. */
-static int break_guest_out(struct lguest *lg, const unsigned long __user *input)
+static int break_guest_out(struct lguest_vcpu *vcpu,
+			   const unsigned long __user *input)
 {
 	unsigned long on;
 
@@ -22,14 +23,15 @@ static int break_guest_out(struct lguest *lg, const unsigned long __user *input)
 		return -EFAULT;
 
 	if (on) {
-		lg->break_out = 1;
+		vcpu->break_out = 1;
 		/* Pop it out of the Guest (may be running on different CPU) */
-		wake_up_process(lg->tsk);
+		wake_up_process(vcpu->tsk);
 		/* Wait for them to reset it */
-		return wait_event_interruptible(lg->break_wq, !lg->break_out);
+		return wait_event_interruptible(vcpu->break_wq,
+						!vcpu->break_out);
 	} else {
-		lg->break_out = 0;
-		wake_up(&lg->break_wq);
+		vcpu->break_out = 0;
+		wake_up(&vcpu->break_wq);
 		return 0;
 	}
 }
@@ -66,7 +68,7 @@ static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 	vcpu = &lg->vcpus[vcpu_id];
 
 	/* If you're not the task which owns the Guest, go away. */
-	if (current != lg->tsk)
+	if (current != vcpu->tsk)
 		return -EPERM;
 
 	/* If the guest is already dead, we indicate why */
@@ -114,6 +116,19 @@ static int vcpu_start(struct lguest_vcpu *vcpu, int vcpu_id,
 	 * address. */
 	lguest_arch_setup_regs(vcpu, start_ip);
 
+	/* Initialize the queue for the waker to wait on */
+	init_waitqueue_head(&vcpu->break_wq);
+
+	/* We keep a pointer to the Launcher task (ie. current task) for when
+	 * other Guests want to wake this one (inter-Guest I/O). */
+	vcpu->tsk = current;
+
+	/* We need to keep a pointer to the Launcher's memory map, because if
+	 * the Launcher dies we need to clean it up.  If we don't keep a
+	 * reference, it is destroyed before close() is called. */
+	vcpu->mm = get_task_mm(vcpu->tsk);
+
+
 	vcpu->lg = container_of((vcpu - vcpu_id), struct lguest, vcpus[0]);
 	vcpu->lg->nr_vcpus++;
 
@@ -179,17 +194,6 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	if (err)
 		goto free_regs;
 
-	/* We keep a pointer to the Launcher task (ie. current task) for when
-	 * other Guests want to wake this one (inter-Guest I/O). */
-	lg->tsk = current;
-	/* We need to keep a pointer to the Launcher's memory map, because if
-	 * the Launcher dies we need to clean it up.  If we don't keep a
-	 * reference, it is destroyed before close() is called. */
-	lg->mm = get_task_mm(lg->tsk);
-
-	/* Initialize the queue for the waker to wait on */
-	init_waitqueue_head(&lg->break_wq);
-
 	/* We remember which CPU's pages this Guest used last, for optimization
 	 * when the same Guest runs on the same CPU twice. */
 	lg->last_pages = NULL;
@@ -244,7 +248,7 @@ static ssize_t write(struct file *file, const char __user *in,
 		return -ENOENT;
 
 	/* If you're not the task which owns the Guest, you can only break */
-	if (lg && current != lg->tsk && req != LHREQ_BREAK)
+	if (lg && current != vcpu->tsk && req != LHREQ_BREAK)
 		return -EPERM;
 
 	switch (req) {
@@ -253,7 +257,7 @@ static ssize_t write(struct file *file, const char __user *in,
 	case LHREQ_IRQ:
 		return user_send_irq(vcpu, input);
 	case LHREQ_BREAK:
-		return break_guest_out(lg, input);
+		return break_guest_out(vcpu, input);
 	default:
 		return -EINVAL;
 	}
@@ -278,17 +282,19 @@ static int close(struct inode *inode, struct file *file)
 	/* We need the big lock, to protect from inter-guest I/O and other
 	 * Launchers initializing guests. */
 	mutex_lock(&lguest_lock);
+
+	/* Free up the shadow page tables for the Guest. */
+	free_guest_pagetable(lg);
+
 	for (i = 0; i < lg->nr_vcpus; i++) {
 		/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
 		hrtimer_cancel(&lg->vcpus[i].hrt);
 		/* We can free up the register page we allocated. */
 		free_page(lg->vcpus[i].regs_page);
+		/* Now all the memory cleanups are done, it's safe to release
+		 * the Launcher's memory management structure. */
+		mmput(lg->vcpus[i].mm);
 	}
-	/* Free up the shadow page tables for the Guest. */
-	free_guest_pagetable(lg);
-	/* Now all the memory cleanups are done, it's safe to release the
-	 * Launcher's memory management structure. */
-	mmput(lg->mm);
 	/* If lg->dead doesn't contain an error code it will be NULL or a
 	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
 	if (!IS_ERR(lg->dead))
-- 
1.5.0.6

