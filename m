Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZIWJFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZIWJFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbZIWJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZIWJFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:05:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Use asm/generic-hardirq.h
To: torvalds@osdl.org, akpm@linux-foundation.org, hch@lst.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 23 Sep 2009 10:04:02 +0100
Message-ID: <20090923090402.21426.1909.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Use asm/generic-hardirq.h to build asm/hardirq.h and also remove the unused
idle_timestamp field in irq_cpustat whilst we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/hardirq.h |   17 ++++-------------
 arch/frv/kernel/process.c      |    4 ----
 2 files changed, 4 insertions(+), 17 deletions(-)


diff --git a/arch/frv/include/asm/hardirq.h b/arch/frv/include/asm/hardirq.h
index fc47515..5fc8b6f 100644
--- a/arch/frv/include/asm/hardirq.h
+++ b/arch/frv/include/asm/hardirq.h
@@ -12,24 +12,15 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-#ifdef CONFIG_SMP
-#error SMP not available on FR-V
-#endif /* CONFIG_SMP */
+#include <asm/atomic.h>
 
 extern atomic_t irq_err_count;
 static inline void ack_bad_irq(int irq)
 {
 	atomic_inc(&irq_err_count);
 }
+#define ack_bad_irq ack_bad_irq
+
+#include <asm-generic/hardirq.h>
 
 #endif
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 0de50df..9042559 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -83,13 +83,9 @@ void (*idle)(void) = core_sleep_idle;
  */
 void cpu_idle(void)
 {
-	int cpu = smp_processor_id();
-
 	/* endless idle loop with no priority at all */
 	while (1) {
 		while (!need_resched()) {
-			irq_stat[cpu].idle_timestamp = jiffies;
-
 			check_pgt_cache();
 
 			if (!frv_dma_inprogress && idle)

