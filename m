Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYHSLGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYHSLGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHSLGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:06:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbYHSLGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:06:37 -0400
Date: Tue, 19 Aug 2008 13:05:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080819110557.GA18608@elte.hu>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819103844.459178947@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Disable bandwidth control by default.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -824,9 +824,9 @@ static __read_mostly int scheduler_runni
>  
>  /*
>   * part of the period that we allow rt tasks to run in us.
> - * default: 0.95s
> + * default: inf
>   */
> -int sysctl_sched_rt_runtime = 950000;
> +int sysctl_sched_rt_runtime = -1;

The fixes look good to me, but this enabling of infinite RT task lockups 
is not an improvement.

The thing is, i got far more bugreports about locked up RT tasks where 
the lockup was unintentional, than real bugreports about anyone 
_intending_ for the whole box to come to a grinding halt because a 
high-prio RT tasks is monopolizing the CPU.

In fact there's only been this artificial test so far.

So could you please just increase the chunking to 10 seconds or so, from 
the current 1 second? Anyone locking up the system for more than 10 
seconds via an RT task has to deal with many other issues already.

I.e. keep the system borderline debuggable (up to 10 seconds delays are 
_not_ nice so people will notice) - but it's still a marked improvement 
from completly locked up desktops.

And those who really need longer than 10 second periods can set it 
higher, or even (if they want to live dangerously or run POSIX 
conformance tests) make it infinite (set it to -1) - and will have to 
deal with other things like the softlockup watchdog as well.

Ok?

	Ingo
