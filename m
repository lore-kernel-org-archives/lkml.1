Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXJOOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXJOOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXJOOjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:39:33 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:39262 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXJOOjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:39:32 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time accounting.
Date: Mon, 15 Oct 2007 16:39:23 +0200
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46E550EF.5080209@bull.net> <200710151333.21078.borntraeger@de.ibm.com> <47135150.8040901@bull.net>
In-Reply-To: <47135150.8040901@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151639.23614.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 15. Oktober 2007 schrieb Laurent Vivier:
> > Any idea how to make this proper on all architectures? I will have a look.
> 
> I think the solution is to have an arch dependent kvm_guest_exit(): empty for
> x86, clearing the bit for s390.

I think we can merge your patches, as the userspace interface seems fine. To 
make the accounting work for virtual cpu accounting found on ppc and s390 we
can later add an additional patch that also deals with interruptible guest 
contexts.
So something like this should work:

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 drivers/kvm/kvm.h |    8 ++++++++
 kernel/sched.c    |    2 ++
 2 files changed, 10 insertions(+)

Index: kvm/drivers/kvm/kvm.h
===================================================================
--- kvm.orig/drivers/kvm/kvm.h
+++ kvm/drivers/kvm/kvm.h
@@ -18,6 +18,7 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
+#include <asm/system.h>
 
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
@@ -675,11 +676,18 @@ __init void kvm_arch_init(void);
 
 static inline void kvm_guest_enter(void)
 {
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+	account_system_vtime(current);
+#endif
 	current->flags |= PF_VCPU;
 }
 
 static inline void kvm_guest_exit(void)
 {
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+	account_system_vtime(current);
+	current->flags &= ~PF_VCPU;
+#endif
 }
 
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
Index: kvm/kernel/sched.c
===================================================================
--- kvm.orig/kernel/sched.c
+++ kvm/kernel/sched.c
@@ -3312,7 +3312,9 @@ void account_system_time(struct task_str
 
 	if (p->flags & PF_VCPU) {
 		account_guest_time(p, cputime);
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 		p->flags &= ~PF_VCPU;
+#endif
 		return;
 	}
 
