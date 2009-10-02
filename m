Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZJBBtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZJBBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbZJBBtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:49:08 -0400
Received: from kroah.org ([198.145.64.141]:33268 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbZJBBdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:18 2009
Message-Id: <20091002012418.302580674@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [075/136] KVM: MMU: fix missing locking in alloc_mmu_pages
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-fix-missing-locking-in-alloc_mmu_pages.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 6a1ac77110ee3e8d8dfdef8442f3b30b3d83e6a2)

n_requested_mmu_pages/n_free_mmu_pages are used by
kvm_mmu_change_mmu_pages to calculate the number of pages to zap.

alloc_mmu_pages, called from the vcpu initialization path, modifies this
variables without proper locking, which can result in a negative value
in kvm_mmu_change_mmu_pages (say, with cpu hotplug).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2713,12 +2713,14 @@ static int alloc_mmu_pages(struct kvm_vc
 
 	ASSERT(vcpu);
 
+	spin_lock(&vcpu->kvm->mmu_lock);
 	if (vcpu->kvm->arch.n_requested_mmu_pages)
 		vcpu->kvm->arch.n_free_mmu_pages =
 					vcpu->kvm->arch.n_requested_mmu_pages;
 	else
 		vcpu->kvm->arch.n_free_mmu_pages =
 					vcpu->kvm->arch.n_alloc_mmu_pages;
+	spin_unlock(&vcpu->kvm->mmu_lock);
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first


