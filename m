Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYHAJyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYHAJyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYHAJyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:54:12 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:13784 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYHAJyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FZWhu40GkCA8r89uK8COLDfyVrmRcPIDOHSDEPFox9NhkaMHLnATBnsZqsGFDh9xPZ
         5D8IaThg0ojxeuG86KP6OdIY2wxPzGZACvuoXSA1kXUv8RBKD0kijneX0BgHd1UfpjVf
         CwA1Jrhqdt5yfCwVbPLbWLbrqXUpeaqAKYjio=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 10/16] irq: make irqs in kernel stat use per_cpu_dyn_array
Date: Fri,  1 Aug 2008 02:37:38 -0700
Message-Id: <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/linux/kernel_stat.h |    4 ++++
 kernel/sched.c              |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/kernel_stat.h
===================================================================
--- linux-2.6.orig/include/linux/kernel_stat.h
+++ linux-2.6/include/linux/kernel_stat.h
@@ -28,7 +28,11 @@ struct cpu_usage_stat {
 
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned int *irqs;
+#else
 	unsigned int irqs[NR_IRQS];
+#endif
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4021,9 +4021,12 @@ static inline void idle_balance(int cpu,
 #endif
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
-
 EXPORT_PER_CPU_SYMBOL(kstat);
 
+#ifdef CONFIG_HAVE_DYN_ARRAY
+DEFINE_PER_CPU_DYN_ARRAY_ADDR(per_cpu__kstat_irqs, per_cpu__kstat.irqs, sizeof(unsigned int), nr_irqs, sizeof(unsigned long), NULL);
+#endif
+
 /*
  * Return p->sum_exec_runtime plus any more ns on the sched_clock
  * that have not yet been banked in case the task is currently running.
