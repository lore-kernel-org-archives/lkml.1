Return-Path: <linux-kernel-owner+w=401wt.eu-S936326AbXG3JIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936326AbXG3JIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbXG3JIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:08:15 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:3529 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbXG3JIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:08:13 -0400
Date: Mon, 30 Jul 2007 11:08:31 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
Message-ID: <20070730110831.68075b30@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070729025339.GB19311@kernel.sg>
References: <20070729025339.GB19311@kernel.sg>
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

On Sun, 29 Jul 2007 10:53:39 +0800,
Eugene Teo <eugeneteo@kernel.sg> wrote:

> @@ -388,20 +389,34 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
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

You need a remove uevent if you did an add uevent above.

> +err_out_del_kobj:
> +	kobject_del(&p->kobj);
> +err_out:
> +	kfree(p);

Please use kobject_put() instead.
