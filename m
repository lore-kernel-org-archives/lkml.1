Return-Path: <linux-kernel-owner+w=401wt.eu-S1760676AbZDQLYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbZDQLYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760602AbZDQLY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:24:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55696 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760085AbZDQLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:24:26 -0400
Message-ID: <49E866D3.1020003@jp.fujitsu.com>
Date: Fri, 17 Apr 2009 20:24:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: Re: [PATCH] [20/28] x86: MCE: Switch x86 machine check handler to
 Monarch election.
References: <20090407507.636692542@firstfloor.org> <20090407150803.1AF0C1D046E@basil.firstfloor.org>
In-Reply-To: <20090407150803.1AF0C1D046E@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> +/*
> + * Check if a timeout waiting for other CPUs happened.
> + */
> +static int mce_timed_out(u64 *t)
> +{
> +	/*
> +	 * The others already did panic for some reason.
> +	 * Bail out like in a timeout.
> +	 * rmb() to tell the compiler that system_state
> +	 * might have been modified by someone else.
> +	 */
> +	rmb();
> +	if (atomic_read(&mce_paniced))
> +		wait_for_panic();
> +	if (!monarch_timeout)
> +		goto out;
> +	if ((s64)*t < SPINUNIT) {
> +		/* CHECKME: Make panic default for 1 too? */
> +		if (tolerant < 1)
> +			mce_panic("Timeout synchronizing machine check over CPUs",
> +				  NULL, NULL);

Assuming that if we came here from mce_start() and panic, then I suppose no mce
log would be appeared on the console since no cpu have invoked mce_log(&m) yet.
Is it expected behavior?

> +		cpu_missing = 1;
> +		return 1;
> +	}
> +	*t -= SPINUNIT;
> +out:
> +	touch_nmi_watchdog();
> +	return 0;
> +}
(snip)
> +/*
> + * Start of Monarch synchronization. This waits until all CPUs have
> + * entered the ecception handler and then determines if any of them
                  ^^^^^^^^^
                  exception

> + * saw a fatal event that requires panic. Then it executes them
> + * in the entry order.
> + * TBD double check parallel CPU hotunplug
> + */
> +static int mce_start(int no_way_out, int *order)
> +{
> +	int nwo;
> +	int cpus = num_online_cpus();
> +	static atomic_t global_nwo;
> +	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
> +
> +	if (!timeout) {
> +		*order = -1;
> +		return no_way_out;
> +	}
> +
> +	atomic_add(no_way_out, &global_nwo);
> +
> +	/*
> +	 * Wait for everyone.
> +	 */
> +	while (atomic_read(&mce_callin) != cpus) {
> +		if (mce_timed_out(&timeout)) {
> +			atomic_set(&global_nwo, 0);
> +			*order = -1;
> +			return no_way_out;
> +		}
> +		ndelay(SPINUNIT);
> +	}
> +
> +	/*
> +	 * Cache the global no_way_out state.
> +	 */
> +	nwo = atomic_read(&global_nwo);
> +
> +	/*
> +	 * Monarch starts executing now, the others wait.
> +	 */
> +	if (*order == 1) {
> +		atomic_set(&global_nwo, 0);

Monarch should clear global_nwo after all Subjects have read it.
Or it should be cleared by last Subject instead.

> +		atomic_set(&mce_executing, 1);
> +		return nwo;
> +	}
> +
> +	/*
> +	 * Now start the scanning loop one by one
> +	 * in the original callin order.
> +	 * This way when there are any shared banks it will
> +	 * be only seen by one CPU before cleared, avoiding duplicates.
> +	 */
> +	while (atomic_read(&mce_executing) < *order) {
> +		if (mce_timed_out(&timeout)) {
> +			atomic_set(&global_nwo, 0);
> +			*order = -1;
> +			return no_way_out;
> +		}
> +		ndelay(SPINUNIT);
> +	}
> +	return nwo;
> +}

Thanks,
H.Seto

