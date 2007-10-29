Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbXJ2NHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbXJ2NHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXJ2NHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:07:42 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:14848 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbXJ2NHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:07:41 -0400
Date: Mon, 29 Oct 2007 14:06:57 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Andries Brouwer <aeb@cwi.nl>, Al Viro <viro@ftp.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071029140657.09d3a343@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071029122211.GA18536@bigserver.hohndel.org>
References: <20071029122211.GA18536@bigserver.hohndel.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 05:22:11 -0700,
Dirk Hohndel <hohndel@linux.intel.com> wrote:

<only commenting on the kobject part...>

> @@ -390,20 +390,31 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>  	p->kobj.parent = &disk->kobj;
>  	p->kobj.ktype = &ktype_part;
>  	kobject_init(&p->kobj);
> -	kobject_add(&p->kobj);
> +	if (kobject_add(&p->kobj)) 
> +		return -1;
>  	if (!disk->part_uevent_suppress)
>  		kobject_uevent(&p->kobj, KOBJ_ADD);
> -	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
> +	if(sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem")) {
> +		kobject_del(&p->kobj);
> +		kfree(p);
> +		return -1;
> +	}


- This is missing a KOBJ_DEL uevent if you did a KOBJ_ADD uevent.
- Calling kfree() after you already registered the kobject via
  kobject_add() is wrong, since someone else might already have obtained
  a reference. You must drop your reference after kobject_del() and let
  the release mechanism take care of it.

<I think I'm having some kind of deja vu, since it seems I've already
pointed that out a couple of times to different people :) >

>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>  		static struct attribute addpartattr = {
>  			.name = "whole_disk",
>  			.mode = S_IRUSR | S_IRGRP | S_IROTH,
>  		};
> 
> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
> +			kobject_del(&p->kobj);
> +			kfree(p);
> +			return -1;
> +		}

Same here. You should probably also delete the link you created above.

>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;
> +	
> +	return 0;
>  }
> 
>  static char *make_block_name(struct gendisk *disk)
