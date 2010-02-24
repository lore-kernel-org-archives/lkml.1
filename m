Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0BXWbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:31:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363Ab0BXWbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:31:37 -0500
Date: Wed, 24 Feb 2010 17:30:48 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
cc: torvalds@linux-foundation.org, Alasdair Kergon <agk@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Junichi Nomura <j-nomura@ce.jp.nec.com>, akpm@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [93/93] dm mpath: fix stall when requeueing io
In-Reply-To: <4B847D10.9040509@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.64.1002241706500.2537@hs20-bc2-1.build.redhat.com>
References: <20100219163257.186977438@kvm.kroah.org> <4B815A3D.9040402@canonical.com>
 <4B825982.3060606@ct.jp.nec.com> <20100223181229.GF560@agk-dp.fab.redhat.com>
 <4B847D10.9040509@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Kiyoshi Ueda wrote:

> Hi Alasdair, Linus,
> 
> On 02/24/2010 03:12 AM +0900, Alasdair G Kergon wrote:
> > On Mon, Feb 22, 2010 at 07:16:34PM +0900, Kiyoshi Ueda wrote:
> >> On 02/22/2010 01:07 AM +0900, Stefan Bader wrote:
> >>>> @@ -1568,12 +1575,16 @@ static void dm_request_fn(struct request
> >>>>  
> >>>>  		blk_start_request(rq);
> >>>>  		spin_unlock(q->queue_lock);
> >>>> -		map_request(ti, rq, md);
> >>>> +		if (map_request(ti, rq, md))
> >>>> +			goto requeued;
> >>>>  		spin_lock_irq(q->queue_lock);
> >>>>  	}
> >> In the current device-mapper code, I would like to go with
> >> spin_unlock/lock here.
> >> However, there was a case to enable irq in map_requst() for request
> >> allocation, and this spin_lock_irq was a work-around for the case.
> >> Now, there is no such case in the device-mapper code, so spin_lock should
> >> be enough here.  But I'm still using spin_lock_irq for safeness, since
> >> there might be some more cases to enable irq during request submission
> >> to underlying devices.
> >> I'll remove the _irq in the future after lots of testings.
> >  
> > So, have I understood your reasoning?
> > 
> > - This function (dm_request_fn) is always called with local interrupts disabled.
> > E.g. from generic_unplug_device() or blk_run_queue().
> > 
> > - The 'map_request()' function was found to re-enable interrupts in one case, but
> > that case got fixed.
> > 
> > - The code still uses spin_lock_irq to ensure they remain disabled as protection
> > against there being other cases.  This should be changed to spin_lock as a clean-up
> > but you are not aware of any current breakage.
> 
> That's correct.
> I think the spin_lock_irq can be changed to spin_lock as a clean-up.
> But I don't want to break things in this late stage of 2.6.33-rc
> and/or the stable tree.
> So I'll send the clean-up patch for 2.6.34 once I make sure it's ok.
> 
> Thanks,
> Kiyoshi Ueda

Yes. Change it in 2.6.34-rc.

Please review the code --- do call graph search over the functions to 
check that none of them enables interrupts (similar to the search I did to 
find out that dm_put).


A general note: Never ever try to hide race conditions --- i.e. don't ever 
try to think like "interrupts should be disabled here but maybe I 
overlooked something and they are enabled, so I disable them for sure". 
This doesn't work, it only makes the race condition happen less probably. 
And the bug that happens less probably is harder to find!

If you want to check that there is no place in map_request() that enables 
interrupts, use this: BUG_ON(!irqs_disabled()); after map_request() and 
before spin_lock().

The rationale is this: if you use BUG_ON, and interrupts are accidentally 
enabled, the user will send you a report with a line number where the 
crash happened. With the line number, it's pretty easy to find out what 
happened.

However, if you try to hide the bug and disable interrupts "for sure", the 
race condition will still happen (i.e. the code that should run with 
interrupts disabled will be called recursively), but it will happen less 
likely, and the user will be reporting things like "it locks up once a 
month" or "it corrupted my filesystem but I can't reproduce it" --- and 
these things are much-much-much harder to track down than a single BUG().

Mikulas

