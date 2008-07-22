Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbYGVFea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbYGVFea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYGVFYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:24:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:53892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853AbYGVFYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:24:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 38/79] block: move header for /proc/partitions to seq_start
Date: Mon, 21 Jul 2008 22:19:02 -0700
Message-Id: <1216703983-21448-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seq_start call is the better place for the header for the file, that
way we don't have to be mucking in the class structure to try to figure
out if this is the first partition or not.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index f03bdad..70f1d70 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -305,6 +305,10 @@ static int find_start(struct device *dev, void *data)
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
 	struct device *dev;
+	loff_t n = *pos;
+
+	if (!n)
+		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	mutex_lock(&block_class_lock);
 	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
@@ -338,9 +342,6 @@ static int show_partition(struct seq_file *part, void *v)
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->dev.node == block_class.devices.next)
-		seq_puts(part, "major minor  #blocks  name\n\n");
-
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) ||
 			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
-- 
1.5.6.3

