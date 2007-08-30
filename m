Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbXH3PxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbXH3PxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXH3PxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:53:05 -0400
Received: from ehaase.plus.com ([84.92.183.15]:58706 "EHLO
	mail.mauerkinder.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbXH3PxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:53:04 -0400
X-Greylist: delayed 2343 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 11:53:03 EDT
Date: Thu, 30 Aug 2007 16:13:55 +0100 (BST)
From: The AmigaLinux A2232 Driver Project <A2232@gmx.net>
X-X-Sender: a2232@haneman.hacenet
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ser_a2232.c bug removed: handles "IRQ request denied" case
Message-ID: <Pine.LNX.4.64.0708301609120.21063@haneman.hacenet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This patch handles the case in which the request for the
vertical blank interrupt could not be granted. Thanks to
Nazia Zaman for spotting it.

Applies to latest 2.6.x kernels.


--- linux/drivers/char/ser_a2232.c.org	2007-08-30 15:41:25.000000000 +0100
+++ linux/drivers/char/ser_a2232.c	2007-08-30 15:46:17.000000000 +0100
@@ -787,7 +787,7 @@ static int __init a2232board_init(void)

  	}

-	printk("Total: %d A2232 boards initialized.\n", nr_a2232); /* Some status report if no card was found */
+	printk("Total: %d A2232 boards detected.\n", nr_a2232); /* Some status report if no card was found */

  	a2232_init_portstructs();

@@ -795,9 +795,13 @@ static int __init a2232board_init(void)
  		a2232_init_drivers also registers the drivers. Must be here because all boards
  		have to be detected first.
  	*/
-	if (a2232_init_drivers()) return -ENODEV; // maybe we should use a different -Exxx?
+	if (a2232_init_drivers())
+		return -ENODEV; // maybe we should use a different -Exxx?

-	request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID);
+	if (request_irq(IRQ_AMIGA_VERTB, a2232_vbl_inter, 0, "A2232 serial VBL", a2232_driver_ID))
+		return -ENODEV;
+
+	printk("A2232 driver initialized successfully.\n");
  	return 0;
  }



Signed-off-by: Enver Haase <a2232@gmx.net>
