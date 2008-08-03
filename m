Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYHCKu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYHCKu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYHCKuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:50:18 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37118 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYHCKuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:50:17 -0400
Date: Sun, 3 Aug 2008 14:53:38 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: oliver.pntr@gmail.com
Cc: stable@kernel.org, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
Message-ID: <20080803105338.GB79@tv-sign.ru>
References: <e65964651c0f02f5554e1e4c5e40a876@zipernowsky.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65964651c0f02f5554e1e4c5e40a876@zipernowsky.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Oliver Pinter wrote:
>
> >From 2b201a9eddf509e8e935b45e573648e36f4b623f Mon Sep 17 00:00:00 2001
> From: Oleg Nesterov <oleg@tv-sign.ru>
> Date: Fri, 25 Jul 2008 01:47:31 -0700
> Subject: [PATCH] signals: do_signal_stop: kill the SIGNAL_UNKILLABLE check
> 
> [ Upstream commit 2b201a9eddf509e8e935b45e573648e36f4b623f ]
> 
> fae5fa44f1fd079ffbed8e0add929dd7bbd1347f changed do_signal_stop() to check
> SIGNAL_UNKILLABLE, this wasn't needed.  If signal_group_exit() == F, the
> signal sent to SIGNAL_UNKILLABLE task must be already filtered out by the
> caller, get_signal_to_deliver().  And if signal_group_exit() == T we are
> not going to stop.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Acked-by: Roland McGrath <roland@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oliver Pinter <oliver.pntr@gmail.com>
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 15f901a..0514da5 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1649,8 +1649,7 @@ static int do_signal_stop(int signr)
>  	} else {
>  		struct task_struct *t;
>  
> -		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
> -					 != SIGNAL_STOP_DEQUEUED) ||
> +		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||

Again, I don't think this minor cleanup is good for -stable.

It doesn't fix any bug, it only removes the unnecessary uglification (which
was previously added by me in fae5fa44f1fd079ffbed8e0add929dd7bbd1347f).

Oleg.

