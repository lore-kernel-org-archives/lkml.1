Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXLTNhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXLTNhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762202AbXLTNek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760413AbXLTNeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:37 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 08/16] per-vcpu interrupt processing.
Date: Thu, 20 Dec 2007 11:33:48 -0200
Message-Id: <1198157678759-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576731969-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com> <11981576632726-git-send-email-gcosta@redhat.com> <11981576671720-git-send-email-gcosta@redhat.com> <11981576731969-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adapts interrupt processing for using the vcpu struct.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/core.c                 |    2 +-
 drivers/lguest/interrupts_and_traps.c |   25 ++++++++++++++-----------
 drivers/lguest/lg.h                   |   10 +++++-----
 drivers/lguest/lguest_user.c          |    7 ++++---
 drivers/lguest/x86/core.c             |    2 +-
 5 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index ef35e02..4d0102d 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -203,7 +203,7 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user)
 		/* Check if there are any interrupts which can be delivered
 		 * now: if so, this sets up the hander to be executed when we
 		 * next run the Guest. */
-		maybe_do_interrupt(lg);
+		maybe_do_interrupt(vcpu);
 
 		/* All long-lived kernel loops need to check with this horrible
 		 * thing called the freezer.  If the Host is trying to suspend,
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index 189d66e..db440cb 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -60,11 +60,13 @@ static void push_guest_stack(struct lguest *lg, unsigned long *gstack, u32 val)
  * We set up the stack just like the CPU does for a real interrupt, so it's
  * identical for the Guest (and the standard "iret" instruction will undo
  * it). */
-static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
+static void set_guest_interrupt(struct lguest_vcpu *vcpu, u32 lo, u32 hi,
+				int has_err)
 {
 	unsigned long gstack, origstack;
 	u32 eflags, ss, irq_enable;
 	unsigned long virtstack;
+	struct lguest *lg = vcpu->lg;
 
 	/* There are two cases for interrupts: one where the Guest is already
 	 * in the kernel, and a more complex one where the Guest is in
@@ -129,9 +131,10 @@ static void set_guest_interrupt(struct lguest *lg, u32 lo, u32 hi, int has_err)
  *
  * maybe_do_interrupt() gets called before every entry to the Guest, to see if
  * we should divert the Guest to running an interrupt handler. */
-void maybe_do_interrupt(struct lguest *lg)
+void maybe_do_interrupt(struct lguest_vcpu *vcpu)
 {
 	unsigned int irq;
+	struct lguest *lg = vcpu->lg;
 	DECLARE_BITMAP(blk, LGUEST_IRQS);
 	struct desc_struct *idt;
 
@@ -145,7 +148,7 @@ void maybe_do_interrupt(struct lguest *lg)
 			   sizeof(blk)))
 		return;
 
-	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
+	bitmap_andnot(blk, vcpu->irqs_pending, blk, LGUEST_IRQS);
 
 	/* Find the first interrupt. */
 	irq = find_first_bit(blk, LGUEST_IRQS);
@@ -180,11 +183,11 @@ void maybe_do_interrupt(struct lguest *lg)
 	/* If they don't have a handler (yet?), we just ignore it */
 	if (idt_present(idt->a, idt->b)) {
 		/* OK, mark it no longer pending and deliver it. */
-		clear_bit(irq, lg->irqs_pending);
+		clear_bit(irq, vcpu->irqs_pending);
 		/* set_guest_interrupt() takes the interrupt descriptor and a
 		 * flag to say whether this interrupt pushes an error code onto
 		 * the stack as well: virtual interrupts never do. */
-		set_guest_interrupt(lg, idt->a, idt->b, 0);
+		set_guest_interrupt(vcpu, idt->a, idt->b, 0);
 	}
 
 	/* Every time we deliver an interrupt, we update the timestamp in the
@@ -245,19 +248,19 @@ static int has_err(unsigned int trap)
 }
 
 /* deliver_trap() returns true if it could deliver the trap. */
-int deliver_trap(struct lguest *lg, unsigned int num)
+int deliver_trap(struct lguest_vcpu *vcpu, unsigned int num)
 {
 	/* Trap numbers are always 8 bit, but we set an impossible trap number
 	 * for traps inside the Switcher, so check that here. */
-	if (num >= ARRAY_SIZE(lg->arch.idt))
+	if (num >= ARRAY_SIZE(vcpu->lg->arch.idt))
 		return 0;
 
 	/* Early on the Guest hasn't set the IDT entries (or maybe it put a
 	 * bogus one in): if we fail here, the Guest will be killed. */
-	if (!idt_present(lg->arch.idt[num].a, lg->arch.idt[num].b))
+	if (!idt_present(vcpu->lg->arch.idt[num].a, vcpu->lg->arch.idt[num].b))
 		return 0;
-	set_guest_interrupt(lg, lg->arch.idt[num].a, lg->arch.idt[num].b,
-			    has_err(num));
+	set_guest_interrupt(vcpu, vcpu->lg->arch.idt[num].a,
+			    vcpu->lg->arch.idt[num].b, has_err(num));
 	return 1;
 }
 
@@ -493,7 +496,7 @@ static enum hrtimer_restart clockdev_fn(struct hrtimer *timer)
 	struct lguest_vcpu *vcpu = container_of(timer, struct lguest_vcpu, hrt);
 
 	/* Remember the first interrupt is the timer interrupt. */
-	set_bit(0, vcpu->lg->irqs_pending);
+	set_bit(0, vcpu->irqs_pending);
 	/* If the Guest is actually stopped, we need to wake it up. */
 	if (vcpu->lg->halted)
 		wake_up_process(vcpu->lg->tsk);
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 0205409..db2edd6 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -50,6 +50,9 @@ struct lguest_vcpu {
 
 	/* Virtual clock device */
 	struct hrtimer hrt;
+
+	/* Pending virtual interrupts */
+	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 };
 
 /* The private info the thread maintains about the guest. */
@@ -97,9 +100,6 @@ struct lguest
 	const char *dead;
 
 	struct lguest_arch arch;
-
-	/* Pending virtual interrupts */
-	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 };
 
 static inline struct lguest *lg_of_vcpu(struct lguest_vcpu *vcpu)
@@ -141,8 +141,8 @@ int run_guest(struct lguest_vcpu *vcpu, unsigned long __user *user);
 #define pgd_pfn(x)	(pgd_val(x) >> PAGE_SHIFT)
 
 /* interrupts_and_traps.c: */
-void maybe_do_interrupt(struct lguest *lg);
-int deliver_trap(struct lguest *lg, unsigned int num);
+void maybe_do_interrupt(struct lguest_vcpu *vcpu);
+int deliver_trap(struct lguest_vcpu *vcpu, unsigned int num);
 void load_guest_idt_entry(struct lguest *lg, unsigned int i, u32 low, u32 hi);
 void guest_set_stack(struct lguest *lg, u32 seg, u32 esp, unsigned int pages);
 void pin_stack_pages(struct lguest *lg);
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 7481e82..60cf6c6 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -36,7 +36,8 @@ static int break_guest_out(struct lguest *lg, const unsigned long __user *input)
 
 /*L:050 Sending an interrupt is done by writing LHREQ_IRQ and an interrupt
  * number to /dev/lguest. */
-static int user_send_irq(struct lguest *lg, const unsigned long __user *input)
+static int user_send_irq(struct lguest_vcpu *vcpu,
+			 const unsigned long __user *input)
 {
 	unsigned long irq;
 
@@ -46,7 +47,7 @@ static int user_send_irq(struct lguest *lg, const unsigned long __user *input)
 		return -EINVAL;
 	/* Next time the Guest runs, the core code will see if it can deliver
 	 * this interrupt. */
-	set_bit(irq, lg->irqs_pending);
+	set_bit(irq, vcpu->irqs_pending);
 	return 0;
 }
 
@@ -251,7 +252,7 @@ static ssize_t write(struct file *file, const char __user *in,
 	case LHREQ_INITIALIZE:
 		return initialize(file, input);
 	case LHREQ_IRQ:
-		return user_send_irq(lg, input);
+		return user_send_irq(vcpu, input);
 	case LHREQ_BREAK:
 		return break_guest_out(lg, input);
 	default:
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 5e56629..3d21c6d 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -344,7 +344,7 @@ void lguest_arch_handle_trap(struct lguest_vcpu *vcpu)
 	}
 
 	/* We didn't handle the trap, so it needs to go to the Guest. */
-	if (!deliver_trap(lg, lg->regs->trapnum))
+	if (!deliver_trap(vcpu, lg->regs->trapnum))
 		/* If the Guest doesn't have a handler (either it hasn't
 		 * registered any yet, or it's one of the faults we don't let
 		 * it handle), it dies with a cryptic error message. */
-- 
1.5.0.6

