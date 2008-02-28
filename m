Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYB1GSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYB1GSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYB1GR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:17:59 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:39115 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYB1GR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:17:59 -0500
Date: Thu, 28 Feb 2008 09:17:23 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
Message-ID: <20080228061723.GB108@tv-sign.ru>
References: <47BEC663.7050904@openvz.org> <20080222144155.GA4349@tv-sign.ru> <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Thomas Gleixner wrote:
>
> On Fri, 22 Feb 2008, Oleg Nesterov wrote:
> > > -
> > > -	if (unlikely(!list_empty(&q->list))) {
> > > -		/*
> > > -		 * If an SI_TIMER entry is already queue just increment
> > > -		 * the overrun count.
> > > -		 */
> > > -		BUG_ON(q->info.si_code != SI_TIMER);
> > > -		q->info.si_overrun++;
> > > -		goto out;
> > > -	}
> > > -	/* Short-circuit ignored signals.  */
> > > -	if (sig_ignored(p, sig)) {
> > > -		ret = 1;
> > > -		goto out;
> > > -	}
> 
> > >  send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
> 
> > > -	/* Short-circuit ignored signals.  */
> > > -	if (sig_ignored(p, sig)) {
> > > -		ret = 1;
> > > -		goto out;
> > > -	}
> > > -
> > > -	if (unlikely(!list_empty(&q->list))) {
> > > -		/*
> > > -		 * If an SI_TIMER entry is already queue just increment
> > > -		 * the overrun count.  Other uses should not try to
> > > -		 * send the signal multiple times.
> > > -		 */
> > > -		BUG_ON(q->info.si_code != SI_TIMER);
> > > -		q->info.si_overrun++;
> > > -		goto out;
> > > -	} 
> > 
> > Personally, I think this change is very good. But send_sigqueue() and
> > send_group_sigqueue() have a very subtle difference which I was never
> > able to understand.
> > 
> > Let's suppose that sigqueue is already queued, and the signal is ignored
> > (the latter means we should re-schedule cpu timer or handle overrruns).
> > In that case send_sigqueue() returns 0, but send_group_sigqueue() returns 1.
> > 
> > I think this is not the problem (in fact, I think this patch makes the
> > behaviour more correct), but I hope Thomas can take a look and confirm.
> 
> It should not change anything. We should never have a signal enqueued
> when it's ignored anyway.

Well, it _is_ possible. Suppose that the signal is both ignored and blocked.
Now, if the task unblocks the signal, it could be ignored, queued, and
sig_ignored() == T.

But yes, I think you are right, this can't change anything. I just wanted
to be sure there is no subtle reason to prefer one way or another.

> Roland, any insight why this is different aside of a copy and paste
> error ?

I guess this was the reason for the difference.

Oleg.

