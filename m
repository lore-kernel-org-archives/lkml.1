Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbYLYMmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbYLYMmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYLYMl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:41:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45344 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYLYMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:41:57 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 25 Dec 2008 21:41:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +#include <linux/irq.h>
> > > 
> > > looks good, but linux/irq.h cannot be included on all architectures. (for 
> > > example s390 has no notion of 'hardirqs'). But we created linux/irqnr.h 
> > > for this purpose - so including that should work better.
> > 
> > Oh, thanks good explain.
> > I'll fix soon.
> 
> next spin is here.
> I confirmed three architecture.
> 
>  1. alpha (without SPARSE_IRQ, build test by cross compiler only)
>  2. ia64 (without SPARSE_IRQ)
>  3. x86_64 (with SPARSE_IRQ)


Is this good idea?
this patch also tested on above three architecture.


===
Subject: [PATCH] irq: for_each_irq_desc() makes simplify
Impact: cleanup

all for_each_irq_desc() usage point have !desc check.
then its check can move into for_each_irq_desc() macro.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |   10 ----------
 drivers/xen/events.c      |    3 ---
 fs/proc/stat.c            |    3 ---
 include/linux/irqnr.h     |    6 ++++--
 kernel/irq/autoprobe.c    |   15 ---------------
 kernel/irq/handle.c       |    3 ---
 kernel/irq/spurious.c     |    5 -----
 7 files changed, 4 insertions(+), 41 deletions(-)

Index: b/arch/x86/kernel/io_apic.c
===================================================================
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1400,8 +1400,6 @@ void __setup_vector_irq(int cpu)
 
 	/* Mark the inuse vectors */
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
 		cfg = desc->chip_data;
 		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
@@ -1783,8 +1781,6 @@ __apicdebuginit(void) print_IO_APIC(void
 	for_each_irq_desc(irq, desc) {
 		struct irq_pin_list *entry;
 
-		if (!desc)
-			continue;
 		cfg = desc->chip_data;
 		entry = cfg->irq_2_pin;
 		if (!entry)
@@ -2425,9 +2421,6 @@ static void ir_irq_migration(struct work
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
-
 		if (desc->status & IRQ_MOVE_PENDING) {
 			unsigned long flags;
 
@@ -2713,9 +2706,6 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_irq_desc(irq, desc) {
-		if (!desc)
-			continue;
-
 		cfg = desc->chip_data;
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
Index: b/drivers/xen/events.c
===================================================================
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -142,9 +142,6 @@ static void init_evtchn_cpu_bindings(voi
 
 	/* By default all event channels notify CPU#0. */
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		desc->affinity = cpumask_of_cpu(0);
 	}
 #endif
Index: b/fs/proc/stat.c
===================================================================
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -47,9 +47,6 @@ static int show_stat(struct seq_file *p,
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for_each_irq_desc(j, desc) {
-			if (!desc)
-				continue;
-
 			sum += kstat_irqs_cpu(j, i);
 		}
 		sum += arch_irq_stat_cpu(i);
Index: b/kernel/irq/autoprobe.c
===================================================================
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -40,9 +40,6 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
@@ -71,9 +68,6 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
@@ -92,9 +86,6 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -133,9 +124,6 @@ unsigned int probe_irq_mask(unsigned lon
 	int i;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -178,9 +166,6 @@ int probe_irq_off(unsigned long val)
 	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
Index: b/kernel/irq/handle.c
===================================================================
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -433,9 +433,6 @@ void early_init_irq_lock_class(void)
 	int i;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	}
 }
Index: b/kernel/irq/spurious.c
===================================================================
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -91,9 +91,6 @@ static int misrouted_irq(int irq)
 	int i, ok = 0;
 
 	for_each_irq_desc(i, desc) {
-		if (!desc)
-			continue;
-
 		if (!i)
 			 continue;
 
@@ -115,8 +112,6 @@ static void poll_spurious_irqs(unsigned 
 	for_each_irq_desc(i, desc) {
 		unsigned int status;
 
-		if (!desc)
-			continue;
 		if (!i)
 			 continue;
 
Index: b/include/linux/irqnr.h
===================================================================
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -22,11 +22,13 @@ struct irq_desc;
 
 # define for_each_irq_desc(irq, desc)					\
 	for (irq = 0, desc = irq_to_desc(irq); irq < nr_irqs; 		\
-	     irq++, desc = irq_to_desc(irq))
+	     irq++, desc = irq_to_desc(irq))				\
+		if (desc)
 
 # define for_each_irq_desc_reverse(irq, desc)				\
 	for (irq = nr_irqs - 1, desc = irq_to_desc(irq); irq >= 0;	\
-	     irq--, desc = irq_to_desc(irq))
+	     irq--, desc = irq_to_desc(irq))				\
+		if (desc)
 
 extern struct irq_desc *irq_to_desc(unsigned int irq);
 


