Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0BRMNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 07:13:54 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14211 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab0BRMNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 07:13:52 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1DYT-02-HOO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 04/10] KVM: SVM: Sync all control registers on nested vmexit
Date: Thu, 18 Feb 2010 12:38:29 +0100
Message-ID: <1266493115-28386-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0436 (UTC) FILETIME=[E8FF23C0:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the vmexit emulation does not sync control
registers were the access is typically intercepted by the
nested hypervisor. But we can not count on that intercepts
to sync these registers too and make the code
architecturally more correct.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 25d26ec..9a4f9ee 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1644,9 +1644,13 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->save.ds     = vmcb->save.ds;
 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
 	nested_vmcb->save.idtr   = vmcb->save.idtr;
+	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	if (npt_enabled)
 		nested_vmcb->save.cr3    = vmcb->save.cr3;
+	else
+		nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
 	nested_vmcb->save.cr2    = vmcb->save.cr2;
+	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
 	nested_vmcb->save.rflags = vmcb->save.rflags;
 	nested_vmcb->save.rip    = vmcb->save.rip;
 	nested_vmcb->save.rsp    = vmcb->save.rsp;
-- 
1.6.6


