Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZBFO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZBFO7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZBFO70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:59:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37922 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZBFO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:59:25 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 6 Feb 2009 15:58:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.39a0c5a1f06ea8b7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.

Petr Vandrovec (1):
      firewire: core: Remove card from list of cards when enable fails

Stefan Richter (1):
      ieee1394: dv1394: move deprecation message from module init to file open

 drivers/firewire/fw-card.c |    9 ++++++++-
 drivers/ieee1394/dv1394.c  |    8 ++++----
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 7be2cf3..a5dd7a6 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -412,6 +412,7 @@ fw_card_add(struct fw_card *card,
 {
 	u32 *config_rom;
 	size_t length;
+	int err;
 
 	card->max_receive = max_receive;
 	card->link_speed = link_speed;
@@ -422,7 +423,13 @@ fw_card_add(struct fw_card *card,
 	list_add_tail(&card->link, &card_list);
 	mutex_unlock(&card_mutex);
 
-	return card->driver->enable(card, config_rom, length);
+	err = card->driver->enable(card, config_rom, length);
+	if (err < 0) {
+		mutex_lock(&card_mutex);
+		list_del(&card->link);
+		mutex_unlock(&card_mutex);
+	}
+	return err;
 }
 EXPORT_SYMBOL(fw_card_add);
 
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index a329e6b..3838bc4 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -1823,6 +1823,10 @@ static int dv1394_open(struct inode *inode, struct file *file)
 
 #endif
 
+	printk(KERN_INFO "%s: NOTE, the dv1394 interface is unsupported "
+	       "and will not be available in the new firewire driver stack. "
+	       "Try libraw1394 based programs instead.\n", current->comm);
+
 	return 0;
 }
 
@@ -2567,10 +2571,6 @@ static int __init dv1394_init_module(void)
 {
 	int ret;
 
-	printk(KERN_WARNING
-	       "NOTE: The dv1394 driver is unsupported and may be removed in a "
-	       "future Linux release. Use raw1394 instead.\n");
-
 	cdev_init(&dv1394_cdev, &dv1394_fops);
 	dv1394_cdev.owner = THIS_MODULE;
 	ret = cdev_add(&dv1394_cdev, IEEE1394_DV1394_DEV, 16);


Thanks,
-- 
Stefan Richter
-=====-==--= --=- --==-
http://arcgraph.de/sr/

