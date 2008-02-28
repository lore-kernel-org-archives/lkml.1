Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbYB1Ezz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbYB1Ezz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 23:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYB1Ezr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 23:55:47 -0500
Received: from www.tglx.de ([62.245.132.106]:55545 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYB1Ezq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 23:55:46 -0500
Date: Thu, 28 Feb 2008 05:54:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
In-Reply-To: <20080222144155.GA4349@tv-sign.ru>
Message-ID: <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de>
References: <47BEC663.7050904@openvz.org> <20080222144155.GA4349@tv-sign.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008, Oleg Nesterov wrote:
> > -
> > -	if (unlikely(!list_empty(&q->list))) {
> > -		/*
> > -		 * If an SI_TIMER entry is already queue just increment
> > -		 * the overrun count.
> > -		 */
> > -		BUG_ON(q->info.si_code != SI_TIMER);
> > -		q->info.si_overrun++;
> > -		goto out;
> > -	}
> > -	/* Short-circuit ignored signals.  */
> > -	if (sig_ignored(p, sig)) {
> > -		ret = 1;
> > -		goto out;
> > -	}

> >  send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)

> > -	/* Short-circuit ignored signals.  */
> > -	if (sig_ignored(p, sig)) {
> > -		ret = 1;
> > -		goto out;
> > -	}
> > -
> > -	if (unlikely(!list_empty(&q->list))) {
> > -		/*
> > -		 * If an SI_TIMER entry is already queue just increment
> > -		 * the overrun count.  Other uses should not try to
> > -		 * send the signal multiple times.
> > -		 */
> > -		BUG_ON(q->info.si_code != SI_TIMER);
> > -		q->info.si_overrun++;
> > -		goto out;
> > -	} 
> 
> Personally, I think this change is very good. But send_sigqueue() and
> send_group_sigqueue() have a very subtle difference which I was never
> able to understand.
> 
> Let's suppose that sigqueue is already queued, and the signal is ignored
> (the latter means we should re-schedule cpu timer or handle overrruns).
> In that case send_sigqueue() returns 0, but send_group_sigqueue() returns 1.
> 
> I think this is not the problem (in fact, I think this patch makes the
> behaviour more correct), but I hope Thomas can take a look and confirm.

It should not change anything. We should never have a signal enqueued
when it's ignored anyway.

Roland, any insight why this is different aside of a copy and paste
error ?

Thanks,

	tglx
