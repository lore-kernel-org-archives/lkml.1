Return-Path: <linux-kernel-owner+w=401wt.eu-S1763793AbXGQRCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763793AbXGQRCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXGQRCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:02:31 -0400
Received: from www.osadl.org ([213.239.205.134]:53009 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753990AbXGQRCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:02:31 -0400
Subject: Re: [PATCH] posix-timer: fix deletion race
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jeremy Katz <jeremy.katz@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>
In-Reply-To: <20070717130705.GA74@tv-sign.ru>
References: <Pine.LNX.4.63.0707131058390.10358@localhost.localdomain>
	 <1184662429.12353.426.camel@chaos>  <20070717130705.GA74@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 19:02:26 +0200
Message-Id: <1184691746.12353.450.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 17:07 +0400, Oleg Nesterov wrote:
> I think we can make a simpler patch,
> 
> --- posix-timers.c~	2007-06-29 14:45:04.000000000 +0400
> +++ posix-timers.c	2007-07-17 16:59:45.000000000 +0400
> @@ -449,6 +449,9 @@ static void release_posix_timer(struct k
>  		idr_remove(&posix_timers_id, tmr->it_id);
>  		spin_unlock_irqrestore(&idr_lock, flags);
>  	}
> +
> +	spin_unlock_wait(tmr->it_lock);
> +
>  	sigqueue_free(tmr->sigq);
>  	if (unlikely(tmr->it_process) &&
>  	    tmr->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
> 
> 
> What do you think? Instead of complicating the lock_timer(), release_posix_timer()
> just makes sure that nobody can "use" tmr.

Hmm, I prefer to fix that at the place where the race actually happens. 

	tglx


