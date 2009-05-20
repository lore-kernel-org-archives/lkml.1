Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZETLbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZETLbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbZETLVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55266 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbZETLSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:48 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 14/46] KVM: Fix task switch back link handling.
Date: Wed, 20 May 2009 14:18:11 +0300
Message-Id: <1242818323-10413-15-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Back link is written to a wrong TSS now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   40 ++++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7be18d4..157d54b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3713,7 +3713,6 @@ static void save_state_to_tss32(struct kvm_vcpu *vcpu,
 	tss->fs = get_segment_selector(vcpu, VCPU_SREG_FS);
 	tss->gs = get_segment_selector(vcpu, VCPU_SREG_GS);
 	tss->ldt_selector = get_segment_selector(vcpu, VCPU_SREG_LDTR);
-	tss->prev_task_link = get_segment_selector(vcpu, VCPU_SREG_TR);
 }
 
 static int load_state_from_tss32(struct kvm_vcpu *vcpu,
@@ -3810,8 +3809,8 @@ static int load_state_from_tss16(struct kvm_vcpu *vcpu,
 }
 
 static int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
-		       u32 old_tss_base,
-		       struct desc_struct *nseg_desc)
+			      u16 old_tss_sel, u32 old_tss_base,
+			      struct desc_struct *nseg_desc)
 {
 	struct tss_segment_16 tss_segment_16;
 	int ret = 0;
@@ -3830,6 +3829,16 @@ static int kvm_task_switch_16(struct kvm_vcpu *vcpu, u16 tss_selector,
 			   &tss_segment_16, sizeof tss_segment_16))
 		goto out;
 
+	if (old_tss_sel != 0xffff) {
+		tss_segment_16.prev_task_link = old_tss_sel;
+
+		if (kvm_write_guest(vcpu->kvm,
+				    get_tss_base_addr(vcpu, nseg_desc),
+				    &tss_segment_16.prev_task_link,
+				    sizeof tss_segment_16.prev_task_link))
+			goto out;
+	}
+
 	if (load_state_from_tss16(vcpu, &tss_segment_16))
 		goto out;
 
@@ -3839,7 +3848,7 @@ out:
 }
 
 static int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
-		       u32 old_tss_base,
+		       u16 old_tss_sel, u32 old_tss_base,
 		       struct desc_struct *nseg_desc)
 {
 	struct tss_segment_32 tss_segment_32;
@@ -3859,6 +3868,16 @@ static int kvm_task_switch_32(struct kvm_vcpu *vcpu, u16 tss_selector,
 			   &tss_segment_32, sizeof tss_segment_32))
 		goto out;
 
+	if (old_tss_sel != 0xffff) {
+		tss_segment_32.prev_task_link = old_tss_sel;
+
+		if (kvm_write_guest(vcpu->kvm,
+				    get_tss_base_addr(vcpu, nseg_desc),
+				    &tss_segment_32.prev_task_link,
+				    sizeof tss_segment_32.prev_task_link))
+			goto out;
+	}
+
 	if (load_state_from_tss32(vcpu, &tss_segment_32))
 		goto out;
 
@@ -3914,12 +3933,17 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 
+	/* set back link to prev task only if NT bit is set in eflags
+	   note that old_tss_sel is not used afetr this point */
+	if (reason != TASK_SWITCH_CALL && reason != TASK_SWITCH_GATE)
+		old_tss_sel = 0xffff;
+
 	if (nseg_desc.type & 8)
-		ret = kvm_task_switch_32(vcpu, tss_selector, old_tss_base,
-					 &nseg_desc);
+		ret = kvm_task_switch_32(vcpu, tss_selector, old_tss_sel,
+					 old_tss_base, &nseg_desc);
 	else
-		ret = kvm_task_switch_16(vcpu, tss_selector, old_tss_base,
-					 &nseg_desc);
+		ret = kvm_task_switch_16(vcpu, tss_selector, old_tss_sel,
+					 old_tss_base, &nseg_desc);
 
 	if (reason == TASK_SWITCH_CALL || reason == TASK_SWITCH_GATE) {
 		u32 eflags = kvm_x86_ops->get_rflags(vcpu);
-- 
1.6.0.6

