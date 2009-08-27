Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZH0XQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZH0XQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbZH0XQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:16:31 -0400
Received: from www.tglx.de ([62.245.132.106]:49888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZH0XQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:16:28 -0400
Date: Fri, 28 Aug 2009 01:16:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A971245.5070507@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Ashwin Chaugule wrote:
> Thomas Gleixner wrote:
> > You forgot to describe the application scenario which triggers this.
> >    
> I didn't have anything specific running in userspace to trigger this. The
> sched_timer itself was causing most of the unnecessary reprogramming. I
> reckon, with more applications running, the timer_stats will show other timers
> (hrtimer_wakeup, it_real_fn etc.) that cause this effect too.

Hmm. That's related to NOHZ I guess. Ok, that's a serious issue and we
need to look at that.

> > So if I'm not totally on the wrong track, that's the meat of the
> > patch.
> >   
> Yup.
> > Any reason why we can't solve that problem with checking
> > cpu_base->expires_next against the timer which is deleted ? 
> > See the patently untested patch below.
> > 
> > Another question which arises is whether we should bother with the
> > reprogramming at all and just let the last programmed event happen
> > even when the corresponding timer has been removed.
> >   
> Hm. Interesting approach. See below.
> 
> So, you suggest checking the ktime of the hrtimer thats about to expire and
> compare it with expires_next ?

What's wrong with that ?

> I guess, another reason to go with caching the hrtimer is to avoid looping
> through HRTIMER_MAX_CLOCK_BASES, which may increase to more than 2 (?) for
> other architectures, and also all the code flow to arm the clock events
> device.
> With the caching approach, I also saw a 4% speedup in various application
> startups too.

Can you reevaluate against my patch please ?

Thanks,

	tglx
