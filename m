Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYF0Mnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYF0Mnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYF0Mnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:43:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYF0Mnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:43:40 -0400
Date: Fri, 27 Jun 2008 14:43:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] softlockup: fix watchdog task wakeup frequency
Message-ID: <20080627124329.GA14576@elte.hu>
References: <20080627000445.346130358@saeurebad.de> <20080627000805.504878592@saeurebad.de> <20080627120350.GB30872@elte.hu> <87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prq3xdjv.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> Hm, it updates the timestamp, so it makes only sense if it runs at a 
> maximum every second (timestamp granularity) or even less.  The check 
> for hung tasks uses the cpu timestamp as well for comparison, so that 
> would be okay too.
> 
> Like this?
> 
> diff --git a/kernel/softlockup.c b/kernel/softlockup.c
> index c828c23..b884546 100644
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -106,8 +106,9 @@ void softlockup_tick(void)
>  
>  	now = get_timestamp(this_cpu);
>  
> -	/* Wake up the high-prio watchdog task every second: */
> -	if (now > (touch_timestamp + 1))
> +	/* Wake up the high-prio watchdog task twice per
> +	 * threshold timespan. */
> +	if (now > (touch_timestamp + softlockup_thresh / 2))
>  		wake_up_process(per_cpu(watchdog_task, this_cpu));

yeah - but please use the best possible coding style. Two-line comments 
should be in the:

  /*
   * Here we ......................
   * ........................ come:
   */

... format. And the arithmetics should be:

	if (now > touch_timestamp + softlockup_thresh/2)

(the unnecessary paranthesis was a small style mistake in the original 
too)

	Ingo
