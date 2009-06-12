Return-Path: <linux-kernel-owner+w=401wt.eu-S1765752AbZFLQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765752AbZFLQ21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762684AbZFLQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:06 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39076 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764763AbZFLQZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 10/27] Blackfin: fix deadlock in SMP IPI handler
Date: Fri, 12 Jun 2009 12:24:28 -0400
Message-Id: <1244823885-22410-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

When a low priority interrupt (like ethernet) is triggered between 2 high
priority IPI messages, a deadlock in disable_irq() is hit by the second
IPI handler.  This is because the second IPI message is queued within the
first IPI handler, but the handler doesn't process all messages, and new
ones are inserted rather than appended.  So now we process all the pending
messages, and append new ones to the pending list.

URL: http://blackfin.uclinux.org/gf/tracker/5226
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/smp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index c187da2..6184005 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -144,7 +144,7 @@ static void ipi_call_function(unsigned int cpu, struct ipi_message *msg)
 
 static irqreturn_t ipi_handler(int irq, void *dev_instance)
 {
-	struct ipi_message *msg, *mg;
+	struct ipi_message *msg;
 	struct ipi_message_queue *msg_queue;
 	unsigned int cpu = smp_processor_id();
 
@@ -154,7 +154,8 @@ static irqreturn_t ipi_handler(int irq, void *dev_instance)
 	msg_queue->count++;
 
 	spin_lock(&msg_queue->lock);
-	list_for_each_entry_safe(msg, mg, &msg_queue->head, list) {
+	while (!list_empty(&msg_queue->head)) {
+		msg = list_entry(msg_queue->head.next, typeof(*msg), list);
 		list_del(&msg->list);
 		switch (msg->type) {
 		case BFIN_IPI_RESCHEDULE:
@@ -221,7 +222,7 @@ int smp_call_function(void (*func)(void *info), void *info, int wait)
 	for_each_cpu_mask(cpu, callmap) {
 		msg_queue = &per_cpu(ipi_msg_queue, cpu);
 		spin_lock_irqsave(&msg_queue->lock, flags);
-		list_add(&msg->list, &msg_queue->head);
+		list_add_tail(&msg->list, &msg_queue->head);
 		spin_unlock_irqrestore(&msg_queue->lock, flags);
 		platform_send_ipi_cpu(cpu);
 	}
@@ -261,7 +262,7 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 
 	msg_queue = &per_cpu(ipi_msg_queue, cpu);
 	spin_lock_irqsave(&msg_queue->lock, flags);
-	list_add(&msg->list, &msg_queue->head);
+	list_add_tail(&msg->list, &msg_queue->head);
 	spin_unlock_irqrestore(&msg_queue->lock, flags);
 	platform_send_ipi_cpu(cpu);
 
@@ -292,7 +293,7 @@ void smp_send_reschedule(int cpu)
 
 	msg_queue = &per_cpu(ipi_msg_queue, cpu);
 	spin_lock_irqsave(&msg_queue->lock, flags);
-	list_add(&msg->list, &msg_queue->head);
+	list_add_tail(&msg->list, &msg_queue->head);
 	spin_unlock_irqrestore(&msg_queue->lock, flags);
 	platform_send_ipi_cpu(cpu);
 
@@ -320,7 +321,7 @@ void smp_send_stop(void)
 	for_each_cpu_mask(cpu, callmap) {
 		msg_queue = &per_cpu(ipi_msg_queue, cpu);
 		spin_lock_irqsave(&msg_queue->lock, flags);
-		list_add(&msg->list, &msg_queue->head);
+		list_add_tail(&msg->list, &msg_queue->head);
 		spin_unlock_irqrestore(&msg_queue->lock, flags);
 		platform_send_ipi_cpu(cpu);
 	}
-- 
1.6.3.1

