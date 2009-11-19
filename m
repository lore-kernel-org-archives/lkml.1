Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZKSNgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZKSNgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZKSNgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 34/35] KVM: VMX: Report unexpected simultaneous exceptions as internal errors
Date: Thu, 19 Nov 2009 15:35:10 +0200
Message-Id: <1258637711-11674-35-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These happen when we trap an exception when another exception is being
delivered; we only expect these with MCEs and page faults.  If something
unexpected happens, things probably went south and we're better off reporting
an internal error and freezing.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c  |   11 ++++++++---
 include/linux/kvm.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c0e66dd..22fcd27 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2744,9 +2744,14 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 		return handle_machine_check(vcpu);
 
 	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
-						!is_page_fault(intr_info))
-		printk(KERN_ERR "%s: unexpected, vectoring info 0x%x "
-		       "intr info 0x%x\n", __func__, vect_info, intr_info);
+	    !is_page_fault(intr_info)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
+		vcpu->run->internal.ndata = 2;
+		vcpu->run->internal.data[0] = vect_info;
+		vcpu->run->internal.data[1] = intr_info;
+		return 0;
+	}
 
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR)
 		return 1;  /* already handled by vmx_vcpu_run() */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 172639e..976f4d1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -163,6 +163,7 @@ struct kvm_pit_config {
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 #define KVM_INTERNAL_ERROR_EMULATION 1
+#define KVM_INTERNAL_ERROR_SIMUL_EX 2
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
-- 
1.6.5.2

