Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXAaPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXAaPAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbXAaPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:00:23 -0500
Received: from il.qumranet.com ([62.219.232.206]:42716 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXAaPAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:00:22 -0500
Subject: [PATCH] KVM: Fix lockup on 32-bit intel hosts with nx disabled in the
	bios
From: Avi Kivity <avi@qumranet.com>
Date: Wed, 31 Jan 2007 15:00:16 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070131150017.020B9A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel hosts, without long mode, and with nx support disabled in the bios
have an efer that is readable but not writable.  This causes a lockup on
switch to guest mode (even though it should exit with reason 34 according to
the documentation).

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1128,6 +1128,8 @@ static int vmx_vcpu_setup(struct kvm_vcp
 
 		if (rdmsr_safe(index, &data_low, &data_high) < 0)
 			continue;
+		if (wrmsr_safe(index, data_low, data_high) < 0)
+			continue;
 		data = data_low | ((u64)data_high << 32);
 		vcpu->host_msrs[j].index = index;
 		vcpu->host_msrs[j].reserved = 0;
