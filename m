Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbXG3MLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbXG3MLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759711AbXG3MK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:10:58 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:43083 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbXG3MK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:10:57 -0400
Date: Mon, 30 Jul 2007 14:11:39 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
 (take 4)
Message-ID: <20070730141139.4cb1bc90@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070730113847.GA28404@kernel.sg>
References: <20070730113847.GA28404@kernel.sg>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 19:38:47 +0800,
Eugene Teo <eugeneteo@kernel.sg> wrote:

> This patch fixes these warnings:
> 
> fs/partitions/check.c: In function 'add_partition':
> fs/partitions/check.c:391: warning: ignoring return value of 'kobject_add',
> 	declared with attribute warn_unused_result
> fs/partitions/check.c:394: warning: ignoring return value of
> 	'sysfs_create_link', declared with attribute warn_unused_result
> fs/partitions/check.c:401: warning: ignoring return value of
> 	'sysfs_create_file', declared with attribute warn_unused_result
> 
> Got it right this time. Thanks Cornelia for help.
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>

Looks OK.

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>

> ---
>  fs/partitions/check.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> index 783c57e..bc69f81 100644
> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -371,6 +371,7 @@ void delete_partition(struct gendisk *disk, int part)
>  void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
>  {
>  	struct hd_struct *p;
> +	int err;
> 
>  	p = kzalloc(sizeof(*p), GFP_KERNEL);
>  	if (!p)
> @@ -388,20 +389,36 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>  	p->kobj.parent = &disk->kobj;
>  	p->kobj.ktype = &ktype_part;
>  	kobject_init(&p->kobj);
> -	kobject_add(&p->kobj);
> +	err = kobject_add(&p->kobj);
> +	if (err)
> +		goto err_out;
>  	if (!disk->part_uevent_suppress)
>  		kobject_uevent(&p->kobj, KOBJ_ADD);
> -	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
> +	err = sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
> +	if (err)
> +		goto err_out_del_kobj;
>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>  		static struct attribute addpartattr = {
>  			.name = "whole_disk",
>  			.mode = S_IRUSR | S_IRGRP | S_IROTH,
>  		};
> 
> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		err = sysfs_create_file(&p->kobj, &addpartattr);
> +		if (err)
> +			goto err_out_del_link;
>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;
> +	return;
> +
> +err_out_del_link:
> +	sysfs_remove_link(&p->kobj, "subsystem");
> +err_out_del_kobj:
> +	if (!disk->part_uevent_suppress)
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +	kobject_del(&p->kobj);
> +err_out:
> +	kobject_put(&p->kobj);
>  }
> 
>  static char *make_block_name(struct gendisk *disk)
> 

