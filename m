Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXG3LjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXG3LjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 07:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbXG3Li4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 07:38:56 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:59153 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbXG3Liz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 07:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=ueFEO+Z46jMwMA1wLPv7EmWzkoZaTG5PY76skx40eW7ryB2zcJB2nYguQEH6fq8+fcmfLCm1pAsSjWK8Zi1IMPjn3VmDs+kvPaFXSCyo6PyXAbdS9zgHwOGgdE20hZU75sHc/QATCwXmNYnXswFMIU/kVF52WWuFMAXPFtEUYvA=
Date: Mon, 30 Jul 2007 19:38:47 +0800
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [PATCH] fs/partitions/check.c: add_partition() warning fixes (take
	4)
Message-ID: <20070730113847.GA28404@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes these warnings:

fs/partitions/check.c: In function 'add_partition':
fs/partitions/check.c:391: warning: ignoring return value of 'kobject_add',
	declared with attribute warn_unused_result
fs/partitions/check.c:394: warning: ignoring return value of
	'sysfs_create_link', declared with attribute warn_unused_result
fs/partitions/check.c:401: warning: ignoring return value of
	'sysfs_create_file', declared with attribute warn_unused_result

Got it right this time. Thanks Cornelia for help.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/partitions/check.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 783c57e..bc69f81 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -371,6 +371,7 @@ void delete_partition(struct gendisk *disk, int part)
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -388,20 +389,36 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
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
+	if (!disk->part_uevent_suppress)
+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
+	kobject_del(&p->kobj);
+err_out:
+	kobject_put(&p->kobj);
 }
 
 static char *make_block_name(struct gendisk *disk)

