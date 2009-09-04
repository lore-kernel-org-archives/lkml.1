Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbZIDUSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbZIDUSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934069AbZIDUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:36 -0400
Received: from kroah.org ([198.145.64.141]:36216 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030AbZIDUOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200854.115208548@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 26/48] KVM: VMX: Handle vmx instruction vmexits
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-handle-vmx-instruction-vmexits.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit e3c7cb6ad7191e92ba89d00a7ae5f5dd1ca0c214)

IF a guest tries to use vmx instructions, inject a #UD to let it know the
instruction is not implemented, rather than crashing.

This prevents guest userspace from crashing the guest kernel.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2582,6 +2582,12 @@ static int handle_vmcall(struct kvm_vcpu
 	return 1;
 }
 
+static int handle_vmx_insn(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 static int handle_wbinvd(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	skip_emulated_instruction(vcpu);
@@ -2714,6 +2720,15 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
+	[EXIT_REASON_VMCLEAR]	              = handle_vmx_insn,
+	[EXIT_REASON_VMLAUNCH]                = handle_vmx_insn,
+	[EXIT_REASON_VMPTRLD]                 = handle_vmx_insn,
+	[EXIT_REASON_VMPTRST]                 = handle_vmx_insn,
+	[EXIT_REASON_VMREAD]                  = handle_vmx_insn,
+	[EXIT_REASON_VMRESUME]                = handle_vmx_insn,
+	[EXIT_REASON_VMWRITE]                 = handle_vmx_insn,
+	[EXIT_REASON_VMOFF]                   = handle_vmx_insn,
+	[EXIT_REASON_VMON]                    = handle_vmx_insn,
 	[EXIT_REASON_TPR_BELOW_THRESHOLD]     = handle_tpr_below_threshold,
 	[EXIT_REASON_APIC_ACCESS]             = handle_apic_access,
 	[EXIT_REASON_WBINVD]                  = handle_wbinvd,


