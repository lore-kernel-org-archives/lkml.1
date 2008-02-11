Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYBKW0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYBKW0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:26:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbYBKW0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:26:18 -0500
Received: from lixom.net ([66.141.50.11]:57456 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbYBKW0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:26:17 -0500
Date: Mon, 11 Feb 2008 16:28:13 -0600
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Execute tasklets in the same order they were queued
Message-ID: <20080211222813.GA14316@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed this when looking at an openswan issue. Openswan (ab?)uses
the tasklet API to defer processing of packets in some situations,
with one packet per tasklet_action(). I started noticing sequences of
reverse-ordered sequence numbers coming over the wire, since new tasklets
are always queued at the head of the list but processed sequentially.

Convert it to instead append new entries to the tail of the list. As an
extra bonus, the splicing code in takeover_tasklets() no longer has to
iterate over the list.


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5b3aea5..228c9c9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -355,7 +355,8 @@ void open_softirq(int nr, void (*action)(struct softirq_action*), void *data)
 /* Tasklets */
 struct tasklet_head
 {
-	struct tasklet_struct *list;
+	struct tasklet_struct *head;
+	struct tasklet_struct **tail;
 };
 
 /* Some compilers disobey section attribute on statics when not
@@ -368,8 +369,9 @@ void __tasklet_schedule(struct tasklet_struct *t)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = t;
+	t->next = NULL;
+	*__get_cpu_var(tasklet_vec).tail = t;
+	__get_cpu_var(tasklet_vec).tail = &(t->next);
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -381,8 +383,9 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	t->next = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = t;
+	t->next = NULL;
+	*__get_cpu_var(tasklet_hi_vec).tail = t;
+	__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
 	raise_softirq_irqoff(HI_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -394,8 +397,9 @@ static void tasklet_action(struct softirq_action *a)
 	struct tasklet_struct *list;
 
 	local_irq_disable();
-	list = __get_cpu_var(tasklet_vec).list;
-	__get_cpu_var(tasklet_vec).list = NULL;
+	list = __get_cpu_var(tasklet_vec).head;
+	__get_cpu_var(tasklet_vec).head = NULL;
+	__get_cpu_var(tasklet_vec).tail = &__get_cpu_var(tasklet_vec).head;
 	local_irq_enable();
 
 	while (list) {
@@ -415,8 +419,9 @@ static void tasklet_action(struct softirq_action *a)
 		}
 
 		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_vec).list;
-		__get_cpu_var(tasklet_vec).list = t;
+		t->next = NULL;
+		*__get_cpu_var(tasklet_vec).tail = t;
+		__get_cpu_var(tasklet_vec).tail = &(t->next);
 		__raise_softirq_irqoff(TASKLET_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -427,8 +432,9 @@ static void tasklet_hi_action(struct softirq_action *a)
 	struct tasklet_struct *list;
 
 	local_irq_disable();
-	list = __get_cpu_var(tasklet_hi_vec).list;
-	__get_cpu_var(tasklet_hi_vec).list = NULL;
+	list = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = NULL;
+	__get_cpu_var(tasklet_hi_vec).tail = &__get_cpu_var(tasklet_hi_vec).head;
 	local_irq_enable();
 
 	while (list) {
@@ -448,8 +454,9 @@ static void tasklet_hi_action(struct softirq_action *a)
 		}
 
 		local_irq_disable();
-		t->next = __get_cpu_var(tasklet_hi_vec).list;
-		__get_cpu_var(tasklet_hi_vec).list = t;
+		t->next = NULL;
+		*__get_cpu_var(tasklet_hi_vec).tail = t;
+		__get_cpu_var(tasklet_hi_vec).tail = &(t->next);
 		__raise_softirq_irqoff(HI_SOFTIRQ);
 		local_irq_enable();
 	}
@@ -486,6 +493,15 @@ EXPORT_SYMBOL(tasklet_kill);
 
 void __init softirq_init(void)
 {
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		per_cpu(tasklet_vec, cpu).tail =
+			&per_cpu(tasklet_vec, cpu).head;
+		per_cpu(tasklet_hi_vec, cpu).tail =
+			&per_cpu(tasklet_hi_vec, cpu).head;
+	}
+
 	open_softirq(TASKLET_SOFTIRQ, tasklet_action, NULL);
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
 }
@@ -554,9 +570,12 @@ void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu)
 		return;
 
 	/* CPU is dead, so no lock needed. */
-	for (i = &per_cpu(tasklet_vec, cpu).list; *i; i = &(*i)->next) {
+	for (i = &per_cpu(tasklet_vec, cpu).head; *i; i = &(*i)->next) {
 		if (*i == t) {
 			*i = t->next;
+			/* If this was the tail element, move the tail ptr */
+			if (*i == NULL)
+				per_cpu(tasklet_vec, cpu).tail = i;
 			return;
 		}
 	}
@@ -571,14 +590,16 @@ static void takeover_tasklets(unsigned int cpu)
 	local_irq_disable();
 
 	/* Find end, append list for that CPU. */
-	for (i = &__get_cpu_var(tasklet_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_vec, cpu).list;
-	per_cpu(tasklet_vec, cpu).list = NULL;
+	*__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).head;
+	__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).tail;
+	per_cpu(tasklet_vec, cpu).head = NULL;
+	per_cpu(tasklet_vec, cpu).next = &per_cpu(tasklet_vec, cpu).head;
 	raise_softirq_irqoff(TASKLET_SOFTIRQ);
 
-	for (i = &__get_cpu_var(tasklet_hi_vec).list; *i; i = &(*i)->next);
-	*i = per_cpu(tasklet_hi_vec, cpu).list;
-	per_cpu(tasklet_hi_vec, cpu).list = NULL;
+	*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
+	__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
+	per_cpu(tasklet_hi_vec, cpu).head = NULL;
+	per_cpu(tasklet_hi_vec, cpu).next = &per_cpu(tasklet_hi_vec, cpu).head;
 	raise_softirq_irqoff(HI_SOFTIRQ);
 
 	local_irq_enable();
