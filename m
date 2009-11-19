Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZKSNgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZKSNgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZKSNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 33/35] KVM: Allow internal errors reported to userspace to carry extra data
Date: Thu, 19 Nov 2009 15:35:09 +0200
Message-Id: <1258637711-11674-34-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually userspace will freeze the guest so we can inspect it, but some
internal state is not available.  Add extra data to internal error
reporting so we can expose it to the debugger.  Extra data is specific
to the suberror.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c  |    1 +
 arch/x86/kvm/vmx.c  |    1 +
 include/linux/kvm.h |    4 ++++
 virt/kvm/kvm_main.c |    1 +
 4 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a902479..4c3e5b2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2800,6 +2800,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 	case EMULATE_FAIL:
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
 		return 0;
 	default:
 		BUG();
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c9cc959..c0e66dd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3352,6 +3352,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 			kvm_report_emulation_failure(vcpu, "emulation failure");
 			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 			vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
 			ret = 0;
 			goto out;
 		}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ca62b8e..172639e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -251,6 +251,9 @@ struct kvm_run {
 		} dcr;
 		struct {
 			__u32 suberror;
+			/* Available with KVM_CAP_INTERNAL_ERROR_DATA: */
+			__u32 ndata;
+			__u64 data[16];
 		} internal;
 		/* Fix the size of the union. */
 		char padding[256];
@@ -484,6 +487,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_XEN_HVM 38
 #endif
 #define KVM_CAP_ADJUST_CLOCK 39
+#define KVM_CAP_INTERNAL_ERROR_DATA 40
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bd44fb4..f92ba13 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1653,6 +1653,7 @@ static long kvm_dev_ioctl_check_extension_generic(long arg)
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
 	case KVM_CAP_SET_BOOT_CPU_ID:
 #endif
+	case KVM_CAP_INTERNAL_ERROR_DATA:
 		return 1;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	case KVM_CAP_IRQ_ROUTING:
-- 
1.6.5.2

