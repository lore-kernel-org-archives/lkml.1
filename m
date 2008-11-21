Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKUG4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKUG4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 01:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYKUG4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 01:56:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:55969 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYKUG4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 01:56:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="465657033"
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
	management
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: David Brownell <david-b@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <200811201211.19552.david-b@pacbell.net>
References: <1222334744.9267.41.camel@yangyi-dev>
	 <200811201211.19552.david-b@pacbell.net>
Content-Type: text/plain; charset=utf8
Organization: Intel
Date: Fri, 21 Nov 2008 22:55:37 +0800
Message-Id: <1227279337.3447.22.camel@yangyi-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2008-11-21五的 04:11 +0800，David Brownell写道：
> On Thursday 25 September 2008, Yi Yang wrote:
> > ehci_watchdog will wake up CPU very frequently so that CPU
> > stays at C3 very short, average residence time is about 50
> > ms on Aspire One, but we expect it should be about 1 second
> > or more, so this kind of periodic timer is very bad for power
> > saving.
> 
> How did you finger this timer?  I think you don't understand
> what it's really doing.
> 
> Near as I can tell, f0d781d59cb621e1795d510039df973d0f8b23fc
> should just be reverted.
> 
> Alan Stern had some good comments.  Although GCC will usually
> end up optimizing most of this code away, this function may now
> be too large now for inlining.
> 
>  
> > We can't remove this timer because of some bad USB controller
> > chipset, but at least we should reduce its side effect to as
> > possible as low.
> 
> That's actually a different timer ... the IAA watchdog timer
> is coping with a quirk that's been observed on most VIA chips.
> On sane hardware, it should never fire (since the IAA interrupt
> actually happens).
Thank you for your very clear explanation. It does depend on USB
device's chip origin.

But on Asus EeePC, i saw another periodical timer usb_hcd_poll_rh_status
which fires every 256 milisecond, is this also doing with some
hardware's quirk?

> 
> 
> > This patch can make CPU stay at C3 longer, average residence time
> > is about twice as long as original. 
> 
> Did you actually measure this patch?  It looks very wrong to me.
Yes, i did test it, it can dramatically increase C3 residence time, but
i didn't do data transfer verification. On Acer Aspire One, there is a
webcam from Suyin Corp which maybe uses VIA USB chip, but USB Controller
is from Intel.

> 
> Recall that the primary purpose of *this* timer is to reduce
> the DMA load ... first by shrinking the async ring by taking
> out unused QH entries, and then by disabling the async ring
> entirely.
> 
> So leaving needless DMA loads active for longer, you prevent
> entry to C3... contrary to what you're attempting.
I didn't use it to transfer data because it (webcam) is idle. :-)

Really thank you for your clear comments, i'll double check it.

Anyway, i agree this patch is reverted. These timers are really what
we must concern, they are culprits resulting in short C3 residence time.
> 
> To improve C3 times, you'd want to stop DMA *sooner* not later...
> there's a tradeoff of course, since stopping DMA too soon will
> shrink performance (and causes various hardware races to be
> more common).
> 
> 
> > Please consider to apply it, thanks
> > 
> > Signed-off-by: Yi Yang <yi.y.yang@intel.com>
> > ---
> >  ehci.h |   12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
> > index 5799298..9d530d9 100644
> > --- a/drivers/usb/host/ehci.h
> > +++ b/drivers/usb/host/ehci.h
> > @@ -181,14 +181,16 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
> >  	 * the async ring; just the I/O watchdog.  Note that if a
> >  	 * SHRINK were pending, OFF would never be requested.
> >  	 */
> > -	if (timer_pending(&ehci->watchdog)
> > -			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
> > -				& ehci->actions))
> > -		return;
> > +	enum ehci_timer_action oldactions = ehci->actions;
> 
> Moving that test invalidates the comment desribing what it was
> doing.  This change *also* looks fishy... either it's not needed,
> or it was thet only change you needed (but, with comment fix).
> 
> 
> >  
> >  	if (!test_and_set_bit (action, &ehci->actions)) {
> >  		unsigned long t;
> >  
> > +		if (timer_pending(&ehci->watchdog)
> > +			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
> > +				& oldactions))
> > +			return;
> > +
> >  		switch (action) {
> >  		case TIMER_IO_WATCHDOG:
> >  			t = EHCI_IO_JIFFIES;
> > @@ -204,7 +206,7 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
> >  			t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
> >  			break;
> >  		}
> > -		mod_timer(&ehci->watchdog, t + jiffies);
> > +		mod_timer(&ehci->watchdog, round_jiffies(t + jiffies));
> 
> So basically, instead of having the DMA load shrink down to zero
> and finally to off, in on the order of 1/20 of a second ... you
> instead leave DMA active for much longer periods.
> 
> An async ring with three empty entries will be doing DMA for one,
> two, three seconds ... preventing C3 all the while ... before
> turning off.
> 
> Vs previous behavior where will shrink to empty and then stop
> doing DMA, in under 1/10 of a second.
> 
> This round_jiffies() call is the very least that needs reverting.
> 
> 
> 
> >  	}
> >  }
> >  
> > 
> > 
> > 
> 
> 

