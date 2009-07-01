Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbZGAAsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbZGAAsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761363AbZGAAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:10 -0400
Received: from kroah.org ([198.145.64.141]:60035 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761320AbZGAAeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:12 2009
Message-Id: <20090701002412.598019788@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 004/108] KVM: VMX: Fix handling of a fault during NMI unblocked due to IRET
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-fix-handling-of-a-fault-during-nmi-unblocked-due-to-iret.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 7b4a25cb296e2a73d2e87a4af65361d45d450a27 upstream.

Bit 12 is undefined in any of the following cases:
 If the VM exit sets the valid bit in the IDT-vectoring information field.
 If the VM exit is due to a double fault.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3248,36 +3248,41 @@ static void update_tpr_threshold(struct 
 static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 {
 	u32 exit_intr_info;
-	u32 idt_vectoring_info;
+	u32 idt_vectoring_info = vmx->idt_vectoring_info;
 	bool unblock_nmi;
 	u8 vector;
 	int type;
 	bool idtv_info_valid;
 	u32 error;
 
+	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (cpu_has_virtual_nmis()) {
 		unblock_nmi = (exit_intr_info & INTR_INFO_UNBLOCK_NMI) != 0;
 		vector = exit_intr_info & INTR_INFO_VECTOR_MASK;
 		/*
-		 * SDM 3: 25.7.1.2
+		 * SDM 3: 27.7.1.2 (September 2008)
 		 * Re-set bit "block by NMI" before VM entry if vmexit caused by
 		 * a guest IRET fault.
+		 * SDM 3: 23.2.2 (September 2008)
+		 * Bit 12 is undefined in any of the following cases:
+		 *  If the VM exit sets the valid bit in the IDT-vectoring
+		 *   information field.
+		 *  If the VM exit is due to a double fault.
 		 */
-		if (unblock_nmi && vector != DF_VECTOR)
+		if ((exit_intr_info & INTR_INFO_VALID_MASK) && unblock_nmi &&
+		    vector != DF_VECTOR && !idtv_info_valid)
 			vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
 				      GUEST_INTR_STATE_NMI);
 	} else if (unlikely(vmx->soft_vnmi_blocked))
 		vmx->vnmi_blocked_time +=
 			ktime_to_ns(ktime_sub(ktime_get(), vmx->entry_time));
 
-	idt_vectoring_info = vmx->idt_vectoring_info;
-	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 	vector = idt_vectoring_info & VECTORING_INFO_VECTOR_MASK;
 	type = idt_vectoring_info & VECTORING_INFO_TYPE_MASK;
 	if (vmx->vcpu.arch.nmi_injected) {
 		/*
-		 * SDM 3: 25.7.1.2
+		 * SDM 3: 27.7.1.2 (September 2008)
 		 * Clear bit "block by NMI" before VM entry if a NMI delivery
 		 * faulted.
 		 */


