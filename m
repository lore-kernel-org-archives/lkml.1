Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXDZJWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXDZJWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXDZJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:53003 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769AbXDZJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 02/18] KVM: Fix overflow bug in overflow detection code
Date: Thu, 26 Apr 2007 12:22:02 +0300
Message-Id: <11775793382198-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>

The expression

   sp - 6 < sp

where sp is a u16 is undefined in C since 'sp - 6' is promoted to int,
and signed overflow is undefined in C.  gcc 4.2 actually warns about it.
Replace with a simpler test.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 61a6116..8c0115b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1182,7 +1182,7 @@ static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
 	u16 sp =  vmcs_readl(GUEST_RSP);
 	u32 ss_limit = vmcs_read32(GUEST_SS_LIMIT);
 
-	if (sp > ss_limit || sp - 6 > sp) {
+	if (sp > ss_limit || sp < 6 ) {
 		vcpu_printf(vcpu, "%s: #SS, rsp 0x%lx ss 0x%lx limit 0x%x\n",
 			    __FUNCTION__,
 			    vmcs_readl(GUEST_RSP),
-- 
1.5.0.6

