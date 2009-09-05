Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbZIEA1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbZIEA1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934651AbZIEAVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:15 -0400
Received: from kroah.org ([198.145.64.141]:42135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934599AbZIEAUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:51 2009
Message-Id: <20090905001451.296102408@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 25/71] KVM: MMU: Use different shadows when EFER.NXE changes
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-use-different-shadows-when-efer.nxe-changes.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 9645bb56b31a1b70ab9e470387b5264cafc04aa9)

A pte that is shadowed when the guest EFER.NXE=1 is not valid when
EFER.NXE=0; if bit 63 is set, the pte should cause a fault, and since the
shadow EFER always has NX enabled, this won't happen.

Fix by using a different shadow page table for different EFER.NXE bits.  This
allows vcpus to run correctly with different values of EFER.NXE, and for
transitions on this bit to be handled correctly without requiring a full
flush.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    3 +++
 2 files changed, 4 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -185,6 +185,7 @@ union kvm_mmu_page_role {
 		unsigned access:3;
 		unsigned invalid:1;
 		unsigned cr4_pge:1;
+		unsigned nxe:1;
 	};
 };
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -523,6 +523,9 @@ static void set_efer(struct kvm_vcpu *vc
 	efer |= vcpu->arch.shadow_efer & EFER_LMA;
 
 	vcpu->arch.shadow_efer = efer;
+
+	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
+	kvm_mmu_reset_context(vcpu);
 }
 
 void kvm_enable_efer_bits(u64 mask)


