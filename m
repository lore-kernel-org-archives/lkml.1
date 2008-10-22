Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYJVPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYJVPBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYJVPBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:01:32 -0400
Received: from nebensachen.de ([195.34.83.29]:47687 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYJVPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:01:31 -0400
X-Hashcash: 1:20:081022:bzolnier@gmail.com::LkcVSIqqN3WBL4uw:000000000000000000000000000000000000000000014IY
X-Hashcash: 1:20:081022:linux-kernel@vger.kernel.org::p3uC7opAzM6xMGEj:0000000000000000000000000000000003IUs
X-Hashcash: 1:20:081022:linux-ide@vger.kernel.org::/gynAO6oyFanA8q3:0000000000000000000000000000000000000BV0
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
References: <200810111617.51298.bzolnier@gmail.com>
	<874p3hd74p.fsf@denkblock.local>
	<200810152106.45728.bzolnier@gmail.com>
Date: Wed, 22 Oct 2008 17:01:20 +0200
Message-ID: <87od1cu11b.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Sunday 12 October 2008, Elias Oltmanns wrote:
>> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
>> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > Subject: [PATCH] ide: don't execute the next queued command from the hard-IRQ context
>> >
>> > * Tell the block layer that we are not done handling requests by using
>> >   blk_plug_device() in ide_do_request() (request handling function)
>> >   and ide_timer_expiry() (timeout handler) if the queue is not empty.
>> >
>> > * Remove optimization which directly calls ide_do_request() for the next
>> >   queued command from the ide_intr() (IRQ handler) and ide_timer_expiry().
>> >
>> > * Remove no longer needed IRQ masking from ide_do_request() - in case of
>> >   IDE ports needing serialization disable_irq_nosync()/enable_irq() was
>> >   used for the (possibly shared) IRQ of the other IDE port.
>> >
>> > * Put the misplaced comment in the right place in ide_do_request().
>> >
>> > * Drop no longer needed 'int masked_irq' argument from ide_do_request().
>> >
>> > * Merge ide_do_request() into do_ide_request().
>> >
>> > * Remove no longer needed IDE_NO_IRQ define.
>> >
>> > While at it:
>> >
>> > * Don't use HWGROUP() macro in do_ide_request().
>> >
>> > * Use __func__ in ide_intr().
>> >
>> > This patch reduces IRQ hadling latency for IDE and improves the system-wide
>> > handling of shared IRQs (which should result in more timeout resistant and
>> > stable IDE systems).  It also makes it possible to do some further changes
>> > later (i.e. replace some busy-waiting delays with sleeping equivalents).
>> >
>> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > ---
[...]
>> > Index: b/drivers/ide/ide-io.c
>> > ===================================================================
>> > --- a/drivers/ide/ide-io.c
>> > +++ b/drivers/ide/ide-io.c
[...]
>> >  		startstop = start_request(drive, rq);
>> >  		spin_lock_irq(&hwgroup->lock);
>> > -		if (masked_irq != IDE_NO_IRQ && hwif->irq != masked_irq)
>> > -			enable_irq(hwif->irq);
>> > -		if (startstop == ide_stopped)
>> > +
>> > +		if (startstop == ide_stopped) {
>> >  			hwgroup->busy = 0;
>> > +			goto plug_device;
>> 
>> This goto statement is wrong. Simply set ->busy to zero and be done with
>> it. This way, the loop will start again and either elv_next_request()
>> returns NULL, in which case the queue need not be plugged, or the next
>> request will be processed immediately, which is exactly what we want.
>
> The problem is that the next loop can choose the different drive than
> the current one so we can end up with the situation where we will "lose"
> the blk_plug_device() call.
>
> I fixed it by just inlining "plug_device" code for now.

Right, I had missed that. Still, I'm not really convinced yet that this
is the right way  to handle things. In fact, I believe that the role of
choose_drive() has changed since it is now called directly from the
->request_fn() and it should probably be rewritten and renamed along the
way. However, this needs further discussion and the issue below has some
bearing on this too.

>
>> [...]
>> > @@ -1438,11 +1431,11 @@ irqreturn_t ide_intr (int irq, void *dev
>> >  	if (startstop == ide_stopped) {
>> >  		if (hwgroup->handler == NULL) {	/* paranoia */
>> >  			hwgroup->busy = 0;
>> > -			ide_do_request(hwgroup, hwif->irq);
>> > -		} else {
>> > -			printk(KERN_ERR "%s: ide_intr: huh? expected NULL handler "
>> > -				"on exit\n", drive->name);
>> > -		}
>> > +			if (!elv_queue_empty(drive->queue))
>> > +				blk_plug_device(drive->queue);
>> 
>> This is perhaps not exactly what you really want. It basically means
>> that there will be a delay (q->unplug_delay) after each command which
>> may well hurt I/O performance. Instead, I'd suggest something like the
>> following:
>> 
>> 	if (!elv_queue_empty(drive->queue))
>> 		blk_schedule_queue_run(drive->queue);
>> 
>> and a function
>> 
>> void blk_schedule_queue_run(struct request_queue *q)
>> {
>> 	blk_plug_device(q);
>> 	kblockd_schedule_work(&q->unplug_work);
>> }
>> 
>> in blk-core.c. This can also be used as a helper function in blk-core.c
>> itself.
>
> Care to make a patch adding such helper to blk-core.c?

Thinking about this a bit more, I'd like to raise this issue with Jens
and discuss it in some more generality.

Regards,

Elias
