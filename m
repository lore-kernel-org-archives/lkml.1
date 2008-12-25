Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYLYKqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYLYKqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 05:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYLYKqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 05:46:32 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43005 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYLYKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 05:46:31 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for -tip] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081225194440.50ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 19:46:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I confirmed by alpha cross compiler.

==
Subject: [PATCH] proc: remove ifdef CONFIG_SPARSE_IRQ from stat.c
Impact: cleanup

commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 has a bit strange analysis.
The fact is, irq_desc() can be used old architecuture too. 
but old code don't include <linux/irq.h>.

right fixing is here.



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/stat.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: b/fs/proc/stat.c
===================================================================
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/irq.h>
 #include <asm/cputime.h>
 
 #ifndef arch_irq_stat_cpu
@@ -27,6 +28,7 @@ static int show_stat(struct seq_file *p,
 	u64 sum = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+	struct irq_desc *desc;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -44,11 +46,10 @@ static int show_stat(struct seq_file *p,
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for_each_irq_nr(j) {
-#ifdef CONFIG_SPARSE_IRQ
-			if (!irq_to_desc(j))
+		for_each_irq_desc(j, desc) {
+			if (!desc)
 				continue;
-#endif
+
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
@@ -95,12 +96,10 @@ static int show_stat(struct seq_file *p,
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
-#ifdef CONFIG_SPARSE_IRQ
 		if (!irq_to_desc(j)) {
 			seq_printf(p, " %u", per_irq_sum);
 			continue;
 		}
-#endif
 		for_each_possible_cpu(i)
 			per_irq_sum += kstat_irqs_cpu(j, i);
 


