Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab0BQNph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:45:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab0BQNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:33 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] KVM: PIT: unregister kvm irq notifier if fail to create pit
Date: Wed, 17 Feb 2010 15:45:14 +0200
Message-Id: <1266414330-27444-5-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

If fail to create pit, we should unregister kvm irq notifier
which register in kvm_create_pit().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 6a74246..c9569f2 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -663,8 +663,9 @@ fail_unregister:
 	kvm_io_bus_unregister_dev(kvm, KVM_PIO_BUS, &pit->dev);
 
 fail:
-	if (pit->irq_source_id >= 0)
-		kvm_free_irq_source_id(kvm, pit->irq_source_id);
+	kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
+	kvm_unregister_irq_ack_notifier(kvm, &pit_state->irq_ack_notifier);
+	kvm_free_irq_source_id(kvm, pit->irq_source_id);
 
 	kfree(pit);
 	return NULL;
-- 
1.6.5.3

