Return-Path: <linux-kernel-owner+w=401wt.eu-S1750793AbXBWDM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750793AbXBWDM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXBWDM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:12:58 -0500
Received: from ozlabs.org ([203.10.76.45]:36139 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbXBWDM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:12:57 -0500
Subject: [PATCH] Make hvc_console.c compile on non-powerpc: Remove NO_IRQ
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@suse.de>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 14:12:02 +1100
Message-Id: <1172200322.6111.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply.  Andrew, please drop the other hvc_console patch
you have.

Paulus preferred this over #defining NO_IRQ in the file, since that's
0 for powerpc anyway.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Paul Mackerras <paulus@samba.org>

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.21-rc1/drivers/char/hvc_console.c working-2.6.21-rc1-NO_IRQ/drivers/char/hvc_console.c
--- linux-2.6.21-rc1/drivers/char/hvc_console.c	2007-02-05 17:30:59.000000000 +1100
+++ working-2.6.21-rc1-NO_IRQ/drivers/char/hvc_console.c	2007-02-23 14:03:26.000000000 +1100
@@ -316,7 +316,7 @@ static int hvc_open(struct tty_struct *t
 {
 	struct hvc_struct *hp;
 	unsigned long flags;
-	int irq = NO_IRQ;
+	int irq = 0;
 	int rc = 0;
 	struct kobject *kobjp;
 
@@ -338,14 +338,14 @@ static int hvc_open(struct tty_struct *t
 	hp->tty = tty;
 	/* Save for request_irq outside of spin_lock. */
 	irq = hp->irq;
-	if (irq != NO_IRQ)
+	if (irq)
 		hp->irq_requested = 1;
 
 	kobjp = &hp->kobj;
 
 	spin_unlock_irqrestore(&hp->lock, flags);
 	/* check error, fallback to non-irq */
-	if (irq != NO_IRQ)
+	if (irq)
 		rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED, "hvc_console", hp);
 
 	/*
@@ -373,7 +373,7 @@ static void hvc_close(struct tty_struct 
 {
 	struct hvc_struct *hp;
 	struct kobject *kobjp;
-	int irq = NO_IRQ;
+	int irq = 0;
 	unsigned long flags;
 
 	if (tty_hung_up_p(filp))
@@ -407,7 +407,7 @@ static void hvc_close(struct tty_struct 
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 
-		if (irq != NO_IRQ)
+		if (irq)
 			free_irq(irq, hp);
 
 	} else {
@@ -424,7 +424,7 @@ static void hvc_hangup(struct tty_struct
 {
 	struct hvc_struct *hp = tty->driver_data;
 	unsigned long flags;
-	int irq = NO_IRQ;
+	int irq = 0;
 	int temp_open_count;
 	struct kobject *kobjp;
 
@@ -453,7 +453,7 @@ static void hvc_hangup(struct tty_struct
 		irq = hp->irq;
 	hp->irq_requested = 0;
 	spin_unlock_irqrestore(&hp->lock, flags);
-	if (irq != NO_IRQ)
+	if (irq)
 		free_irq(irq, hp);
 	while(temp_open_count) {
 		--temp_open_count;
@@ -583,7 +583,7 @@ static int hvc_poll(struct hvc_struct *h
 	/* If we aren't interrupt driven and aren't throttled, we always
 	 * request a reschedule
 	 */
-	if (hp->irq == NO_IRQ)
+	if (hp->irq == 0)
 		poll_mask |= HVC_POLL_READ;
 
 	/* Read data if any */


