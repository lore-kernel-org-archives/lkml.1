Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXDAFbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXDAFbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 01:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbXDAFbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 01:31:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXDAFbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 01:31:39 -0400
Date: Sat, 31 Mar 2007 22:31:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Cong WANG" <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add
 etc.
Message-Id: <20070331223136.6019d98f.akpm@linux-foundation.org>
In-Reply-To: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 10:30:31 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:

> Since kobject_add, sysfs_create_link and sysfs_create_file are marked
> as '__must_check', so we must always check their return values, or gcc
> will give us warnings.
> 
> Signed-off-by: Cong WANG <xiyou.wangcong@gmail.com>
> 
> ---
> --- fs/partitions/check.c.orig	2007-03-30 21:35:45.000000000 +0800
> +++ fs/partitions/check.c	2007-03-30 21:49:53.000000000 +0800
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
>  	}
>  	partition_sysfs_add_subdir(p);
>  	disk->part[part-1] = p;

Well yes, but the point here it to fix kernel bugs, not to just make the
warnings go away.

The bugs here are that the effects of the kobject_add() and the
sysfs_create_link() are not undone on the error path.

Also, please always prepare patches in `patch -p1' form, as per
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.

