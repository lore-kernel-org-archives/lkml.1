Return-Path: <linux-kernel-owner+w=401wt.eu-S965545AbXA3OrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545AbXA3OrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965546AbXA3OrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:47:07 -0500
Received: from il.qumranet.com ([62.219.232.206]:52822 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbXA3OrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:47:03 -0500
Subject: [PATCH 11/11] KVM: fix vcpu freeing bug
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:47:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144700.4A5BEA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

vcpu_load() can return NULL and it sometimes does in failure paths (for 
example when the userspace ABI version is too old) - causing a 
preemption count underflow in the ->vcpu_free() later on. So check for 
NULL.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -272,7 +272,9 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	vcpu_load(vcpu->kvm, vcpu_slot(vcpu));
+	if (!vcpu_load(vcpu->kvm, vcpu_slot(vcpu)))
+		return;
+
 	kvm_mmu_destroy(vcpu);
 	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
