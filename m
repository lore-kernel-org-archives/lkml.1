Return-Path: <linux-kernel-owner+w=401wt.eu-S1761775AbZGAAtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761775AbZGAAtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761315AbZGAAeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:17 -0400
Received: from kroah.org ([198.145.64.141]:60073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760890AbZGAAeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:15 2009
Message-Id: <20090701002415.081558754@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 010/108] KVM: VMX: Handle vmx instruction vmexits
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-handle-vmx-instruction-vmexits.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit e3c7cb6ad7191e92ba89d00a7ae5f5dd1ca0c214 upstream.

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
@@ -3015,6 +3015,12 @@ static int handle_vmcall(struct kvm_vcpu
 	return 1;
 }
 
+static int handle_vmx_insn(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 static int handle_invlpg(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	u64 exit_qualification = vmcs_read64(EXIT_QUALIFICATION);
@@ -3182,6 +3188,15 @@ static int (*kvm_vmx_exit_handlers[])(st
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
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


