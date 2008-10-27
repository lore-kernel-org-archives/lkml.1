Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYJ0B2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYJ0B2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 21:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbYJ0B2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 21:28:35 -0400
Received: from mailgw.cvut.cz ([147.32.3.235]:46183 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYJ0B2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 21:28:34 -0400
Message-ID: <4905193D.90607@vc.cvut.cz>
Date: Sun, 26 Oct 2008 18:28:29 -0700
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.17) Gecko/20080829 Iceape/1.1.12 (Debian-1.1.12-1)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Paul Mundt <lethal@linux-sh.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk> <20081024071608.GA3879@linux-sh.org> <20081024072428.GP22217@kernel.dk> <873aimv0v8.fsf@denkblock.local> <20081024084818.GB22217@kernel.dk> <4903004D.2050904@vc.cvut.cz> <20081025184506.GM22217@kernel.dk> <20081026173421.GN22217@kernel.dk>
In-Reply-To: <20081026173421.GN22217@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sat, Oct 25 2008, Jens Axboe wrote:
>> On Sat, Oct 25 2008, Petr Vandrovec wrote:
>>> Jens Axboe wrote:
>>>> On Fri, Oct 24 2008, Elias Oltmanns wrote:
>>>>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>>>> >From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
>>>>>> From: Jens Axboe <jens.axboe@oracle.com>
>>>>>> Date: Fri, 24 Oct 2008 09:22:42 +0200
>>>>>> Subject: [PATCH] libata: fix bug with non-ncq devices
>>>>>>
>>>>>> The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable
>>>>> Wouldn't that be commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e?
>>>> Yes that is correct, the other commit is actually a private one in my
>>>> tree for other libata changes. Updated patch below, thanks for checking!
>>>>
>>> >From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
>>>> From: Jens Axboe <jens.axboe@oracle.com>
>>>> Date: Fri, 24 Oct 2008 09:22:42 +0200
>>>> Subject: [PATCH] libata: fix bug with non-ncq devices
>>> Hello,
>>>   this fixes my DVD, but unfortunately NCQ devices connected to PMP are 
>>> still dead - apparently as soon as mount() tries to do serious I/O on 
>>> the drive.  Backing out both post-2.6.28-rc1 fix as well as your 
>>> original change brings storage back.  I suspect that problem is that 
>>> with PMP same tag cannot be (should not be?  must not be?) used on 
>>> multiple devices behind PMP - and before your change tags were allocated 
>>> per-port, while now they are allocated per-device.
>> That would indeed break, this requires allocating the tag map in the
> 
> Totally untested, does this work?
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 4b95c43..0785c46 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1107,6 +1107,10 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>  
>  		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>  		depth = min(ATA_MAX_QUEUE - 1, depth);
> +
> +		if (dev->link->ap->pmp_link)
> +			scsi_init_shared_tag_map(sdev->host, ATA_MAX_QUEUE - 1);
> +
>  		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
>  		scsi_activate_tcq(sdev, depth);
>  	}

No.  It went through same story as without patch - first it declared 
drive #2 hung, after port reset drives #0,1,2 were declared hung, after 
second port reset drive #2 was declared dead, after third port reset 
drive #3 was hung, after fourth reset it said that /dev/sde changed 
capacity from 0 to 1TB, and at that point I decided that it is time to 
hit alt-sysrq-b to prevent damage...

Also I think that this change leaks memory a bit...
						Petr
						Petr

