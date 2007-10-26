Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbXJZBYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbXJZBYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJZBYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:24:07 -0400
Received: from waste.org ([66.93.16.53]:50746 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXJZBYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:24:06 -0400
Date: Thu, 25 Oct 2007 20:23:42 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071026012342.GV19691@waste.org>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472129C3.6040405@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:41:55PM -0700, Tim Bird wrote:
> Matt Mackall wrote:
> > On Thu, Oct 25, 2007 at 03:52:28PM -0700, Tim Bird wrote:
> >> Mathieu Desnoyers wrote:
> >>> It might help to read this thread I posted on LKML in January 2006
> >>> explaining the problem, which led to some discussion about the issue.
> >>>
> >>> http://lkml.org/lkml/2006/6/3/48
> >> This is very helpful.  Jon Smirl's answer seems to give the
> >> rationale for supporting printk output in interrupt context.
> >> I'm not sure, however, if extending the interrupt off period
> >> to cover the console output is required.  It didn't until
> >> Ingo changed it in 2.6.17.
> > 
> > Hmm, I see this at the beginning of the post-BK era (2.6.12-rc2):
> > 
> > 	        spin_lock_irqsave(&logbuf_lock, flags);
> > 		...
> > 		spin_unlock(&logbuf_lock);
> > 		call_console_drivers(_con_start, _log_end);
> > 		local_irq_restore(flags);
> > 
> 
> Well, I need to do some more research.  This must be in
> release_console_sem().  I was looking at vprintk, through
> the ages.  At 2.6.16, it looked like this:
> 
>         spin_lock_irqsave(&logbuf_lock, flags);
>         ...
>               spin_unlock_irqrestore(&logbuf_lock, flags);
>               console_may_schedule = 0;
>               release_console_sem();
> 
> but the irq restore has been moving around to different places
> in that function over the last few years.  I suspect that in the
> common case the irqsave in vprintk is the one that disables
> ints.
> 
> It appears that formerly interrupts were enabled in vprintk but
> re-disabled immediately upon entering release_console_sem().
> As it is now, they're held during formatting, buffering,
> and output, which seems excessive.
> 
> It seems draconian to drain the entire buffer with ints disabled.
> Is it possible to break this up and send out smaller chunks
> at a time?  Maybe by putting a chunk loop in release_console_sem()?

Well there are things we can do, yes, but I'd be worried that they've
give up the deterministic behavior we rely on quite heavily for
debugging. If event A happens before event B, we must see the message
from A before the one from B, even if B happens in irq context. 

And if event B is a hard lock up, we'd also like to be sure the
message for A actually gets out. If B happens in the interrupt that
comes in when we re-enable them, that won't happen.

(This is also a problem on unaccelerated video consoles, where
scrolling may actually be slower than 115kbps!)

-- 
Mathematics is the supreme nostalgia of our time.
