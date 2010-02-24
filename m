Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0BXR7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:59:37 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:19425
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757344Ab0BXR7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:35 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXYX-02-PJQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/11] KVM: SVM: Reset MMU on nested_svm_vmrun for NPT too
Date: Wed, 24 Feb 2010 18:59:11 +0100
Message-ID: <1267034360-5907-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0449 (UTC) FILETIME=[18C29290:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without resetting the MMU the gva_to_pga function will not
work reliably when the vcpu is running in nested context.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 217b8b0..b821b2f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1871,10 +1871,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	if (npt_enabled) {
 		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
 		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
-	} else {
+	} else
 		kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
-		kvm_mmu_reset_context(&svm->vcpu);
-	}
+
+	/* Guest paging mode is active - reset mmu */
+	kvm_mmu_reset_context(&svm->vcpu);
+
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, nested_vmcb->save.rax);
 	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
-- 
1.7.0


