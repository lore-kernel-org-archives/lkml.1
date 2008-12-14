Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbYLNIN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbYLNIN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYLNIHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbYLNIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:16 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 16/36] KVM: don't fee an unallocated irq source id
Date: Sun, 14 Dec 2008 10:06:49 +0200
Message-Id: <1229242029-13410-17-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Set assigned_dev->irq_source_id to -1 so that we can avoid freeing
a source ID which we never allocated.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8dab7ce..63fd882 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -210,7 +210,10 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 		pci_disable_msi(assigned_dev->dev);
 
 	kvm_unregister_irq_ack_notifier(&assigned_dev->ack_notifier);
-	kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
+
+	if (assigned_dev->irq_source_id != -1)
+		kvm_free_irq_source_id(kvm, assigned_dev->irq_source_id);
+	assigned_dev->irq_source_id = -1;
 
 	if (cancel_work_sync(&assigned_dev->interrupt_work))
 		/* We had pending work. That means we will have to take
@@ -466,7 +469,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	match->host_busnr = assigned_dev->busnr;
 	match->host_devfn = assigned_dev->devfn;
 	match->dev = dev;
-
+	match->irq_source_id = -1;
 	match->kvm = kvm;
 
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
-- 
1.6.0.3

