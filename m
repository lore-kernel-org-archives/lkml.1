Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbZGAAt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbZGAAt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbZGAAeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:16 -0400
Received: from kroah.org ([198.145.64.141]:60069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761265AbZGAAeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:14 2009
Message-Id: <20090701002414.580133016@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 009/108] KVM: x86: check for cr3 validity in ioctl_set_sregs
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-check-for-cr3-validity-in-ioctl_set_sregs.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 59839dfff5eabca01cc4e20b45797a60a80af8cb upstream.

Matt T. Yourst notes that kvm_arch_vcpu_ioctl_set_sregs lacks validity
checking for the new cr3 value:

"Userspace callers of KVM_SET_SREGS can pass a bogus value of cr3 to
the kernel. This will trigger a NULL pointer access in gfn_to_rmap()
when userspace next tries to call KVM_RUN on the affected VCPU and kvm
attempts to activate the new non-existent page table root.

This happens since kvm only validates that cr3 points to a valid guest
physical memory page when code *inside* the guest sets cr3. However, kvm
currently trusts the userspace caller (e.g. QEMU) on the host machine to
always supply a valid page table root, rather than properly validating
it along with the rest of the reloaded guest state."

http://sourceforge.net/tracker/?func=detail&atid=893831&aid=2687641&group_id=180599

Check for a valid cr3 address in kvm_arch_vcpu_ioctl_set_sregs, triple
fault in case of failure.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3934,7 +3934,13 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
-	vcpu->arch.cr3 = sregs->cr3;
+
+	down_read(&vcpu->kvm->slots_lock);
+	if (gfn_to_memslot(vcpu->kvm, sregs->cr3 >> PAGE_SHIFT))
+		vcpu->arch.cr3 = sregs->cr3;
+	else
+		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+	up_read(&vcpu->kvm->slots_lock);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 


