Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbZGAAtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbZGAAtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761320AbZGAAeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:18 -0400
Received: from kroah.org ([198.145.64.141]:60079 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761369AbZGAAeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:15 2009
Message-Id: <20090701002415.528425884@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrea Arcangeli <aarcange@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 011/108] KVM: protect concurrent make_all_cpus_request
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-protect-concurrent-make_all_cpus_request.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 84261923d3dddb766736023bead6fa07b7e218d5 upstream.

make_all_cpus_request contains a race condition which can
trigger false request completed status, as follows:

CPU0                                              CPU1

if (test_and_set_bit(req,&vcpu->requests))
   ....                                        	   if (test_and_set_bit(req,&vcpu->requests))
   ..                                                  return
proceed to smp_call_function_many(wait=1)

Use a spinlock to serialize concurrent CPUs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    3 +++
 2 files changed, 4 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -125,6 +125,7 @@ struct kvm_kernel_irq_routing_entry {
 struct kvm {
 	struct mutex lock; /* protects the vcpus array and APIC accesses */
 	spinlock_t mmu_lock;
+	spinlock_t requests_lock;
 	struct rw_semaphore slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	int nmemslots;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -581,6 +581,7 @@ static bool make_all_cpus_request(struct
 		cpumask_clear(cpus);
 
 	me = get_cpu();
+	spin_lock(&kvm->requests_lock);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		vcpu = kvm->vcpus[i];
 		if (!vcpu)
@@ -597,6 +598,7 @@ static bool make_all_cpus_request(struct
 		smp_call_function_many(cpus, ack_flush, NULL, 1);
 	else
 		called = false;
+	spin_unlock(&kvm->requests_lock);
 	put_cpu();
 	free_cpumask_var(cpus);
 	return called;
@@ -817,6 +819,7 @@ static struct kvm *kvm_create_vm(void)
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
+	spin_lock_init(&kvm->requests_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);


