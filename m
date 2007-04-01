Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXDAHch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXDAHch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 03:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXDAHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 03:32:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXDAHcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 03:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oLn7WRIiC+dfmY3EzpX4L/tnhBR+Ed5kal85XklRZ6ST6Iv+mLQlGBpG/PptFlr4n9P1+lWLZ3GJFltW87gJ+uAIw0X+VrB/coYlkWQgOamzgwPoRxna202ZbySEAIgugyldqOyEhBiLz27ZdNOb6CHh2MrkDLzHdoX3eyB4ZqY=
Message-ID: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
Date: Sun, 1 Apr 2007 15:32:34 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since kobject_add, sysfs_create_link and sysfs_create_file are marked
as '__must_check', we must always check their return values.

Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>

---
--- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30
21:35:45.000000000 +0800
+++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-03-30
21:49:53.000000000 +0800
@@ -385,10 +385,16 @@ void add_partition(struct gendisk *disk,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	if (kobject_add(&p->kobj)) {
+		kfree(p);
+		return;
+	}
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
+	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
+		kfree(p);
+		return;
+	}
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
@@ -396,7 +402,10 @@ void add_partition(struct gendisk *disk,
 			.owner = THIS_MODULE,
 		};

-		sysfs_create_file(&p->kobj, &addpartattr);
+		if (sysfs_create_file(&p->kobj, &addpartattr)) {
+			kfree(p);
+			return;
+		}
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
