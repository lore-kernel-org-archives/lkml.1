Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbZHGJvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbZHGJvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZHGJvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:51:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21921 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbZHGJvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:51:01 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03B7-03-0WP-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/21] kvm/svm: complete interrupts after handling nested exits
Date: Fri, 7 Aug 2009 11:49:32 +0200
Message-ID: <1249638588-10982-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:50.0921 (UTC) FILETIME=[6856BB90:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt completion code must run after nested exits are handled
because not injected interrupts or exceptions may be handled by the l1
guest first.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Alexander Graf <agraf@suse.de>
---
 arch/x86/kvm/svm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e656425..b51d288 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -112,6 +112,7 @@ static int nested = 0;
 module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
+static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm, bool kvm_override);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
@@ -2325,6 +2326,8 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		}
 	}
 
+	svm_complete_interrupts(svm);
+
 	if (npt_enabled) {
 		int mmu_reload = 0;
 		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
@@ -2691,8 +2694,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.regs_avail &= ~(1 << VCPU_EXREG_PDPTR);
 		vcpu->arch.regs_dirty &= ~(1 << VCPU_EXREG_PDPTR);
 	}
-
-	svm_complete_interrupts(svm);
 }
 
 #undef R
-- 
1.6.3.3


