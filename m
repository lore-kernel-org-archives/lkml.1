Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZEXP42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZEXP42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZEXPw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 31/45] KVM: s390: use hrtimer for clock wakeup from idle - v2
Date: Sun, 24 May 2009 18:50:16 +0300
Message-Id: <1243180230-2480-32-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch reworks the s390 clock comparator wakeup to hrtimer. The clock
comparator is a per-cpu value that is compared against the TOD clock. If
ckc <= TOD an external interrupt 1004 is triggered. Since the clock comparator
and the TOD clock have a much higher resolution than jiffies we should use
hrtimers to trigger the wakeup. This speeds up guest nanosleep for small
values.

Since hrtimers callbacks run in hard-irq context, I added a tasklet to do
the actual work with enabled interrupts.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/include/asm/kvm_host.h |    5 ++++-
 arch/s390/kvm/interrupt.c        |   33 +++++++++++++++++++++++----------
 arch/s390/kvm/kvm-s390.c         |    7 +++++--
 arch/s390/kvm/kvm-s390.h         |    4 +++-
 4 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 54ea39f..a27d0d5 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -13,6 +13,8 @@
 
 #ifndef ASM_KVM_HOST_H
 #define ASM_KVM_HOST_H
+#include <linux/hrtimer.h>
+#include <linux/interrupt.h>
 #include <linux/kvm_host.h>
 #include <asm/debug.h>
 #include <asm/cpuid.h>
@@ -210,7 +212,8 @@ struct kvm_vcpu_arch {
 	s390_fp_regs      guest_fpregs;
 	unsigned int      guest_acrs[NUM_ACRS];
 	struct kvm_s390_local_interrupt local_int;
-	struct timer_list ckc_timer;
+	struct hrtimer    ckc_timer;
+	struct tasklet_struct tasklet;
 	union  {
 		cpuid_t	  cpu_id;
 		u64	  stidp_data;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4ed4c3a..a48830f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -12,6 +12,8 @@
 
 #include <asm/lowcore.h>
 #include <asm/uaccess.h>
+#include <linux/hrtimer.h>
+#include <linux/interrupt.h>
 #include <linux/kvm_host.h>
 #include <linux/signal.h>
 #include "kvm-s390.h"
@@ -361,12 +363,10 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	sltime = (vcpu->arch.sie_block->ckc - now) / (0xf4240000ul / HZ) + 1;
+	sltime = ((vcpu->arch.sie_block->ckc - now)*125)>>9;
 
-	vcpu->arch.ckc_timer.expires = jiffies + sltime;
-
-	add_timer(&vcpu->arch.ckc_timer);
-	VCPU_EVENT(vcpu, 5, "enabled wait timer:%llx jiffies", sltime);
+	hrtimer_start(&vcpu->arch.ckc_timer, ktime_set (0, sltime) , HRTIMER_MODE_REL);
+	VCPU_EVENT(vcpu, 5, "enabled wait via clock comparator: %llx ns", sltime);
 no_timer:
 	spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
 	spin_lock_bh(&vcpu->arch.local_int.lock);
@@ -389,21 +389,34 @@ no_timer:
 	remove_wait_queue(&vcpu->wq, &wait);
 	spin_unlock_bh(&vcpu->arch.local_int.lock);
 	spin_unlock_bh(&vcpu->arch.local_int.float_int->lock);
-	del_timer(&vcpu->arch.ckc_timer);
+	hrtimer_try_to_cancel(&vcpu->arch.ckc_timer);
 	return 0;
 }
 
-void kvm_s390_idle_wakeup(unsigned long data)
+void kvm_s390_tasklet(unsigned long parm)
 {
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) parm;
 
-	spin_lock_bh(&vcpu->arch.local_int.lock);
+	spin_lock(&vcpu->arch.local_int.lock);
 	vcpu->arch.local_int.timer_due = 1;
 	if (waitqueue_active(&vcpu->arch.local_int.wq))
 		wake_up_interruptible(&vcpu->arch.local_int.wq);
-	spin_unlock_bh(&vcpu->arch.local_int.lock);
+	spin_unlock(&vcpu->arch.local_int.lock);
 }
 
+/*
+ * low level hrtimer wake routine. Because this runs in hardirq context
+ * we schedule a tasklet to do the real work.
+ */
+enum hrtimer_restart kvm_s390_idle_wakeup(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(timer, struct kvm_vcpu, arch.ckc_timer);
+	tasklet_schedule(&vcpu->arch.tasklet);
+
+	return HRTIMER_NORESTART;
+}
 
 void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 86567e1..dc3d068 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/fs.h>
+#include <linux/hrtimer.h>
 #include <linux/init.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
@@ -283,8 +284,10 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gmsor = vcpu->kvm->arch.guest_origin;
 	vcpu->arch.sie_block->ecb   = 2;
 	vcpu->arch.sie_block->eca   = 0xC1002001U;
-	setup_timer(&vcpu->arch.ckc_timer, kvm_s390_idle_wakeup,
-		 (unsigned long) vcpu);
+	hrtimer_init(&vcpu->arch.ckc_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
+	tasklet_init(&vcpu->arch.tasklet, kvm_s390_tasklet,
+		     (unsigned long) vcpu);
+	vcpu->arch.ckc_timer.function = kvm_s390_idle_wakeup;
 	get_cpu_id(&vcpu->arch.cpu_id);
 	vcpu->arch.cpu_id.version = 0xff;
 	return 0;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 00bbe69..748fee8 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -14,6 +14,7 @@
 #ifndef ARCH_S390_KVM_S390_H
 #define ARCH_S390_KVM_S390_H
 
+#include <linux/hrtimer.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -41,7 +42,8 @@ static inline int __cpu_is_stopped(struct kvm_vcpu *vcpu)
 }
 
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
-void kvm_s390_idle_wakeup(unsigned long data);
+enum hrtimer_restart kvm_s390_idle_wakeup(struct hrtimer *timer);
+void kvm_s390_tasklet(unsigned long parm);
 void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu);
 int kvm_s390_inject_vm(struct kvm *kvm,
 		struct kvm_s390_interrupt *s390int);
-- 
1.6.0.6

