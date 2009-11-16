Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZKPRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZKPRT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbZKPRTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:19:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:33495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZKPRTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:19:16 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       torvalds@linux-foundation.org, avi@redhat.com, peterz@infradead.org,
       andi@firstfloor.org, fweisbec@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/21] kvm: convert kvm to use new scheduler notifiers
Date: Tue, 17 Nov 2009 02:15:10 +0900
Message-Id: <1258391726-30264-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258391726-30264-1-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert kvm to use new scheduler notifiers instead of preempt
notifiers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
---
 include/linux/kvm_host.h |    5 +--
 virt/kvm/kvm_main.c      |   51 +++++++++++++++++++--------------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b7bbb5d..b6e56f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -74,9 +74,8 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
-#ifdef CONFIG_PREEMPT_NOTIFIERS
-	struct preempt_notifier preempt_notifier;
-#endif
+	struct sched_notifier sched_in_notifier;
+	struct sched_notifier sched_out_notifier;
 	int vcpu_id;
 	struct mutex mutex;
 	int   cpu;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7495ce3..4cc8051 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -79,8 +79,6 @@ static cpumask_var_t cpus_hardware_enabled;
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
-static __read_mostly struct preempt_ops kvm_preempt_ops;
-
 struct dentry *kvm_debugfs_dir;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
@@ -713,7 +711,8 @@ void vcpu_load(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&vcpu->mutex);
 	cpu = get_cpu();
-	preempt_notifier_register(&vcpu->preempt_notifier);
+	sched_notifier_register(SCHED_NOTIFIER_IN, &vcpu->sched_in_notifier);
+	sched_notifier_register(SCHED_NOTIFIER_OUT, &vcpu->sched_out_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
 }
@@ -722,11 +721,28 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
-	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	sched_notifier_unregister(&vcpu->sched_in_notifier);
+	sched_notifier_unregister(&vcpu->sched_out_notifier);
 	preempt_enable();
 	mutex_unlock(&vcpu->mutex);
 }
 
+static void kvm_sched_in(struct sched_notifier *sn, struct task_struct *prev)
+{
+	struct kvm_vcpu *vcpu =
+		container_of(sn, struct kvm_vcpu, sched_in_notifier);
+
+	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+}
+
+static void kvm_sched_out(struct sched_notifier *sn, struct task_struct *next)
+{
+	struct kvm_vcpu *vcpu =
+		container_of(sn, struct kvm_vcpu, sched_out_notifier);
+
+	kvm_arch_vcpu_put(vcpu);
+}
+
 static void ack_flush(void *_completed)
 {
 }
@@ -1772,7 +1788,8 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
-	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
+	vcpu->sched_in_notifier.in = kvm_sched_in;
+	vcpu->sched_out_notifier.out = kvm_sched_out;
 
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
@@ -2690,27 +2707,6 @@ static struct sys_device kvm_sysdev = {
 struct page *bad_page;
 pfn_t bad_pfn;
 
-static inline
-struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
-{
-	return container_of(pn, struct kvm_vcpu, preempt_notifier);
-}
-
-static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
-{
-	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
-
-	kvm_arch_vcpu_load(vcpu, cpu);
-}
-
-static void kvm_sched_out(struct preempt_notifier *pn,
-			  struct task_struct *next)
-{
-	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
-
-	kvm_arch_vcpu_put(vcpu);
-}
-
 int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module)
 {
@@ -2780,9 +2776,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		goto out_free;
 	}
 
-	kvm_preempt_ops.sched_in = kvm_sched_in;
-	kvm_preempt_ops.sched_out = kvm_sched_out;
-
 	kvm_init_debug();
 
 	return 0;
-- 
1.6.4.2

