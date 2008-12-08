Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbYLHJ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYLHJ6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYLHJ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:58:10 -0500
Received: from ozlabs.org ([203.10.76.45]:37594 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbYLHJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:58:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: kvm: use modern cpumask primitives, no cpumask_t on stack
Date: Mon, 8 Dec 2008 20:28:04 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com> <200812082026.24350.rusty@rustcorp.com.au>
In-Reply-To: <200812082026.24350.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082028.05126.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting rid on on-stack cpumasks for large NR_CPUS.

1) Use cpumask_var_t/alloc_cpumask_var.
2) smp_call_function_mask -> smp_call_function_many
3) cpus_clear, cpus_empty, cpu_set -> cpumask_clear, cpumask_empty,
   cpumask_set_cpu.

This actually generates slightly smaller code than the old one with
CONFIG_CPUMASKS_OFFSTACK=n.  (gcc knows that cpus cannot be NULL in
that case, where cpumask_var_t is cpumask_t[1]).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 virt/kvm/kvm_main.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -358,12 +358,14 @@ static bool make_all_cpus_request(struct
 static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	int i, cpu, me;
-	cpumask_t cpus;
-	bool called = false;
+	cpumask_var_t cpus;
+	bool called = true;
 	struct kvm_vcpu *vcpu;
 
+	if (alloc_cpumask_var(&cpus, GFP_ATOMIC))
+		cpumask_clear(cpus);
+
 	me = get_cpu();
-	cpus_clear(cpus);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
@@ -371,14 +373,17 @@ static bool make_all_cpus_request(struct
 		if (test_and_set_bit(req, &vcpu->requests))
 			continue;
 		cpu = vcpu->cpu;
-		if (cpu != -1 && cpu != me)
-			cpu_set(cpu, cpus);
+		if (cpus != NULL && cpu != -1 && cpu != me)
+			cpumask_set_cpu(cpu, cpus);
 	}
-	if (!cpus_empty(cpus)) {
-		smp_call_function_mask(cpus, ack_flush, NULL, 1);
-		called = true;
-	}
+	if (unlikely(cpus == NULL))
+		smp_call_function_many(cpu_online_mask, ack_flush, NULL, 1);
+	else if (!cpumask_empty(cpus))
+		smp_call_function_many(cpus, ack_flush, NULL, 1);
+	else
+		called = false;
 	put_cpu();
+	free_cpumask_var(cpus);
 	return called;
 }
 
