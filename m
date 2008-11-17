Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYKQWup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYKQWup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYKQWuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:50:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47593 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKQWuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:50:37 -0500
Date: Mon, 17 Nov 2008 23:50:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081117225018.GA25619@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu> <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org> <20081108192957.GA22219@elte.hu> <20081117224358.GA27249@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117224358.GA27249@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Patch being discussed on this thread (commit 0d12cdd) has a 
> regression on one of the test systems here.
> 
> With the patch, I see
> 
> checking TSC synchronization [CPU#0 -> CPU#1]:
> Measured 28 cycles TSC warp between CPUs, turning off TSC clock.
> Marking TSC unstable due to check_tsc_sync_source failed
> 
> Whereas, without the patch syncs pass fine on all CPUs
> 
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> 
> Due to this, TSC is marke unstable, when it is not actually unstable.
> This is because syncs in check_tsc_wrap() goes away due to this commit.
> 
> As per the discussion on this thread, correct way to fix this is to add
> explicit syncs as below?

ah. Yes.

Could you please check whether:

> +	rdtsc_barrier();
>  	start = get_cycles();
> +	rdtsc_barrier();
>  	/*
>  	 * The measurement runs for 20 msecs:
>  	 */
> @@ -61,7 +63,9 @@ static __cpuinit void check_tsc_warp(voi
>  		 */
>  		__raw_spin_lock(&sync_lock);
>  		prev = last_tsc;
> +		rdtsc_barrier();
>  		now = get_cycles();
> +		rdtsc_barrier();

adding the barrier just _after_ the get_cycles() call (but not before 
it) does the trick too? That should be enough in this case.

	Ingo
