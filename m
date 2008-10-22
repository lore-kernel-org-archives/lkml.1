Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYJVDYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYJVDYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYJVDYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:24:13 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38521 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJVDYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jEf3P/wj3wkL77EoyHYe6sKMBVa1B2O/TkV6X1GfT36KkbZJm7PmOj6Xu+ssOq7Qb1
         c2KAaYXK96k7ZaQS/7eXiGT5U/da2XF2Dr1zpNoxzZqaqfqAaiwUTXYMiyCYEUHm5V8c
         HvmjFweB0fXR1DgvrEwti94oSfsmlI/aRjl6A=
Message-ID: <386072610810212024l52cd86cen79061d7111c421ba@mail.gmail.com>
Date: Wed, 22 Oct 2008 11:24:10 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] re-modprobe a nand controller driver module will cause system crash.
In-Reply-To: <386072610810160356p3807f538la5087debe0c76866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610810160356p3807f538la5087debe0c76866@mail.gmail.com>
X-Google-Sender-Auth: 0743b6e2bd29a831
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Did anyone meet this issue before?

-Bryan

On Thu, Oct 16, 2008 at 6:56 PM, Bryan Wu <cooloney@kernel.org> wrote:
> Hi folks,
>
> These days I found a subtle bug which should be related with mtdcore layers.
> The detailed story is located at
> https://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_id=141&tracker_item_id=4463.
>
> Briefly speaking,
> 1) modprobe a nand controller driver to add_mtd_paritition().
> 2) add_mtd_partition->add_devices->blktrans_notify_add->mtdblock_add_mtd->add_mtd_blktrans_dev
> 3) in add_mtd_blktrans_dev, alloc_disk will be called to create a new
> gendisk structure according to the partition setting.
> 4) "gd->queue = tr->blkcore_priv->rq;"
>    No matter how many partitions (in my test, 2 partitions), there
> will be the same number gendisk structures but just 1 queue.
>    They all use the same request_queue which is created in
> register_mtd_blktrans.
> 5) mtdblockd kthread handles this request_queue for mtdblock layer.
> 6) There is one backing_dev_info structure member (not pointer) in
> request_queue. so for several mtd partitions (serveral gendisks) there
> is only one bdi structure instance.
> 7) So the problem is in add_disk(),
>    bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
>    For 1st partition mtdblock0, it will create /sys/class/bdi/31:0
> and register information in bdi structure instance.
>    Then for 2nd partition mtdblock1, because the bdi structure
> instance is the same as the 1st partition, it will overwrite bdi
> structure and create /sys/class/bdi/31:1.
>    So the bdi info of 1st partition are totally lost.
> 8) When we rmmod the nand controller driver, del_mtd_partition will
> only remove /sys/class/bdi/31:1 but left 1st partition
> /sys/class/bdi/31:0 there.
> 9) modprobe again will let the bug show up.
>
> I found this bug does not relate with my nand flash controller driver
> and it should be fixed in mtdblock layer.
> And if we just add only one partition, there is no such bug at all. I
> tried to solve this bug, but it related with
> mtdblock/mtd_blktrans/block/bdi. It is diffcult for me to find a way
> to satisfy all the parts with minimal changes.
>
> IMHO, can we just simply remove the bdi_register_dev (in add_disk) and
> bdi_unregister_dev (in unlink_disk)?
>
> P.S. I also found this bug in latest 2.6.27 kernel mainline.
>
> Thanks
> -Bryan
>
