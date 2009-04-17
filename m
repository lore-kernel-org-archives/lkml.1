Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZDQNGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZDQNGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZDQNGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:06:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37453 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZDQNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:06:39 -0400
Date: Fri, 17 Apr 2009 15:09:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [20/28] x86: MCE: Switch x86 machine check handler to Monarch election.
Message-ID: <20090417130944.GL14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <20090407150803.1AF0C1D046E@basil.firstfloor.org> <49E866D3.1020003@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E866D3.1020003@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for your review.

On Fri, Apr 17, 2009 at 08:24:03PM +0900, Hidetoshi Seto wrote:
> > +		goto out;
> > +	if ((s64)*t < SPINUNIT) {
> > +		/* CHECKME: Make panic default for 1 too? */
> > +		if (tolerant < 1)
> > +			mce_panic("Timeout synchronizing machine check over CPUs",
> > +				  NULL, NULL);
> 
> Assuming that if we came here from mce_start() and panic, then I suppose no mce
> log would be appeared on the console since no cpu have invoked mce_log(&m) yet.

Well it would be rather random if the CPU who detects the timeout
actually has something useful to report.
More likely the useful information is in some CPU's banks who doesn't
answer.

On the other hand the real log will come out to disk after reboot from
the CPU registers (especially together with the new mce panic=30 default)

> Is it expected behavior?

Kind of expected. We could probably fix it, adding a fallback path here,
but due to the reasons above I have my doubts it would improve things
in practice.

> > +	}
> > +	*t -= SPINUNIT;
> > +out:
> > +	touch_nmi_watchdog();
> > +	return 0;
> > +}
> (snip)
> > +/*
> > + * Start of Monarch synchronization. This waits until all CPUs have
> > + * entered the ecception handler and then determines if any of them
>                   ^^^^^^^^^
>                   exception

Thanks fixed. I did actually run the spell checker on the comments,
but that one must have slipped through somehow.

> 
> > +	while (atomic_read(&mce_callin) != cpus) {
> > +		if (mce_timed_out(&timeout)) {
> > +			atomic_set(&global_nwo, 0);
> > +			*order = -1;
> > +			return no_way_out;
> > +		}
> > +		ndelay(SPINUNIT);
> > +	}
> > +
> > +	/*
> > +	 * Cache the global no_way_out state.
> > +	 */
> > +	nwo = atomic_read(&global_nwo);
> > +
> > +	/*
> > +	 * Monarch starts executing now, the others wait.
> > +	 */
> > +	if (*order == 1) {
> > +		atomic_set(&global_nwo, 0);
> 
> Monarch should clear global_nwo after all Subjects have read it.

The subjects don't care about the global nwo state, it only matters to the 
Monarch who does the panic in mce_end(). The only exception would be timeout, 
but in this case all the decisions are local only anyways.
We ensure that all the subjects have written it first.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
