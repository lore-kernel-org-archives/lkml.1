Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXDKGmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXDKGmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXDKGmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:42:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:13328 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbXDKGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EI4uxc9XyE+AAu3iGp4Paao3kH0/WeLiWyUQde3CCRTHGG0xqNNxpP1OA3BUkFPZoAeMvTdbqDBxIt1+GVKMpT2lEqK6tHNXX5oUEcDsn4YA2jRIZbFOrKIVcaNvN08fODUPMb15yX+u1bBhaWHtq9YhUmJHBHakjYxf09GDObU=
Date: Wed, 11 Apr 2007 14:45:25 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
Message-ID: <20070411064525.GC4343@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Cornelia Huck <cornelia.huck@de.ibm.com>,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070405045410.GA4692@localhost.localdomain> <20070405111142.4723035f@gondolin.boeblingen.de.ibm.com> <20070405144409.GA5294@localhost.localdomain> <20070405170514.481b765f@gondolin.boeblingen.de.ibm.com> <20070405152732.GA5569@localhost.localdomain> <20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com> <20070406025343.GA2407@localhost.localdomain> <20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com> <20070410140829.GA3382@localhost.localdomain> <20070410151815.906ef9b4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410151815.906ef9b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 03:18:15PM -0700, Andrew Morton wrote:
>On Tue, 10 Apr 2007 22:08:29 +0800
>WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
>> Since kobject_add, sysfs_create_link and sysfs_create_file are marked as '__must_check', we must always check their return values.
>> 

<snip>

>
>Your mail client replaces tabs with spaces - please fix it.
>

Oh, I did't notice that. Thank you. I will fix it soon.

>The code duplication is unpleasing.  We normally do this as below (please
>review this code).
>

Er, I see.

>Note that I changed it to not send the KOBJ_REMOVE if we didn't send a
>KOBJ_ADD.
>

I think you are right.

>
>From: WANG Cong <xiyou.wangcong@gmail.com>
>
>Since kobject_add, sysfs_create_link and sysfs_create_file are marked as
>'__must_check', we must always check their return values.
>
>Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> fs/partitions/check.c |   25 ++++++++++++++++++++-----
> 1 files changed, 20 insertions(+), 5 deletions(-)
>
>diff -puN fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc fs/partitions/check.c
>--- a/fs/partitions/check.c~partitions-check-the-return-value-of-kobject_add-etc
>+++ a/fs/partitions/check.c
>@@ -383,26 +383,41 @@ void add_partition(struct gendisk *disk,
> 	p->policy = disk->policy;
> 
> 	if (isdigit(disk->kobj.name[strlen(disk->kobj.name)-1]))
>-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
>+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%sp%d",
>+				disk->kobj.name, part);
                                               ^^^
Andrew, it seems that you left an additional whitespace in the above line (marked as ^^^).

> 	else
>-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
>+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%s%d",
>+				disk->kobj.name, part);
                                               ^^^
Also here. ;-p

> 	p->kobj.parent = &disk->kobj;
> 	p->kobj.ktype = &ktype_part;
> 	kobject_init(&p->kobj);
>-	kobject_add(&p->kobj);
>+	if (kobject_add(&p->kobj))
>+		goto out_put;
> 	if (!disk->part_uevent_suppress)
> 		kobject_uevent(&p->kobj, KOBJ_ADD);
>-	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
>+	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem"))
>+		goto out_uevent;
> 	if (flags & ADDPART_FLAG_WHOLEDISK) {
> 		static struct attribute addpartattr = {
> 			.name = "whole_disk",
> 			.mode = S_IRUSR | S_IRGRP | S_IROTH,
> 		};
> 
>-		sysfs_create_file(&p->kobj, &addpartattr);
>+		if (sysfs_create_file(&p->kobj, &addpartattr))
>+			goto out_link;
> 	}
> 	partition_sysfs_add_subdir(p);
> 	disk->part[part-1] = p;
>+	return;
>+
>+out_link:
>+	sysfs_remove_link(&p->kobj, "subsystem");
>+out_uevent:
>+	if (!disk->part_uevent_suppress)
>+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
>+	kobject_del(&p->kobj);
>+out_put:
>+	kobject_put(&p->kobj);
> }
> 
> static char *make_block_name(struct gendisk *disk)
>_


Your code is better. Thanks again!


