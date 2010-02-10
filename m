Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0BJRXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab0BJRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/40] KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
Date: Wed, 10 Feb 2010 19:22:33 +0200
Message-Id: <1265822589-11155-5-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

We don't support these instructions, but guest can execute them even if the
feature('monitor') haven't been exposed in CPUID. So we would trap and inject
a #UD if guest try this way.

Cc: stable@kernel.org
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/vmx.h |    1 +
 arch/x86/kvm/vmx.c         |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 2b49454..8f6b011 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -251,6 +251,7 @@ enum vmcs_field {
 #define EXIT_REASON_MSR_READ            31
 #define EXIT_REASON_MSR_WRITE           32
 #define EXIT_REASON_MWAIT_INSTRUCTION   36
+#define EXIT_REASON_MONITOR_INSTRUCTION 39
 #define EXIT_REASON_PAUSE_INSTRUCTION   40
 #define EXIT_REASON_MCE_DURING_VMENTRY	 41
 #define EXIT_REASON_TPR_BELOW_THRESHOLD 43
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d4918d6..8a8e139 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1224,6 +1224,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 	      CPU_BASED_USE_IO_BITMAPS |
 	      CPU_BASED_MOV_DR_EXITING |
 	      CPU_BASED_USE_TSC_OFFSETING |
+	      CPU_BASED_MWAIT_EXITING |
+	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING;
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
@@ -3416,6 +3418,12 @@ static int handle_pause(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_invalid_op(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -3453,6 +3461,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
 	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
 	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
+	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
+	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
1.6.5.3

