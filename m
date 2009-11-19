Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZKSNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZKSNgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZKSNgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 27/35] KVM: VMX: Remove vmx->msr_offset_efer
Date: Thu, 19 Nov 2009 15:35:03 +0200
Message-Id: <1258637711-11674-28-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is used to communicate between a caller and a callee; switch
to a function argument instead.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a5f3f3e..c9cc959 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -101,7 +101,6 @@ struct vcpu_vmx {
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
-	int                   msr_offset_efer;
 #ifdef CONFIG_X86_64
 	u64 		      msr_host_kernel_gs_base;
 	u64 		      msr_guest_kernel_gs_base;
@@ -584,14 +583,11 @@ static void reload_tss(void)
 	load_TR_desc();
 }
 
-static bool update_transition_efer(struct vcpu_vmx *vmx)
+static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 {
-	int efer_offset = vmx->msr_offset_efer;
 	u64 guest_efer;
 	u64 ignore_bits;
 
-	if (efer_offset < 0)
-		return false;
 	guest_efer = vmx->vcpu.arch.shadow_efer;
 
 	/*
@@ -926,8 +922,8 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 			move_msr_up(vmx, index, save_nmsrs++);
 	}
 #endif
-	vmx->msr_offset_efer = index = __find_msr_index(vmx, MSR_EFER);
-	if (index >= 0 && update_transition_efer(vmx))
+	index = __find_msr_index(vmx, MSR_EFER);
+	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, save_nmsrs++);
 
 	vmx->save_nmsrs = save_nmsrs;
-- 
1.6.5.2

