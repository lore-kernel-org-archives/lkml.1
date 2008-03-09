Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYCIUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYCIUZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYCIUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:25:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYCIUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:25:12 -0400
Subject: [PATCH] block: send disk "change" event for rescan_partitions()
From: Kay Sievers <kay.sievers@vrfy.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, David Zeuthen <david@fubar.dk>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 21:26:02 +0100
Message-Id: <1205094362.2366.2.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/8fD6/QYnJ6VWZAsWiECBcf1eqkdFojnzvdyl
 x/puA5GhEH3wNomY+23hsXVClNKu3bfrmUwqKRivVyRZGKVpx0
 lcjMLlS8HJnt1j5IqZiYy3CF0g3ojeO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: send disk "change" event for rescan_partitions()

Userspace likes to get notified that the disk may have changed, when
rescan_partitions() is called after partitioning or media change. It will
make it possible to update the state of the disk with the "change" event,
before the following partition "add" events are handled.

Cc: David Zeuthen <david@fubar.dk>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 03f808c..6149e4b 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -473,6 +473,10 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 		return 0;
 	if (IS_ERR(state))	/* I/O error reading the partition table */
 		return -EIO;
+
+	/* tell userspace that the media / partition table may have changed */
+	kobject_uevent(&disk->dev.kobj, KOBJ_CHANGE);
+
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;


