Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXJ2OoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXJ2OoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXJ2OoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:44:01 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:45658 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbXJ2OoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:44:00 -0400
Date: Mon, 29 Oct 2007 15:43:39 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Andries Brouwer <aeb@cwi.nl>, Al Viro <viro@ftp.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071029142427.GA21930@bigserver.hohndel.org>
References: <20071029140657.09d3a343@gondolin.boeblingen.de.ibm.com>
	<20071029142427.GA21930@bigserver.hohndel.org>
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

On Mon, 29 Oct 2007 07:24:27 -0700,
Dirk Hohndel <hohndel@linux.intel.com> wrote:

> @@ -390,20 +390,33 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>  	p->kobj.parent = &disk->kobj;
>  	p->kobj.ktype = &ktype_part;
>  	kobject_init(&p->kobj);
> -	kobject_add(&p->kobj);
> +	if (kobject_add(&p->kobj)) 

Hm, here the structure needs to be freed as well (via kobject_put()).

> +		return -1;
>  	if (!disk->part_uevent_suppress)
>  		kobject_uevent(&p->kobj, KOBJ_ADD);
> -	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
> +	if(sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem")) 

Whitespace (if (...)).

> +		goto out_cleanup;
>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>  		static struct attribute addpartattr = {
>  			.name = "whole_disk",
>  			.mode = S_IRUSR | S_IRGRP | S_IROTH,
>  		};
> 
> -		sysfs_create_file(&p->kobj, &addpartattr);
> +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
> +			sysfs_remove_link (&p->kobj, "subsystem");
> +			goto out_cleanup;
> +		}
>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;
> +	
> +	return 0;
> +
> +out_cleanup:
> +	if (!disk->part_uevent_suppress)
> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
> +	kobject_del(&p->kobj);

You need a kobject_put() here to drop the reference you obtained in
kobject_init().

> +	return -1;
>  }
> 
>  static char *make_block_name(struct gendisk *disk)
