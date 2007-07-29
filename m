Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbXG2Cx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbXG2Cx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXG2Cxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:53:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:38697 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXG2Cxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:reply-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from:sender;
        b=BShJY/WWM8VE5HbgSrPWRxzWsu6Klrm0dRNUbI+VxW6/sjfN9qEfu1i1tD+/gZSB1EPDxMh97DCHDuAnmb8re6sfSOH0zEtss7lox/D+lW3OTqLoq1upPj2aMe1u5ZqYEiFT4eeD3GCSqlT7Pp2Q/RHpD9DxETFXXh7ecArKqQc=
Date: Sun, 29 Jul 2007 10:53:39 +0800
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/partitions/check.c: add_partition() warning fixes
Message-ID: <20070729025339.GB19311@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes these warnings:

fs/partitions/check.c: In function ‘add_partition’:
fs/partitions/check.c:391: warning: ignoring return value of ‘kobject_add’,
	declared with attribute warn_unused_result
fs/partitions/check.c:394: warning: ignoring return value of
	‘sysfs_create_link’, declared with attribute warn_unused_result
fs/partitions/check.c:401: warning: ignoring return value of
	‘sysfs_create_file’, declared with attribute warn_unused_result

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/partitions/check.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 783c57e..01397c1 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -371,6 +371,7 @@ void delete_partition(struct gendisk *disk, int part)
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -388,20 +389,34 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	err = kobject_add(&p->kobj);
+	if (err)
+		goto err_out;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	err = sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
+	if (err)
+		goto err_out_del_kobj;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		err = sysfs_create_file(&p->kobj, &addpartattr);
+		if (err)
+			goto err_out_del_link;
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
+	return;
+
+err_out_del_link:
+	sysfs_remove_link(&p->kobj, "subsystem");
+err_out_del_kobj:
+	kobject_del(&p->kobj);
+err_out:
+	kfree(p);
 }
 
 static char *make_block_name(struct gendisk *disk)

