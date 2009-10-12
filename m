Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZJLJUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZJLJUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZJLJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:20:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZJLJUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:20:18 -0400
Date: Mon, 12 Oct 2009 11:19:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-m68k <linux-m68k@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-Reply-To: <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <alpine.LSU.2.00.0910121106330.19284@wotan.suse.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de> <10f740e80910100201n30367714uc57ec3c9c39b92af@mail.gmail.com> <alpine.DEB.2.00.0910110846420.20140@zirkon.biophys.uni-duesseldorf.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ restoring original recepient list, and thus keeping all your text 
  below for reference ]

On Sun, 11 Oct 2009, Michael Schmitz wrote:

> > There is a nice gem in drivers/block/ataflop.c::do_fd_request()
> > 
> > 	void do_fd_request(struct request_queue * q)
> > 	{
> > 		unsigned long flags;
> > 
> > 		DPRINT(("do_fd_request for pid %d\n",current->pid));
> > 		while( fdc_busy ) sleep_on( &fdc_wait );
> > 		fdc_busy = 1;
> > 		stdma_lock(floppy_irq, NULL);
> > 
> > 		atari_disable_irq( IRQ_MFP_FDC );
> > 		local_save_flags(flags);        /* The request function is called with ints
> > 		local_irq_disable();             * disabled... so must save the IPL
> > for later */
> > 		redo_fd_request();
> > 		local_irq_restore(flags);
> > 		atari_enable_irq( IRQ_MFP_FDC );
> > 	}
> > 
> > If you look at the code long enough, you will notioce that the
> > local_irq_disable() call is actually commented out. This has been
> > introduced back in 2002 in [1], but as you can see, the same bug has been
> > there even before, with the sti() call being commented out in the very
> > same way :)
> > 
> > I am not familiar with the code myself at all, but I guess that the whole
> > stuff can just be removed. Why do we need save_flags/restore_flags at all,
> > without actually disabling the local IRQs afterwards? The
> 
> The IRQ source has been disabled in the MFC by the atari_disable_irq( 
> IRQ_MFP_FDC ) call just before local_save_flags(flags). For that reason, 
> the fact that local_irq_disable is commented out will not usually matter 
> (a timer interrupt that would result in retrying the floppy request or 
> removing the request from the queue excepted).
> 
> I would rather suggest to leave the code in, and fix the buggy comments instead.
> 
> Note: IDE or SCSI cannot get in the way here -and I haven't seen IDE and 
> floppy races in recent kernels. SCSI was pretty broken anyway last time I tried 
> a few months ago. I cannot run any tests since my PC motherboard or CPU died 
> recently.
> 
> > redo_fd_request() doesn't seem to do anything that would mess with flags
> > inconsistently.
> > 
> > But I'd rather anyone who has touched the surrounding code in past years
> > Ack it. I can then take it through trivial tree or submit to akpm.
> 
> The surounding code probably hasn't been touched in ages. The floppy driver in 
> its current state does work. If redo_fd_request could alter timers ot queues, 
> rmoving the locking would be dangerous, no?

The patch is not removing any locking. It only

1) removes the local_irq_disable() that has been commented out for many 
   years already anyway
2) removes the saving and restoring of CPU flags around do_fd_request(), 
   which is rather clearly a nop than any kind of "locking"

> > [1] http://lkml.org/lkml/2002/12/27/58
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> NAck for my part. 

Please elaborate a little bit more which of the two points above you base 
your NACK on.

> 
> 	Michael
> 
> 
> > ---
> >  drivers/block/ataflop.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> > index 847a9e5..a5af1d6 100644
> > --- a/drivers/block/ataflop.c
> > +++ b/drivers/block/ataflop.c
> > @@ -1478,10 +1478,7 @@ void do_fd_request(struct request_queue * q)
> >  	stdma_lock(floppy_irq, NULL);
> > 
> >  	atari_disable_irq( IRQ_MFP_FDC );
> > -	local_save_flags(flags);	/* The request function is called with ints
> > -	local_irq_disable();		 * disabled... so must save the IPL for later */
> >  	redo_fd_request();
> > -	local_irq_restore(flags);
> >  	atari_enable_irq( IRQ_MFP_FDC );
> >  }
> > 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
