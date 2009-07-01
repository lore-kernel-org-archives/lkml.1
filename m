Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbZGAAsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbZGAAsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761017AbZGAAeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:12 -0400
Received: from kroah.org ([198.145.64.141]:60039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357AbZGAAeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:13 2009
Message-Id: <20090701002413.036101160@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 005/108] KVM: Move "exit due to NMI" handling into vmx_complete_interrupts()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-move-exit-due-to-nmi-handling-into-vmx_complete_interrupts.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 20f65983e30f222e5383f77206e3f571d1d64610 upstream.

To save us one reading of VM_EXIT_INTR_INFO.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3255,8 +3255,17 @@ static void vmx_complete_interrupts(stru
 	bool idtv_info_valid;
 	u32 error;
 
-	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	/* We need to handle NMIs before interrupts are enabled */
+	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
+	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
+		KVMTRACE_0D(NMI, &vmx->vcpu, handler);
+		asm("int $2");
+	}
+
+	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
+
 	if (cpu_has_virtual_nmis()) {
 		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
 		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
@@ -3386,7 +3395,6 @@ static void fixup_rmode_irq(struct vcpu_
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 intr_info;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!cpu_has_virtual_nmis() && vmx->soft_vnmi_blocked))
@@ -3515,15 +3523,6 @@ static void vmx_vcpu_run(struct kvm_vcpu
 	asm("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
 	vmx->launched = 1;
 
-	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-
-	/* We need to handle NMIs before interrupts are enabled */
-	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
-	    (intr_info & INTR_INFO_VALID_MASK)) {
-		KVMTRACE_0D(NMI, vcpu, handler);
-		asm("int $2");
-	}
-
 	vmx_complete_interrupts(vmx);
 }
 


