Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYJMLKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYJMLKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbYJMLKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:10:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:50243 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409AbYJMLKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:10:22 -0400
Message-ID: <48F32BF6.8010109@kernel.org>
Date: Mon, 13 Oct 2008 20:07:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] block: add partition attribute for partition number
References: <20081010203043.GA11798@elte.hu> <20081010204015.GA15668@elte.hu> <20081010205642.GA28840@elte.hu> <alpine.LFD.2.00.0810101408320.3503@nehalem.linux-foundation.org> <48EFF84B.5060108@kernel.org> <48F00476.6030108@zytor.com> <48F3113F.7090905@kernel.org>
In-Reply-To: <48F3113F.7090905@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 11:09:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With extended devt, finding out the partition number becomes a bit
more challenging as subtracting the minor number from that of the
parent device doesn't work anymore.  The only thing left is parsing
the partition name which is brittle and not exactly universal (some
have '-' between the device name and partition number while others
don't).  This patch introduced partition attribute which contains the
partition number of the device.  This should make finding partitions
and its index easier.

This problem and solution were suggested by H. Peter Anvin.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 fs/partitions/check.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7408227..4684a49 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -195,6 +195,14 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	return ERR_PTR(res);
 }
 
+static ssize_t part_partition_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%d\n", p->partno);
+}
+
 static ssize_t part_start_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -260,6 +268,7 @@ ssize_t part_fail_store(struct device *dev,
 }
 #endif
 
+static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
@@ -269,6 +278,7 @@ static struct device_attribute dev_attr_fail =
 #endif
 
 static struct attribute *part_attrs[] = {
+	&dev_attr_partition.attr,
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_stat.attr,
