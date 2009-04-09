Return-Path: <linux-kernel-owner+w=401wt.eu-S935455AbZDIPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455AbZDIPjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbZDIPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:39:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760335AbZDIPjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:39:13 -0400
Date: Thu, 9 Apr 2009 17:39:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] irq fixes
Message-ID: <20090409153901.GA19681@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Yinghai Lu (1):
      irq: fix cpumask memory leak on offstack cpumask kernels


 include/linux/irq.h       |   14 ++++++++++++++
 kernel/irq/numa_migrate.c |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 974890b..99d147e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -482,6 +482,16 @@ static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 #endif
 }
 
+static inline void free_desc_masks(struct irq_desc *old_desc,
+				   struct irq_desc *new_desc)
+{
+	free_cpumask_var(old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	free_cpumask_var(old_desc->pending_mask);
+#endif
+}
+
 #else /* !CONFIG_SMP */
 
 static inline bool init_alloc_desc_masks(struct irq_desc *desc, int cpu,
@@ -495,6 +505,10 @@ static inline void init_copy_desc_masks(struct irq_desc *old_desc,
 {
 }
 
+static inline void free_desc_masks(struct irq_desc *old_desc,
+				   struct irq_desc *new_desc)
+{
+}
 #endif	/* CONFIG_SMP */
 
 #endif /* _LINUX_IRQ_H */
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 243d612..44bbdcb 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -54,6 +54,7 @@ static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
 static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
 {
 	free_kstat_irqs(old_desc, desc);
+	free_desc_masks(old_desc, desc);
 	arch_free_chip_data(old_desc, desc);
 }
 
