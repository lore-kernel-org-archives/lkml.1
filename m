Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZCEMO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZCEMO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCEMND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:13:03 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:13633
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753505AbZCEMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:12:57 -0500
X-BigFish: VPS11(z1857rzzzzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KG18L4-02-DEF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/6] kvm/x86: call kvm_lapic_sync_from_vapic with preemption disabled
Date: Thu, 5 Mar 2009 13:12:32 +0100
Message-ID: <1236255153-4432-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 05 Mar 2009 12:12:33.0811 (UTC) FILETIME=[AA30CE30:01C99D8B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function uses kmap_atomic. Calling it with preemption enabled is
racy.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b556b6a..ff833f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3203,6 +3203,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	kvm_guest_exit();
 
+	kvm_lapic_sync_from_vapic(vcpu);
+
 	preempt_enable();
 
 	down_read(&vcpu->kvm->slots_lock);
@@ -3218,7 +3220,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	if (vcpu->arch.exception.pending && kvm_x86_ops->exception_injected(vcpu))
 		vcpu->arch.exception.pending = false;
 
-	kvm_lapic_sync_from_vapic(vcpu);
 
 	r = kvm_x86_ops->handle_exit(kvm_run, vcpu);
 out:
-- 
1.5.6.4


