Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYLZD2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYLZD2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 22:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYLZD2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 22:28:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54808 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYLZD2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 22:28:35 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH for -tip 3/4] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081226121703.5CA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081226122422.5CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 12:28:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Impact: cleanup

introduce irq_inuse() macro and remove ifdef in stat.c

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/stat.c        |    9 +++------
 include/linux/irqnr.h |    9 +++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

Index: b/fs/proc/stat.c
===================================================================
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/irqnr.h>
 #include <asm/cputime.h>
 
 #ifndef arch_irq_stat_cpu
@@ -45,10 +46,8 @@ static int show_stat(struct seq_file *p,
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for_each_irq_nr(j) {
-#ifdef CONFIG_SPARSE_IRQ
-			if (!irq_to_desc(j))
+			if (!irq_inuse(j))
 				continue;
-#endif
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
@@ -95,12 +94,10 @@ static int show_stat(struct seq_file *p,
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-#ifdef CONFIG_SPARSE_IRQ
-		if (!irq_to_desc(j)) {
+		if (!irq_inuse(j)) {
 			seq_printf(p, " %u", per_irq_sum);
 			continue;
 		}
-#endif
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 
Index: b/include/linux/irqnr.h
===================================================================
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -15,6 +15,9 @@
 
 # define for_each_irq_desc_reverse(irq, desc)                          \
 	for (irq = nr_irqs - 1; irq >= 0; irq--)
+
+#define irq_inuse(irq) 1
+
 #else /* CONFIG_GENERIC_HARDIRQS */
 
 extern int nr_irqs;
@@ -27,6 +30,12 @@ extern struct irq_desc *irq_to_desc(unsi
 	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
 	     irq--, desc = irq_to_desc(irq))
 
+#ifdef CONFIG_SPARSE_IRQ
+#define irq_inuse(irq) (!!irq_to_desc(irq))
+#else
+#define irq_inuse(irq) 1
+#endif
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #define for_each_irq_nr(irq)                   \


