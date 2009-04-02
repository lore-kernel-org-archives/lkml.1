Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbZDBQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbZDBQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZDBQ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:58:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbZDBQ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:58:11 -0400
Date: Thu, 2 Apr 2009 18:57:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] itimers: periodic timers fixes
Message-ID: <20090402165753.GA12793@elte.hu>
References: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402141135.655d1b2b@dhcp-lab-109.englab.brq.redhat.com>
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


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Hi.
> 
> We found the periodic timers ITIMER_PROF and ITIMER_VIRT are 
> unreliable, they have systematic timing error. For example period 
> of 10000 us will not be represented by the kernel as 10 ticks, but 
> 11 (for HZ=1000). The reason is that the frequency of the hardware 
> timer can only be chosen in discrete steps and the actual 
> frequency is about 1000.152 Hz. So 10 ticks would take only about 
> 9.9985 ms, the kernel decides it must never return earlier than 
> requested, so it rounds the period up to 11 ticks. This results in 
> a systematic multiplicative timing error of -10 %. The situation 
> is even worse where application try to request with 1 thick 
> period. It will get the signal once per two kernel ticks, not on 
> every tick. The systematic multiplicative timing error is -50 %. 
> He have program [1] that shows itimers systematic error, results 
> are below [2].
> 
> To fix situation we wrote two patches. First one just simplify 
> code related with itimers. Second is fix, it change intervals 
> measurement resolutions and correct times when signal is 
> generated. However this add some drawback, that I'm not sure if 
> are acceptable:
> 
> - the time between two consecutive tics can be smaller than 
>   requested interval
> 
> - intervals values which are returned to user by getitimer() are 
>   not rounded up
> 
> Second drawback mean that applications which first call 
> setitimer() then call getitimer() to see if interval was round up 
> and to correct timings, will potentially stop works. However this 
> can be only problem with requested interval smaller than 1/HZ, as 
> for intervals > 1/Hz we can generate signals with proper 
> resolution.

Converting those to GTOD sampling instead of jiffies sampling is a 
worthwile change IMO and a good concept.

The unificaton of ITIMER_PROF and ITIMER_VIRT is a nice observation 
and a good patch.

The second one, changing all the sampling from cputime to ktime_t is 
nicely done too:

We could do more though, there's still a bit of cputime legacies 
around:

+	cputime_t cval, nval;

Couldnt all of that go over into the ktime_t space as well, phasing 
out cputime logic from the itimer code?

The user ABI is struct timeval based, so there's no need to have 
cputime anywhere. The scheduler does nanoseconds accurate stats so 
it can be connected up there too.

	Ingo
