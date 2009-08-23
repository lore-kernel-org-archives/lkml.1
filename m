Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbZHWMAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbZHWMAz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933697AbZHWMA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/46] KVM: Drop obsolete cpu_get/put in make_all_cpus_request
Date: Sun, 23 Aug 2009 14:56:34 +0300
Message-Id: <1251028605-31977-36-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

spin_lock disables preemption, so we can simply read the current cpu.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/kvm_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 532af9b..646cf2a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -741,8 +741,8 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	if (alloc_cpumask_var(&cpus, GFP_ATOMIC))
 		cpumask_clear(cpus);
 
-	me = get_cpu();
 	spin_lock(&kvm->requests_lock);
+	me = smp_processor_id();
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (test_and_set_bit(req, &vcpu->requests))
 			continue;
@@ -757,7 +757,6 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	else
 		called = false;
 	spin_unlock(&kvm->requests_lock);
-	put_cpu();
 	free_cpumask_var(cpus);
 	return called;
 }
-- 
1.6.4.1

