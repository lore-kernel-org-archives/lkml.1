Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYAGNIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYAGNIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbYAGNGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:06:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628AbYAGNGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:06:34 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 07/16] per-vcpu lguest timers
Date: Mon,  7 Jan 2008 11:05:28 -0200
Message-Id: <11997111711574-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11997111661344-git-send-email-gcosta@redhat.com>
References: 11981576363806-git-send-email-gcosta@redhat.com <1199711137195-git-send-email-gcosta@redhat.com> <11997111432356-git-send-email-gcosta@redhat.com> <11997111481113-git-send-email-gcosta@redhat.com> <11997111523234-git-send-email-gcosta@redhat.com> <1199711157132-git-send-email-gcosta@redhat.com> <11997111623212-git-send-email-gcosta@redhat.com> <11997111661344-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here, I introduce per-vcpu timers. With this, we can have
local expiries, needed for accounting time in smp guests

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/hypercalls.c           |    2 +-
 drivers/lguest/interrupts_and_traps.c |   20 ++++++++++----------
 drivers/lguest/lg.h                   |   10 +++++-----
 drivers/lguest/lguest_user.c          |   12 +++++++-----
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 9417601..1bf133e 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -78,7 +78,7 @@ static void do_hcall(struct lg_vcpu *vcpu, struct hcall_args *args)
 		guest_set_pmd(lg, args->arg1, args->arg2);
 		break;
 	case LHCALL_SET_CLOCKEVENT:
-		guest_set_clockevent(lg, args->arg1);
+		guest_set_clockevent(vcpu, args->arg1);
 		break;
 	case LHCALL_TS:
 		/* This sets the TS flag, as we saw used in run_guest(). */
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 2b66f79..3be18a6 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -470,13 +470,13 @@ void copy_traps(const struct lguest *lg, struct desc_struct *idt,
  * infrastructure to set a callback at that time.
  *
  * 0 means "turn off the clock". */
-void guest_set_clockevent(struct lguest *lg, unsigned long delta)
+void guest_set_clockevent(struct lg_vcpu *vcpu, unsigned long delta)
 {
 	ktime_t expires;
 
 	if (unlikely(delta == 0)) {
 		/* Clock event device is shutting down. */
-		hrtimer_cancel(&lg->hrt);
+		hrtimer_cancel(&vcpu->hrt);
 		return;
 	}
 
@@ -484,25 +484,25 @@ void guest_set_clockevent(struct lguest *lg, unsigned long delta)
 	 * all the time between now and the timer interrupt it asked for.  This
 	 * is almost always the right thing to do. */
 	expires = ktime_add_ns(ktime_get_real(), delta);
-	hrtimer_start(&lg->hrt, expires, HRTIMER_MODE_ABS);
+	hrtimer_start(&vcpu->hrt, expires, HRTIMER_MODE_ABS);
 }
 
 /* This is the function called when the Guest's timer expires. */
 static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
 {
-	struct lguest *lg = container_of(timer, struct lguest, hrt);
+	struct lg_vcpu *vcpu = container_of(timer, struct lg_vcpu, hrt);
 
 	/* Remember the first interrupt is the timer interrupt. */
-	set_bit(0, lg->irqs_pending);
+	set_bit(0, vcpu->lg->irqs_pending);
 	/* If the Guest is actually stopped, we need to wake it up. */
-	if (lg->halted)
-		wake_up_process(lg->tsk);
+	if (vcpu->lg->halted)
+		wake_up_process(vcpu->lg->tsk);
 	return HRTIMER_NORESTART;
 }
 
 /* This sets up the timer for this Guest. */
-void init_clockdev(struct lguest *lg)
+void init_clockdev(struct lg_vcpu *vcpu)
 {
-	hrtimer_init(&lg->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
-	lg->hrt.function = clockdev_fn;
+	hrtimer_init(&vcpu->hrt, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	vcpu->hrt.function = clockdev_fn;
 }
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 13a991a..9c90fd3 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -47,6 +47,9 @@ struct lg_vcpu {
 	/* If a hypercall was asked for, this points to the arguments. */
 	struct hcall_args *hcall;
 	u32 next_hcall;
+
+	/* Virtual clock device */
+	struct hrtimer hrt;
 };
 
 /* The private info the thread maintains about the guest. */
@@ -95,9 +98,6 @@ struct lguest
 
 	struct lguest_arch arch;
 
-	/* Virtual clock device */
-	struct hrtimer hrt;
-
 	/* Pending virtual interrupts */
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 };
@@ -145,8 +145,8 @@ void setup_default_idt_entries(struct lguest_ro_state *state,
 			       const unsigned long *def);
 void copy_traps(const struct lguest *lg, struct desc_struct *idt,
 		const unsigned long *def);
-void guest_set_clockevent(struct lguest *lg, unsigned long delta);
-void init_clockdev(struct lguest *lg);
+void guest_set_clockevent(struct lg_vcpu *vcpu, unsigned long delta);
+void init_clockdev(struct lg_vcpu *vcpu);
 bool check_syscall_vector(struct lguest *lg);
 int init_interrupts(void);
 void free_interrupts(void);
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index d176004..cd2b0bf 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -104,6 +104,9 @@ static int vcpu_start(struct lg_vcpu *vcpu, int vcpu_id,
 
 	vcpu->vcpu_id = vcpu_id;
 
+	/* The timer for lguest's clock needs initialization. */
+	init_clockdev(vcpu);
+
 	vcpu->lg = container_of((vcpu - vcpu_id), struct lguest, vcpus[0]);
 	vcpu->lg->nr_vcpus++;
 
@@ -183,9 +186,6 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	 * address. */
 	lguest_arch_setup_regs(lg, args[3]);
 
-	/* The timer for lguest's clock needs initialization. */
-	init_clockdev(lg);
-
 	/* We keep a pointer to the Launcher task (ie. current task) for when
 	 * other Guests want to wake this one (inter-Guest I/O). */
 	lg->tsk = current;
@@ -276,6 +276,7 @@ static ssize_t write(struct file *file, const char __user *in,
 static int close(struct inode *inode, struct file *file)
 {
 	struct lguest *lg = file->private_data;
+	int i;
 
 	/* If we never successfully initialized, there's nothing to clean up */
 	if (!lg)
@@ -284,8 +285,9 @@ static int close(struct inode *inode, struct file *file)
 	/* We need the big lock, to protect from inter-guest I/O and other
 	 * Launchers initializing guests. */
 	mutex_lock(&lguest_lock);
-	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
-	hrtimer_cancel(&lg->hrt);
+	for (i = 0; i < lg->nr_vcpus; i++)
+		/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
+		hrtimer_cancel(&lg->vcpus[i].hrt);
 	/* Free up the shadow page tables for the Guest. */
 	free_guest_pagetable(lg);
 	/* Now all the memory cleanups are done, it's safe to release the
-- 
1.5.0.6

