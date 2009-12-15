Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZLOEG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZLOEG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZLOEGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZLOEGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:06:54 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 01/20] Move TSC read to vmx_vcpu_put
Date: Mon, 14 Dec 2009 18:08:28 -1000
Message-Id: <1260850127-9766-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the VMX implementation match the SVM implementation as far
as when the TSC is read.  This means last_tsc is measured at the time
of relinquishing VM operation, rather than at CPU switch time.
That may seem non-optimal for now, but it is a preparatory step for
unifying the TSC code in both VMX and SVM and also for allowing
non-real time based TSCs.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b923f2a..75aa1d5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -424,7 +424,6 @@ static void __vcpu_clear(void *arg)
 		vmcs_clear(vmx->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
-	rdtscll(vmx->vcpu.arch.host_tsc);
 	list_del(&vmx->local_vcpus_link);
 	vmx->vcpu.cpu = -1;
 	vmx->launched = 0;
@@ -762,6 +761,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.host_tsc = native_read_tsc();
 	__vmx_load_host_state(to_vmx(vcpu));
 }
 
-- 
1.6.5.2

