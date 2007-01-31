Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXAaRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXAaRRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030329AbXAaRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:17:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030332AbXAaRRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:17:38 -0500
Date: Wed, 31 Jan 2007 18:15:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH 11/23] clocksource: atomic signals
Message-ID: <20070131171532.GC4468@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033806.468210824@mvista.com> <20070131110722.GA1847@elte.hu> <1170259185.9781.66.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170259185.9781.66.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4711]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > I see little difference between your and John's code: both poll 
> > something - you poll an atomic "did a new clocksource arrive" flag 
> > in the timer interrupt, John takes the clocksource_lock spinlock and 
> > checks a "did a new clocksource arrive" variable. Both are global 
> > atomic variables in essence.
> 
> The original version has more operations on every timer interrupt. 
> Also changing the spinlock to an atomic eliminates the possibility of 
> contention in the timer interrupt ..

there is precisely /zero/ contention on the clocksource_lock! It is a 
very short-held lock, and it's only held by the timer interrupt and some 
really rare operations like 'clocksource register' or 'show 
clocksources'.

> > what i'd see as a real cleanup here would be to get away from this 
> > 'poll whether there's any clocksource update' model, and to just 
> > ensure that a running timer irq will always see the latest 
> > clocksource. I.e. to run the change_clocksource() logic (and the 
> > following updates) when a new clock source is selected - not when 
> > the next timer interrupt runs. That would propagate all effects of a 
> > new clock source immediately.
> 
> You could reduce the code in the interrupt handler (which is good), 
> but I think you'll end up with a polling model regardless.. If you add 
> some locking between the interrupt handler and something else you may 
> as well add the run time of that new critical section to the timer 
> latency . So I'm not sure it would be a outright win ..

I think you didnt understand what i said: the point is to /remove/ the 
polling, and to replace it with a natural lock that is held anyway: 
xtime_lock or whatever other exclusion mechanism. Again, there is almost 
/never/ any contention on this lock so there's no 'latency to add'. But 
the polling overhead in every timer irq, even if it's just a single 
atomic flag, does add up in every timer tick.

you also didnt seem to understand my other point:

> > I.e. to run the change_clocksource() logic (and the following 
> > updates) when a new clock source is selected - not when the next 
> > timer interrupt runs. That would propagate all effects of a new 
> > clock source immediately.

that is actually more important from a design cleanliness POV than the 
basic avoidance of some polling overhead.

	Ingo
