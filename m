Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbXFQJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbXFQJvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXFQJo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:55175 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 21/58] KVM: Avoid corrupting tr in real mode
Date: Sun, 17 Jun 2007 12:44:02 +0300
Message-Id: <1182073480150-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The real mode tr needs to be set to a specific tss so that I/O
instructions can function.  Divert the new tr values to the real
mode save area from where they will be restored on transition to
protected mode.

This fixes some crashes on reboot when the bios accesses an I/O
instruction.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   45 +++++++++++++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b353eaa..e39ebe0 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1042,23 +1042,11 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 	var->unusable = (ar >> 16) & 1;
 }
 
-static void vmx_set_segment(struct kvm_vcpu *vcpu,
-			    struct kvm_segment *var, int seg)
+static u32 vmx_segment_access_rights(struct kvm_segment *var)
 {
-	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
 	u32 ar;
 
-	vmcs_writel(sf->base, var->base);
-	vmcs_write32(sf->limit, var->limit);
-	vmcs_write16(sf->selector, var->selector);
-	if (vcpu->rmode.active && var->s) {
-		/*
-		 * Hack real-mode segments into vm86 compatibility.
-		 */
-		if (var->base == 0xffff0000 && var->selector == 0xf000)
-			vmcs_writel(sf->base, 0xf0000);
-		ar = 0xf3;
-	} else if (var->unusable)
+	if (var->unusable)
 		ar = 1 << 16;
 	else {
 		ar = var->type & 15;
@@ -1072,6 +1060,35 @@ static void vmx_set_segment(struct kvm_vcpu *vcpu,
 	}
 	if (ar == 0) /* a 0 value means unusable */
 		ar = AR_UNUSABLE_MASK;
+
+	return ar;
+}
+
+static void vmx_set_segment(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg)
+{
+	struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
+	u32 ar;
+
+	if (vcpu->rmode.active && seg == VCPU_SREG_TR) {
+		vcpu->rmode.tr.selector = var->selector;
+		vcpu->rmode.tr.base = var->base;
+		vcpu->rmode.tr.limit = var->limit;
+		vcpu->rmode.tr.ar = vmx_segment_access_rights(var);
+		return;
+	}
+	vmcs_writel(sf->base, var->base);
+	vmcs_write32(sf->limit, var->limit);
+	vmcs_write16(sf->selector, var->selector);
+	if (vcpu->rmode.active && var->s) {
+		/*
+		 * Hack real-mode segments into vm86 compatibility.
+		 */
+		if (var->base == 0xffff0000 && var->selector == 0xf000)
+			vmcs_writel(sf->base, 0xf0000);
+		ar = 0xf3;
+	} else
+		ar = vmx_segment_access_rights(var);
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
-- 
1.5.0.6

