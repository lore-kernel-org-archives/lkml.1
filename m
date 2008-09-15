Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYIOTQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYIOTQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYIOTP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:15:57 -0400
Received: from nebensachen.de ([195.34.83.29]:37316 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYIOTP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:15:56 -0400
X-Hashcash: 1:20:080915:bzolnier@gmail.com::ovJYRH+0K3FQQpHX:00000000000000000000000000000000000000000001FzD
X-Hashcash: 1:20:080915:alan@lxorguk.ukuu.org.uk::+rDownY8KC6f93TB:000000000000000000000000000000000000048IQ
X-Hashcash: 1:20:080915:akpm@linux-foundation.org::oS84uJ1auWwl9pEC:00000000000000000000000000000000000021gE
X-Hashcash: 1:20:080915:jeff@garzik.org::YD63rwGMgFeNx+89:005p90
X-Hashcash: 1:20:080915:randy.dunlap@oracle.com::W2SjYJttY5Fv+tAI:000000000000000000000000000000000000009c2e
X-Hashcash: 1:20:080915:htejun@gmail.com::or0ap399fmSVpPLl:072OI
X-Hashcash: 1:20:080915:linux-ide@vger.kernel.org::ArOhsGgCfw2dHqkb:0000000000000000000000000000000000000sNa
X-Hashcash: 1:20:080915:linux-kernel@vger.kernel.org::5hh1gUWfjEchOjf+:0000000000000000000000000000000006jfg
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<200809012129.14979.bzolnier@gmail.com>
	<87ljy90zin.fsf@denkblock.local>
	<200809051933.38888.bzolnier@gmail.com>
	<87vdx1y9gv.fsf@denkblock.local>
Date: Mon, 15 Sep 2008 21:15:26 +0200
In-Reply-To: <87vdx1y9gv.fsf@denkblock.local> (Elias Oltmanns's message of
	"Fri, 12 Sep 2008 11:55:28 +0200")
Message-ID: <87k5ddxltd.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> From: Elias Oltmanns <eo@nebensachen.de>
> Subject: [PATCH] ide: Implement disk shock protection support
>
> On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> FEATURE as specified in ATA-7 is issued to the device and processing of
> the request queue is stopped thereafter until the specified timeout
> expires or user space asks to resume normal operation. This is supposed
> to prevent the heads of a hard drive from accidentally crashing onto the
> platter when a heavy shock is anticipated (like a falling laptop expected
> to hit the floor). Port resets are deferred whenever a device on that
> port is in the parked state.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
[...]
> diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
> new file mode 100644
> index 0000000..8cd43f6
> --- /dev/null
> +++ b/drivers/ide/ide-park.c
> @@ -0,0 +1,119 @@
> +#include <linux/kernel.h>
> +#include <linux/ide.h>
> +#include <linux/jiffies.h>
> +#include <linux/blkdev.h>
> +
> +DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
> +
> +static int issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
> +{
> +	struct request_queue *q = drive->queue;
> +	struct request *rq;
> +	int rc;
> +
> +	timeout += jiffies;
> +	spin_lock_irq(&ide_lock);
> +	if (drive->dev_flags & IDE_DFLAG_PARKED) {
> +		ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
> +		int reset_timer;
> +
> +		reset_timer = time_before(timeout, drive->sleep);
> +		drive->sleep = timeout;
> +		if (reset_timer) {
> +			wake_up_all(&ide_park_wq);
> +			if (hwgroup->sleeping && del_timer(&hwgroup->timer)) {
> +				hwgroup->sleeping = 0;
> +				hwgroup->busy = 0;
> +				__blk_run_queue(q);
> +			}
> +		}
> +		spin_unlock_irq(&ide_lock);
> +		return 0;
> +	}

This wake_up_all() has to go outside the if clause. I'll change this the
next time round to be called right after drive->sleep has been set. The
two nested if clauses will be unified and the conditions &&'ed.

Regards,

Elias
