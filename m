Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbYDCTgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbYDCTgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbYDCTdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:08 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53020
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760302AbYDCTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 17/35] KVM: Add reset support for in kernel PIT
Date: Thu,  3 Apr 2008 22:32:32 +0300
Message-Id: <1207251170-5013-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

Separate the reset part and prepare for reset support.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8254.c |   30 +++++++++++++++++++-----------
 arch/x86/kvm/i8254.h |    1 +
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 7776f50..06a241a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -476,12 +476,28 @@ static int speaker_in_range(struct kvm_io_device *this, gpa_t addr)
 	return (addr == KVM_SPEAKER_BASE_ADDRESS);
 }
 
-struct kvm_pit *kvm_create_pit(struct kvm *kvm)
+void kvm_pit_reset(struct kvm_pit *pit)
 {
 	int i;
+	struct kvm_kpit_channel_state *c;
+
+	mutex_lock(&pit->pit_state.lock);
+	for (i = 0; i < 3; i++) {
+		c = &pit->pit_state.channels[i];
+		c->mode = 0xff;
+		c->gate = (i != 2);
+		pit_load_count(pit->kvm, i, 0);
+	}
+	mutex_unlock(&pit->pit_state.lock);
+
+	atomic_set(&pit->pit_state.pit_timer.pending, 0);
+	pit->pit_state.inject_pending = 1;
+}
+
+struct kvm_pit *kvm_create_pit(struct kvm *kvm)
+{
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
-	struct kvm_kpit_channel_state *c;
 
 	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
 	if (!pit)
@@ -510,17 +526,9 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	pit_state->pit = pit;
 	hrtimer_init(&pit_state->pit_timer.timer,
 		     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	atomic_set(&pit_state->pit_timer.pending, 0);
-	for (i = 0; i < 3; i++) {
-		c = &pit_state->channels[i];
-		c->mode = 0xff;
-		c->gate = (i != 2);
-		pit_load_count(kvm, i, 0);
-	}
-
 	mutex_unlock(&pit->pit_state.lock);
 
-	pit->pit_state.inject_pending = 1;
+	kvm_pit_reset(pit);
 
 	return pit;
 }
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 586bbf0..e63ef38 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -57,5 +57,6 @@ void kvm_pit_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val);
 struct kvm_pit *kvm_create_pit(struct kvm *kvm);
 void kvm_free_pit(struct kvm *kvm);
+void kvm_pit_reset(struct kvm_pit *pit);
 
 #endif
-- 
1.5.4.5

