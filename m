Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZGCEHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZGCEHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 00:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZGCEHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 00:07:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:44880 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZGCEHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 00:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=TSmyLBbiZ0HziyPLbE0YHo5sA6rd9CwwjgpUs4rEvs1XCJmwNa5f118ee5eXt9mCcb
         JclwlHRYcCwjnjM7bGZybswF6F8+JmkVWiiOZlERyBmKwstvpeyRCG0t4sftSkNarXMz
         AzP4FQ++GAga639RXwJi1sG/Uek6CVk6i/+l0=
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
In-Reply-To: <1246593505.27828.187.camel@falcon>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <200907011829.16850.bzolnier@gmail.com> <1246499203.9660.52.camel@falcon>
	 <200907021813.57322.bzolnier@gmail.com> <1246593505.27828.187.camel@falcon>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 03 Jul 2009 12:06:57 +0800
Message-Id: <1246594017.27828.195.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 11:58 +0800, Wu Zhangjin wrote:
> On Thu, 2009-07-02 at 18:13 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 02 July 2009 03:46:43 Wu Zhangjin wrote:
> > > On Wed, 2009-07-01 at 18:29 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Wednesday 01 July 2009 18:21:25 Bartlomiej Zolnierkiewicz wrote:
> > > > > On Wednesday 01 July 2009 16:47:41 Wu Zhangjin wrote:
> > > > > > On Wed, 2009-07-01 at 22:31 +0800, Jeff Chua wrote:
> > > > > > > On Tue, Jun 30, 2009 at 12:21 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:
> > > > > > > 
> > > > > > > > I just tried, and it "seems" to work. Will try a few more cycles.
> > > > > > > 
> > > > > > > STD/STR survived quite a few cycles now. Patch seems to be doing the
> > > > > > > right thing.
> > > > > > > 
> > > > > > > On Mon, Jun 29, 2009 at 11:51 PM, Etienne
> > > > > > > Basset<etienne.basset@numericable.fr> wrote:
> > > > > > > 
> > > > > > > > To have STR/resume work with current git, I have to :
> > > > > > > 
> > > > > > > > 1) apply Bart's patch
> > > > > > > 
> > > > > > > This is not yet in Linus's tree. And much needed to really fix the problem.
> > > > > > > 
> > > > > > > > 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b
> > > > > > > 
> > > > > > 
> > > > > > Yes, This commit must be reverted, otherwise, STD/Hibernation will not
> > > > > > work either. I have tested it on two different loongson-based machines:
> > > > > > fuloong2e box and yeeloong2f netbook.(loongson is mips compatiable)
> > > > > 
> > > > > Since it seems like Dave is taking his sweet time with doing the revert
> > > > > I stared at the code a bit more and I think that I finally found the bug
> > > > > (thanks to your debugging work for giving me the right hint!).
> > > > > 
> > > > > The patch needs to take into the account a new code introduced by the recent
> > > > > block layer changes (commit 8f6205cd572fece673da0255d74843680f67f879):
> > > > > 
> > > > > @@ -555,8 +560,11 @@ repeat:
> > > > >                 startstop = start_request(drive, rq);
> > > > >                 spin_lock_irq(&hwif->lock);
> > > > >  
> > > > > -               if (startstop == ide_stopped)
> > > > > +               if (startstop == ide_stopped) {
> > > > > +                       rq = hwif->rq;
> > > > > +                       hwif->rq = NULL;
> > > > >                         goto repeat;
> > > > > +               }
> > > > >         } else
> > > > >                 goto plug_device;
> > > > >  out:
> > > > > 
> > > > > and not zero hwif->rq if the device is blocked. 
> > > > > 
> > > > > Could you try the attached patch and see if it fixes the issue?
> > > > 
> > > > Here is the more complete version, also taking into the account changes
> > > > in ide_intr() and ide_timer_expiry():
> > > > 
> > > 
> > > Sorry, I can not apply this patch directly, which original version did
> > > you use? I used the one in the master branch of linux-mips development
> > > git repository.
> > > 
> > > commit 5a4f13fad1ab5bd08dea78fc55321e429d83cddf
> > > Merge: ec9c45d e18ed14
> > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date:   Mon Jun 29 20:07:43 2009 -0700
> > > 
> > >     Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6
> > >     
> > >     * git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-2.6:
> > >       ide: memory overrun in ide_get_identity_ioctl() on big endian
> > > machines using ioctl HDIO_OBSOLETE_IDENTITY
> > >       ide: fix resume for CONFIG_BLK_DEV_IDEACPI=y
> > >       ide-cd: handle fragmented packet commands gracefully
> > >       ide: always kill the whole request on error
> > >       ide: fix ide_kill_rq() for special ide-{floppy,tape} driver
> > > requests
> > > 
> > > it this too old? should i merge another git repository?
> > 
> > Weird, I used linux-next but Linus' tree should also be fine
> > (as it matches linux-next w.r.t. ide currently).
> 
> I just cloned the linux-next git repo, and tested your patch with
> STD/Hibernation, unfortunately, it also not work :-(
> 
> here is the Call Trace:
> 
> blk_delete_timer+0x0/0x20
> blk_requeue_request+0x24/0xd0
> ide_requeue_and_plug+0x38/0xb0
> ide_intr+0x120/0x300             --->  ide_intr....
> handle_IRQ_event+0x94/0x230
> handle_level_irq+0x7c/0x120
> mach_irq_dispatch+0xc8/0x158
> ret_from_irq+0x0/0x4
> cpu_idle+0x30/0x60
> start_kernel+0x330/0x34c
> 
There are two more lines after the Call Trace:

Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt.

> If _NOT_ apply your patch and comment this part, it works:
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index d5f3c77..a45de2b 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -468,12 +468,12 @@ void do_ide_request(struct request_queue *q)
>                 ide_hwif_t *prev_port;
>  repeat:
>                 prev_port = hwif->host->cur_port;
> -
> +/*
>                 if (drive->dev_flags & IDE_DFLAG_BLOCKED)
>                         rq = hwif->rq;
>                 else
>                         WARN_ON_ONCE(hwif->rq);
> -
> +*/
>                 if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
>                     time_after(drive->sleep, jiffies)) {
>                         ide_unlock_port(hwif);
>  
> 
> Regards,
> Wu Zhangjin
> > 
> > Anyway since the patch was confirmed to fix the problem by
> > Jeff and Etienne here is the final version for Dave.
> > 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: make resume work again
> > 
> > It turns out that commit a1317f714af7aed60ddc182d0122477cbe36ee9b
> > ("ide: improve handling of Power Management requests") needs to take
> > into the account a new code added by the recent block layer changes
> > in commit 8f6205cd572fece673da0255d74843680f67f879 ("ide: dequeue
> > in-flight request") and prevent clearing of hwif->rq if the device
> > is blocked.
> > 
> > Thanks to Etienne, Wu and Jeff for help in fixing the issue.
> > 
> > Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
> > Reported-and-tested-by: Etienne Basset <etienne.basset@numericable.fr>
> > Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> > Added patch description, no other changes.
> > 
> >  drivers/ide/ide-io.c |   15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -532,7 +532,8 @@ repeat:
> >  
> >  		if (startstop == ide_stopped) {
> >  			rq = hwif->rq;
> > -			hwif->rq = NULL;
> > +			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0)
> > +				hwif->rq = NULL;
> >  			goto repeat;
> >  		}
> >  	} else
> > @@ -679,8 +680,10 @@ void ide_timer_expiry (unsigned long dat
> >  		spin_lock_irq(&hwif->lock);
> >  		enable_irq(hwif->irq);
> >  		if (startstop == ide_stopped && hwif->polling == 0) {
> > -			rq_in_flight = hwif->rq;
> > -			hwif->rq = NULL;
> > +			if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
> > +				rq_in_flight = hwif->rq;
> > +				hwif->rq = NULL;
> > +			}
> >  			ide_unlock_port(hwif);
> >  			plug_device = 1;
> >  		}
> > @@ -856,8 +859,10 @@ irqreturn_t ide_intr (int irq, void *dev
> >  	 */
> >  	if (startstop == ide_stopped && hwif->polling == 0) {
> >  		BUG_ON(hwif->handler);
> > -		rq_in_flight = hwif->rq;
> > -		hwif->rq = NULL;
> > +		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
> > +			rq_in_flight = hwif->rq;
> > +			hwif->rq = NULL;
> > +		}
> >  		ide_unlock_port(hwif);
> >  		plug_device = 1;
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

