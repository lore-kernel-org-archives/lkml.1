Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXIZAzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXIZAzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832AbXIZAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:54:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46712 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbXIZAyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:54:40 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cdrom_open() forgets to unlock on -EROFS failure exits
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Message-Id: <E1IaLAU-00085M-9P@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:54:22 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/cdrom/cdrom.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 67ee3d4..7924571 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1032,6 +1032,10 @@ int cdrom_open(struct cdrom_device_info *cdi, struct inode *ip, struct file *fp)
 	check_disk_change(ip->i_bdev);
 	return 0;
 err_release:
+	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
+		cdi->ops->lock_door(cdi, 0);
+		cdinfo(CD_OPEN, "door unlocked.\n");
+	}
 	cdi->ops->release(cdi);
 err:
 	cdi->use_count--;
-- 
1.5.3.GIT


