Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbZCYRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbZCYRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZCYRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:19:10 -0400
Received: from gw.goop.org ([64.81.55.164]:44661 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773AbZCYRTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:19:09 -0400
Message-ID: <49CA678A.30606@goop.org>
Date: Wed, 25 Mar 2009 10:19:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "Alex.Zeffertt" <Alex.Zeffertt@citrix.com>,
       stable@kernel.org
Subject: Re: [PATCH] clockevent: on resume program the next oneshot tick with
 the next actual event
References: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>
In-Reply-To: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> When resuming a Xen domU we were seeing an issue where the timer ticks never
> seemed to start up again. This was with CONFIG_NO_HZ=y, the Xen clocksource
> has CLOCK_EVT_FEAT_ONESHOT but not CLOCK_EVT_FEAT_PERIODIC.
>
> The issue is that on resume tick_resume_oneshot() tries to program an event for
> "now", e.g.
> 	tick_program_event(ktime_get(), 1);
>
> However further down the call chain tick_dev_program_event() then compares that
>   
Where's that?  Do you mean in clockevents_program_event():

	delta = ktime_to_ns(ktime_sub(expires, now));

	if (delta <= 0)
		return -ETIME;


?

> expiry time with a second call to ktime_get() and discards the event if the
> timeout is negative -- which it always will be since some time must have passed
> since tick_program_event was called.
>
> Instead of asking for an immediate event on resume, instead ask for the next
> actual event.
>   

What if the next event is now anyway?  What timebase is it in anyway?

> With this fix I can successfully resume a Xen domain.
>   

That's good, but I think there's more going on here.

    J
