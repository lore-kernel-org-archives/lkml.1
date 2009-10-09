Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbZJIJ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbZJIJ6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZJIJ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:58:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50379 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZJIJ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:58:45 -0400
Date: Fri, 9 Oct 2009 11:58:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] ataflop: remove buggy IRQ disable from
	do_fd_request()
Message-ID: <20091009095808.GU9228@kernel.dk>
References: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910091141150.19284@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Jiri Kosina wrote:
> There is a nice gem in drivers/block/ataflop.c::do_fd_request()
> 
> 	void do_fd_request(struct request_queue * q)
> 	{
> 		unsigned long flags;
> 
> 		DPRINT(("do_fd_request for pid %d\n",current->pid));
> 		while( fdc_busy ) sleep_on( &fdc_wait );
> 		fdc_busy = 1;
> 		stdma_lock(floppy_irq, NULL);
> 
> 		atari_disable_irq( IRQ_MFP_FDC );
> 		local_save_flags(flags);        /* The request function is called with ints
> 		local_irq_disable();             * disabled... so must save the IPL for later */
> 		redo_fd_request();
> 		local_irq_restore(flags);
> 		atari_enable_irq( IRQ_MFP_FDC );
> 	}
> 
> If you look at the code long enough, you will notioce that the 
> local_irq_disable() call is actually commented out. This has been 
> introduced back in 2002 in [1], but as you can see, the same bug has been 
> there even before, with the sti() call being commented out in the very 
> same way :)
> 
> I am not familiar with the code myself at all, but I guess that the whole 
> stuff can just be removed. Why do we need save_flags/restore_flags at all, 
> without actually disabling the local IRQs afterwards? The 
> redo_fd_request() doesn't seem to do anything that would mess with flags 
> inconsistently.
> 
> But I'd rather anyone who has touched the surrounding code in past years 
> Ack it. I can then take it through trivial tree or submit to akpm.

That does look odd. The comment is correct that the function is entered
with interrupts disabled (and the queue lock held). So I'd say your
patch looks fine, the whole save/restore business looks meaningless.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

