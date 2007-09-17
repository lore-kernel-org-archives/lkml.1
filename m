Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXIQIie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXIQIie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbXIQIch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:45264 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXIQIc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 030/104] KVM: fx_init() needs preemption disabled while it plays with the FPU state
Date: Mon, 17 Sep 2007 10:31:12 +0200
Message-Id: <1190017947449-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Now that kvm generally runs with preemption enabled, we need to protect
the fpu intialization sequence.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7aeaaba..5b42731 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -693,10 +693,13 @@ void fx_init(struct kvm_vcpu *vcpu)
 
 	} *fx_image;
 
+	/* Initialize guest FPU by resetting ours and saving into guest's */
+	preempt_disable();
 	fx_save(vcpu->host_fx_image);
 	fpu_init();
 	fx_save(vcpu->guest_fx_image);
 	fx_restore(vcpu->host_fx_image);
+	preempt_enable();
 
 	fx_image = (struct fx_image_s *)vcpu->guest_fx_image;
 	fx_image->mxcsr = 0x1f80;
-- 
1.5.3

