Return-Path: <linux-kernel-owner+w=401wt.eu-S965687AbXDJWSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687AbXDJWSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXDJWSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:18:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXDJWSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:18:46 -0400
Date: Tue, 10 Apr 2007 15:18:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-Id: <20070410151815.906ef9b4.akpm@linux-foundation.org>
In-Reply-To: <20070410140829.GA3382@localhost.localdomain>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
	<20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
	<20070406025343.GA2407@localhost.localdomain>
	<20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
	<20070410140829.GA3382@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 22:08:29 +0800
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Since kobject_add, sysfs_create_link and sysfs_create_file are marked as '__must_check', we must always check their return values.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> ---
> --- linux-2.6.21-rc5-mm4/fs/partitions/check.c.orig     2007-04-05 12:48:29.000000000 +0800
> +++ linux-2.6.21-rc5-mm4/fs/partitions/check.c  2007-04-05 23:15:41.000000000 +0800
> @@ -385,10 +385,18 @@ void add_partition(struct gendisk *disk,
>         p->kobj.parent = &disk->kobj;
>         p->kobj.ktype = &ktype_part;
>         kobject_init(&p->kobj);
> -       kobject_add(&p->kobj);
> +       if (kobject_add(&p->kobj)) {
> +               kobject_put(&p->kobj);
> +               return;
> +       }
>         if (!disk->part_uevent_suppress)
>                 kobject_uevent(&p->kobj, KOBJ_ADD);
> -       sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
> +       if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
> +               kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +               kobject_del(&p->kobj);
> +               kobject_put(&p->kobj);
> +               return;
> +       }
>         if (flags & ADDPART_FLAG_WHOLEDISK) {
>                 static struct attribute addpartattr = {
>                         .name = "whole_disk",
> @@ -396,7 +404,13 @@ void add_partition(struct gendisk *disk,
>                         .owner = THIS_MODULE,
>                 };
> 
> -               sysfs_create_file(&p->kobj, &addpartattr);
> +               if (sysfs_create_file(&p->kobj, &addpartattr)) {
> +                       sysfs_remove_link(&p->kobj, "subsystem");
> +                       kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +                       kobject_del(&p->kobj);
> +                       kobject_put(&p->kobj);
> +                       return;
> +               }
>         }
>         partition_sysfs_add_subdir(p);
>         disk->part[part-1] = p;

Your mail client replaces tabs with spaces - please fix it.

The code duplication is unpleasing.  We normally do this as below (please
review this code).

Note that I changed it to not send the KOBJ_REMOVE if we didn't send a
KOBJ_ADD.


From: WANG Cong <xiyou.wangcong@gmail.com>

Since kobject_add, sysfs_create_link and sysfs_create_file are marked as
'__must_check', we must always check their return values.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/check.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff -puN fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc fs/partitions/check.c
--- a/fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc
+++ a/fs/partitions/check.c
@@ -383,26 +383,41 @@ void add_partition(struct gendisk *disk,
 	p->policy = disk->policy;
 
 	if (isdigit(disk->kobj.name[strlen(disk->kobj.name)-1]))
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%sp%d",
+				disk->kobj.name, part);
 	else
-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%s%d",
+				disk->kobj.name, part);
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	if (kobject_add(&p->kobj))
+		goto out_put;
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
+	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem"))
+		goto out_uevent;
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		if (sysfs_create_file(&p->kobj, &addpartattr))
+			goto out_link;
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;
+	return;
+
+out_link:
+	sysfs_remove_link(&p->kobj, "subsystem");
+out_uevent:
+	if (!disk->part_uevent_suppress)
+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
+	kobject_del(&p->kobj);
+out_put:
+	kobject_put(&p->kobj);
 }
 
 static char *make_block_name(struct gendisk *disk)
_

