Return-Path: <linux-kernel-owner+w=401wt.eu-S948371AbXHMQ2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948371AbXHMQ2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969512AbXHMPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:22:51 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:11187 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971552AbXHMPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:22:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
Date: Mon, 13 Aug 2007 17:22:43 +0200
User-Agent: KMail/1.9.7
Cc: Laurent Vivier <Laurent.Vivier@bull.net>, Avi Kivity <avi@qumranet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, cotte@de.ibm.com
References: <46BC8B39.6050202@bull.net> <46C06AFE.2050702@qumranet.com> <46C06D99.2030106@bull.net>
In-Reply-To: <46C06D99.2030106@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131722.43936.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. August 2007 schrieb Laurent Vivier:
> >> As guest accounting is hw dependent, I think we should add a hook in the
> >> accounting functions.
> >>   
> > 
> > Isn't PF_VM exactly such a hook?  All the hypervisor needs to do is to
> > set/unset it correctly?
> 
> In fact, no.
> 
> PF_VM is used to know we have entered a virtual CPU (the hypervisor set it,
> the scheduler unset it on accounting)

Why not do something like the following. (This patch does not work as it 
relies on the no-existing var cputime_since_last_update, but it shows the 
idea)

---
 drivers/kvm/kvm.h |   13 +++++++++++++
 drivers/kvm/svm.c |    3 ++-
 drivers/kvm/vmx.c |    3 ++-
 kernel/sched.c    |    1 -
 4 files changed, 17 insertions(+), 3 deletions(-)

Index: kvm/drivers/kvm/kvm.h
===================================================================
--- kvm.orig/drivers/kvm/kvm.h
+++ kvm/drivers/kvm/kvm.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/signal.h>
@@ -726,6 +727,18 @@ static inline u32 get_rdx_init_val(void)
 	return 0x600; /* P6 family */
 }
 
+static inline guest_enter(void)
+{
+	account_system_time(current, 0, cputime_since_last_update);
+	current->flags |= PF_VCPU;
+}
+
+static inline guest_exit(void)
+{
+	current->flags &= ~PF_VCPU;
+	account_system_time(current, 0, cputime_since_last_update);
+}
+
 #define ASM_VMX_VMCLEAR_RAX       ".byte 0x66, 0x0f, 0xc7, 0x30"
 #define ASM_VMX_VMLAUNCH          ".byte 0x0f, 0x01, 0xc2"
 #define ASM_VMX_VMRESUME          ".byte 0x0f, 0x01, 0xc3"
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c
+++ kvm/kernel/sched.c
@@ -3251,7 +3251,6 @@ void account_system_time(struct task_str
 		p->utime = cputime_add(p->utime, cputime);
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 		cpustat->guest = cputime64_add(cpustat->guest, tmp);
-		p->flags &= ~PF_VCPU;
 		return;
 	}
 
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c
+++ kvm/drivers/kvm/svm.c
@@ -1404,7 +1404,7 @@ again:
 	clgi();
 
 	vcpu->guest_mode = 1;
-	current->flags |= PF_VCPU;
+	guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
@@ -1537,6 +1537,7 @@ again:
 #endif
 		: "cc", "memory" );
 
+	guest_exit();
 	vcpu->guest_mode = 0;
 
 	if (vcpu->fpu_active) {
Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c
+++ kvm/drivers/kvm/vmx.c
@@ -2078,7 +2078,7 @@ again:
 	local_irq_disable();
 
 	vcpu->guest_mode = 1;
-	current->flags |= PF_VCPU;
+	guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
@@ -2199,6 +2199,7 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
