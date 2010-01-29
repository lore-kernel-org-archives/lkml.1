Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735Ab0A2IHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab0A2IHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867Ab0A2IHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:07:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0A2IHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:07:21 -0500
Date: Fri, 29 Jan 2010 09:07:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Dongdong Deng <Dongdong.Deng@windriver.com>, peterz@infradead.org
Subject: Re: [PATCH 1/3] softlockup: add sched_clock_tick() to avoid kernel
 warning on kgdb resume
Message-ID: <20100129080706.GJ14636@elte.hu>
References: <1264631124-4837-1-git-send-email-jason.wessel@windriver.com>
 <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264631124-4837-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> @@ -118,6 +125,14 @@ void softlockup_tick(void)
>  	}
>  
>  	if (touch_ts == 0) {
> +		if (unlikely(per_cpu(softlock_touch_sync, this_cpu))) {
> +			/*
> +			 * If the time stamp was touched atomically
> +			 * make sure the scheduler tick is up to date.
> +			 */
> +			per_cpu(softlock_touch_sync, this_cpu) = false;
> +			sched_clock_tick();
> +		}
>  		__touch_softlockup_watchdog();
>  		return;

Shouldnt just all of touch_softlockup_watchdog() gain this new 
sched_clock_tick() call, instead of doing this ugly flaggery? Or would that 
lock up or misbehave in other ways in some cases?

That would also make the patch much simpler i guess, as we'd only have the 
chunk above.

	Ingo
