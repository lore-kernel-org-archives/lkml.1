Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214Ab0CMA0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:26:23 -0500
Received: from kroah.org ([198.145.64.141]:32880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934766Ab0CMAVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:09 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.199154108@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sheng Yang <sheng@linux.intel.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 115/123] KVM: VMX: Trap and invalid MWAIT/MONITOR instruction
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Sheng Yang <sheng@linux.intel.com>

commit 59708670b639bff00f92e519df1ae14da240e919 upstream.

We don't support these instructions, but guest can execute them even if the
feature('monitor') haven't been exposed in CPUID. So we would trap and inject
a #UD if guest try this way.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/vmx.h |    1 +
 arch/x86/kvm/vmx.c         |   10 ++++++++++
 2 files changed, 11 insertions(+)

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
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1224,6 +1224,8 @@ static __init int setup_vmcs_config(stru
 	      CPU_BASED_USE_IO_BITMAPS |
 	      CPU_BASED_MOV_DR_EXITING |
 	      CPU_BASED_USE_TSC_OFFSETING |
+	      CPU_BASED_MWAIT_EXITING |
+	      CPU_BASED_MONITOR_EXITING |
 	      CPU_BASED_INVLPG_EXITING;
 	opt = CPU_BASED_TPR_SHADOW |
 	      CPU_BASED_USE_MSR_BITMAPS |
@@ -3416,6 +3418,12 @@ static int handle_pause(struct kvm_vcpu
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
@@ -3453,6 +3461,8 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_EPT_VIOLATION]	      = handle_ept_violation,
 	[EXIT_REASON_EPT_MISCONFIG]           = handle_ept_misconfig,
 	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
+	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
+	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
 };
 
 static const int kvm_vmx_max_exit_handlers =


