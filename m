Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYKXPYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYKXPYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYKXPYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:24:11 -0500
Received: from nebensachen.de ([195.34.83.29]:54663 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbYKXPYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:24:10 -0500
X-Hashcash: 1:20:081124:bzolnier@gmail.com::K45KuX9f6748CRaA:000000000000000000000000000000000000000000087dz
X-Hashcash: 1:20:081124:linux-ide@vger.kernel.org::iRTpohQ7kZAqKnay:00000000000000000000000000000000000041B6
X-Hashcash: 1:20:081124:linux-kernel@vger.kernel.org::kszC8rl2QoQcIc5e:000000000000000000000000000000000A9l5
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide: use per-device request queue locks
References: <200811182119.21286.bzolnier@gmail.com>
Date: Mon, 24 Nov 2008 16:23:57 +0100
Message-ID: <87vdudjgfm.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> * Move hack for flush requests from choose_drive() to do_ide_request().
>
> * Add ide_plug_device() helper and convert core IDE code from using
>   per-hwgroup lock as a request lock to use the ->queue_lock instead.
>
> * Remove no longer needed:
>   - choose_drive() function
>   - WAKEUP() macro
>   - 'sleeping' flag from ide_hwif_t
>   - 'service_{start,time}' fields from ide_drive_t
>
> This patch results in much simpler and more maintainable code
> (besides being a scalability improvement).
>
> Cc: Elias Oltmanns <eo@nebensachen.de>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> newer version

Eventually, I got round to having a look at this one (I reviewed the two
small ones at the time). Apologies for the delay.

>
>  drivers/ide/ide-io.c    | 213 +++++++++++++++---------------------------------
>  drivers/ide/ide-park.c  |   13 +-
>  drivers/ide/ide-probe.c |    3 
>  include/linux/ide.h     |    4 
>  4 files changed, 79 insertions(+), 154 deletions(-)
>
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
[...]
> @@ -780,61 +704,40 @@ repeat:	
>   */
>  void do_ide_request(struct request_queue *q)
>  {
> -	ide_drive_t	*orig_drive = q->queuedata;
> -	ide_hwgroup_t	*hwgroup = orig_drive->hwif->hwgroup;
> -	ide_drive_t	*drive;
> -	ide_hwif_t	*hwif;
> +	ide_drive_t	*drive = q->queuedata;
> +	ide_hwif_t	*hwif = drive->hwif;
> +	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
>  	struct request	*rq;
>  	ide_startstop_t	startstop;
>  
> -	/* caller must own hwgroup->lock */
> -	BUG_ON(!irqs_disabled());
> -
> -	while (!ide_lock_hwgroup(hwgroup)) {
> -		drive = choose_drive(hwgroup);
> -		if (drive == NULL) {
> -			int sleeping = 0;
> -			unsigned long sleep = 0; /* shut up, gcc */
> -			hwgroup->rq = NULL;
> -			drive = hwgroup->drive;
> -			do {
> -				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) &&
> -				    (sleeping == 0 ||
> -				     time_before(drive->sleep, sleep))) {
> -					sleeping = 1;
> -					sleep = drive->sleep;
> -				}
> -			} while ((drive = drive->next) != hwgroup->drive);
> -			if (sleeping) {
> +	/*
> +	 * drive is doing pre-flush, ordered write, post-flush sequence. even
> +	 * though that is 3 requests, it must be seen as a single transaction.
> +	 * we must not preempt this drive until that is complete
> +	 */
> +	if (blk_queue_flushing(q))
>  		/*
> -		 * Take a short snooze, and then wake up this hwgroup again.
> -		 * This gives other hwgroups on the same a chance to
> -		 * play fairly with us, just in case there are big differences
> -		 * in relative throughputs.. don't want to hog the cpu too much.
> +		 * small race where queue could get replugged during
> +		 * the 3-request flush cycle, just yank the plug since
> +		 * we want it to finish asap
>  		 */
> -				if (time_before(sleep, jiffies + WAIT_MIN_SLEEP))
> -					sleep = jiffies + WAIT_MIN_SLEEP;
> -#if 1
> -				if (timer_pending(&hwgroup->timer))
> -					printk(KERN_CRIT "ide_set_handler: timer already active\n");
> -#endif
> -				/* so that ide_timer_expiry knows what to do */
> -				hwgroup->sleeping = 1;
> -				hwgroup->req_gen_timer = hwgroup->req_gen;
> -				mod_timer(&hwgroup->timer, sleep);
> -				/* we purposely leave hwgroup locked
> -				 * while sleeping */
> -			} else
> -				ide_unlock_hwgroup(hwgroup);
> +		blk_remove_plug(q);

I'm not at all convinced that this works as expected. First of all, I
think we can safely assume that the plug is removed when block layer
calls into the ->request_fn(). Secondly, since the ide layer doesn't
call the ->request_fn() on it's own accord, I rather suspect that this
check can be dropped altogether. On the other hand, I'm not sure I agree
with the rest of the patch anyway, see below.

>  
> -			/* no more work for this hwgroup (for now) */
> -			goto plug_device;
> -		}
> +	spin_unlock_irq(q->queue_lock);
> +	spin_lock_irq(&hwgroup->lock);
>  
> -		if (drive != orig_drive)
> -			goto plug_device;
> +	/* caller must own hwgroup->lock */
> +	BUG_ON(!irqs_disabled());

Does this check really make any sense? The lock is being taken just two
lines before, after all.

>  
> -		hwif = drive->hwif;
> +	if (!ide_lock_hwgroup(hwgroup)) {
> +		hwgroup->rq = NULL;
> +
> +		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
> +			if (time_before(drive->sleep, jiffies)) {
> +				ide_unlock_hwgroup(hwgroup);
> +				goto plug_device;
> +			}
> +		}
>  
>  		if (hwif != hwgroup->hwif) {
>  			/*
> @@ -847,16 +750,20 @@ void do_ide_request(struct request_queue
>  		hwgroup->hwif = hwif;
>  		hwgroup->drive = drive;
>  		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
> -		drive->service_start = jiffies;
>  
> +		spin_unlock_irq(&hwgroup->lock);
> +		spin_lock_irq(q->queue_lock);
>  		/*
>  		 * we know that the queue isn't empty, but this can happen
>  		 * if the q->prep_rq_fn() decides to kill a request
>  		 */
>  		rq = elv_next_request(drive->queue);
> +		spin_unlock_irq(q->queue_lock);
> +		spin_lock_irq(&hwgroup->lock);
> +
>  		if (!rq) {
>  			ide_unlock_hwgroup(hwgroup);
> -			break;
> +			goto out;
>  		}
>  
>  		/*
> @@ -888,15 +795,22 @@ void do_ide_request(struct request_queue
>  
>  		if (startstop == ide_stopped) {
>  			ide_unlock_hwgroup(hwgroup);
> -			if (!elv_queue_empty(orig_drive->queue))
> -				blk_plug_device(orig_drive->queue);
> +			/* give other devices a chance */
> +			goto plug_device;

This, I think, is very wrong. The rule of thumb for a ->requst_fn()
should be to take as many requests off the queue as possible. Besides,
this may easily preempt an ordered sequence as mentioned earlier. In my
opinion, we really need a loop of sorts (while or goto).

>  		}
> -	}
> +	} else
> +		goto plug_device;
> +out:
> +	spin_unlock_irq(&hwgroup->lock);
> +	spin_lock_irq(q->queue_lock);
>  	return;
>  
>  plug_device:
> -	if (!elv_queue_empty(orig_drive->queue))
> -		blk_plug_device(orig_drive->queue);
> +	spin_unlock_irq(&hwgroup->lock);
> +	spin_lock_irq(q->queue_lock);
> +
> +	if (!elv_queue_empty(q))
> +		blk_plug_device(q);
>  }
>  
>  /*
[...]
> @@ -974,10 +899,12 @@ out:
>  void ide_timer_expiry (unsigned long data)
>  {
>  	ide_hwgroup_t	*hwgroup = (ide_hwgroup_t *) data;
> +	ide_drive_t	*uninitialized_var(drive);
>  	ide_handler_t	*handler;
>  	ide_expiry_t	*expiry;
>  	unsigned long	flags;
>  	unsigned long	wait = -1;
> +	int		plug_device = 0;
>  
>  	spin_lock_irqsave(&hwgroup->lock, flags);
>  
> @@ -989,12 +916,8 @@ void ide_timer_expiry (unsigned long dat
>  		 * or we were "sleeping" to give other devices a chance.
>  		 * Either way, we don't really want to complain about anything.
>  		 */

Not that important, I suppose, but you might want to update that comment
while you're at it.

> -		if (hwgroup->sleeping) {
> -			hwgroup->sleeping = 0;
> -			ide_unlock_hwgroup(hwgroup);
> -		}
>  	} else {
> -		ide_drive_t *drive = hwgroup->drive;
> +		drive = hwgroup->drive;
>  		if (!drive) {
>  			printk(KERN_ERR "ide_timer_expiry: hwgroup->drive was NULL\n");
>  			hwgroup->handler = NULL;

Finally, some more general blathering on the topic at hand: A while ago,
I spent some thought on the possibilities of giving the block layer a
notion of linked device queues as an equivalent hwgroups in ide,
scsi_hosts or ata_ports and let it take care of time / bandwidth
distribution among the queues belonging to one group. This is, as I
understand, pretty much what your code is relying on since you have
chucked out choose_drive(). However, this turned out not to be too easy
and I'm not quite sure whether we really want to go down that road. One
major problem is that there is no straight forward way for the block
layer to know, whether a ->request_fn() has actually taken a request off
the queue and if not (or less than queue_depth anyway), whether it's
just the device that couldn't take any more or the controller instead.
On the whole, it seems not exactly trivial to get it right and it would
probably be a good idea to consult Jens and perhaps James before
embarking on such a venture. Short of that, I think that ide layer has
to keep an appropriate equivalent of choose_drive() and also the while
loop in the do_ide_request() function.

Regards,

Elias
