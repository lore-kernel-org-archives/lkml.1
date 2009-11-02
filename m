Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZKBQSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZKBQSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbZKBQR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:17:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:53646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbZKBQR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:17:57 -0500
Date: Mon, 2 Nov 2009 16:17:11 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091026230001.752968906@sbs-t61.sc.intel.com>
References: <20091026230001.752968906@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Remove move_cleanup_count from irq_cfg
Message-ID: <tip-23359a88e7eca3c4f402562b102f23014db3c2aa@git.kernel.org>
Git-Commit-ID: 23359a88e7eca3c4f402562b102f23014db3c2aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23359a88e7eca3c4f402562b102f23014db3c2aa
Gitweb:     http://git.kernel.org/tip/23359a88e7eca3c4f402562b102f23014db3c2aa
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 26 Oct 2009 14:24:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 15:56:35 +0100

x86: Remove move_cleanup_count from irq_cfg

move_cleanup_count for each irq in irq_cfg is keeping track of
the total number of cpus that need to free the corresponding
vectors associated with the irq which has now been migrated to
new destination. As long as this move_cleanup_count is non-zero
(i.e., as long as we have n't freed the vector allocations on
the old destinations) we were preventing the irq's further
migration.

This cleanup count is unnecessary and it is enough to not allow
the irq migration till we send the cleanup vector to the
previous irq destination, for which we already have irq_cfg's
move_in_progress.  All we need to make sure is that we free the
vector at the old desintation but we don't need to wait till
that gets freed.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Gary Hade <garyhade@us.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <20091026230001.752968906@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/hw_irq.h  |    1 -
 arch/x86/kernel/apic/io_apic.c |    9 +--------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 1984ce9..6e12426 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -94,7 +94,6 @@ struct irq_cfg {
 	struct irq_pin_list	*irq_2_pin;
 	cpumask_var_t		domain;
 	cpumask_var_t		old_domain;
-	unsigned		move_cleanup_count;
 	u8			vector;
 	u8			move_in_progress : 1;
 };
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce16b65..e9e5b02 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1161,7 +1161,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+	if (cfg->move_in_progress)
 		return -EBUSY;
 
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
@@ -2234,14 +2234,10 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
-		cfg->move_cleanup_count = 0;
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
-			cfg->move_cleanup_count++;
 		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
 			apic->send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
 		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
-		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
 		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
@@ -2430,8 +2426,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 
 		cfg = irq_cfg(irq);
 		spin_lock(&desc->lock);
-		if (!cfg->move_cleanup_count)
-			goto unlock;
 
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
@@ -2449,7 +2443,6 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			goto unlock;
 		}
 		__get_cpu_var(vector_irq)[vector] = -1;
-		cfg->move_cleanup_count--;
 unlock:
 		spin_unlock(&desc->lock);
 	}
