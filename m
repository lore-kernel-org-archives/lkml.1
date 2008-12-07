Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYLGKza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYLGKza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 05:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYLGKzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 05:55:21 -0500
Received: from ozlabs.org ([203.10.76.45]:52301 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbYLGKzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 05:55:20 -0500
To: "kvm-devel" <kvm-devel@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Avi Kivity <avi@qumranet.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 7 Dec 2008 21:25:14 +1030
Subject: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t on stack
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812072125.14416.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting rid on on-stack cpumasks for large NR_CPUS.

1) Use cpumask_var_t and alloc_cpumask_var (a noop normally).  Fallback
   code is inefficient but never happens in practice.
2) smp_call_function_mask -> smp_call_function_many
3) cpus_clear, cpus_empty, cpu_set -> cpumask_clear, cpumask_empty,
   cpumask_set_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 virt/kvm/kvm_main.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -358,11 +358,23 @@ static void ack_flush(void *_completed)
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	int i, cpu, me;
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 	struct kvm_vcpu *vcpu;
 
 	me = get_cpu();
-	cpus_clear(cpus);
+	if (!alloc_cpumask_var(&cpus, GFP_ATOMIC)) {
+		/* Slow path on failure.  Call everyone. */
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (vcpu)
+				set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests);
+		}
+		++kvm->stat.remote_tlb_flush;
+		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
+		put_cpu();
+		return;
+	}
+
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
@@ -371,24 +383,36 @@ void kvm_flush_remote_tlbs(struct kvm *k
 			continue;
 		cpu = vcpu->cpu;
 		if (cpu != -1 && cpu != me)
-			cpu_set(cpu, cpus);
+			cpumask_set_cpu(cpu, cpus);
 	}
-	if (cpus_empty(cpus))
+	if (cpumask_empty(cpus))
 		goto out;
 	++kvm->stat.remote_tlb_flush;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+	smp_call_function_many(cpus, ack_flush, NULL, 1);
 out:
 	put_cpu();
+	free_cpumask_var(cpus);
 }
 
 void kvm_reload_remote_mmus(struct kvm *kvm)
 {
 	int i, cpu, me;
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 	struct kvm_vcpu *vcpu;
 
 	me = get_cpu();
-	cpus_clear(cpus);
+	if (!alloc_cpumask_var(&cpus, GFP_ATOMIC)) {
+		/* Slow path on failure.  Call everyone. */
+		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+			vcpu = kvm->vcpus[i];
+			if (vcpu)
+				set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests);
+		}
+		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
+		put_cpu();
+		return;
+	}
+
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
@@ -397,13 +421,14 @@ void kvm_reload_remote_mmus(struct kvm *
 			continue;
 		cpu = vcpu->cpu;
 		if (cpu != -1 && cpu != me)
-			cpu_set(cpu, cpus);
+			cpumask_set_cpu(cpu, cpus);
 	}
-	if (cpus_empty(cpus))
+	if (cpumask_empty(cpus))
 		goto out;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
+	smp_call_function_many(cpus, ack_flush, NULL, 1);
 out:
 	put_cpu();
+	free_cpumask_var(cpus);
 }
 
 

