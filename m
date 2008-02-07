Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbYBGJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbYBGJXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbYBGJUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:20:17 -0500
Received: from brick.kernel.dk ([87.55.233.238]:18522 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbYBGJUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:20:04 -0500
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com, npiggin@suse.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/8] kernel: add generic softirq interface for triggering a remote softirq
Date: Thu,  7 Feb 2008 10:19:04 +0100
Message-Id: <1202375945-29525-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.4.22.g7a20
In-Reply-To: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This only works for the block softirq, due to the hackish method of
the arch implementations.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/smp.h |    5 +++++
 kernel/softirq.c    |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 55232cc..2b546c0 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -61,6 +61,7 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
  * Call a function on all processors
  */
 int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
+extern void FASTCALL(raise_softirq_on_cpu(int cpu, unsigned int nr));
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -112,6 +113,10 @@ static inline void smp_send_reschedule(int cpu) { }
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
+#define raise_softirq_on_cpu(cpu, nr)	do {	\
+	WARN_ON(!irqs_disabled());		\
+	raise_softirq_irqoff((nr));		\
+} while (0)
 
 #endif /* !SMP */
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d7837d4..0bad5c3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -663,4 +663,11 @@ int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+extern void arch_raise_softirq_on_cpu(int, unsigned int);
+void fastcall raise_softirq_on_cpu(int cpu, unsigned int nr)
+{
+	BUG_ON(nr != BLOCK_SOFTIRQ);
+	arch_raise_softirq_on_cpu(cpu, nr);
+}
 #endif
-- 
1.5.4.22.g7a20

