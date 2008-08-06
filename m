Return-Path: <linux-kernel-owner+w=401wt.eu-S1765438AbYHFIxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765438AbYHFIxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763553AbYHFIpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:45:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYHFIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q7y31Vhl+uJVhILCDXyCup5bMutoLCE+MFb22EVFteEMtK98RFm2OVNQZ83ZnbfCR7
         5XM6fTpsxyJwn7KmE1mwlBScSm5PSWR4RiFUKOB1zaWL6TYMa8X1IcenJw3T7IftO2K7
         Tw3ka4g8SOsBvii4qF3pbXXXzOKNgmhRzS2bM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/33] serial: change remove NR_IRQS in 8250.c v2
Date: Wed,  6 Aug 2008 01:43:03 -0700
Message-Id: <1218012195-10429-22-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-21-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-11-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-12-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-13-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-14-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-15-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-16-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-17-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-18-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-19-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-20-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-21-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use small array with index to handle irq locking for serial port
hope 32 slot is enough

v2: according to Eric, move irq_no into irq_info, and not clean irq_no

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/serial/8250.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 3920324..595b956 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
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
@@ -1554,9 +1584,12 @@ static void serial_do_unlink(struct irq_info *i, struct uart_8250_port *up)
 
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
@@ -1580,7 +1613,11 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	int irq_no = up->port.irq;
+	struct irq_info *i = get_irq_info(irq_no, 0);
+
+	if (!i)
+		return;
 
 	BUG_ON(i->head == NULL);
 
@@ -2964,7 +3001,7 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < nr_irqs; i++)
+	for (i = 0; i < NR_IRQ_INFO; i++)
 		spin_lock_init(&irq_lists[i].lock);
 
 	ret = uart_register_driver(&serial8250_reg);
-- 
1.5.4.5

