Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYJJIsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYJJIsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYJJIrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:47:19 -0400
Received: from nebensachen.de ([195.34.83.29]:39832 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYJJIrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:47:17 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ide: use queue lock instead of ide_lock when possible
Date: Fri, 10 Oct 2008 10:43:11 +0200
Message-ID: <87zllcet7k.fsf@denkblock.local>
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
	<20081008203027.19112.20883.sendpatchset@localhost.localdomain>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:081010:bzolnier@gmail.com::njzPfP0zobd1zSSV:00000000000000000000000000000000000000000006FO6
X-Hashcash: 1:20:081010:jens.axboe@oracle.com::C4m2ICpDupZkmW5H:00000000000000000000000000000000000000004P5N
X-Hashcash: 1:20:081010:linux-ide@vger.kernel.org::vGuOlGFJrLM+Jx59:000000000000000000000000000000000000178k
X-Hashcash: 1:20:081010:linux-kernel@vger.kernel.org::ztAOsCxFzx4+dL6Y:0000000000000000000000000000000003S8q
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: use queue lock instead of ide_lock when possible
>
> This is just a preparation for future changes and there should be no
> functional changes caused by this patch since ide_lock is currently
> also used as queue lock.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
[...]
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
[...]
> @@ -1469,16 +1470,16 @@ out:
>  void ide_do_drive_cmd(ide_drive_t *drive, struct request *rq)
>  {
>  	ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
> +	struct request_queue *q = drive->queue;
>  	unsigned long flags;
>  
>  	hwgroup->rq = NULL;
>  
> -	spin_lock_irqsave(&ide_lock, flags);
> -	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
> -	__generic_unplug_device(drive->queue);
> -	spin_unlock_irqrestore(&ide_lock, flags);
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	__elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
> +	__generic_unplug_device(q);

By the way, wouldn't blk_run_queue() be more appropriate here? It looks
to me as if blk_run_queue() was the thing intended for general usage by
low level drivers who don't know and care about schedulers, whereas the
usage of __generic_unplug_device() should mostly be restricted to the
block layer. On the other hand, there are other drivers in
drivers/block/ that use __generic_unplug_device(), so I may well be
wrong. Jens?

Regards,

Elias
