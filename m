Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbYHHWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbYHHWCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbYHHVya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762105AbYHHVy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C2zJTBKPlxPbENNygfuTA2Zr5agpy/sttvEabkLxuoQGPmZcTfbBIqjB1tCmUVlveW
         EdBfz/ngdDXroxsmLG7GnclS85M5miRwghsm1C9c8kQJegabJABRTEtkprEAcLpYjRtT
         SeoCQHHFYZ0xQGRRWYvM5npeWo5jcWJC/rUIA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 22/42] irq: make irqs in kernel stat use per_cpu_dyn_array
Date: Fri,  8 Aug 2008 14:52:28 -0700
Message-Id: <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/linux/kernel_stat.h |    4 ++++
 kernel/sched.c              |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index cf9f40a..fe1f7fe 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 55cb4ce..21c0839 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4021,9 +4021,12 @@ static inline void idle_balance(int cpu, struct rq *rq)
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
-- 
1.5.4.5

