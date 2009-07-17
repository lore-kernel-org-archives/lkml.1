Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZGQUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZGQUXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZGQUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:23:17 -0400
Received: from kroah.org ([198.145.64.141]:43086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZGQUTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:30 2009
Message-Id: <20090717201230.125985614@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:08:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sonic Zhang <sonic.zhang@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [patch 07/24] Blackfin: fix deadlock in SMP IPI handler
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=blackfin-fix-deadlock-in-smp-ipi-handler.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sonic Zhang <sonic.zhang@analog.com>

commit 86f2008bf546af9a434f480710e8d33891616bf5 upstream.

When a low priority interrupt (like ethernet) is triggered between 2 high
priority IPI messages, a deadlock in disable_irq() is hit by the second
IPI handler.  This is because the second IPI message is queued within the
first IPI handler, but the handler doesn't process all messages, and new
ones are inserted rather than appended.  So now we process all the pending
messages, and append new ones to the pending list.

URL: http://blackfin.uclinux.org/gf/tracker/5226

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/mach-common/smp.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -139,7 +139,7 @@ static void ipi_call_function(unsigned i
 
 static irqreturn_t ipi_handler(int irq, void *dev_instance)
 {
-	struct ipi_message *msg, *mg;
+	struct ipi_message *msg;
 	struct ipi_message_queue *msg_queue;
 	unsigned int cpu = smp_processor_id();
 
@@ -149,7 +149,8 @@ static irqreturn_t ipi_handler(int irq, 
 	msg_queue->count++;
 
 	spin_lock(&msg_queue->lock);
-	list_for_each_entry_safe(msg, mg, &msg_queue->head, list) {
+	while (!list_empty(&msg_queue->head)) {
+		msg = list_entry(msg_queue->head.next, typeof(*msg), list);
 		list_del(&msg->list);
 		switch (msg->type) {
 		case BFIN_IPI_RESCHEDULE:
@@ -216,7 +217,7 @@ int smp_call_function(void (*func)(void 
 	for_each_cpu_mask(cpu, callmap) {
 		msg_queue = &per_cpu(ipi_msg_queue, cpu);
 		spin_lock_irqsave(&msg_queue->lock, flags);
-		list_add(&msg->list, &msg_queue->head);
+		list_add_tail(&msg->list, &msg_queue->head);
 		spin_unlock_irqrestore(&msg_queue->lock, flags);
 		platform_send_ipi_cpu(cpu);
 	}
@@ -256,7 +257,7 @@ int smp_call_function_single(int cpuid, 
 
 	msg_queue = &per_cpu(ipi_msg_queue, cpu);
 	spin_lock_irqsave(&msg_queue->lock, flags);
-	list_add(&msg->list, &msg_queue->head);
+	list_add_tail(&msg->list, &msg_queue->head);
 	spin_unlock_irqrestore(&msg_queue->lock, flags);
 	platform_send_ipi_cpu(cpu);
 
@@ -287,7 +288,7 @@ void smp_send_reschedule(int cpu)
 
 	msg_queue = &per_cpu(ipi_msg_queue, cpu);
 	spin_lock_irqsave(&msg_queue->lock, flags);
-	list_add(&msg->list, &msg_queue->head);
+	list_add_tail(&msg->list, &msg_queue->head);
 	spin_unlock_irqrestore(&msg_queue->lock, flags);
 	platform_send_ipi_cpu(cpu);
 
@@ -315,7 +316,7 @@ void smp_send_stop(void)
 	for_each_cpu_mask(cpu, callmap) {
 		msg_queue = &per_cpu(ipi_msg_queue, cpu);
 		spin_lock_irqsave(&msg_queue->lock, flags);
-		list_add(&msg->list, &msg_queue->head);
+		list_add_tail(&msg->list, &msg_queue->head);
 		spin_unlock_irqrestore(&msg_queue->lock, flags);
 		platform_send_ipi_cpu(cpu);
 	}


