Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXCHNH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXCHNH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXCHNH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:07:29 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:48345 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXCHNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:07:28 -0500
Date: Thu, 8 Mar 2007 14:06:08 +0100
From: Thibaut VARENE <T-Bone@parisc-linux.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] make elv_register() output atomic
Message-ID: <20070308140608.2b034013@Alucard.r3z0>
Organization: PA/Linux
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; powerpc-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Booting 2.6.21-rc3-g45592145 I noticed the following on one of my
machines in the bootlog:

io scheduler noop registered<6>Time: jiffies clocksource has been installed.

io scheduler deadline registered (default)


Looking at block/elevator.c, it appears that elv_register() uses two
consecutive printks in a non-atomic way, leading to the above glitch. The
attached trivial patch fixes this issue, by using a single printk.

HTH

T-Bone

PS: please CC-me in replies.

Signed-off-by: Thibaut VARENE <varenet@parisc-linux.org>

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/


diff --git a/block/elevator.c b/block/elevator.c
index 25f6ef2..96a00c8 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -964,17 +964,18 @@ void elv_unregister_queue(struct request_queue *q)
 
 int elv_register(struct elevator_type *e)
 {
+	char *def = "";
 	spin_lock_irq(&elv_list_lock);
 	BUG_ON(elevator_find(e->elevator_name));
 	list_add_tail(&e->list, &elv_list);
 	spin_unlock_irq(&elv_list_lock);
 
-	printk(KERN_INFO "io scheduler %s registered", e->elevator_name);
 	if (!strcmp(e->elevator_name, chosen_elevator) ||
 			(!*chosen_elevator &&
 			 !strcmp(e->elevator_name, CONFIG_DEFAULT_IOSCHED)))
-				printk(" (default)");
-	printk("\n");
+				def = " (default)";
+
+	printk(KERN_INFO "io scheduler %s registered%s\n", e->elevator_name, def);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(elv_register);
