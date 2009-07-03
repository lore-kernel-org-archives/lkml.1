Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZGCOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZGCOrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZGCOrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:47:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42154 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbZGCOrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:47:05 -0400
Message-ID: <4A4E19E4.4020009@redhat.com>
Date: Fri, 03 Jul 2009 16:47:00 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: Linux 2.6.27.26
References: <20090703000703.GA17190@kroah.com> <20090703000722.GB17190@kroah.com> <200907030852.24912.a.miskiewicz@gmail.com>
In-Reply-To: <200907030852.24912.a.miskiewicz@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arkadiusz Miskiewicz wrote:
> On Friday 03 of July 2009, Greg KH wrote:
> 
> Isn't this part broken?

yes, this part is broken, patch is misapplied to wrong function...
it applies only for for dm_get_from_kobject(), not dm_blk_open()

The patch

  4d89b7b4e4726893453d0fb4ddbb5b3e16353994 
  Do not process sysfs attributes when device is being destroyed.

is not needed for 2.6.27 (dm sysfs attributes are not there yet)

Milan


> 
> The code in 2.6.27 already has such thing and new code is trying to return 
> NULL even if function returns int
> 
> static int dm_blk_open(struct inode *inode, struct file *file)
> {
>         struct mapped_device *md;
> 
>         spin_lock(&_minor_lock);
> 
>         md = inode->i_bdev->bd_disk->private_data;
>         if (!md)
>                 goto out;
> 
>         if (test_bit(DMF_FREEING, &md->flags) ||
>             test_bit(DMF_DELETING, &md->flags)) {
>                 md = NULL;
>                 goto out;
>         }
> 
>         dm_get(md);
>         atomic_inc(&md->open_count);
> 
> out:
>         spin_unlock(&_minor_lock);
> 
>         return md ? 0 : -ENXIO;
> }
> 
> 
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index ace998c..925efaf 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -265,6 +265,10 @@ static int dm_blk_open(struct inode *inode, struct
>> file *file) goto out;
>>         }
>>  
>> +       if (test_bit(DMF_FREEING, &md->flags) ||
>> +           test_bit(DMF_DELETING, &md->flags))
>> +               return NULL;
>> +
>>         dm_get(md);
>>         atomic_inc(&md->open_count);
>>  
> 
> 
