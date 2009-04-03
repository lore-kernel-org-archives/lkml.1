Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbZDCRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbZDCRQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbZDCRQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:16:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:42112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717AbZDCRQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:16:06 -0400
Date: Fri, 3 Apr 2009 17:15:34 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49D18FF0.50707@kernel.org>
References: <49D18FF0.50707@kernel.org>
Subject: [tip:irq/urgent] irq: fix cpumask memory leak on offstack cpumask kernels
Message-ID: <tip-9756b15e1b58453a6fd54b85c1ad8515209e10bb@git.kernel.org>
Git-Commit-ID: 9756b15e1b58453a6fd54b85c1ad8515209e10bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 17:15:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9756b15e1b58453a6fd54b85c1ad8515209e10bb
Gitweb:     http://git.kernel.org/tip/9756b15e1b58453a6fd54b85c1ad8515209e10bb
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 30 Mar 2009 20:37:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 19:14:44 +0200

irq: fix cpumask memory leak on offstack cpumask kernels

Need to free the old cpumask for affinity and pending_mask.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49D18FF0.50707@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
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
 
