Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab0BPKhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:37:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932824Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/38] KVM: MMU: Remove some useless code from alloc_mmu_pages()
Date: Tue, 16 Feb 2010 12:35:19 +0200
Message-Id: <1266316536-28936-22-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If we fail to alloc page for vcpu->arch.mmu.pae_root, call to
free_mmu_pages() is unnecessary, which just do free the page
malloc for vcpu->arch.mmu.pae_root.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/mmu.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 599c422..dc4d954 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2843,16 +2843,13 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	 */
 	page = alloc_page(GFP_KERNEL | __GFP_DMA32);
 	if (!page)
-		goto error_1;
+		return -ENOMEM;
+
 	vcpu->arch.mmu.pae_root = page_address(page);
 	for (i = 0; i < 4; ++i)
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 
 	return 0;
-
-error_1:
-	free_mmu_pages(vcpu);
-	return -ENOMEM;
 }
 
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
-- 
1.6.5.3

