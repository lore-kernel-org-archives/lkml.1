Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYLNIM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYLNIM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYLNIHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 15/36] KVM: make kvm_unregister_irq_ack_notifier() safe
Date: Sun, 14 Dec 2008 10:06:48 +0200
Message-Id: <1229242029-13410-16-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

We never pass a NULL notifier pointer here, but we may well
pass a notifier struct which hasn't previously been
registered.

Guard against this by using hlist_del_init() which will
not do anything if the node hasn't been added to the list
and, when removing the node, will ensure that a subsequent
call to hlist_del_init() will be fine too.

Fixes an oops seen when an assigned device is freed before
and IRQ is assigned to it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/irq_comm.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 973df99..db75045 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -63,9 +63,7 @@ void kvm_register_irq_ack_notifier(struct kvm *kvm,
 
 void kvm_unregister_irq_ack_notifier(struct kvm_irq_ack_notifier *kian)
 {
-	if (!kian)
-		return;
-	hlist_del(&kian->link);
+	hlist_del_init(&kian->link);
 }
 
 /* The caller must hold kvm->lock mutex */
-- 
1.6.0.3

