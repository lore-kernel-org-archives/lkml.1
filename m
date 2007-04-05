Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXDEEvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXDEEvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 00:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161161AbXDEEvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 00:51:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:30893 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161158AbXDEEvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 00:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ExRd/IIK+vE08dRRT8WU9iwdS+CFYbhCrf/1+m6LJC0Y3/I6jtRCbkJ+gNacm54Peyq73fd3ohTRIgdLFtBlr5SyMyE29gqsuhAQWHiF3JVkir5Xh1G2oCGw6pXMxJ/O7Ec2geBcjbTER1mQ3YYRFxaihl2Pv33M2Yv1c5EK3t4=
Date: Thu, 5 Apr 2007 12:54:11 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
Message-ID: <20070405045410.GA4692@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Cornelia Huck <cornelia.huck@de.ibm.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com> <20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 01:01:28PM +0200, Cornelia Huck wrote:
>On Sun, 1 Apr 2007 15:32:34 +0800,
>"Cong WANG" <xiyou.wangcong@gmail.com> wrote:
>
>> --- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30
>> 21:35:45.000000000 +0800
>> +++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-03-30
>> 21:49:53.000000000 +0800
>> @@ -385,10 +385,16 @@ void add_partition(struct gendisk *disk,
>>  	p->kobj.parent = &disk->kobj;
>>  	p->kobj.ktype = &ktype_part;
>>  	kobject_init(&p->kobj);
>> -	kobject_add(&p->kobj);
>> +	if (kobject_add(&p->kobj)) {
>> +		kfree(p);
>> +		return;
>> +	}
>>  	if (!disk->part_uevent_suppress)
>>  		kobject_uevent(&p->kobj, KOBJ_ADD);
>> -	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
>> +	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
>> +		kfree(p);
>> +		return;
>> +	}
>
>You need to properly undo whatever you did before. You're missing a
>KOBJ_DEL uevent and a kobject_del here.
>
>>  	if (flags & ADDPART_FLAG_WHOLEDISK) {
>>  		static struct attribute addpartattr = {
>>  			.name = "whole_disk",
>> @@ -396,7 +402,10 @@ void add_partition(struct gendisk *disk,
>>  			.owner = THIS_MODULE,
>>  		};
>> 
>> -		sysfs_create_file(&p->kobj, &addpartattr);
>> +		if (sysfs_create_file(&p->kobj, &addpartattr)) {
>> +			kfree(p);
>> +			return;
>> +		}
>
>Also here.

Sorry for my delay. My mutt sucked these days. ;-(

OK. Thanks for your point. I make the patch again and is it OK now?
I find -mm4 still has these warnings when compile this file. It is not fixed yet, and the following patch can also be applied to -mm4.

----

--- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30 21:35:45.000000000 +0800
+++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-04-02 21:29:02.000000000 +0800
@@ -385,10 +385,18 @@ void add_partition(struct gendisk *disk,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+	if (kobject_add(&p->kobj)) {
+		kfree(p);
+		return;
+	}
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
-	sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem");
+	if (sysfs_create_link(&p->kobj, &block_subsys.kset.kobj, "subsystem")) {
+		kobject_uevent(&p->kobj, KOBJ_REMOVE);
+		kobject_del(&p->kobj);
+		kfree(p);
+		return;
+	}
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		static struct attribute addpartattr = {
 			.name = "whole_disk",
@@ -396,7 +404,13 @@ void add_partition(struct gendisk *disk,
 			.owner = THIS_MODULE,
 		};
 
-		sysfs_create_file(&p->kobj, &addpartattr);
+		if (sysfs_create_file(&p->kobj, &addpartattr)) {
+			sysfs_remove_link(&p->kobj, "subsystem");
+			kobject_uevent(&p->kobj, KOBJ_REMOVE);
+			kobject_del(&p->kobj);
+			kfree(p);
+			return;
+		}
 	}
 	partition_sysfs_add_subdir(p);
 	disk->part[part-1] = p;



