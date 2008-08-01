Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYHAJk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYHAJk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbYHAJio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:16382 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbYHAJil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LWmhiFu6Oarpgnrx7I9RXNHMiUOCskyNpNl+9/oiCLE4VyrHwRMruEWrxvouJaZRkA
         DA0h/RHxfgoT3DBtPeLAT11HFhWyckDAh2HyhKQE1CiXuzVz230D6GCgSTN8wuQpLZ3v
         q+kgwrcGs92MBflkU5dBKx0XSaDbRp5GRjm/k=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 08/16] serial: change remove NR_IRQS in 8250.c v2
Date: Fri,  1 Aug 2008 02:37:36 -0700
Message-Id: <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace
	[PATCH] serial: change irq_lists to use dyn_array
use small array with index to handle irq locking for serial port
hope 32 slot is enough

v2: according to Eric, move irq_no into irq_info, and not clean irq_no

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/serial/8250.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250.c
+++ linux-2.6/drivers/serial/8250.c
@@ -147,9 +147,39 @@ struct uart_8250_port {
 struct irq_info {
 	spinlock_t		lock;
 	struct list_head	*head;
+	int irq_no;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+#define NR_IRQ_INFO	32
+
+static struct irq_info irq_lists[NR_IRQ_INFO] = {
+	[0 ... NR_IRQ_INFO-1] = {
+		.irq_no = -1,
+	}
+};
+
+static struct irq_info *get_irq_info(int irq, int with_free)
+{
+	int i, first_free = -1;
+
+	for (i = 0; i < NR_IRQ_INFO; i++) {
+		if (irq_lists[i].irq_no == irq)
+			return &irq_lists[i];
+		if (irq_lists[i].irq_no == -1 && first_free == -1)
+			first_free = i;
+	}
+	if (!with_free)
+		return NULL;
+
+	if (first_free != -1) {
+		irq_lists[first_free].irq_no = irq;
+		return &irq_lists[first_free];
+	}
+
+	WARN_ON("NR_IRQ_INFO too small");
+
+	return NULL;
+}
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -1541,9 +1571,12 @@ static void serial_do_unlink(struct irq_
 
 static int serial_link_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	struct irq_info *i = get_irq_info(up->port.irq, 1);
 	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
 
+	if (!i)
+		return -1;
+
 	spin_lock_irq(&i->lock);
 
 	if (i->head) {
@@ -1567,7 +1600,11 @@ static int serial_link_irq_chain(struct
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	int irq_no = up->port.irq;
+	struct irq_info *i = get_irq_info(irq_no, 0);
+
+	if (!i)
+		return;
 
 	BUG_ON(i->head == NULL);
 
@@ -2951,7 +2988,7 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < nr_irqs; i++)
+	for (i = 0; i < NR_IRQ_INFO; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&serial8250_reg);
