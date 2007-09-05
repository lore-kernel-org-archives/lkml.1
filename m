Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbXIEHqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbXIEHqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 03:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXIEHqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 03:46:45 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:14279 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755597AbXIEHqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 03:46:43 -0400
Message-ID: <46DE5EB2.4050505@panasas.com>
Date: Wed, 05 Sep 2007 10:45:54 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com,
       grant.likely@secretlab.ca, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 3/7] blk_end_request: changing "normal" drivers
References: <20070831.184219.95065632.k-ueda@ct.jp.nec.com>
In-Reply-To: <20070831.184219.95065632.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2007 07:46:04.0382 (UTC) FILETIME=[CFCA4FE0:01C7EF90]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01 2007 at 1:42 +0300, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> This patch converts "normal" drivers, which complete request
> in a standard way shown below, to use blk_end_request().
> 
>  a) end_that_request_{chunk/first}
>     spin_lock_irqsave()
>     (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
>     end_that_request_last()
>     spin_unlock_irqrestore()
>     => blk_end_request()
> 
>  b) spin_lock_irqsave()
>     end_that_request_{chunk/first}
>     (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
>     end_that_request_last()
>     spin_unlock_irqrestore()
>     => spin_lock_irqsave()
>        __blk_end_request()
>        spin_unlock_irqsave()
> 
>  c) end_that_request_last()
>     => __blk_end_request()
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  arch/arm/plat-omap/mailbox.c    |    9 ++++++---
>  arch/um/drivers/ubd_kern.c      |   10 +---------
>  block/elevator.c                |    4 ++--
>  block/ll_rw_blk.c               |   15 +++++----------
>  drivers/block/DAC960.c          |    6 ++----
>  drivers/block/floppy.c          |    8 +++-----
>  drivers/block/lguest_blk.c      |    5 +----
>  drivers/block/nbd.c             |    4 +---
>  drivers/block/ps3disk.c         |    6 +-----
>  drivers/block/sunvdc.c          |    5 +----
>  drivers/block/sx8.c             |    4 +---
>  drivers/block/ub.c              |    4 ++--
>  drivers/block/viodasd.c         |    5 +----
>  drivers/block/xen-blkfront.c    |    5 ++---
>  drivers/cdrom/viocd.c           |    5 +----
>  drivers/ide/ide-cd.c            |    6 +++---
>  drivers/ide/ide-io.c            |   22 +++++++---------------
>  drivers/message/i2o/i2o_block.c |    8 ++------
>  drivers/mmc/card/block.c        |   24 +++++-------------------
>  drivers/mmc/card/queue.c        |    4 ++--
>  drivers/s390/block/dasd.c       |    4 +---
>  drivers/s390/char/tape_block.c  |    3 +--
>  drivers/scsi/ide-scsi.c         |    8 ++++----
>  drivers/scsi/scsi_lib.c         |   13 ++-----------
>  24 files changed, 57 insertions(+), 130 deletions(-)
> 
> diff -rupN 02-sect2byte-macro/arch/arm/plat-omap/mailbox.c 03-normal-caller-change/arch/arm/plat-omap/mailbox.c
> --- 02-sect2byte-macro/arch/arm/plat-omap/mailbox.c	2007-08-13 00:25:24.000000000 -0400
> +++ 03-normal-caller-change/arch/arm/plat-omap/mailbox.c	2007-08-23 17:51:33.000000000 -0400
> @@ -117,7 +117,8 @@ static void mbox_tx_work(struct work_str
>  
> ...

Please Separate this patch to at least three patches.
1. Block layer - block/elevator.c block/ll_rw_blk.c
2. SCSI-ML - drivers/scsi/scsi_lib.c
3. Normal drivers, can also be separated into logical
   groups like scsi/block etc..

This is because these patches introduce conflicts
to lots of queued work I have, and if you separate
them it will help me with my giting. Also I think
that this is logical. Block-layer and scsi_lib are
not drivers, the Subject of the patch does not match.

Thanks
Boaz
