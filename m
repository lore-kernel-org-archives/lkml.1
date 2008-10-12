Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbYJLSDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbYJLSDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 14:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbYJLSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 14:03:10 -0400
Received: from nebensachen.de ([195.34.83.29]:57264 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYJLSDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 14:03:08 -0400
X-Hashcash: 1:20:081012:bzolnier@gmail.com::3QvXBjtiUnwndSHI:0000000000000000000000000000000000000000000AhjC
X-Hashcash: 1:20:081012:linux-kernel@vger.kernel.org::bpe5rTCZGa1Cew8w:0000000000000000000000000000000001Qub
X-Hashcash: 1:20:081012:linux-ide@vger.kernel.org::2+ERDeuGiI9y8JwI:000000000000000000000000000000000000C9/u
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
References: <200810111617.51298.bzolnier@gmail.com>
Date: Sun, 12 Oct 2008 20:02:14 +0200
Message-ID: <874p3hd74p.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
>
> * Tell the block layer that we are not done handling requests by using
>   blk_plug_device() in ide_do_request() (request handling function)
>   and ide_timer_expiry() (timeout handler) if the queue is not empty.
>
> * Remove optimization which directly calls ide_do_request() for the next
>   queued command from the ide_intr() (IRQ handler) and ide_timer_expiry().
>
> * Remove no longer needed IRQ masking from ide_do_request() - in case of
>   IDE ports needing serialization disable_irq_nosync()/enable_irq() was
>   used for the (possibly shared) IRQ of the other IDE port.
>
> * Put the misplaced comment in the right place in ide_do_request().
>
> * Drop no longer needed 'int masked_irq' argument from ide_do_request().
>
> * Merge ide_do_request() into do_ide_request().
>
> * Remove no longer needed IDE_NO_IRQ define.
>
> While at it:
>
> * Don't use HWGROUP() macro in do_ide_request().
>
> * Use __func__ in ide_intr().
>
> This patch reduces IRQ hadling latency for IDE and improves the system-wide
> handling of shared IRQs (which should result in more timeout resistant and
> stable IDE systems).  It also makes it possible to do some further changes
> later (i.e. replace some busy-waiting delays with sleeping equivalents).
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> on top of per-hwgroup locks patch and with a special dedication to people
> complaining about improving IDE ;)

Some comments / questions. Admittedly, I don't always know enough about
the things I'm talking about here, but I'm hoping to learn something
that way ;-).

[...]
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
[...]
> @@ -999,8 +1001,11 @@ static void ide_do_request (ide_hwgroup_
>  			}
>  
>  			/* no more work for this hwgroup (for now) */
> -			return;
> +			goto plug_device;
>  		}
> +
> +		if (drive != orig_drive)
> +			goto plug_device;
>  	again:
>  		hwif = HWIF(drive);

Didn't you want to get rid of HWIF() too?

>  		if (hwgroup->hwif->sharing_irq && hwif != hwgroup->hwif) {
> @@ -1055,41 +1060,27 @@ static void ide_do_request (ide_hwgroup_
>  				goto again;
>  			/* We clear busy, there should be no pending ATA command at this point. */
>  			hwgroup->busy = 0;
> -			break;
> +			goto plug_device;
>  		}
>  
>  		hwgroup->rq = rq;
>  
> -		/*
> -		 * Some systems have trouble with IDE IRQs arriving while
> -		 * the driver is still setting things up.  So, here we disable
> -		 * the IRQ used by this interface while the request is being started.
> -		 * This may look bad at first, but pretty much the same thing
> -		 * happens anyway when any interrupt comes in, IDE or otherwise
> -		 *  -- the kernel masks the IRQ while it is being handled.
> -		 */
> -		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
> -			disable_irq_nosync(hwif->irq);
>  		spin_unlock(&hwgroup->lock);
> +		/* allow other IRQs while we start this request */
>  		local_irq_enable_in_hardirq();
> -			/* allow other IRQs while we start this request */

That's the part I don't understand completely. Wouldn't it be alright to
do just spin_unlock_irq() here and be done with it? SCSI does exactly
that and as far as I can see, IDE is in a similar situation now that the
->request_fn() is not called from ide_intr() and ide_timer_expiry()
anymore, i.e. the ->request_fn() will always be executed in process
context.

>  		startstop = start_request(drive, rq);
>  		spin_lock_irq(&hwgroup->lock);
> -		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
> -			enable_irq(hwif->irq);
> -		if (startstop == ide_stopped)
> +
> +		if (startstop == ide_stopped) {
>  			hwgroup->busy = 0;
> +			goto plug_device;

This goto statement is wrong. Simply set ->busy to zero and be done with
it. This way, the loop will start again and either elv_next_request()
returns NULL, in which case the queue need not be plugged, or the next
request will be processed immediately, which is exactly what we want.

[...]
> @@ -1438,11 +1431,11 @@ irqreturn_t ide_intr (int irq, void *dev
>  	if (startstop == ide_stopped) {
>  		if (hwgroup->handler == NULL) {	/* paranoia */
>  			hwgroup->busy = 0;
> -			ide_do_request(hwgroup, hwif->irq);
> -		} else {
> -			printk(KERN_ERR "%s: ide_intr: huh? expected NULL handler "
> -				"on exit\n", drive->name);
> -		}
> +			if (!elv_queue_empty(drive->queue))
> +				blk_plug_device(drive->queue);

This is perhaps not exactly what you really want. It basically means
that there will be a delay (q->unplug_delay) after each command which
may well hurt I/O performance. Instead, I'd suggest something like the
following:

	if (!elv_queue_empty(drive->queue))
		blk_schedule_queue_run(drive->queue);

and a function

void blk_schedule_queue_run(struct request_queue *q)
{
	blk_plug_device(q);
	kblockd_schedule_work(&q->unplug_work);
}

in blk-core.c. This can also be used as a helper function in blk-core.c
itself.

Regards,

Elias
