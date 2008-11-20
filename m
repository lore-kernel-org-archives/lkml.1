Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYKTULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYKTULb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYKTULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:11:23 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:36468 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751827AbYKTULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:11:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ywaAfhQWk3qxOw0nW5drf5hAyhRkpgG69z0sjMXb1XWMyouyE9LP2bPNQ0/zKonshevM7ynf7K3sQXcMS+eNVHPc0/CjZnD3Gm7bTSsAt5JiI+8mGW//9yIgoU3xot8P/1zmJvzfjRJfqKfjtCOCbQVqyhaldCtQ5Ax+W3mE5go=  ;
X-YMail-OSG: HWGwCBoVM1mB.UII6OzslrUcjDdwW7iBWpjVedDQ8dTKEvb6LvaAIYrZTh.MXmqHOPgXOX9kstkh.9G99.PnslOuUvzUxf8K4OvFzmTf0C7191AmLVrhW79ummEds3rl5sVRRKB2J.UjqC4JW9D0DlFNUNyHHz0MKfRez7EAlMv1dq3hp0prAcAB0Mil
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: yi.y.yang@intel.com
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power management
Date: Thu, 20 Nov 2008 12:11:19 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <1222334744.9267.41.camel@yangyi-dev>
In-Reply-To: <1222334744.9267.41.camel@yangyi-dev>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201211.19552.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008, Yi Yang wrote:
> ehci_watchdog will wake up CPU very frequently so that CPU
> stays at C3 very short, average residence time is about 50
> ms on Aspire One, but we expect it should be about 1 second
> or more, so this kind of periodic timer is very bad for power
> saving.

How did you finger this timer?  I think you don't understand
what it's really doing.

Near as I can tell, f0d781d59cb621e1795d510039df973d0f8b23fc
should just be reverted.

Alan Stern had some good comments.  Although GCC will usually
end up optimizing most of this code away, this function may now
be too large now for inlining.

 
> We can't remove this timer because of some bad USB controller
> chipset, but at least we should reduce its side effect to as
> possible as low.

That's actually a different timer ... the IAA watchdog timer
is coping with a quirk that's been observed on most VIA chips.
On sane hardware, it should never fire (since the IAA interrupt
actually happens).


> This patch can make CPU stay at C3 longer, average residence time
> is about twice as long as original. 

Did you actually measure this patch?  It looks very wrong to me.

Recall that the primary purpose of *this* timer is to reduce
the DMA load ... first by shrinking the async ring by taking
out unused QH entries, and then by disabling the async ring
entirely.

So leaving needless DMA loads active for longer, you prevent
entry to C3... contrary to what you're attempting.

To improve C3 times, you'd want to stop DMA *sooner* not later...
there's a tradeoff of course, since stopping DMA too soon will
shrink performance (and causes various hardware races to be
more common).


> Please consider to apply it, thanks
> 
> Signed-off-by: Yi Yang <yi.y.yang@intel.com>
> ---
>  ehci.h |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
> index 5799298..9d530d9 100644
> --- a/drivers/usb/host/ehci.h
> +++ b/drivers/usb/host/ehci.h
> @@ -181,14 +181,16 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
>  	 * the async ring; just the I/O watchdog.  Note that if a
>  	 * SHRINK were pending, OFF would never be requested.
>  	 */
> -	if (timer_pending(&ehci->watchdog)
> -			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
> -				& ehci->actions))
> -		return;
> +	enum ehci_timer_action oldactions = ehci->actions;

Moving that test invalidates the comment desribing what it was
doing.  This change *also* looks fishy... either it's not needed,
or it was thet only change you needed (but, with comment fix).


>  
>  	if (!test_and_set_bit (action, &ehci->actions)) {
>  		unsigned long t;
>  
> +		if (timer_pending(&ehci->watchdog)
> +			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
> +				& oldactions))
> +			return;
> +
>  		switch (action) {
>  		case TIMER_IO_WATCHDOG:
>  			t = EHCI_IO_JIFFIES;
> @@ -204,7 +206,7 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
>  			t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
>  			break;
>  		}
> -		mod_timer(&ehci->watchdog, t + jiffies);
> +		mod_timer(&ehci->watchdog, round_jiffies(t + jiffies));

So basically, instead of having the DMA load shrink down to zero
and finally to off, in on the order of 1/20 of a second ... you
instead leave DMA active for much longer periods.

An async ring with three empty entries will be doing DMA for one,
two, three seconds ... preventing C3 all the while ... before
turning off.

Vs previous behavior where will shrink to empty and then stop
doing DMA, in under 1/10 of a second.

This round_jiffies() call is the very least that needs reverting.



>  	}
>  }
>  
> 
> 
> 


