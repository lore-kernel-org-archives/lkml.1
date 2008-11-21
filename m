Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYKUDzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYKUDzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 22:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKUDzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:55:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38577 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYKUDzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:55:44 -0500
Date: Thu, 20 Nov 2008 19:55:42 -0800
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: h-shimamoto@ct.jp.nec.com
Subject: [PATCH 1/3] softirq: Introduce statistics for softirq
Message-Id: <20081120195542.c85d4967.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Statistics for softirq doesn't exist.
It will be helpful like statistics for interrupts.
This patch introduces counting the number of softirq,
which will be exported in /proc/softirqs.

When softirq handler consumes much CPU time,
/proc/stat is like the following.

$ while :; do  cat /proc/stat | head -n1 ; sleep 10 ; done
cpu  88 0 408 739665 583 28 2 0 0
cpu  450 0 1090 740970 594 28 1294 0 0
                              ^^^^
                             softirq

In such a situation,
/proc/softirqs shows us which softirq handler is invoked.
We can see the increase rate of softirqs.

<before>
$ cat /proc/softirqs
                CPU0       CPU1       CPU2       CPU3
HI                 0          0          0          0
TIMER         462850     462805     462782     462718
NET_TX             0          0          0        365
NET_RX          2472          2          2         40
BLOCK              0          0        381       1164
TASKLET            0          0          0        224
SCHED         462654     462689     462698     462427
RCU             3046       2423       3367       3173

<after>
$ cat /proc/softirqs
                CPU0       CPU1       CPU2       CPU3
HI                 0          0          0          0
TIMER         463361     465077     465056     464991
NET_TX            53          0          1        365
NET_RX          3757          2          2         40
BLOCK              0          0        398       1170
TASKLET            0          0          0        224
SCHED         463074     464318     464612     463330
RCU             3505       2948       3947       3673

When CPU TIME of softirq is high,
the rates of increase is the following.
  TIMER  : 220/sec     : CPU1-3
  NET_TX : 5/sec       : CPU0
  NET_RX : 120/sec     : CPU0
  SCHED  : 40-200/sec  : all CPU
  RCU    : 45-58/sec   : all CPU

The rates of increase in an idle mode is the following.
  TIMER  : 250/sec
  SCHED  : 250/sec
  RCU    : 2/sec

It seems many softirqs for receiving packets and rcu are invoked.
This gives us help for checking system.

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
Reviewed-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/kernel_stat.h |   12 ++++++++++++
 kernel/softirq.c            |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 4a145ca..57c1643 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -5,6 +5,7 @@
 #include <linux/threads.h>
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
+#include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/cputime.h>
 
@@ -29,6 +30,7 @@ struct cpu_usage_stat {
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
 	unsigned int irqs[NR_IRQS];
+	unsigned int softirqs[NR_SOFTIRQS];
 };
 
 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -52,6 +54,16 @@ static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
        return kstat_cpu(cpu).irqs[irq];
 }
 
+static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
+{
+	kstat_this_cpu.softirqs[irq]++;
+}
+
+static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
+{
+       return kstat_cpu(cpu).softirqs[irq];
+}
+
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..088e179 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -208,6 +208,7 @@ restart:
 	do {
 		if (pending & 1) {
 			int prev_count = preempt_count();
+			kstat_incr_softirqs_this_cpu(h - softirq_vec);
 
 			h->action(h);
 
-- 
1.5.0.6

