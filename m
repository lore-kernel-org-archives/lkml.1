Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYHURj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYHURj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYHURj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:39:28 -0400
Received: from ns.suse.de ([195.135.220.2]:48003 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760732AbYHURj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:39:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/15] block: fix partial read() of /proc/{partitions,diskstats}
Date: Thu, 21 Aug 2008 10:32:58 -0700
Message-Id: <1219339983-9634-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

The proc files get truncated if they do not fit into the buffer with
a single read(). We need to move the seq_file index from the callback
of class_find_device() to the caller of class_find_device(), to keep
its value across multiple invocations of the callback.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c13cc77..f34befc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -293,25 +293,26 @@ void __init printk_all_partitions(void)
 /* iterator */
 static int find_start(struct device *dev, void *data)
 {
-	loff_t k = *(loff_t *)data;
+	loff_t *k = data;
 
 	if (dev->type != &disk_type)
 		return 0;
-	if (!k--)
+	if (!*k)
 		return 1;
+	(*k)--;
 	return 0;
 }
 
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
 	struct device *dev;
-	loff_t n = *pos;
+	loff_t k = *pos;
 
-	if (!n)
+	if (!k)
 		seq_puts(part, "major minor  #blocks  name\n\n");
 
 	mutex_lock(&block_class_lock);
-	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	dev = class_find_device(&block_class, NULL, &k, find_start);
 	if (dev)
 		return dev_to_disk(dev);
 	return NULL;
@@ -568,9 +569,10 @@ static struct device_type disk_type = {
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
 	struct device *dev;
+	loff_t k = *pos;
 
 	mutex_lock(&block_class_lock);
-	dev = class_find_device(&block_class, NULL, (void *)pos, find_start);
+	dev = class_find_device(&block_class, NULL, &k, find_start);
 	if (dev)
 		return dev_to_disk(dev);
 	return NULL;
-- 
1.5.6.5

