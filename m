Return-Path: <linux-kernel-owner+w=401wt.eu-S1750839AbXBSKYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839AbXBSKYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXBSKYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:24:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:35398 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXBSKYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:24:53 -0500
Subject: [PATCH 4/13] KVM: vmx: hack set_cr0_no_modeswitch() to actually do
	modeswitch
From: Avi Kivity <avi@qumranet.com>
Date: Mon, 19 Feb 2007 10:24:51 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45D979D3.2020907@qumranet.com>
In-Reply-To: <45D979D3.2020907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070219102451.E848F25016B@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Rechberger <markus.rechberger@amd.com>
From: Joerg Roedel <joerg.roedel@amd.com>

The whole thing is rotten, but this allows vmx to boot with the guest reboot
fix.

Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -791,6 +791,9 @@ static void vmx_set_cr0(struct kvm_vcpu 
  */
 static void vmx_set_cr0_no_modeswitch(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
+	if (!vcpu->rmode.active && !(cr0 & CR0_PE_MASK))
+		enter_rmode(vcpu);
+
 	vcpu->rmode.active = ((cr0 & CR0_PE_MASK) == 0);
 	update_exception_bitmap(vcpu);
 	vmcs_writel(CR0_READ_SHADOW, cr0);
