Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbZHaHIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbZHaHIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZHaHIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:08:44 -0400
Received: from www.tglx.de ([62.245.132.106]:38809 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZHaHIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:08:43 -0400
Date: Mon, 31 Aug 2009 09:08:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ashwin Chaugule <ashwinc@codeaurora.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
In-Reply-To: <4A9B4ECB.7070506@codeaurora.org>
Message-ID: <alpine.LFD.2.00.0908310854020.19335@localhost.localdomain>
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org>
 <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain> <4A9A1701.2070703@codeaurora.org> <alpine.LFD.2.00.0908301016230.19335@localhost.localdomain>
 <4A9B4ECB.7070506@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Ashwin Chaugule wrote:
> Thomas Gleixner wrote:
> 
> >   That's not hard to fix by allowing the reprogramming to skip when the
> > new expiry time is the same as the old one.
> > 
> > I think that allowing the reprogram to skip is catching more cases
> > than the cached pointer. If the cached pointer is the one which gets
> > removed we might still reprogram with the same expiry value.
> >   
> Um. Wouldn't the cached pointer point to the first (oldest) hrtimer in the
> series of timers with the same expires value ? Then it would be the last
> hrtimer to be removed. I'm walking through the rbtree now to confirm this.
> 
> > Can you please try the delta patch on top of the last one I sent ?
> >   
> This looks very good ! Our results are almost similar now. However, I think
> that with this new
> patch we're still arming the timer needlessly at least once. This is the
> case when we're trying to remove the first (oldest) hrtimer with
> timer->expires = cpu->expires_next, but we forgo the reprogramming, when we
> really shouldn't. At this point, with the current scheme of things, we will
> needlessly wakeup and simply correct the expires_next value by
> traversing up the rbtree, to the parent node.

That only happens, when that timer is the last one in both trees. Then
the resulting reprogramming value is KTIME_MAX and we skip the
reprogramming. That's easy to fix by removing the KTIME_MAX check.
 
> If we knew in advance that this to-be-removed timer, was the oldest hrtimer
> of the series, then we could force reprogram, such that we wake up only when
> the parent node timer is really going to expire. This may make a noticeable
> difference in power for some devices. 
>
> Another question is, what happens when base->first of REALTIME and MONOTONIC
> both have the same expires ?

The skip_equal check covers both. We find out which timer of the two
bases is expiring next and compare the result against
cpu_base->expires_next. If both are identical we skip.

Thanks,

	tglx

