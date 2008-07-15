Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYGOMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYGOMN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYGOMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:30328 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbYGOMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:40 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 03/19] KVM: move slots_lock acquision down to vapic_exit
Date: Tue, 15 Jul 2008 15:12:22 +0300
Message-Id: <1216123958-10717-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

There is no need to grab slots_lock if the vapic_page will not
be touched.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0fbc032..ef53d88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2787,8 +2787,10 @@ static void vapic_exit(struct kvm_vcpu *vcpu)
 	if (!apic || !apic->vapic_addr)
 		return;
 
+	down_read(&vcpu->kvm->slots_lock);
 	kvm_release_page_dirty(apic->vapic_page);
 	mark_page_dirty(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
+	up_read(&vcpu->kvm->slots_lock);
 }
 
 static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
@@ -2944,9 +2946,7 @@ out:
 
 	post_kvm_run_save(vcpu, kvm_run);
 
-	down_read(&vcpu->kvm->slots_lock);
 	vapic_exit(vcpu);
-	up_read(&vcpu->kvm->slots_lock);
 
 	return r;
 }
-- 
1.5.6.1

