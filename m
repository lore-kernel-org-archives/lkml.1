Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYGaI1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYGaI1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYGaI1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:27:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:2822 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYGaI07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fVJv1/irh5p72nL6/fs3E5lzZkIorS52JKz5K97prs7bGy/kM/UpylDdtUDJ5Bkd0U
         PBQcP1S6w/7CzlJiNwwI2IgVxu4q6/42LEmJyzJaB4I80K42a0DbCW6XOsC9gtWAKLvO
         jfwOxnkC3Kzav+9heEIKaoz3EdK6ZXDoWHVfU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] serial: change remove NR_IRQS in 8250.c
Date: Thu, 31 Jul 2008 01:26:12 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807302109.21519.yhlu.kernel@gmail.com> <200807302110.10585.yhlu.kernel@gmail.com>
In-Reply-To: <200807302110.10585.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807310126.12572.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


replace
	[PATCH] serial: change irq_lists to use dyn_array
use small array with index to handle irq locking for serial port
hope 32 slot is enough

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/serial/8250.c |   73 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/serial/8250.c
===================================================================
--- linux-2.6.orig/drivers/serial/8250.c
+++ linux-2.6/drivers/serial/8250.c
@@ -149,7 +149,55 @@ struct irq_info {
 	struct list_head	*head;
 };
 
-static struct irq_info irq_lists[NR_IRQS];
+struct irq_info_pair {
+	struct irq_info irq_info;
+	int irq_no;
+};
+
+#define NR_IRQ_INFO_PAIR	32
+
+static struct irq_info_pair irq_pair_lists[NR_IRQ_INFO_PAIR] = {
+	[0 ... NR_IRQ_INFO_PAIR-1] = {
+		.irq_no = -1,
+	}
+};
+
+static struct irq_info *get_irq_info(int irq, int with_free)
+{
+	int i, first_free = -1;
+
+	for (i = 0; i < NR_IRQ_INFO_PAIR; i++) {
+		if (irq_pair_lists[i].irq_no == irq)
+			return &irq_pair_lists[i].irq_info;
+		if (irq_pair_lists[i].irq_no == -1 && first_free == -1)
+			first_free = i;
+	}
+	if (!with_free)
+		return NULL;
+
+	if (first_free != -1) {
+		irq_pair_lists[first_free].irq_no = irq;
+		return &irq_pair_lists[first_free].irq_info;
+	}
+
+	WARN_ON("NR_IRQ_INFO_PAIR too small");
+
+	return NULL;
+}
+
+static void check_free_irq_info(int irq_no)
+{
+
+	int i;
+
+	for (i = 0; i < NR_IRQ_INFO_PAIR; i++) {
+		if (irq_pair_lists[i].irq_no != irq_no)
+			continue;
+
+		irq_pair_lists[i].irq_no = -1;
+		break;
+	}
+}
 
 /*
  * Here we define the default xmit fifo size used for each type of UART.
@@ -1554,9 +1602,12 @@ static void serial_do_unlink(struct irq_
 
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
@@ -1580,14 +1631,24 @@ static int serial_link_irq_chain(struct
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i = irq_lists + up->port.irq;
+	int irq_no = up->port.irq;
+	struct irq_info *i = get_irq_info(irq_no, 0);
+	int empty = 0;
+
+	if (!i)
+		return;
 
 	BUG_ON(i->head == NULL);
 
-	if (list_empty(i->head))
+	if (list_empty(i->head)) {
 		free_irq(up->port.irq, i);
+		empty = 1;
+	}
 
 	serial_do_unlink(i, up);
+
+	if (empty)
+		check_free_irq_info(irq_no);
 }
 
 /* Base timer interval for polling */
@@ -2964,8 +3025,8 @@ static int __init serial8250_init(void)
 		"%d ports, IRQ sharing %sabled\n", nr_uarts,
 		share_irqs ? "en" : "dis");
 
-	for (i = 0; i < nr_irqs; i++)
-		spin_lock_init(&irq_lists[i].lock);
+	for (i = 0; i < NR_IRQ_INFO_PAIR; i++)
+		spin_lock_init(&irq_pair_lists[i].irq_info.lock);
 
 	ret = uart_register_driver(&serial8250_reg);
 	if (ret)
