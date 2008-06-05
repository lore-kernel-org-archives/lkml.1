Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYFEInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYFEInR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYFEInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:43:06 -0400
Received: from sacred.ru ([62.205.161.221]:56976 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYFEInF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:43:05 -0400
Message-ID: <4847A67D.9060006@openvz.org>
Date: Thu, 05 Jun 2008 12:40:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] devscgroup: check for device permissions at mount time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 05 Jun 2008 12:42:46 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently even if a task sits in an all-denied cgroup it can still 
mount any block device in any mode it wants.

Put a proper check in do_open for block device to prevent this.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 fs/block_dev.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index a0e9596..7e1c7a3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -24,6 +24,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/hardirq.h>
+#include <linux/device_cgroup.h>
 
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -933,9 +934,14 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
 	struct module *owner = NULL;
 	struct gendisk *disk;
-	int ret = -ENXIO;
+	int ret;
 	int part;
 
+	ret = devcgroup_inode_permission(bdev->bd_inode, file->f_mode);
+	if (ret != 0)
+		return ret;
+
+	ret = -ENXIO;
 	file->f_mapping = bdev->bd_inode->i_mapping;
 	lock_kernel();
 	disk = get_gendisk(bdev->bd_dev, &part);
-- 
1.5.3.4

