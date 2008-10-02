Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYJBX5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYJBX5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYJBX5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:57:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753203AbYJBX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:57:04 -0400
Date: Thu, 2 Oct 2008 16:56:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: yi.y.yang@intel.com
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       gregkh@suse.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
 management
Message-Id: <20081002165649.00d021db.akpm@linux-foundation.org>
In-Reply-To: <1222334744.9267.41.camel@yangyi-dev>
References: <1222334744.9267.41.camel@yangyi-dev>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 17:25:44 +0800
Yi Yang <yi.y.yang@intel.com> wrote:

> ehci_watchdog will wake up CPU very frequently so that CPU
> stays at C3 very short, average residence time is about 50
> ms on Aspire One, but we expect it should be about 1 second
> or more, so this kind of periodic timer is very bad for power
> saving.
> 
> We can't remove this timer because of some bad USB controller
> chipset, but at least we should reduce its side effect to as
> possible as low.
> 
> This patch can make CPU stay at C3 longer, average residence time
> is about twice as long as original. 
> 
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
>  	}
>  }
>  

<looks>

<regrets it>


Why does this:

	t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;

add "1000" to a jiffies value when it doesn't know what HZ is?  It'll
be adding anywhere from one second up to ten seconds to the timeout
interval depending upon compile-time options.

I suspect s/1000/HZ/ would improve things here.  Or just delete it -
doesn't the subsequent round_jiffies() do the same thing, only better? 
This code needs help, I suspect.


Also, do we really need to inline this large function into at least
five callsites?

