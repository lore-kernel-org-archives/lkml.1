Return-Path: <linux-kernel-owner+w=401wt.eu-S1767013AbXDEOl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767013AbXDEOl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767015AbXDEOl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:41:28 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:18954 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767013AbXDEOl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=d6fr+eGS3uFJxA8jopabQs6gAyyN2HAoidnXwQ36kQGG64aW1v+gjK4ZYrw7fxz0URU2a5UK3r86ECxHek+gKeSFTC4gLbf3OS16J55LDt3nW0vu8tSXJq4/sqX0mCHDCeK1dcD/E3RDPS52ENP38+wMrhwPV9kadSp8G2pAXLg=
Date: Thu, 5 Apr 2007 22:44:09 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
Message-ID: <20070405144409.GA5294@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Cornelia Huck <cornelia.huck@de.ibm.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com> <20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com> <20070405045410.GA4692@localhost.localdomain> <20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 11:11:42AM +0200, Cornelia Huck wrote:
>On Thu, 5 Apr 2007 12:54:11 +0800,
>WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
>> --- linux-2.6.21-rc5-mm3/fs/partitions/check.c.orig	2007-03-30 21:35:45.000000000 +0800
>> +++ linux-2.6.21-rc5-mm3/fs/partitions/check.c	2007-04-02 21:29:02.000000000 +0800
>> @@ -385,10 +385,18 @@ void add_partition(struct gendisk *disk,
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
>> +		kobject_uevent(&p->kobj, KOBJ_REMOVE);
>> +		kobject_del(&p->kobj);
>> +		kfree(p);
>
>You should use kobject_put instead of kfree, since someone could have
>(theoretically) obtained a reference on the object after the
>kobject_add. (Or just use kobject_unregister, if the delete uevent
>isn't suppressed anyway.)
>

I can't understand that. The memory pointed by 'p' is obtained via kmalloc(), _not_ kobject_get. How can we use kobject_put instead? 

Thanks! 

