Return-Path: <linux-kernel-owner+w=401wt.eu-S1765942AbYAYI3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765942AbYAYI3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761971AbYAYIBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763881AbYAYIAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 125/196] Kobject: change drivers/md/md.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:34 -0800
Message-Id: <1201246425-5058-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/md.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cef9ebd..c503086 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3054,6 +3054,7 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	int partitioned = (MAJOR(dev) != MD_MAJOR);
 	int shift = partitioned ? MdpMinorShift : 0;
 	int unit = MINOR(dev) >> shift;
+	int error;
 
 	if (!mddev)
 		return NULL;
@@ -3082,12 +3083,13 @@ static struct kobject *md_probe(dev_t dev, int *part, void *data)
 	add_disk(disk);
 	mddev->gendisk = disk;
 	mutex_unlock(&disks_mutex);
-	mddev->kobj.parent = &disk->kobj;
-	kobject_set_name(&mddev->kobj, "%s", "md");
-	mddev->kobj.ktype = &md_ktype;
-	if (kobject_register(&mddev->kobj))
+	error = kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->kobj,
+				     "%s", "md");
+	if (error)
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);
+	else
+		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	return NULL;
 }
 
-- 
1.5.3.8

