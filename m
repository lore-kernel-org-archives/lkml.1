Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZC0OdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZC0OdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbZC0OcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:32:25 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5262 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755682AbZC0OcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:32:22 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KH65PG-02-E3T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] kvm mmu: enabling 1GB pages by extending backing_size funtion
Date: Fri, 27 Mar 2009 15:31:58 +0100
Message-ID: <1238164319-16092-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Mar 2009 14:32:00.0634 (UTC) FILETIME=[CA4B2DA0:01C9AEE8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for 1GB pages in KVM by implementing
the support in backing_size().

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   30 ++++++++++++++++++++++--------
 1 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3f5e20b..471e5d0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -479,7 +479,9 @@ static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
 	vma = find_vma(current->mm, addr);
 	if (vma) {
 		size = vma_kernel_pagesize(vma);
-		if (size >= KVM_PAGE_SIZE_2M)
+		if (size == KVM_PAGE_SIZE_1G)
+			ret = KVM_PAGE_SIZE_1G;
+		else if (size >= KVM_PAGE_SIZE_2M)
 			ret = KVM_PAGE_SIZE_2M;
 	}
 	up_read(&current->mm->mmap_sem);
@@ -490,18 +492,30 @@ static enum kvm_page_size host_page_size(struct kvm *kvm, gfn_t gfn)
 static enum kvm_page_size backing_size(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
-
-	if (has_wrprotected_page(vcpu->kvm, gfn))
-		return KVM_PAGE_SIZE_4k;
-
-	if (host_page_size(vcpu->kvm, gfn) < KVM_PAGE_SIZE_2M)
-		return KVM_PAGE_SIZE_4k;
+	enum kvm_page_size host_size, ret;
 
 	slot = gfn_to_memslot(vcpu->kvm, gfn);
 	if (slot && slot->dirty_bitmap)
 		return KVM_PAGE_SIZE_4k;
 
-	return KVM_PAGE_SIZE_2M;
+	host_size = host_page_size(vcpu->kvm, gfn);
+
+	switch (host_size) {
+	case KVM_PAGE_SIZE_1G:
+		if (!has_wrprotected_largepage(vcpu->kvm, gfn)) {
+			ret = KVM_PAGE_SIZE_1G;
+			break;
+		}
+	case KVM_PAGE_SIZE_2M:
+		if (!has_wrprotected_page(vcpu->kvm, gfn)) {
+			ret = KVM_PAGE_SIZE_2M;
+			break;
+		}
+	default:
+		ret = KVM_PAGE_SIZE_4k;
+	}
+
+	return ret;
 }
 
 /*
-- 
1.5.6.4


