Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXGQJ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXGQJ5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXGQJ51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:57:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXGQJ50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:57:26 -0400
Date: Tue, 17 Jul 2007 11:57:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Katz <jeremy.katz@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Stable Team <stable@kernel.org>
Subject: Re: [PATCH] posix-timer: fix deletion race
Message-ID: <20070717095707.GB6411@elte.hu>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain> <1184662429.12353.426.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184662429.12353.426.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Jeremy Katz experienced a posix-timer related bug on 2.6.14. This is
> caused by a subtle race, which is there since the original posix timer
> commit and persists until today.
> 
> timer_delete does:
> lock_timer();
> timer->it_process = NULL;
> unlock_timer();
> release_posix_timer();
> 
> timer->it_process is checked in lock_timer() to prevent access to a
> timer, which is on the way to be deleted, but the check happens after
> idr_lock is dropped. This allows release_posix_timer() to delete the
> timer before the lock code can check the timer:
> 
> CPU 0				CPU 1
> lock_timer();			
> timer->it_process = NULL;
> unlock_timer();
> 				lock_timer()
> 					spin_lock(idr_lock);
> 					timer = idr_find();
> 					spin_lock(timer->lock);
> 					spin_unlock(idr_lock);
> release_posix_timer();
> 	spin_lock(idr_lock);
> 	idr_remove(timer);
> 	spin_unlock(idr_lock);
> 	free_timer(timer);
> 					if (timer->......)
> 
> Change the locking to prevent this.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

nice one! The race looks pretty narrow - Jeremy, does your Xens have 
hyperthreading? (or are there any heavy SMI sources perhaps that could 
open up this race.) If not then there might be some other bug lurking in 
there as well.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
