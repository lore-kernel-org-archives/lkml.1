Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbZHSNCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbZHSNCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZHSNCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50541 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751529AbZHSNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:44 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/47] KVM: Return to userspace on emulation failure
Date: Wed, 19 Aug 2009 16:01:57 +0300
Message-Id: <1250686963-8357-2-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of mindlessly retrying to execute the instruction, report the
failure to userspace.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c  |    5 +++--
 include/linux/kvm.h |    7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5f97dbd..b6e4cda 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2673,8 +2673,9 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
 		++vcpu->stat.mmio_exits;
 		return 0;
 	case EMULATE_FAIL:
-		kvm_report_emulation_failure(vcpu, "pagetable");
-		return 1;
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		return 0;
 	default:
 		BUG();
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5037e17..6710518 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -95,6 +95,10 @@ struct kvm_pit_config {
 #define KVM_EXIT_S390_RESET       14
 #define KVM_EXIT_DCR              15
 #define KVM_EXIT_NMI              16
+#define KVM_EXIT_INTERNAL_ERROR   17
+
+/* For KVM_EXIT_INTERNAL_ERROR */
+#define KVM_INTERNAL_ERROR_EMULATION 1
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -181,6 +185,9 @@ struct kvm_run {
 			__u32 data;
 			__u8  is_write;
 		} dcr;
+		struct {
+			__u32 suberror;
+		} internal;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
1.6.3.3

