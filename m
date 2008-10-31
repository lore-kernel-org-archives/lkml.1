Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYJaEZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYJaEZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYJaEZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:25:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:61924 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYJaEY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uVWL/FIWMTObQ6GnJvJx9xpNyMNUkoCzLFVPUr60NUlDEWvFOP8/AhVMSPgsHspQ/+
         uVfR5Mq94YTvgcHcexffDRPitgVSOnEMhJEuN1Ne5WdmfopaLmrvujgPCP3S2Jhbkbrs
         ubz0ihpXBvecoqtmh6aLw5U1/sBx667QKk85s=
Message-ID: <386072610810302124x6b3bdcfby41f37941017f2ee7@mail.gmail.com>
Date: Fri, 31 Oct 2008 12:24:58 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
Cc: "Peter Korsgaard" <jacmet@sunsite.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510810301647k5e3dfecdjfa79f7e916fcdd20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
	 <200810300027.19116.rjw@sisk.pl> <87abcnj810.fsf@macbook.be.48ers.dk>
	 <ac3eb2510810301451x7dbf18edgd03c1433099ce5e4@mail.gmail.com>
	 <ac3eb2510810301647k5e3dfecdjfa79f7e916fcdd20@mail.gmail.com>
X-Google-Sender-Auth: b3bf48bde0f9b80a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 7:47 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Oct 30, 2008 at 22:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Thu, Oct 30, 2008 at 00:28, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:
>>>
>>>  Rafael> On Wednesday, 29 of October 2008, Peter Korsgaard wrote:
>>>  >> Hi,
>>>  >>
>>>  >> I'm seing what looks like a kobject reference count issue with
>>>  >> mtdblock_ro + mtd_dataflash + mtd partitions and repeated unbind/bind.
>>>  >> I'm on 2.6.28-rc2, but I can reproduce the problem on 2.6.27 as well.
>>>
>>>  Rafael> Is it reproducible with 2.6.26 too?
>>>
>>> Sorry, I haven't backported my platform support code to such "old"
>>> kernel. I can do it though, if you think it will help pinpoint the
>>> issue.
>>
>> This sounds like a possible reason for the problem:
>> "After digging into the mtd code, this bug is not related to our driver. It
>> should be a subtle bug in mtd core code.
>>
>> In add_mtd_partition, for 2 partitions, 2 gendisk structures will be
>> allocated. But these 2 gendisk->queue will be set to the same
>> request_queue. Then when unregistering the 1st partition, from the
>> same request_queue->backing_dev_info, the bdi struct will be set to
>> NULL. So for the 2nd partition (bdi == NULL), the sysfs dir of 2nd
>> partition will not be removed. Finally, when modprobe the module
>> again, the 2nd partition won't be added"
>> https://blackfin.uclinux.org/gf/tracker/4463
>
> Looks like a bdi issue:
>  http://lkml.org/lkml/2008/10/30/519
>
> Peter, if I do this (whitespace mangled, just pasted in here), the
> error goes away for me. Can you try this?
>
> Thanks,
> Kay
>
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -515,7 +515,8 @@ void add_disk(struct gendisk *disk)
>        blk_register_queue(disk);
>
>        bdi = &disk->queue->backing_dev_info;
> -       bdi_register_dev(bdi, disk_devt(disk));
> +       if (!bdi->dev)
> +               bdi_register_dev(bdi, disk_devt(disk));
>        retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
>                                   "bdi");
>        WARN_ON(retval);

IMHO, this is a workaround, right? I think the final solution should
provide every 'gendisk' a dedicated 'bdi'.
So they won't mess up and overwrite.

-Bryan
