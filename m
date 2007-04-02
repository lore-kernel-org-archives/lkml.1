Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbXDBK7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbXDBK7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXDBK7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:59:23 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:8238 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXDBK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:59:22 -0400
Date: Mon, 2 Apr 2007 13:01:28 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Cong WANG" <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-ID: <20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
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

On Sun, 1 Apr 2007 15:32:34 +0800,
"Cong WANG" <xiyou.wangcong@gmail.com> wrote:

> --- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30
> 21:35:45.000000000 +0800
> +++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-03-30
> 21:49:53.000000000 +0800
> @@ -385,10 +385,16 @@ void add_partition(struct gendisk *disk,
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
> +		kfree(p);
> +		return;
> +	}

You need to properly undo whatever you did before. You're missing a
KOBJ_DEL uevent and a kobject_del here.

>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>  		static struct attribute addpartattr = {
>  			.name = "whole_disk",
> @@ -396,7 +402,10 @@ void add_partition(struct gendisk *disk,
>  			.owner = THIS_MODULE,
>  		};
> 
> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
> +			kfree(p);
> +			return;
> +		}

Also here.
