Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbXL3HZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbXL3HZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbXL3HLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:35 -0500
Received: from il.qumranet.com ([82.166.9.18]:59482 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbXL3HKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:50 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 41/52] KVM: Add statistic for remote tlb flushes
Date: Sun, 30 Dec 2007 09:10:27 +0200
Message-Id: <1198998638-22713-42-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    3 +++
 drivers/kvm/x86.c      |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index b65f5de..048849d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -300,6 +300,7 @@ struct kvm_vm_stat {
 	u32 mmu_pde_zapped;
 	u32 mmu_flooded;
 	u32 mmu_recycled;
+	u32 remote_tlb_flush;
 };
 
 struct kvm {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index d99396b..411b2bd 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -115,6 +115,9 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		if (cpu != -1 && cpu != raw_smp_processor_id())
 			cpu_set(cpu, cpus);
 	}
+	if (cpus_empty(cpus))
+		return;
+	++kvm->stat.remote_tlb_flush;
 	smp_call_function_mask(cpus, ack_flush, NULL, 1);
 }
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index b482b6a..ac09f38 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -73,6 +73,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_pde_zapped", VM_STAT(mmu_pde_zapped) },
 	{ "mmu_flooded", VM_STAT(mmu_flooded) },
 	{ "mmu_recycled", VM_STAT(mmu_recycled) },
+	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
 	{ NULL }
 };
 
-- 
1.5.3.7

