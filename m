Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXDEJJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXDEJJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXDEJJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:09:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:65086 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965148AbXDEJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:09:29 -0400
Date: Thu, 5 Apr 2007 11:11:42 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-ID: <20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070405045410.GA4692@localhost.localdomain>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
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

On Thu, 5 Apr 2007 12:54:11 +0800,
WANG Cong <xiyou.wangcong@gmail.com> wrote:

> --- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30 21:35:45.000000000 +0800
> +++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-04-02 21:29:02.000000000 +0800
> @@ -385,10 +385,18 @@ void add_partition(struct gendisk *disk,
>  	p->kobj.parent = &disk->kobj;
>  	p->kobj.ktype = &ktype_part;
>  	kobject_init(&p->kobj);
> -	kobject_add(&p->kobj);
> +	if (kobject_add(&p->kobj)) {
> +		kfree(p);
> +		return;
> +	}
>  	if (!disk->part_uevent_suppress)
>  		kobject_uevent(&p->kobj, KOBJ_ADD);
> -	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
> +	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +		kobject_del(&p->kobj);
> +		kfree(p);

You should use kobject_put instead of kfree, since someone could have
(theoretically) obtained a reference on the object after the
kobject_add. (Or just use kobject_unregister, if the delete uevent
isn't suppressed anyway.)

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
> +			kfree(p);

Same here.

> +			return;
> +		}
>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;
> 
> 
> 

