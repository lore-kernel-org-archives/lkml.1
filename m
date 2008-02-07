Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbYBGUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbYBGUKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbYBGUEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:04:09 -0500
Received: from mx1.suse.de ([195.135.220.2]:37575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbYBGUEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:04:07 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/3] Block: Fix whole_disk attribute bug
Date: Thu,  7 Feb 2008 12:02:17 -0800
Message-Id: <1202414539-4672-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080207200140.GA4572@suse.de>
References: <20080207200140.GA4572@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "whole_disk" attribute was not properly converted in the block
device conversion earlier, and if the file is read, bad things can
happen.  This patch fixes this, making the attribute an empty one,
preserving the original functionality.

Many thanks to David Miller for finding this, and pointing me in the
proper place within the block code to look.

Acked-by: David S. Miller <davem@davemloft.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/check.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 739da70..9a64045 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -319,6 +319,14 @@ void delete_partition(struct gendisk *disk, int part)
 	put_device(&p->dev);
 }
 
+static ssize_t whole_disk_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return 0;
+}
+static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
+		   whole_disk_show, NULL);
+
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
@@ -352,13 +360,8 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	device_add(&p->dev);
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
-	if (flags & ADDPART_FLAG_WHOLEDISK) {
-		static struct attribute addpartattr = {
-			.name = "whole_disk",
-			.mode = S_IRUSR | S_IRGRP | S_IROTH,
-		};
-		err = sysfs_create_file(&p->dev.kobj, &addpartattr);
-	}
+	if (flags & ADDPART_FLAG_WHOLEDISK)
+		err = device_create_file(&p->dev, &dev_attr_whole_disk);
 
 	/* suppress uevent if the disk supresses it */
 	if (!disk->dev.uevent_suppress)
-- 
1.5.4

