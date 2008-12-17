Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754967AbYLQPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYLQPy1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLQPyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:54:16 -0500
Received: from nebensachen.de ([195.34.83.29]:38884 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYLQPyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:54:14 -0500
X-Hashcash: 1:20:081217:bzolnier@gmail.com::+f/uYTEpnTgB82tL:00000000000000000000000000000000000000000000lUK
X-Hashcash: 1:20:081217:linux-ide@vger.kernel.org::KFYd6+yw624vYaqF:0000000000000000000000000000000000003sVC
X-Hashcash: 1:20:081217:linux-kernel@vger.kernel.org::13Ulutk9Zu5+dfkO:0000000000000000000000000000000001Cxz
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide: use per-device request queue locks
References: <200811182119.21286.bzolnier@gmail.com>
	<87vdudjgfm.fsf@denkblock.local>
	<200812140015.23853.bzolnier@gmail.com>
Date: Wed, 17 Dec 2008 16:53:56 +0100
Message-ID: <87skom6bmz.fsf@denkblock.local>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> [ Once again, sorry for the long delay. ]

Never mind, my responses are rather sluggish these days too.

>
> On Monday 24 November 2008, Elias Oltmanns wrote:
>> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
[...]
>> >  drivers/ide/ide-io.c    | 213 +++++++++++++++---------------------------------
>> >  drivers/ide/ide-park.c  |   13 +-
>> >  drivers/ide/ide-probe.c |    3 
>> >  include/linux/ide.h     |    4 
>> >  4 files changed, 79 insertions(+), 154 deletions(-)
>> >
>> > Index: b/drivers/ide/ide-io.c
>> > ===================================================================
>> > --- a/drivers/ide/ide-io.c
>> > +++ b/drivers/ide/ide-io.c
>> [...]
>> > @@ -780,61 +704,40 @@ repeat:	
>> >   */
>> >  void do_ide_request(struct request_queue *q)
>> >  {
>> > -	ide_drive_t	*orig_drive = q->queuedata;
>> > -	ide_hwgroup_t	*hwgroup = orig_drive->hwif->hwgroup;
>> > -	ide_drive_t	*drive;
>> > -	ide_hwif_t	*hwif;
>> > +	ide_drive_t	*drive = q->queuedata;
>> > +	ide_hwif_t	*hwif = drive->hwif;
>> > +	ide_hwgroup_t	*hwgroup = hwif->hwgroup;
>> >  	struct request	*rq;
>> >  	ide_startstop_t	startstop;
>> >  
>> > -	/* caller must own hwgroup->lock */
>> > -	BUG_ON(!irqs_disabled());
>> > -
>> > -	while (!ide_lock_hwgroup(hwgroup)) {
>> > -		drive = choose_drive(hwgroup);
>> > -		if (drive == NULL) {
>> > -			int sleeping = 0;
>> > -			unsigned long sleep = 0; /* shut up, gcc */
>> > -			hwgroup->rq = NULL;
>> > -			drive = hwgroup->drive;
>> > -			do {
>> > -				if ((drive->dev_flags & IDE_DFLAG_SLEEPING) &&
>> > -				    (sleeping == 0 ||
>> > -				     time_before(drive->sleep, sleep))) {
>> > -					sleeping = 1;
>> > -					sleep = drive->sleep;
>> > -				}
>> > -			} while ((drive = drive->next) != hwgroup->drive);
>> > -			if (sleeping) {
>> > +	/*
>> > +	 * drive is doing pre-flush, ordered write, post-flush sequence. even
>> > +	 * though that is 3 requests, it must be seen as a single transaction.
>> > +	 * we must not preempt this drive until that is complete
>> > +	 */
>> > +	if (blk_queue_flushing(q))
>> >  		/*
>> > -		 * Take a short snooze, and then wake up this hwgroup again.
>> > -		 * This gives other hwgroups on the same a chance to
>> > -		 * play fairly with us, just in case there are big differences
>> > -		 * in relative throughputs.. don't want to hog the cpu too much.
>> > +		 * small race where queue could get replugged during
>> > +		 * the 3-request flush cycle, just yank the plug since
>> > +		 * we want it to finish asap
>> >  		 */
>> > -				if (time_before(sleep, jiffies + WAIT_MIN_SLEEP))
>> > -					sleep = jiffies + WAIT_MIN_SLEEP;
>> > -#if 1
>> > -				if (timer_pending(&hwgroup->timer))
>> > -					printk(KERN_CRIT "ide_set_handler: timer already active\n");
>> > -#endif
>> > -				/* so that ide_timer_expiry knows what to do */
>> > -				hwgroup->sleeping = 1;
>> > -				hwgroup->req_gen_timer = hwgroup->req_gen;
>> > -				mod_timer(&hwgroup->timer, sleep);
>> > -				/* we purposely leave hwgroup locked
>> > -				 * while sleeping */
>> > -			} else
>> > -				ide_unlock_hwgroup(hwgroup);
>> > +		blk_remove_plug(q);
>> 
>> I'm not at all convinced that this works as expected. First of all, I
>> think we can safely assume that the plug is removed when block layer
>> calls into the ->request_fn(). Secondly, since the ide layer doesn't
>> call the ->request_fn() on it's own accord, I rather suspect that this
>> check can be dropped altogether. On the other hand, I'm not sure I agree
>
> I suspect that this is leftover from the old code and I also think that
> it can be removed completely.  However mixing too many real code changes
> in a single patch is not a good practice and the removal can be handled
> independently of the discussed patch.
>
> If you would send me a patch with the above change I will be happy to
> integrate it into pata tree (patch can be against current Linus' tree or
> linux-next, either one is completely fine with me).

I'll have a go at it later.

[...]
>> Finally, some more general blathering on the topic at hand: A while ago,
>> I spent some thought on the possibilities of giving the block layer a
>> notion of linked device queues as an equivalent hwgroups in ide,
>> scsi_hosts or ata_ports and let it take care of time / bandwidth
>> distribution among the queues belonging to one group. This is, as I
>> understand, pretty much what your code is relying on since you have
>> chucked out choose_drive(). However, this turned out not to be too easy
>
> This is the right way to go and I has always advocated for it.  However
> after seeing how libata got away with ignoring the issue altogether
> I'm no longer sure of this.  I haven't seen any bug reports which would
> indicate that simplified approach has any really negative consequences.

Well, libata can safely ignore it since scsi takes care of that (see
scsi_run_queue() which is called on command completion).

>
> [ Still would be great to have the control over bandwitch of "queue-group"
>   at the block layer level since we could also use it for distributing the
>   available PCI[-E] bus bandwitch. ]
>
>> and I'm not quite sure whether we really want to go down that road. One
>> major problem is that there is no straight forward way for the block
>> layer to know, whether a ->request_fn() has actually taken a request off
>> the queue and if not (or less than queue_depth anyway), whether it's
>> just the device that couldn't take any more or the controller instead.
>> On the whole, it seems not exactly trivial to get it right and it would
>> probably be a good idea to consult Jens and perhaps James before
>
> I think that having more information returned by ->request_fn() could be
> beneficial to the block layer (independently whether we end up adding
> support for "queue-groups" to the block layer or not) but this definitely
> needs to be verified with Jens & James.

Some time back, I raised this with Jens in connection with your previous
version of the patchset [1]. I didn't get an answer at the time but
perhaps it would help to raise it again in its own right and to give
some more examples of its potential merits.

>
>> embarking on such a venture. Short of that, I think that ide layer has
>> to keep an appropriate equivalent of choose_drive() and also the while
>> loop in the do_ide_request() function.
>
> Thank you for your review.  v1->v2 interdiff below.
>
> v2:
> * Fixes/improvements based on review from Elias:
>  - take as many requests off the queue as possible
>  - remove now redundant BUG_ON()

Looks alright to me.

Regards,

Elias
