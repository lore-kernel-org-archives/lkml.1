Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbZIDUOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbZIDUOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933989AbZIDUOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:22 -0400
Received: from kroah.org ([198.145.64.141]:36135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbZIDUOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.629953579@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 11/48] KVM: MMU: Add locking around kvm_mmu_slot_remove_write_access()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-add-locking-around-kvm_mmu_slot_remove_write_access.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit 2245a28fe2e6fdb1bdabc4dcde1ea3a5c37e2a9e)

It was generally safe due to slots_lock being held for write, but it wasn't
very nice.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2055,6 +2055,7 @@ void kvm_mmu_slot_remove_write_access(st
 {
 	struct kvm_mmu_page *sp;
 
+	spin_lock(&kvm->mmu_lock);
 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
@@ -2068,6 +2069,7 @@ void kvm_mmu_slot_remove_write_access(st
 			if (pt[i] & PT_WRITABLE_MASK)
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
+	spin_unlock(&kvm->mmu_lock);
 }
 
 void kvm_mmu_zap_all(struct kvm *kvm)


