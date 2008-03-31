Return-Path: <linux-kernel-owner+w=401wt.eu-S1759226AbYCaOoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbYCaOoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYCaOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:46 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51324
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYCaOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/40] KVM: MMU: make the __nonpaging_map function generic
Date: Mon, 31 Mar 2008 17:37:08 +0300
Message-Id: <1206974244-9716-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The mapping function for the nonpaging case in the softmmu does basically the
same as required for Nested Paging. Make this function generic so it can be
used for both.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 21cfa28..33cd7c9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -979,10 +979,9 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int __nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write,
-			   gfn_t gfn, struct page *page)
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
+			   gfn_t gfn, struct page *page, int level)
 {
-	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
 	int pt_write = 0;
 
@@ -1042,7 +1041,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
-	r = __nonpaging_map(vcpu, v, write, gfn, page);
+	r = __direct_map(vcpu, v, write, gfn, page, PT32E_ROOT_LEVEL);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	up_read(&vcpu->kvm->slots_lock);
-- 
1.5.4.5

