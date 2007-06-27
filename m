Return-Path: <linux-kernel-owner+w=401wt.eu-S1763053AbXF0Tz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763053AbXF0Tz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbXF0TzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:55:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:63740 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbXF0TzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rNe+VjGogOOjofz5yJM2JhKdy5IVVh1XdY6aMtDLEIRYaNTPOER/EBTaGYOOXQNtnSYVg/PFKCKdA1WHHvVuiyIogWMlEUuVUJqzw9CrpC5CgzHIM04E5KxBiORlnTbn2iCRi7fLlb7/sRbEp0x9akS0GlaDu0WqBpgCX8PrMzI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Thanos Kyritsis <djart@linux.gr>
Subject: PREEMPT bug? (was: Re: [PROBLEM]: hdparm strange behaviour for 2.6.21 and later)
Date: Wed, 27 Jun 2007 21:46:26 +0200
User-Agent: KMail/1.9.6
Cc: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200706161958.05313.djart@linux.gr> <200706232028.58193.bzolnier@gmail.com> <200706242047.13466.djart@linux.gr>
In-Reply-To: <200706242047.13466.djart@linux.gr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272146.26886.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 24 June 2007, Thanos Kyritsis wrote:
> On Saturday 23 June 2007, Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> 
> Hello, thanks for answering :-D
> 
> 
> > Also could you try running UP kernel without PREEMPT and see
> > if it makes difference?
> 
> Yes, it did make a difference. I've just tried both UP and SMP kernels 
> (22-rc5) *without* PREEMPT. Neither of these locked!

Thanks for testing.

IIRC SMP kernel without PREEMPT should also fail (or not?),
it could be that we are hitting some generic PREEMPT bug.

Cc:ed linux-kernel@ in hope that some PREEMPT guru lends us a hand.

[ original thread is here:
 http://www.mail-archive.com/linux-ide@vger.kernel.org/msg07380.html ]

> I also tried UP with PREEMPT and it locks.
> 
> > Adding a couple of printk-s to ide.c::set_using_dma() and
> > ide.c::ide_spin_wait_hwgroup() will for sure help in debugging
> > it further.
> 
> I just tried that as well. I placed printk-s when entering and exiting 
> these 2 functions and when they use spin_lock_irq() and 
> spin_unlock_irq(), and then watched the output:
> 
> I didn't see something odd. For every hdparm execution, set_using_dma() 
> is called, it successfully calls ide_spin_wait_hwgroup(), then 
> set_using_dma() finishes.
> After set_using_dma() finishes, one more ide_spin_wait_hwgroup() 
> is called and finishes.
> 
> This pattern happens always, no matter if the kernel will eventually 
> lock (preempt) or not lock (no preempt), with absolutely no 
> differences. 
> 
> entering ide.c::set_using_dma()
> |
>   entering ide.c::ide_spin_wait_hwgroup()
>     ide.c::ide_spin_wait_hwgroup: LOCK
>   exiting ide.c::ide_spin_wait_hwgroup()
> |
> ide.c::set_using_dma: set ->busy flag, unlock and let it ride
> ide.c::set_using_dma: UNLOCK
> ide.c::set_using_dma: lock, clear ->busy flag and unlock before leaving
> ide.c::set_using_dma: LOCK
> ide.c::set_using_dma: UNLOCK
> |
> exiting ide.c::set_using_dma()
> 
> entering ide.c::ide_spin_wait_hwgroup()
> ide.c::ide_spin_wait_hwgroup: LOCK
> exiting ide.c::ide_spin_wait_hwgroup()
> 
> The above gets printed twice (one for the hda hdparm and one for hdb).
> 
> But I noticed something extra. 
> 
> Sometimes, the ide_spin_wait_hwgroup() that runs either before the 1st 
> set_using_dma() or between the 1st and the 2nd (1st for hda, 2nd for 
> hdb) (*but never the one called last*) is waiting A LOT inside the busy 
> loop (while (hwgroup->busy)).
> 
> I think PREEMPT kernels always produce a lot of this while loop output, 
> and then print the above pattern, then lock.
> 
> Non-PREEMPT kernels don't always produce the huge while loop output, 
> only sometimes, but they never have locking problem.
> I don't know if this is at all relevant to the problem. Perhaps it's 
> normal that during some of the bootups the IDE device group is busy 
> while during other bootups it's not busy, right ?

Yes, this is expected behavior (especially when you mix SMP in)
unless of course ide_spin_wait_hwgroupt() fails (timeouts).

> However, since all functions exit properly, should I try to place 
> printk-s in other functions as well ? 

ide_do_request() and hwgroup->busy flag but as this could produce *a*lot*
of output (serial or net console would be required to capture the log for
the lockup case).

> (I kind of need and appreciate guideance in order to help you, because 
> I've never been in the kernel hacking business before :) )

No problem, happy hacking. :)

Thanks,
Bart
