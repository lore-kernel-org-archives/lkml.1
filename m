Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZETLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZETLXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbZETLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:19:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901AbZETLSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 37/46] KVM: ia64: restore irq state before calling kvm_vcpu_init
Date: Wed, 20 May 2009 14:18:34 +0300
Message-Id: <1242818323-10413-38-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Make sure to restore the psr after calling kvm_insert_vmm_mapping()
which calls ia64_itr_entry() as it disables local interrupts and
kvm_vcpu_init() may sleep.

Avoids a warning from the lock debugging code.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Acked-by : Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7263171..5b868db 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1290,6 +1290,7 @@ static int vti_vcpu_setup(struct kvm_vcpu *vcpu, int id)
 
 	local_irq_save(psr);
 	r = kvm_insert_vmm_mapping(vcpu);
+	local_irq_restore(psr);
 	if (r)
 		goto fail;
 	r = kvm_vcpu_init(vcpu, vcpu->kvm, id);
@@ -1307,13 +1308,11 @@ static int vti_vcpu_setup(struct kvm_vcpu *vcpu, int id)
 		goto uninit;
 
 	kvm_purge_vmm_mapping(vcpu);
-	local_irq_restore(psr);
 
 	return 0;
 uninit:
 	kvm_vcpu_uninit(vcpu);
 fail:
-	local_irq_restore(psr);
 	return r;
 }
 
-- 
1.6.0.6

