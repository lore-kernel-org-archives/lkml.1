Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588Ab0AEONj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0AEONj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539Ab0AEONb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:13:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab0AEON3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:13:29 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org
Subject: [PATCH v3 07/12] Maintain memslot version number
Date: Tue,  5 Jan 2010 16:12:49 +0200
Message-Id: <1262700774-1808-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1262700774-1808-1-git-send-email-gleb@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code that depends on particular memslot layout can track changes and
adjust to new layout.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 600baf0..3f5ebc2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -163,6 +163,7 @@ struct kvm {
 	spinlock_t requests_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	u32 memslot_version;
 	struct kvm_memslots *memslots;
 	struct srcu_struct srcu;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5077df..df3325c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -737,6 +737,7 @@ skip_lpage:
 	slots->memslots[mem->slot] = new;
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
+	kvm->memslot_version++;
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
-- 
1.6.5

