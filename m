Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYIQTKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYIQTKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYIQTKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:10:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYIQTKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:10:38 -0400
Date: Wed, 17 Sep 2008 21:10:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Howells <dhowells@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: fix jiffie fallback clock
Message-ID: <20080917191023.GA23724@elte.hu>
References: <1221503179.7154.2.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221503179.7154.2.camel@lappy.programming.kicks-ass.net>
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

> David pointed out that the default sched_clock() fallback is broken in 
> that it wraps too soon. Fix this by using the 64 bit jiffie value so 
> that we're large enough to overflow properly.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: David Howells <dhowells@redhat.com>

FYI, -tip testing found bootup hard-lockups today on 32-bit 
testsystems.

I've bisected it down to this change. After some head-scratching and an 
hour of debugging, it turns out that this aspect:

> @@ -46,10 +46,8 @@ u64 native_sched_clock(void)
>        *   very important for it to be as fast as the platform
>        *   can achive it. )
>        */
> -     if (unlikely(tsc_disabled)) {
> -             /* No locking but a rare wrong value is not a big deal: */
> -             return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
> -     }
> +     if (unlikely(tsc_disabled))
> +             return (get_jiffies_64() - INITIAL_JIFFIES) * (NSEC_PER_SEC/HZ);

is the buggy one: it calls get_jiffies_64() which does:

                seq = read_seqbegin(&xtime_lock);

that's not a very wise thing to do within xtime-locked sections - and we 
do call cpu_clock()/sched_clock() in a number of xtime-locked sections.

So i've zapped this commit for the time being, this needs to be solved 
differently.

	Ingo
