Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbYDTKpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbYDTKpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYDTKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56304 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbYDTKkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/36] block: send disk "change" event for rescan_partitions()
Date: Sun, 20 Apr 2008 03:45:48 -0700
Message-Id: <1208688366-9252-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Userspace likes to get notified that the disk may have changed, when
rescan_partitions() is called after partitioning or media change. It will
make it possible to update the state of the disk with the "change" event,
before the following partition "add" events are handled.

Cc: David Zeuthen <david@fubar.dk>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/check.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
-- 
1.5.4.5

