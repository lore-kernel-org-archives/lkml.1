Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbYAYIMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbYAYIMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764044AbYAYIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:53646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764062AbYAYH7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 161/196] Kobject: convert drivers/md/md.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:33:10 -0800
Message-Id: <1201246425-5058-82-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/md.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f79efb3..7ae9740 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1383,16 +1383,13 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 			return -EBUSY;
 	}
 	bdevname(rdev->bdev,b);
-	if (kobject_set_name(&rdev->kobj, "dev-%s", b) < 0)
-		return -ENOMEM;
-	while ( (s=strchr(rdev->kobj.k_name, '/')) != NULL)
+	while ( (s=strchr(b, '/')) != NULL)
 		*s = '!';
-			
+
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
 
-	rdev->kobj.parent = &mddev->kobj;
-	if ((err = kobject_add(&rdev->kobj)))
+	if ((err = kobject_add_ng(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
 
 	if (rdev->bdev->bd_part)
@@ -2036,9 +2033,7 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
 	if (err)
 		goto abort_free;
 
-	rdev->kobj.parent = NULL;
-	rdev->kobj.ktype = &rdev_ktype;
-	kobject_init(&rdev->kobj);
+	kobject_init_ng(&rdev->kobj, &rdev_ktype);
 
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
-- 
1.5.3.8

