Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXCaCae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXCaCae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933379AbXCaCae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:30:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:7607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbXCaCad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YGcp1Pl1FnqH1hp5U9emZW3z8ZFg2YHIADEPadVTBPfqK68T8c7auzhWp0TGbXWR+EMPG2U8K9A3v+aSvYaBrDMZtPryqE4dSRB/0EL3nfYI05fB29zox5LrVtPdkWrtI15/9f/8UWNyYRUGh3aCAKqu7R6XxicL+4V4J1Ez61I=
Message-ID: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
Date: Sat, 31 Mar 2007 10:30:31 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: [-mm3 patch]Warning fix: check the return value of kobject_add etc.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since kobject_add, sysfs_create_link and sysfs_create_file are marked
as '__must_check', so we must always check their return values, or gcc
will give us warnings.

Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>

---
--- fs/partitions/check.c.orig	2007-03-30 21:35:45.000000000 +0800
+++ fs/partitions/check.c	2007-03-30 21:49:53.000000000 +0800
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
