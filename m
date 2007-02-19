Return-Path: <linux-kernel-owner+w=401wt.eu-S1161080AbXBTXXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161080AbXBTXXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161081AbXBTXXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:23:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48054 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161080AbXBTXXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:23:24 -0500
Date: Mon, 19 Feb 2007 23:47:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix refrigerator() vs thaw_process() race
Message-ID: <20070219224725.GF21199@elf.ucw.cz>
References: <20070218221737.GA4880@tv-sign.ru> <20070219105008.GA19184@elf.ucw.cz> <20070219121236.GD91@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219121236.GD91@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > refrigerator() can miss a wakeup, "wait event" loop needs a proper memory
> > > ordering.
> > > 
> > > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> > > 
> > > --- WQ/kernel/power/process.c~WAKE	2007-02-18 22:56:49.000000000 +0300
> > > +++ WQ/kernel/power/process.c	2007-02-19 01:04:26.000000000 +0300
> > > @@ -46,8 +46,10 @@ void refrigerator(void)
> > >  	recalc_sigpending(); /* We sent fake signal, clean it up */
> > >  	spin_unlock_irq(&current->sighand->siglock);
> > >  
> > > -		current->state = TASK_UNINTERRUPTIBLE;
> > > +		set_current_state(TASK_UNINTERRUPTIBLE);
> > 
> > 
> > Looks okay to me... but this one liner would be exactly as effective,
> > right?
> 
> I think no, with this one liner we have
> 
> 	while (frozen(current)) {
> 		// ------ WINDOW ------------
> 		set_current_state(TASK_UNINTERRUPTIBLE);
> 		schedule();
> 	}
> 
> What if thaw_process() happens in the window above?
> 
> We need the barrier exactly because LOAD (check condition) should not
> come before STORE (set task->state).

Aha, ok :-). You already have my ACK ;-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
