Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYHRS7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYHRS7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbYHRS6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:58:11 -0400
Received: from mail.suse.de ([195.135.220.2]:43293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644AbYHRS6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:58:10 -0400
Date: Mon, 18 Aug 2008 11:44:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 33/60] KVM: Avoid instruction emulation when event delivery
	is pending
Message-ID: <20080818184436.GH29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-avoid-instruction-emulation-when-event-delivery-is-pending.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry-picked from commit 577bdc496614ced56d999bbb425e85adf2386490)

When an event (such as an interrupt) is injected, and the stack is
shadowed (and therefore write protected), the guest will exit.  The
current code will see that the stack is shadowed and emulate a few
instructions, each time postponing the injection.  Eventually the
injection may succeed, but at that time the guest may be unwilling
to accept the interrupt (for example, the TPR may have changed).

This occurs every once in a while during a Windows 2008 boot.

Fix by unshadowing the fault address if the fault was due to an event
injection.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    1 +
 arch/x86/kvm/svm.c |    7 ++++++-
 arch/x86/kvm/vmx.c |    2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1792,6 +1792,7 @@ int kvm_mmu_unprotect_page_virt(struct k
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1007,13 +1007,18 @@ static int pf_interception(struct vcpu_s
 	struct kvm *kvm = svm->vcpu.kvm;
 	u64 fault_address;
 	u32 error_code;
+	bool event_injection = false;
 
 	if (!irqchip_in_kernel(kvm) &&
-		is_external_interrupt(exit_int_info))
+	    is_external_interrupt(exit_int_info)) {
+		event_injection = true;
 		push_irq(&svm->vcpu, exit_int_info & SVM_EVTINJ_VEC_MASK);
+	}
 
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
+	if (event_injection)
+		kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2258,6 +2258,8 @@ static int handle_exception(struct kvm_v
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
 			    (u32)((u64)cr2 >> 32), handler);
+		if (vect_info & VECTORING_INFO_VALID_MASK)
+			kvm_mmu_unprotect_page_virt(vcpu, cr2);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
 

-- 
