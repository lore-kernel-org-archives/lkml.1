Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZIUSmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZIUSmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZIUSmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:42:22 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:36435 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZIUSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:42:21 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 14:42:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=ghC5cKI5+2aijqWSBeLstzjcB9wXsEu9mNvP3jtBL3knLvjoLe44gSmxt9m25MdoI2
         Iodq8qnL2HVsv0eJc2Hey95IbR1pOn8qK5nedmR9sthbItozIwb1YQKg56/EaOkftzZb
         xo9kS53iUNStQK1tJonsCgZTthJEZy4qKaKVc=
MIME-Version: 1.0
Date: Mon, 21 Sep 2009 20:36:34 +0200
X-Google-Sender-Auth: 9a26d7a5ca0b51e8
Message-ID: <3efb10970909211136g4e74c8b3vc339d548cdd0959f@mail.gmail.com>
Subject: 2.6.31-rt11 freeze on userland start on ARM
From: Remy Bohmer <linux@bohmer.net>
To: linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am integrating the 2.6.31-rt11 kernel on our ARM9 based (Atmel
at91sam9261) board.
Kernel boots fine but when userland starts the linuxrc process, and
the first 'echo' from the /etc/init.d/rcS script is printed to the
serial console (DBGU) the system locks up completely, from userland no
character ever makes it to the terminal.

I found the reason of the lockup and know a workaround, but I can use
some good suggestions to solve it the correct way.

What happens is that the kernel continuously schedules a IRQ-thread;
namely IRQ1-atmel_serial. And this IRQ thread keeps getting scheduled
forever...

Looking more closely I noticed that it is new compared to 2.6.24/26-RT
that a IRQ thread is started for this driver.
Notice that the DBGU interrupt is called the system-interrupt and it
is shared with the timer interrupt. The timer interrupt has IRQF_TIMER
set which incorporates IRQF_NODELAY. This is different compared to
2.6.24/26 where a sharing with a IRQF_NODELAY interrupt would make all
shared handlers also run in IRQF_NODELAY context.
As such we have here a interrupt handler running as NODELAY handler,
that is shared with a interrupt handler that runs in thread context.

So, as workaround/test I made this change:

Index: linux-2.6.31/drivers/serial/atmel_serial.c
===================================================================
--- linux-2.6.31.orig/drivers/serial/atmel_serial.c	2009-09-21
19:44:48.000000000 +0200
+++ linux-2.6.31/drivers/serial/atmel_serial.c	2009-09-21
19:45:15.000000000 +0200
@@ -808,7 +808,8 @@ static int atmel_startup(struct uart_por
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
+	retval = request_irq(port->irq, atmel_interrupt,
+			IRQF_SHARED | IRQF_NODELAY,
 			tty ? tty->name : "atmel_serial", port);
 	if (retval) {
 		printk("atmel_serial: atmel_startup - Can't get irq\n");
---

This change makes the atmel-serial driver interrupt handler run as
IRQF_NODELAY handler again, just as on 2.6.24/26, and the board is
booting properly again with 2.6.31.
Anyone any ideas how to fix it properly? Or interested in more
debugging information. (I have an ETM tracer hooked up...)

Notice that this driver actually needs the NODELAY flag set on
preempt-RT to prevent missing characters with its 1 byte FIFO-hardware
without flow-control ;-)  (I will provide a clean patch later)
For now, at least it shows a bug in the new irq-threading mechanisms...

I also have a few related questions, besides investigating the
root-cause of this bug:
What is the rationale behind the per-driver irq-thread? What is the
gain here for RT? My first impression is that this would increase the
latencies in case of sharing interrupts with NODELAY interrupts. All
handlers need to run, so the master interrupt cannot be enabled again
until all IRQ-threads have run, so the NODELAY handler must wait until
all IRQ-threads have run. So, giving different prios to the
IRQ-threads that share the same source would increase the latencies
even more.
If different drivers share the same interrupt line, even additional
schedule overhead can be added to the latencies...
On first impression the former implementation seems more efficient. I
guess it is changed for a good reason, so, I must be missing something
here... I hope someone can explain...

Kind regards,

Remy
