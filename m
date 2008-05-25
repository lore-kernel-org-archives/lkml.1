Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYEYMXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYEYMXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760209AbYEYMXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:23:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42586 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbYEYMXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:23:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: petkovbb@gmail.com
Subject: Re: linux-next: Tree for May 22
Date: Sun, 25 May 2008 14:23:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080522165209.ef2cb160.sfr@canb.auug.org.au> <200805252355.47860.bzolnier@gmail.com> <20080525080321.GA3582@gollum.tnic>
In-Reply-To: <20080525080321.GA3582@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251423.31760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of May 2008, Borislav Petkov wrote:
> On Sun, May 25, 2008 at 11:55:47PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Friday 23 May 2008, Rafael J. Wysocki wrote:
> > > On Thursday, 22 of May 2008, Stephen Rothwell wrote:
> > > > Hi all,
> > > > 
> > > > Changes since next-20080522:
> > > > 
> > > > The three patches reverted from the driver-core tree yesterday have been
> > > > removed from there.
> > > > 
> > > > The net tree (actually the wireless tree) had a trivial conflict with the
> > > > wireless-current tree.
> > > > 
> > > > One of the sound tree build patches has been merged.
> > > > 
> > > > The semaphore-removal tree still needed three patches reverted because similar
> > > > patches were merged into upstream and the scsi-rc-fixes trees.
> > > > 
> > > > The bkl-removal tree had a conflict with the arm tree because the arm
> > > > tree removed a file that was changed.
> > > > 
> > > > I have applied the following temporary patch for known build problems:
> > > > 
> > > > 	"Fix various 8390 builds" - the net tree broke builds on various
> > > > architectures - hopefully this patch will go into the net tree shortly.
> > > > 	"build failure with netfilter on __nf_ct_helper_find()" - breakage
> > > > due to the moving of stuff from list.h to rculist.h
> > > 
> > > This one and the previous linux-next can't resume from suspend to RAM on my
> > > HP nx6325.  The problem is reliably reproducible 100% of the time.
> > > 
> > > The patch that causes it to happen, as identified by bisection, is:
> > > 
> > > commit 3dcefa9419f3b8a49921d2218c93a3ddba8e0855
> > > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Date:   Thu May 22 10:40:19 2008 +1000
> > > 
> > >     ide: use __generic_unplug_device() in ide_do_drive_cmd()
> > > 
> > >     Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > >     Cc: Borislav Petkov <petkovbb@gmail.com>
> > >     Cc: Jens Axboe <jens.axboe@oracle.com>
> > >     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > Thanks for narrowing it down.
> > 
> > > Reverting it along with the next IDE patches (up to and including
> > > commit fd42e6df0fd163411f5c655b4bde4fb6a8910edc
> > > "ide: remove action argument in ide_do_drive_cmd") makes the problem go away.
> > 
> > Please check if the patch below (against IDE tree but should also apply
> > to the current linux-next) fixes the issue (for blk_pm_resume_request()
> > the queue is stopped so we need to call ->request_fn explicitly).
> > 
> > ---
> >  block/blk-exec.c     |    3 +++
> >  drivers/ide/ide-io.c |    3 +++
> >  2 files changed, 6 insertions(+)
> > 
> > Index: b/block/blk-exec.c
> > ===================================================================
> > --- a/block/blk-exec.c
> > +++ b/block/blk-exec.c
> > @@ -57,6 +57,9 @@ void blk_execute_rq_nowait(struct reques
> >  	spin_lock_irq(q->queue_lock);
> >  	__elv_add_request(q, rq, where, 1);
> >  	__generic_unplug_device(q);
> > +	/* the queue is stopped so it won't be plugged+unplugged */
> > +	if (blk_pm_resume_request(rq))
> > +		q->request_fn(q);
> >  	spin_unlock_irq(q->queue_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
> > Index: b/drivers/ide/ide-io.c
> > ===================================================================
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -1540,6 +1540,9 @@ void ide_do_drive_cmd(ide_drive_t *drive
> >  	hwgroup->rq = NULL;
> >  	__elv_add_request(drive->queue, rq, ELEVATOR_INSERT_FRONT, 1);
> >  	__generic_unplug_device(drive->queue);
> > +	/* the queue is stopped so it won't be plugged+unplugged */
> > +	if (blk_pm_resume_request(rq))
> > +		do_ide_request(drive->queue);
> >  	spin_unlock_irqrestore(&ide_lock, flags);
> >  }
> 
> I could reproduce the bug on my Asus M6B00N and can confirm that the patch fixes
> it.

I can confirm that the patch helps.  Thanks Bart!

Rafael
