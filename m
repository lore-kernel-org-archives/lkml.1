Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZJBBsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZJBBsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZJBBr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:47:59 -0400
Received: from kroah.org ([198.145.64.141]:33280 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZJBBdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:18 2009
Message-Id: <20091002012418.807040109@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, avi@redhat.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Juan Quintela <quintela@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: [078/136] Revert "KVM: x86: check for cr3 validity in ioctl_set_sregs"
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=revert-kvm-x86-check-for-cr3-validity-in-ioctl_set_sregs.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit dc7e795e3dd2a763e5ceaa1615f307e808cf3932)

This reverts commit 6c20e1442bb1c62914bb85b7f4a38973d2a423ba.

To my understanding, it became obsolete with the advent of the more
robust check in mmu_alloc_roots (89da4ff17f). Moreover, it prevents
the conceptually safe pattern

 1. set sregs
 2. register mem-slots
 3. run vcpu

by setting a sticky triple fault during step 1.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4125,13 +4125,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct
 
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= vcpu->arch.cr3 != sregs->cr3;
-
-	down_read(&vcpu->kvm->slots_lock);
-	if (gfn_to_memslot(vcpu->kvm, sregs->cr3 >> PAGE_SHIFT))
-		vcpu->arch.cr3 = sregs->cr3;
-	else
-		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
-	up_read(&vcpu->kvm->slots_lock);
+	vcpu->arch.cr3 = sregs->cr3;
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 


