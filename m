Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0CCTNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:13:14 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:38763
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753630Ab0CCTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:01 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz936eMab9bhab78ozz1202hzzz32i87h2a8h6bh65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ018-01-LM2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/18] KVM: MMU: Introduce inject_page_fault function pointer
Date: Wed, 3 Mar 2010 20:12:09 +0100
Message-ID: <1267643541-451-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0641 (UTC) FILETIME=[7FC64010:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an inject_page_fault function pointer
into struct kvm_mmu which will be used to inject a page
fault. This will be used later when Nested Nested Paging is
implemented.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/mmu.c              |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 37d0145..c0b5576 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -244,6 +244,9 @@ struct kvm_mmu {
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
+				  unsigned long addr,
+				  u32 error_code);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 189c68d..8f835f1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2263,7 +2263,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_inject_page_fault(vcpu, addr, err_code);
+	vcpu->arch.mmu.inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
@@ -2446,6 +2446,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.tdp_enabled       = false;
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
+	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
 
 	return r;
 }
-- 
1.7.0


