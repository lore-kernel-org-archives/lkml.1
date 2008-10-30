Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYJ3Xrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYJ3Xrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYJ3XrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:47:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:2278 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbYJ3XrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:47:20 -0400
Message-ID: <ac3eb2510810301647k5e3dfecdjfa79f7e916fcdd20@mail.gmail.com>
Date: Fri, 31 Oct 2008 00:47:18 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Korsgaard" <jacmet@sunsite.dk>
Subject: Re: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510810301451x7dbf18edgd03c1433099ce5e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
	 <200810300027.19116.rjw@sisk.pl> <87abcnj810.fsf@macbook.be.48ers.dk>
	 <ac3eb2510810301451x7dbf18edgd03c1433099ce5e4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 22:51, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Oct 30, 2008 at 00:28, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:
>>
>>  Rafael> On Wednesday, 29 of October 2008, Peter Korsgaard wrote:
>>  >> Hi,
>>  >>
>>  >> I'm seing what looks like a kobject reference count issue with
>>  >> mtdblock_ro + mtd_dataflash + mtd partitions and repeated unbind/bind.
>>  >> I'm on 2.6.28-rc2, but I can reproduce the problem on 2.6.27 as well.
>>
>>  Rafael> Is it reproducible with 2.6.26 too?
>>
>> Sorry, I haven't backported my platform support code to such "old"
>> kernel. I can do it though, if you think it will help pinpoint the
>> issue.
>
> This sounds like a possible reason for the problem:
> "After digging into the mtd code, this bug is not related to our driver. It
> should be a subtle bug in mtd core code.
>
> In add_mtd_partition, for 2 partitions, 2 gendisk structures will be
> allocated. But these 2 gendisk->queue will be set to the same
> request_queue. Then when unregistering the 1st partition, from the
> same request_queue->backing_dev_info, the bdi struct will be set to
> NULL. So for the 2nd partition (bdi == NULL), the sysfs dir of 2nd
> partition will not be removed. Finally, when modprobe the module
> again, the 2nd partition won't be added"
> https://blackfin.uclinux.org/gf/tracker/4463

Looks like a bdi issue:
  http://lkml.org/lkml/2008/10/30/519

Peter, if I do this (whitespace mangled, just pasted in here), the
error goes away for me. Can you try this?

Thanks,
Kay

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -515,7 +515,8 @@ void add_disk(struct gendisk *disk)
        blk_register_queue(disk);

        bdi = &disk->queue->backing_dev_info;
-       bdi_register_dev(bdi, disk_devt(disk));
+       if (!bdi->dev)
+               bdi_register_dev(bdi, disk_devt(disk));
        retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
                                   "bdi");
        WARN_ON(retval);
