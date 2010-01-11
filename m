Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399Ab0AKVdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0AKVdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518Ab0AKVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:32:45 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35373 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0AKV1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VY7RLTe8GOmcI0y7wpfbirbyETC6Der2HoeXUuQn3rJC+eGDbM99RRTkSrzcqQerCP
         80ZTrJilZlDw4PuM7jkgA/G2Ebq0GES1yxWiRuw45qBiMyENN1nu/En2lOx94isHZOv9
         QlCCgrblVAkpeTzgmGCmmEWtErfr6BSoV28E4=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 03/26] x86: Convert tlbstate_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:33 +0100
Message-Id: <1263245216-14754-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-3-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep on in preempt-rt to raw_spinlocks.

See also: a74dbe8ff33a5ff1fbfdea84c4f8e2da56c7ebe2

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/x86/mm/tlb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 65b58e4..426f3a1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -41,7 +41,7 @@ union smp_flush_state {
 	struct {
 		struct mm_struct *flush_mm;
 		unsigned long flush_va;
-		spinlock_t tlbstate_lock;
+		raw_spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
 	char pad[INTERNODE_CACHE_BYTES];
@@ -181,7 +181,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
 	 * probably not worth checking this for a cache-hot lock.
 	 */
-	spin_lock(&f->tlbstate_lock);
+	raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -199,7 +199,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	spin_unlock(&f->tlbstate_lock);
+	raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
@@ -223,7 +223,7 @@ static int __cpuinit init_smp_flush(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
-		spin_lock_init(&flush_state[i].tlbstate_lock);
+		raw_spin_lock_init(&flush_state[i].tlbstate_lock);
 
 	return 0;
 }
-- 
1.6.5.2

