Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0BSPX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:23:27 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:4946 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751617Ab0BSPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:23:25 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY3HEO-02-7NA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 04/11] KVM: SVM: Sync all control registers on nested vmexit
Date: Fri, 19 Feb 2010 16:23:03 +0100
Message-ID: <1266592990-8911-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Feb 2010 15:23:12.0715 (UTC) FILETIME=[734D49B0:01CAB177]
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
index 6dc7a41..c9d359a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1642,9 +1642,13 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
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


