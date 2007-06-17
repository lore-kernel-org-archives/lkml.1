Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbXFQJuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbXFQJuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759272AbXFQJox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:55187 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398AbXFQJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 13/58] KVM: Move some more msr mangling into vmx_save_host_state()
Date: Sun, 17 Jun 2007 12:43:54 +0300
Message-Id: <11820734801582-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 677b38c..93c3abf 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -290,6 +290,13 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	vmcs_writel(HOST_FS_BASE, segment_base(hs->fs_sel));
 	vmcs_writel(HOST_GS_BASE, segment_base(hs->gs_sel));
 #endif
+
+#ifdef CONFIG_X86_64
+	if (is_long_mode(vcpu)) {
+		save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
+		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
+	}
+#endif
 }
 
 static void vmx_load_host_state(struct kvm_vcpu *vcpu)
@@ -1903,13 +1910,6 @@ preempted:
 	if (vcpu->guest_debug.enabled)
 		kvm_guest_debug_pre(vcpu);
 
-#ifdef CONFIG_X86_64
-	if (is_long_mode(vcpu)) {
-		save_msrs(vcpu->host_msrs + msr_offset_kernel_gs_base, 1);
-		load_msrs(vcpu->guest_msrs, NR_BAD_MSRS);
-	}
-#endif
-
 again:
 	vmx_save_host_state(vcpu);
 	kvm_load_guest_fpu(vcpu);
-- 
1.5.0.6

