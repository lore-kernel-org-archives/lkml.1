Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZEXPzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZEXPzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZEXPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 32/45] KVM: s390: optimize float int lock: spin_lock_bh --> spin_lock
Date: Sun, 24 May 2009 18:50:17 +0300
Message-Id: <1243180230-2480-33-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The floating interrupt lock is only taken in process context. We can
replace all spin_lock_bh with standard spin_lock calls.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/interrupt.c |   20 ++++++++++----------
 arch/s390/kvm/kvm-s390.c  |    4 ++--
 arch/s390/kvm/priv.c      |    4 ++--
 arch/s390/kvm/sigp.c      |   16 ++++++++--------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index a48830f..f04f530 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -301,13 +301,13 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	}
 
 	if ((!rc) && atomic_read(&fi->active)) {
-		spin_lock_bh(&fi->lock);
+		spin_lock(&fi->lock);
 		list_for_each_entry(inti, &fi->list, list)
 			if (__interrupt_is_deliverable(vcpu, inti)) {
 				rc = 1;
 				break;
 			}
-		spin_unlock_bh(&fi->lock);
+		spin_unlock(&fi->lock);
 	}
 
 	if ((!rc) && (vcpu->arch.sie_block->ckc <
@@ -368,7 +368,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	hrtimer_start(&vcpu->arch.ckc_timer, ktime_set (0, sltime) , HRTIMER_MODE_REL);
 	VCPU_EVENT(vcpu, 5, "enabled wait via clock comparator: %llx ns", sltime);
 no_timer:
-	spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
+	spin_lock(&vcpu->arch.local_int.float_int->lock);
 	spin_lock_bh(&vcpu->arch.local_int.lock);
 	add_wait_queue(&vcpu->arch.local_int.wq, &wait);
 	while (list_empty(&vcpu->arch.local_int.list) &&
@@ -377,18 +377,18 @@ no_timer:
 		!signal_pending(current)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_bh(&vcpu->arch.local_int.lock);
-		spin_unlock_bh(&vcpu->arch.local_int.float_int->lock);
+		spin_unlock(&vcpu->arch.local_int.float_int->lock);
 		vcpu_put(vcpu);
 		schedule();
 		vcpu_load(vcpu);
-		spin_lock_bh(&vcpu->arch.local_int.float_int->lock);
+		spin_lock(&vcpu->arch.local_int.float_int->lock);
 		spin_lock_bh(&vcpu->arch.local_int.lock);
 	}
 	__unset_cpu_idle(vcpu);
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&vcpu->wq, &wait);
 	spin_unlock_bh(&vcpu->arch.local_int.lock);
-	spin_unlock_bh(&vcpu->arch.local_int.float_int->lock);
+	spin_unlock(&vcpu->arch.local_int.float_int->lock);
 	hrtimer_try_to_cancel(&vcpu->arch.ckc_timer);
 	return 0;
 }
@@ -455,7 +455,7 @@ void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 	if (atomic_read(&fi->active)) {
 		do {
 			deliver = 0;
-			spin_lock_bh(&fi->lock);
+			spin_lock(&fi->lock);
 			list_for_each_entry_safe(inti, n, &fi->list, list) {
 				if (__interrupt_is_deliverable(vcpu, inti)) {
 					list_del(&inti->list);
@@ -466,7 +466,7 @@ void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 			}
 			if (list_empty(&fi->list))
 				atomic_set(&fi->active, 0);
-			spin_unlock_bh(&fi->lock);
+			spin_unlock(&fi->lock);
 			if (deliver) {
 				__do_deliver_interrupt(vcpu, inti);
 				kfree(inti);
@@ -531,7 +531,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 
 	mutex_lock(&kvm->lock);
 	fi = &kvm->arch.float_int;
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	list_add_tail(&inti->list, &fi->list);
 	atomic_set(&fi->active, 1);
 	sigcpu = find_first_bit(fi->idle_mask, KVM_MAX_VCPUS);
@@ -548,7 +548,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 	if (waitqueue_active(&li->wq))
 		wake_up_interruptible(&li->wq);
 	spin_unlock_bh(&li->lock);
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 	mutex_unlock(&kvm->lock);
 	return 0;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dc3d068..36c654d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -318,11 +318,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	spin_lock_init(&vcpu->arch.local_int.lock);
 	INIT_LIST_HEAD(&vcpu->arch.local_int.list);
 	vcpu->arch.local_int.float_int = &kvm->arch.float_int;
-	spin_lock_bh(&kvm->arch.float_int.lock);
+	spin_lock(&kvm->arch.float_int.lock);
 	kvm->arch.float_int.local_int[id] = &vcpu->arch.local_int;
 	init_waitqueue_head(&vcpu->arch.local_int.wq);
 	vcpu->arch.local_int.cpuflags = &vcpu->arch.sie_block->cpuflags;
-	spin_unlock_bh(&kvm->arch.float_int.lock);
+	spin_unlock(&kvm->arch.float_int.lock);
 
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 4b88834..93ecd06 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -204,11 +204,11 @@ static void handle_stsi_3_2_2(struct kvm_vcpu *vcpu, struct sysinfo_3_2_2 *mem)
 	int cpus = 0;
 	int n;
 
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	for (n = 0; n < KVM_MAX_VCPUS; n++)
 		if (fi->local_int[n])
 			cpus++;
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 
 	/* deal with other level 3 hypervisors */
 	if (stsi(mem, 3, 2, 2) == -ENOSYS)
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index f27dbed..3667883 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -52,7 +52,7 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, u16 cpu_addr,
 	if (cpu_addr >= KVM_MAX_VCPUS)
 		return 3; /* not operational */
 
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	if (fi->local_int[cpu_addr] == NULL)
 		rc = 3; /* not operational */
 	else if (atomic_read(fi->local_int[cpu_addr]->cpuflags)
@@ -64,7 +64,7 @@ static int __sigp_sense(struct kvm_vcpu *vcpu, u16 cpu_addr,
 		*reg |= SIGP_STAT_STOPPED;
 		rc = 1; /* status stored */
 	}
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 
 	VCPU_EVENT(vcpu, 4, "sensed status of cpu %x rc %x", cpu_addr, rc);
 	return rc;
@@ -86,7 +86,7 @@ static int __sigp_emergency(struct kvm_vcpu *vcpu, u16 cpu_addr)
 
 	inti->type = KVM_S390_INT_EMERGENCY;
 
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	li = fi->local_int[cpu_addr];
 	if (li == NULL) {
 		rc = 3; /* not operational */
@@ -102,7 +102,7 @@ static int __sigp_emergency(struct kvm_vcpu *vcpu, u16 cpu_addr)
 	spin_unlock_bh(&li->lock);
 	rc = 0; /* order accepted */
 unlock:
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 	VCPU_EVENT(vcpu, 4, "sent sigp emerg to cpu %x", cpu_addr);
 	return rc;
 }
@@ -123,7 +123,7 @@ static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int store)
 
 	inti->type = KVM_S390_SIGP_STOP;
 
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	li = fi->local_int[cpu_addr];
 	if (li == NULL) {
 		rc = 3; /* not operational */
@@ -142,7 +142,7 @@ static int __sigp_stop(struct kvm_vcpu *vcpu, u16 cpu_addr, int store)
 	spin_unlock_bh(&li->lock);
 	rc = 0; /* order accepted */
 unlock:
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 	VCPU_EVENT(vcpu, 4, "sent sigp stop to cpu %x", cpu_addr);
 	return rc;
 }
@@ -188,7 +188,7 @@ static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
 	if (!inti)
 		return 2; /* busy */
 
-	spin_lock_bh(&fi->lock);
+	spin_lock(&fi->lock);
 	li = fi->local_int[cpu_addr];
 
 	if ((cpu_addr >= KVM_MAX_VCPUS) || (li == NULL)) {
@@ -220,7 +220,7 @@ static int __sigp_set_prefix(struct kvm_vcpu *vcpu, u16 cpu_addr, u32 address,
 out_li:
 	spin_unlock_bh(&li->lock);
 out_fi:
-	spin_unlock_bh(&fi->lock);
+	spin_unlock(&fi->lock);
 	return rc;
 }
 
-- 
1.6.0.6

