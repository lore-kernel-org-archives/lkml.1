Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbZJIKIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbZJIKIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760586AbZJIKIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:08:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:37356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760569AbZJIKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:08:44 -0400
Date: Fri, 9 Oct 2009 12:08:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
 do_fd_request()
In-Reply-To: <20091009095808.GU9228@kernel.dk>
Message-ID: <alpine.LSU.2.00.0910091207460.19284@wotan.suse.de>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de> <20091009095808.GU9228@kernel.dk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009, Jens Axboe wrote:

> On Fri, Oct 09 2009, Jiri Kosina wrote:
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
> > 		local_irq_disable();             * disabled... so must save the IPL for later */
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
> > redo_fd_request() doesn't seem to do anything that would mess with flags 
> > inconsistently.
> > 
> > But I'd rather anyone who has touched the surrounding code in past years 
> > Ack it. I can then take it through trivial tree or submit to akpm.
> 
> That does look odd. The comment is correct that the function is entered
> with interrupts disabled (and the queue lock held). So I'd say your
> patch looks fine, the whole save/restore business looks meaningless.
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>

Thanks for confirming. I have queued it up in trivial tree.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
