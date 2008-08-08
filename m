Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbYHHWG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbYHHWG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbYHHVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761720AbYHHVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E3hwiCJnoiZX0TTchSY1z74ogNkLJcupotToV0jOJBiNIpbVo6tY5gJ1iFOqsaa3gH
         ki9N+jDnqVTZqXoW0j1QnXKQEWxeJLchOjSsU7pslYhkJ1ECAPL8IQYaC+pnhx/+IBQD
         0ihglQuAAYTIAHLYqy92PcyP7XqRO4pvAngfw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 32/42] replace loop with nr_irqs with for_each_irq_icfg
Date: Fri,  8 Aug 2008 14:52:38 -0700
Message-Id: <1218232368-31228-33-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
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
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so don't all irq_cfg at begining to allocate all.
and only call that when needed

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 784a882..1d1a70d 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -129,6 +129,9 @@ static void __init init_work(void *data)
 		cfg[i-1].next = &cfg[i];
 }
 
+#define for_each_irq_cfg(cfg)		\
+	for(cfg = irq_cfgx; cfg && cfg->irq != -1U; cfg = cfg->next)
+
 static struct irq_cfg *irq_cfgx;
 DEFINE_DYN_ARRAY(irq_cfgx, sizeof(struct irq_cfg), nr_irq_cfg, PAGE_SIZE, init_work);
 
@@ -1063,20 +1066,18 @@ static void __setup_vector_irq(int cpu)
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
 	int irq, vector;
+	struct irq_cfg *cfg;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < nr_irqs; ++irq) {
-		struct irq_cfg *cfg = irq_cfg(irq);
-
+	for_each_irq_cfg(cfg) {
 		if (!cpu_isset(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
+		irq = cfg->irq;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
 	for (vector = 0; vector < NR_VECTORS; ++vector) {
-		struct irq_cfg *cfg;
-
 		irq = per_cpu(vector_irq, cpu)[vector];
 		if (irq < 0)
 			continue;
@@ -1312,6 +1313,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	union IO_APIC_reg_01 reg_01;
 	union IO_APIC_reg_02 reg_02;
 	unsigned long flags;
+	struct irq_cfg *cfg;
 
 	if (apic_verbosity == APIC_QUIET)
 		return;
@@ -1380,12 +1382,11 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for (i = 0; i < nr_irqs; i++) {
-		struct irq_cfg *cfg = irq_cfg(i);
+	for_each_irq_cfg(cfg) {
 		struct irq_pin_list *entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
-		printk(KERN_DEBUG "IRQ%d ", i);
+		printk(KERN_DEBUG "IRQ%d ", cfg->irq);
 		for (;;) {
 			printk("-> %d:%d", entry->apic, entry->pin);
 			if (!entry->next)
@@ -2044,6 +2045,7 @@ static inline void init_IO_APIC_traps(void)
 {
 	int irq;
 	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2056,10 +2058,8 @@ static inline void init_IO_APIC_traps(void)
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for (irq = 0; irq < nr_irqs ; irq++) {
-		struct irq_cfg *cfg;
-
-		cfg = irq_cfg(irq);
+	for_each_irq_cfg(cfg) {
+		irq = cfg->irq;
 		if (IO_APIC_IRQ(irq) && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
-- 
1.5.4.5

