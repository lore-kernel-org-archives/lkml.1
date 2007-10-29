Return-Path: <linux-kernel-owner+w=401wt.eu-S1759862AbXKAOdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbXKAOdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXKAOdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:33:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4263 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753749AbXKAOc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:32:57 -0400
Date: Mon, 29 Oct 2007 18:54:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Matt Mackall <mpm@selenic.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071029185445.GA7742@ucw.cz>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472129C3.6040405@am.sony.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

Well, I believe someone got

DDetetccctted ed 113223 HHzz CPUCPU

in his dmesg, and now we have this 'draconian' locking. How can we
prevent mangled messages without it?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
