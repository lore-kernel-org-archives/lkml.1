Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXA3OoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXA3OoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXA3OoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:44:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:52722 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965533AbXA3OoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:44:01 -0500
Subject: [PATCH 8/11] KVM: Two-way apic tpr synchronization
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:44:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144400.34306A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dor Laor <dor.laor@qumranet.com>

We report the value of cr8 to userspace on an exit.  Also let userspace change
cr8 when we re-enter the guest.  The lets 64-bit guest code maintain the tpr
correctly.

Thanks for Yaniv Kamay for the idea.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -1360,6 +1360,9 @@ static int kvm_dev_ioctl_run(struct kvm 
 	if (!vcpu)
 		return -ENOENT;
 
+	/* re-sync apic's tpr */
+	vcpu->cr8 = kvm_run->cr8;
+
 	if (kvm_run->emulated) {
 		kvm_arch_ops->skip_emulated_instruction(vcpu);
 		kvm_run->emulated = 0;
Index: linux-2.6/include/linux/kvm.h
===================================================================
--- linux-2.6.orig/include/linux/kvm.h
+++ linux-2.6/include/linux/kvm.h
@@ -65,6 +65,8 @@ struct kvm_run {
 	__u8 ready_for_interrupt_injection;
 	__u8 if_flag;
 	__u16 padding2;
+
+	/* in (pre_kvm_run), out (post_kvm_run) */
 	__u64 cr8;
 	__u64 apic_base;
 
