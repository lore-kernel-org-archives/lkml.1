Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYIOXWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYIOXWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 19:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYIOXW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 19:22:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:31158 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYIOXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 19:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=YzRB12VtWxegx/qQIlxLG11sp49Zw3y6ZtPhP9rGs6WFKe35jX///s96U7ag1fvZgU
         h0HyA18iQdw6lkicwuqi7uVwuzYz4Ms7nVmfxnc9C0KVfZ5yylwaCkp/jjgOkg0J4IfL
         fAtKCfzyxKEcl9/JMKq4ergEQam4ppZ+Jg+W4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH 3/4] ide: Implement disk shock protection support
Date: Mon, 15 Sep 2008 16:22:04 -0700
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <87wshzplvk.fsf@denkblock.local> <87vdx1y9gv.fsf@denkblock.local> <87k5ddxltd.fsf@denkblock.local>
In-Reply-To: <87k5ddxltd.fsf@denkblock.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809151622.04724.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2008 12:15:26 Elias Oltmanns wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
> > From: Elias Oltmanns <eo@nebensachen.de>
> > Subject: [PATCH] ide: Implement disk shock protection support
> >
> > On user request (through sysfs), the IDLE IMMEDIATE command with UNLOAD
> > FEATURE as specified in ATA-7 is issued to the device and processing of
> > the request queue is stopped thereafter until the specified timeout
> > expires or user space asks to resume normal operation. This is supposed
> > to prevent the heads of a hard drive from accidentally crashing onto the
> > platter when a heavy shock is anticipated (like a falling laptop expected
> > to hit the floor). Port resets are deferred whenever a device on that
> > port is in the parked state.
> >
> > Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> [...]
> > diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
> > new file mode 100644
> > index 0000000..8cd43f6
> > --- /dev/null
> > +++ b/drivers/ide/ide-park.c
> > @@ -0,0 +1,119 @@
> > +#include <linux/kernel.h>
> > +#include <linux/ide.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/blkdev.h>
> > +
> > +DECLARE_WAIT_QUEUE_HEAD(ide_park_wq);
> > +
> > +static int issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
> > +{
> > +	struct request_queue *q = drive->queue;
> > +	struct request *rq;
> > +	int rc;
> > +
> > +	timeout += jiffies;
> > +	spin_lock_irq(&ide_lock);
> > +	if (drive->dev_flags & IDE_DFLAG_PARKED) {
> > +		ide_hwgroup_t *hwgroup = drive->hwif->hwgroup;
> > +		int reset_timer;
> > +
> > +		reset_timer = time_before(timeout, drive->sleep);
> > +		drive->sleep = timeout;
> > +		if (reset_timer) {
> > +			wake_up_all(&ide_park_wq);
> > +			if (hwgroup->sleeping && del_timer(&hwgroup->timer)) {
> > +				hwgroup->sleeping = 0;
> > +				hwgroup->busy = 0;
> > +				__blk_run_queue(q);
> > +			}
> > +		}
> > +		spin_unlock_irq(&ide_lock);
> > +		return 0;
> > +	}
> 
> This wake_up_all() has to go outside the if clause. I'll change this the
> next time round to be called right after drive->sleep has been set. The
> two nested if clauses will be unified and the conditions &&'ed.

OK.

I've just audited your latest patch and it all seems good (the assumptions
taken are valid and all concerns were addressed) so you may add my ACK to
the next-time-round patch.  Big thanks for patiently improving this patch,
the final version looks so much better than the initial/draft one. :)

Thanks,
Bart
