Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXIQIjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXIQIjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXIQIck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:45291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 039/104] KVM: kvm_vm_ioctl_get_dirty_log restore "nothing dirty" optimization
Date: Mon, 17 Sep 2007 10:31:21 +0200
Message-Id: <11900179471758-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

kvm_vm_ioctl_get_dirty_log scans bitmap to see it it's all zero, but
doesn't use that information.

Avi says:
	Looks like it was used to guard	kvm_mmu_slot_remove_write_access();
	optimizing the case where the guest just leaves the screen alone (which
	it usually does, especially in benchmarks).

	I'd rather reinstate that optimization.  See
	90cb0529dd230548a7f0d6b315997be854caea1b where the damage was done.

It's pretty simple: if the bitmap is all zero, we don't need to do anything to
clean it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index bfb1b6d..5dee302 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -803,11 +803,14 @@ static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-	mutex_lock(&kvm->lock);
-	kvm_mmu_slot_remove_write_access(kvm, log->slot);
-	kvm_flush_remote_tlbs(kvm);
-	memset(memslot->dirty_bitmap, 0, n);
-	mutex_unlock(&kvm->lock);
+	/* If nothing is dirty, don't bother messing with page tables. */
+	if (any) {
+		mutex_lock(&kvm->lock);
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		kvm_flush_remote_tlbs(kvm);
+		memset(memslot->dirty_bitmap, 0, n);
+		mutex_unlock(&kvm->lock);
+	}
 
 	r = 0;
 
-- 
1.5.3

