Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXGHNJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXGHNJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXGHNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:09:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbXGHNJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:09:26 -0400
Date: Sun, 8 Jul 2007 15:09:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
Message-ID: <20070708130915.GA9559@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11838994974161-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> Intel VT essentially introduces a new set of registers into the 
> processor; this means we cannot preempt kvm in kernel mode lest a new 
> VM run with and old VM's registers.  In addition, kvm lazy switches 
> some host registers as well. (AMD does not introduce new registers, 
> but we still want lazy msr switching, and we want to know when we move 
> to a different cpu in order to be able to guarantee a monotonously 
> increasing tsc).
> 
> Current kvm code simply disables preemption when guest context is in 
> use. This, however, has many drawbacks:
> 
> - some kvm mmu code is O(n), causing possibly unbounded latencies and causing
>   -rt great unhappiness.
> - the mmu code wants to sleep (especially with guest paging), but can't.
> - some optimizations are not possible; for example, if we switch from one
>   VM to another, we need not restore some host registers (as they will simply
>   be overwritten with the new guest registers immediately).
> 
> This patch adds hooks to the scheduler that allow kvm to be notified 
> about scheduling decisions involving virtual machines.  When we 
> schedule out a VM, kvm is told to swap guest registers out; when we 
> schedule the VM in, we swap the registers back in.

hm, why not do what i have in -rt? See the patch below. Seems to work 
fine for me, although i might be missing something.

	Ingo

------------------------->
Subject: [patch] kvm: make vcpu_load/put preemptible
From: Ingo Molnar <mingo@elte.hu>

make vcpu_load/put preemptible.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/kvm/svm.c |   13 ++++++++++---
 drivers/kvm/vmx.c |   15 ++++++++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

Index: linux-rt-rebase.q/drivers/kvm/svm.c
===================================================================
--- linux-rt-rebase.q.orig/drivers/kvm/svm.c
+++ linux-rt-rebase.q/drivers/kvm/svm.c
@@ -610,9 +610,17 @@ static void svm_free_vcpu(struct kvm_vcp
 
 static void svm_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	int cpu, i;
+	int cpu = raw_smp_processor_id(), i;
+	cpumask_t this_mask = cpumask_of_cpu(cpu);
+
+	/*
+	 * Keep the context preemptible, but do not migrate
+	 * away to another CPU. TODO: make sure this persists.
+	 * Save/restore original mask.
+	 */
+	if (unlikely(!cpus_equal(current->cpus_allowed, this_mask)))
+		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
-	cpu = get_cpu();
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 tsc_this, delta;
 
@@ -638,7 +646,6 @@ static void svm_vcpu_put(struct kvm_vcpu
 		wrmsrl(host_save_user_msrs[i], vcpu->svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
-	put_cpu();
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
Index: linux-rt-rebase.q/drivers/kvm/vmx.c
===================================================================
--- linux-rt-rebase.q.orig/drivers/kvm/vmx.c
+++ linux-rt-rebase.q/drivers/kvm/vmx.c
@@ -241,9 +241,16 @@ static void vmcs_set_bits(unsigned long 
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	u64 phys_addr = __pa(vcpu->vmcs);
-	int cpu;
+	int cpu = raw_smp_processor_id();
+	cpumask_t this_mask = cpumask_of_cpu(cpu);
 
-	cpu = get_cpu();
+	/*
+	 * Keep the context preemptible, but do not migrate
+	 * away to another CPU. TODO: make sure this persists.
+	 * Save/restore original mask.
+	 */
+	if (unlikely(!cpus_equal(current->cpus_allowed, this_mask)))
+		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	if (vcpu->cpu != cpu)
 		vcpu_clear(vcpu);
@@ -281,7 +288,6 @@ static void vmx_vcpu_load(struct kvm_vcp
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_put_guest_fpu(vcpu);
-	put_cpu();
 }
 
 static void vmx_vcpu_decache(struct kvm_vcpu *vcpu)
@@ -1862,6 +1868,7 @@ again:
 	}
 #endif
 
+	preempt_disable();
 	asm (
 		/* Store host registers */
 		"pushf \n\t"
@@ -2002,6 +2009,8 @@ again:
 
 		reload_tss();
 	}
+	preempt_enable();
+
 	++vcpu->stat.exits;
 
 #ifdef CONFIG_X86_64
