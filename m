Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYLHJ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYLHJ4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYLHJ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:56:29 -0500
Received: from ozlabs.org ([203.10.76.45]:55296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbYLHJ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:56:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: [PATCH] kvm: Extract core of kvm_flush_remote_tlbs/kvm_reload_remote_mmus.
Date: Mon, 8 Dec 2008 20:26:24 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com>
In-Reply-To: <493BF144.9080106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082026.24350.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi said:
> Wow, code duplication from Rusty. Things must be bad.

Something about glass houses comes to mind.  But instead, a patch.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 virt/kvm/kvm_main.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -355,10 +355,11 @@ static void ack_flush(void *_completed)
 {
 }
 
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	int i, cpu, me;
 	cpumask_t cpus;
+	bool called = false;
 	struct kvm_vcpu *vcpu;
 
 	me = get_cpu();
@@ -367,45 +368,30 @@ void kvm_flush_remote_tlbs(struct kvm *k
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
 			continue;
-		if (test_and_set_bit(KVM_REQ_TLB_FLUSH, &vcpu->requests))
+		if (test_and_set_bit(req, &vcpu->requests))
 			continue;
 		cpu = vcpu->cpu;
 		if (cpu != -1 && cpu != me)
 			cpu_set(cpu, cpus);
 	}
-	if (cpus_empty(cpus))
-		goto out;
-	++kvm->stat.remote_tlb_flush;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
-out:
+	if (!cpus_empty(cpus)) {
+		smp_call_function_mask(cpus, ack_flush, NULL, 1);
+		called = true;
+	}
 	put_cpu();
+	return called;
+}
+
+void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
+		++kvm->stat.remote_tlb_flush;
 }
 
 void kvm_reload_remote_mmus(struct kvm *kvm)
 {
-	int i, cpu, me;
-	cpumask_t cpus;
-	struct kvm_vcpu *vcpu;
-
-	me = get_cpu();
-	cpus_clear(cpus);
-	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		vcpu = kvm->vcpus[i];
-		if (!vcpu)
-			continue;
-		if (test_and_set_bit(KVM_REQ_MMU_RELOAD, &vcpu->requests))
-			continue;
-		cpu = vcpu->cpu;
-		if (cpu != -1 && cpu != me)
-			cpu_set(cpu, cpus);
-	}
-	if (cpus_empty(cpus))
-		goto out;
-	smp_call_function_mask(cpus, ack_flush, NULL, 1);
-out:
-	put_cpu();
+	make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
-
 
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
