Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXDJM2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXDJM2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXDJM2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:28:52 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51946 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbXDJM2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:28:51 -0400
Date: Tue, 10 Apr 2007 14:31:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-ID: <20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070406025343.GA2407@localhost.localdomain>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
	<20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
	<20070406025343.GA2407@localhost.localdomain>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 10:53:43 +0800,
WANG Cong <xiyou.wangcong@gmail.com> wrote:
 
> OK. Then I send it again. Hopefully it can be accepted this time. ;-p

Looks sane. (Note that there is still a pathological case where
kobject_put() is not enough to trigger release after the failed
kobject_add(). I'm sending a fix for that.)

<Maybe you want to add one or two lines of explanation for your patch
again?>
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> ---
> 
> --- linux-2.6.21-rc5-mm4/fs/partitions/check.c.orig	2007-04-05 12:48:29.000000000 +0800
> +++ linux-2.6.21-rc5-mm4/fs/partitions/check.c	2007-04-05 23:15:41.000000000 +0800
> @@ -385,10 +385,18 @@ void add_partition(struct gendisk *disk,
>  	p->kobj.parent = &disk->kobj;
>  	p->kobj.ktype = &ktype_part;
>  	kobject_init(&p->kobj);
> -	kobject_add(&p->kobj);
> +	if (kobject_add(&p->kobj)) {
> +		kobject_put(&p->kobj);
> +		return;
> +	}
>  	if (!disk->part_uevent_suppress)
>  		kobject_uevent(&p->kobj, KOBJ_ADD);
> -	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
> +	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +		kobject_del(&p->kobj);
> +		kobject_put(&p->kobj);
> +		return;
> +	}
>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>  		static struct attribute addpartattr = {
>  			.name = "whole_disk",
> @@ -396,7 +404,13 @@ void add_partition(struct gendisk *disk,
>  			.owner = THIS_MODULE,
>  		};
> 
> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
> +			sysfs_remove_link(&p->kobj, "subsystem");
> +			kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +			kobject_del(&p->kobj);
> +			kobject_put(&p->kobj);
> +			return;
> +		}
>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;
> 
> 
