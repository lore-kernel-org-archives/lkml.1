Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbXGAQuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbXGAQuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXGAQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:50:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbXGAQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:50:47 -0400
Date: Sun, 1 Jul 2007 12:50:35 -0400
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: blink driver power saving
Message-ID: <20070701125035.3f54d8b0@oldman>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The blink driver wakes up every jiffies which wastes power unnecessarily.
Using a notifier gives same effect. Also add ability to unload module.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/misc/blink.c	2007-06-29 22:56:20.000000000 -0400
+++ b/drivers/misc/blink.c	2007-07-01 12:44:37.000000000 -0400
@@ -16,12 +16,30 @@ static void do_blink(unsigned long data)
 	add_timer(&blink_timer);
 }
 
-static int blink_init(void)
+static int blink_panic_event(struct notifier_block *blk,
+			     unsigned long event, void *arg)
 {
-	printk(KERN_INFO "Enabling keyboard blinking\n");
 	do_blink(0);
 	return 0;
 }
 
+static struct notifier_block blink_notify = {
+	.notifier_call = blink_panic_event,
+};
+
+static __init int blink_init(void)
+{
+	printk(KERN_INFO "Enabling keyboard blinking\n");
+	atomic_notifier_chain_register(&panic_notifier_list, &blink_notify);
+	return 0;
+}
+
+static __exit void blink_remove(void)
+{
+	del_timer_sync(&blink_timer);
+	atomic_notifier_chain_unregister(&panic_notifier_list, &blink_notify);
+}
+
 module_init(blink_init);
+module_exit(blink_remove);
 
