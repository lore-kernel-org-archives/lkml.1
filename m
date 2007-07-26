Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXGZIFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXGZIFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765492AbXGZIEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:04:32 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:50629 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbXGZIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:04:29 -0400
Subject: [PATCH] fix return value of i8042_aux_test_irq
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, vojtech@suse.cz,
       akpm@linux-foundation.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 26 Jul 2007 17:04:25 +0900
Message-Id: <1185437065.4805.19.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I made an interesting finding while testing the two patches below.

http://lkml.org/lkml/2007/7/19/685
http://lkml.org/lkml/2007/7/19/687

These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
that the request_irq prints a warning if after calling the handler it
returned IRQ_HANDLED .

The code looks like this:

int request_irq(unsigned int irq, irq_handler_t handler,
                unsigned long irqflags, const char *devname, void
*dev_id)
.....
        if (irqflags & IRQF_DISABLED) {
                unsigned long flags;

                local_irq_save(flags);
                retval = handler(irq, dev_id);
                local_irq_restore(flags);
        } else
                retval = handler(irq, dev_id);
        if (retval == IRQ_HANDLED) {
                printk(KERN_WARNING
                       "%s (IRQ %d) handled a spurious interrupt\n",
                       devname, irq);
        }
.....

I discovered that i8042_aux_test_irq handles the "fake" interrupt,
which, in principle, is not correct because it obviously isn't a real
interrupt and it could have been a spurious interrupt as well.

The problem is that the interrupt handler unconditionally returns IRQ
handled, which does not seem correct. Anyway I am not very familiar with
this code so I may be missing the whole point. I would appreciate your
comments on this.

Thank you in advance.

Fernando

--

Do not return IRQ_HANDLED when we haven't handle the interrupt.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.23-rc1-mm1-orig/drivers/input/serio/i8042.c linux-2.6.23-rc1-mm1/drivers/input/serio/i8042.c
--- linux-2.6.23-rc1-mm1-orig/drivers/input/serio/i8042.c	2007-07-26 16:10:11.000000000 +0900
+++ linux-2.6.23-rc1-mm1/drivers/input/serio/i8042.c	2007-07-26 16:05:19.000000000 +0900
@@ -516,6 +516,7 @@ static irqreturn_t __devinit i8042_aux_t
 {
 	unsigned long flags;
 	unsigned char str, data;
+	int ret;
 
 	spin_lock_irqsave(&i8042_lock, flags);
 	str = i8042_read_status();
@@ -524,10 +525,13 @@ static irqreturn_t __devinit i8042_aux_t
 		if (i8042_irq_being_tested &&
 		    data == 0xa5 && (str & I8042_STR_AUXDATA))
 			complete(&i8042_aux_irq_delivered);
+		ret = 1;
 	}
+	else
+		ret = 0;
 	spin_unlock_irqrestore(&i8042_lock, flags);
 
-	return IRQ_HANDLED;
+	return IRQ_RETVAL(ret);
 }
 
 /*


