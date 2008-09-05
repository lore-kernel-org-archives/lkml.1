Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbYIERhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbYIERhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYIERgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:36:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:60444 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYIERgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=xuCdKKm+Ezixayzvlp5o5sVnGoagpdEVygsNfn25qdy2qZ1OwyYllfI3JQgzsmuPSA
         zwoPmNxdwzLlVFclkNFlrgrAA6wuZjjNbNxEL9n4zEBHk5pKuxwJWPX2peg/dyUNX16p
         0dX0THaIW03mKTAwaTO6GH4HpY15x5LuEXTb4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 3/4] ide: Implement disk shock protection support
Date: Fri, 5 Sep 2008 19:33:37 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87wshzplvk.fsf@denkblock.local> <200809012129.14979.bzolnier@gmail.com> <87ljy90zin.fsf@denkblock.local>
In-Reply-To: <87ljy90zin.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051933.38888.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 03 September 2008, Elias Oltmanns wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > On Friday 29 August 2008, Elias Oltmanns wrote:
> >> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> >
> >> FEATURE as specified in ATA-7 is issued to the device and processing of
> >> the request queue is stopped thereafter until the speified timeout
> >> expires or user space asks to resume normal operation. This is supposed
> >> to prevent the heads of a hard drive from accidentally crashing onto the
> >> platter when a heavy shock is anticipated (like a falling laptop
> >> expected to hit the floor). In fact, the whole port stops processing
> >> commands until the timeout has expired in order to avoid resets due to
> >> failed commands on another device.
> >> 
> >> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> >
> > [ continuing the discussion from 'patch #2' thread ]
> >
> > While I'm still not fully convinced this is the best way to go in
> > the long-term I'm well aware that if we won't get in 2.6.28 it will
> > mean at least 3 more months until it hits users so lets concentrate
> > on existing user/kernel-space solution first...
> >
> > There are some issues to address before it can go in but once they
> > are fixed I'm fine with the patch and I'll merge it as soon as patches
> > #1-2 are in.
> 
> Thank you very much Bart, I really do appreciate that. Some more
> questions though:

Thanks for rework, the code looks a lot simpler now.

> > [...]
> >
> >> @@ -842,6 +842,9 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
> >>  
> >>  			if (hwif->dma_ops)
> >>  				ide_set_dma(drive);
> >> +
> >> +			if (!ata_id_has_unload(drive->id))
> >> +				drive->dev_flags |= IDE_DFLAG_NO_UNLOAD;
> >
> > ide_port_tune_devices() is not a best suited place for it,
> > please move it to ide_port_init_devices().
> 
> ... We need to have IDENTIFY data present in drive->id at that point
> which is not the case before ide_probe_port() has been executed. Should
> I perhaps move it to ide_port_setup_devices() instead?

I think that do_identify() is the best place for it at the moment.

> [...]
> >> +	spin_lock_irq(&ide_lock);
> >> +	if (unlikely(!hwif->present || timer_pending(&hwif->park_timer)))
> >> +		goto done;
> >> +
> >> +	drive = hwif->hwgroup->drive;
> >> +	while (drive->hwif != hwif)
> >> +		drive = drive->next;
> >
> > How's about just looping on hwif->drives[] instead?
> >
> > [ this would also allow removal of loops in issue_park_cmd()
> >   and simplify locking there ]
> 
> Yes, I've reorganised it all a bit in order to account for all the
> issues addressed in the discussion. In particular, I loop over
> hwif->drives now as you suggested.
> 
> [...]
> >> +static ssize_t park_store(struct device *dev, struct device_attribute *attr,
> >> +			  const char *buf, size_t len)
> >> +{
> >> +#define MAX_PARK_TIMEOUT 30
> >> +	ide_drive_t *drive = to_ide_device(dev);
> >> +	ide_hwif_t *hwif = drive->hwif;
> >> +	DECLARE_COMPLETION_ONSTACK(wait);
> >> +	unsigned long timeout;
> >> +	int rc, count = 0;
> >> +
> >> +	rc = strict_strtoul(buf, 10, &timeout);
> >> +	if (rc || timeout > MAX_PARK_TIMEOUT)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&ide_setting_mtx);
> >
> > No need to hold ide_settings_mtx here.
> 
> Even though the next version of the patch is different in various ways,
> we have a similar problem. As far as I can see, we need to hold the
> ide_setting_mtx here because the spin_lock will be taken and released
> several times subsequently and therefore cannot protect hwif->park_timer
> (or hwif->park_timeout in the new patch) against concurrent writes to
> this sysfs attribute.

OK.

> >
> >> +	spin_lock_irq(&ide_lock);
> >> +	if (unlikely(!(drive->dev_flags & IDE_DFLAG_PRESENT))) {
> >> +		rc = -ENODEV;
> >> +		goto unlock;
> >> +	}
> 
> [...]
> 
> > Also could you please move the new code to a separate file (i.e.
> > ide-park.c) instead of stuffing it all in ide.c?
> 
> This is probably a sensible idea especially since there may be more once
> we go ahead with the in-kernel solution. This means, however, that some
> more random stuff is going into include/linux/ide.h. If it wasn't so
> huge and if I had an idea what was to be taken into account so as not to
> break user space applications, I'd offer to try my hand at moving things
> to a private header file drivers/ide/ide.h. But as it is, I'm rather
> scared.

<linux/ide.h> it is not exported to user-space at all so introducing
drivers/ide/ide.h shouldn't be a problem.

> >
> > Otherwise it looks OK (modulo PM notifiers concerns raised by Tejun
> > but the code is identical to libata's version so it is sufficient to
> > duplicate the potential fixes here).
> 
> On popular request, they're gone now. With the new patches I can't
> reproduce the system freezes anymore.
> 
> The patch below applies to next-20080903. I'll resend the whole series
> once this (and the libata one) has been reviewed and potential glitches
> have been ironed out.
> 
> Regards,
> 
> Elias
> 
> ---
> 
>  drivers/ide/Makefile       |    2 -
>  drivers/ide/ide-io.c       |   27 +++++++++
>  drivers/ide/ide-park.c     |  133 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/ide/ide-probe.c    |    3 +
>  drivers/ide/ide-taskfile.c |   10 +++
>  drivers/ide/ide.c          |    1 
>  include/linux/ide.h        |   16 +++++
>  7 files changed, 190 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/ide/ide-park.c
> 
> diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
> index e6e7811..16795fe 100644
> --- a/drivers/ide/Makefile
> +++ b/drivers/ide/Makefile
> @@ -5,7 +5,7 @@
>  EXTRA_CFLAGS				+= -Idrivers/ide
>  
>  ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
> -	      ide-taskfile.o ide-pio-blacklist.o
> +	      ide-taskfile.o ide-park.o ide-pio-blacklist.o
>  
>  # core IDE code
>  ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index e205f46..c9f6325 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -672,7 +672,30 @@ EXPORT_SYMBOL_GPL(ide_devset_execute);
>  
>  static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
>  {
> +	ide_hwif_t *hwif = drive->hwif;
> +	ide_task_t task;
> +	struct ide_taskfile *tf = &task.tf;
> +
> +	memset(&task, 0, sizeof(task));
>  	switch (rq->cmd[0]) {
> +	case REQ_PARK_HEADS:
> +		drive->sleep = drive->hwif->park_timeout;
> +		drive->dev_flags |= IDE_DFLAG_SLEEPING;
> +		complete((struct completion *)rq->end_io_data);
> +		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD) {
> +			ide_end_request(drive, 1, 0);
> +			return ide_stopped;
> +		}
> +		tf->command = ATA_CMD_IDLEIMMEDIATE;
> +		tf->feature = 0x44;
> +		tf->lbal = 0x4c;
> +		tf->lbam = 0x4e;
> +		tf->lbah = 0x55;
> +		task.tf_flags |= IDE_TFLAG_CUSTOM_HANDLER;
> +		break;
> +	case REQ_UNPARK_HEADS:
> +		tf->command = ATA_CMD_CHK_POWER;
> +		break;
>  	case REQ_DEVSET_EXEC:
>  	{
>  		int err, (*setfunc)(ide_drive_t *, int) = rq->special;
> @@ -692,6 +715,10 @@ static ide_startstop_t ide_special_rq(ide_drive_t *drive, struct request *rq)
>  		ide_end_request(drive, 0, 0);
>  		return ide_stopped;
>  	}
> +	task.tf_flags |= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
> +	task.rq = rq;
> +	hwif->data_phase = task.data_phase = TASKFILE_NO_DATA;
> +	return do_rw_taskfile(drive, &task);
>  }
>  
>  static void ide_check_pm_state(ide_drive_t *drive, struct request *rq)
> diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
> new file mode 100644
> index 0000000..fd04cb7
> --- /dev/null
> +++ b/drivers/ide/ide-park.c
> @@ -0,0 +1,133 @@
> +#include <linux/kernel.h>
> +#include <linux/ide.h>
> +#include <linux/jiffies.h>
> +#include <linux/blkdev.h>
> +#include <linux/completion.h>
> +
> +static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
> +{
> +	ide_hwif_t *hwif = drive->hwif;
> +	int i, restart;
> +
> +	if (!timeout && time_before(hwif->park_timeout, jiffies))
> +		return;

Maybe this check could be moved to the caller?

> +	timeout += jiffies;
> +	restart = time_before(timeout, hwif->park_timeout);
> +	hwif->park_timeout = timeout;
> +
> +	for (i = 0; i < MAX_DRIVES; i++) {

and the code under for-loop factored out to a separate helper?

> +		ide_drive_t *drive = &hwif->drives[i];
> +		struct request_queue *q;
> +		struct request *rq;
> +		DECLARE_COMPLETION_ONSTACK(wait);
> +
> +		spin_lock_irq(&ide_lock);
> +		if (!(drive->dev_flags & IDE_DFLAG_PRESENT) ||
> +		    ide_device_get(drive)) {
> +			spin_unlock_irq(&ide_lock);
> +			continue;
> +		}

No need to ide_lock for IDE_DLAG_PRESENT check or ide_device_get().

> +		if (drive->dev_flags & IDE_DFLAG_SLEEPING) {
> +			drive->sleep = timeout;
> +			spin_unlock_irq(&ide_lock);
> +			goto next_step;
> +		}
> +		spin_unlock_irq(&ide_lock);
> +
> +		q = drive->queue;
> +		rq = blk_get_request(q, READ, __GFP_WAIT);
> +		rq->cmd[0] = REQ_PARK_HEADS;
> +		rq->cmd_len = 1;
> +		rq->cmd_type = REQ_TYPE_SPECIAL;
> +		rq->end_io_data = &wait;
> +		blk_execute_rq_nowait(q, NULL, rq, 1, NULL);

Shouldn't this be skipped if 'restart' is true?

> +		/*
> +		 * This really is only to make sure that the request
> +		 * has been started yet, not necessarily completed
> +		 * though.
> +		 */
> +		wait_for_completion(&wait);
> +		if (q->rq.count[READ] + q->rq.count[WRITE] <= 1 &&

What it is the point of 'q->rq.count[READ] + q->rq.count[WRITE] <= 1'
check?

> +		    !(drive->dev_flags & IDE_DFLAG_NO_UNLOAD)) {
> +			rq = blk_get_request(q, READ, GFP_NOWAIT);
> +
> +			if (unlikely(!rq))
> +				goto next_step;
> +
> +			rq->cmd[0] = REQ_UNPARK_HEADS;
> +			rq->cmd_len = 1;
> +			rq->cmd_type = REQ_TYPE_SPECIAL;
> +			elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 0);
> +		}
> +
> +next_step:
> +		ide_device_put(drive);
> +	}
> +
> +	if (restart) {
> +		ide_hwgroup_t *hwgroup = hwif->hwgroup;
> +
> +		spin_lock_irq(&ide_lock);
> +		if (hwgroup->sleeping && del_timer(&hwgroup->timer)) {
> +			hwgroup->sleeping = 0;
> +			hwgroup->busy = 0;
> +			__blk_run_queue(drive->queue);

What about the other device?

> +		}
> +		spin_unlock_irq(&ide_lock);
> +	}
> +}
> +
> +ide_devset_w_flag(no_unload, IDE_DFLAG_NO_UNLOAD);
> +
> +ssize_t ide_park_show(struct device *dev, struct device_attribute *attr,
> +		      char *buf)
> +{
> +	ide_drive_t *drive = to_ide_device(dev);
> +	ide_hwif_t *hwif = drive->hwif;
> +	unsigned int seconds;
> +
> +	mutex_lock(&ide_setting_mtx);
> +	if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
> +	    time_after(hwif->park_timeout, jiffies))
> +		/*
> +		 * Adding 1 in order to guarantee nonzero value until timer
> +		 * has actually expired.
> +		 */
> +		seconds = jiffies_to_msecs(hwif->park_timeout - jiffies)
> +			  / 1000 + 1;
> +	else
> +		seconds = 0;
> +	mutex_unlock(&ide_setting_mtx);
> +
> +	return snprintf(buf, 20, "%u\n", seconds);
> +}
> +
> +ssize_t ide_park_store(struct device *dev, struct device_attribute *attr,
> +		       const char *buf, size_t len)
> +{
> +#define MAX_PARK_TIMEOUT 30
> +	ide_drive_t *drive = to_ide_device(dev);
> +	long int input;
> +	int rc;
> +
> +	rc = strict_strtol(buf, 10, &input);
> +	if (rc || input < -2 || input > MAX_PARK_TIMEOUT)
> +		return -EINVAL;
> +
> +	mutex_lock(&ide_setting_mtx);
> +	if (input >= 0) {
> +		if (drive->dev_flags & IDE_DFLAG_NO_UNLOAD) {
> +			mutex_unlock(&ide_setting_mtx);
> +			return -EOPNOTSUPP;
> +		}
> +
> +		issue_park_cmd(drive, msecs_to_jiffies(input * 1000));
> +	} else
> +		/* input can either be -1 or -2 at this point */

Since Tejun already raised concerns about multiplexing per-device
and per-port settings I'm not repeating them here.  Please just
remember to backport fixes from libata version to ide one.

> +		rc = ide_devset_execute(drive, &ide_devset_no_unload,
> +					input + 1);

No need to use ide_devset_execute() - ide_setting_mtx already provides
the needed protection.

Thanks,
Bart
