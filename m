Return-Path: <linux-kernel-owner+w=401wt.eu-S937733AbXGSJ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937733AbXGSJ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXGSJ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:27:37 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:35415 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXGSJ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:27:36 -0400
Date: Thu, 19 Jul 2007 10:16:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070719081650.GA14299@elte.hu>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707180852540.27353@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > ah! It passes in a low-res time source into a high-res time 
> > interface (pthread_cond_timedwait()). Could you change the 
> > time(NULL) + 1 to time(NULL) + 2, or change it to:
> > 
> > 	gettimeofday(&wait, NULL);
> > 	wait.tv_sec++;
> 
> This is wrong. It's wrong for two reasons:
> 
>  - it really shouldn't be needed. I don't think "time()" has to be 
>    *exactly* in sync, but I don't think it can be off by a third of a 
>    second or whatever (as the "30% CPU load" would seem to imply)
> 
>  - gettimeofday works on a timeval, pthread_cond_timedwait() works on a 
>    timespec.

ah, i didnt notice that automount mixed up timespec with timeval! That 
is nasty and the tv_nsec field (which really is ts_usec to 
pthread_cond_timewait()) must stay cleared - or rather, to avoid bugs of 
this type, a timespec variable should be used for all this.

> So if it actually makes a difference, it makes a difference for the 
> *wrong* reason: the time is still totally nonsensical in the tv_nsec 
> field (because it actually got filled in with msecs!), but now the 
> tv_sec field is in sync, so it hides the bug.
> 
> Anyway, hopefully the patch below might help. But we probably should make 
> this whole thing a much more generic routine (ie we have our internal 
> "getnstimeofday()" that still is missing the second-overflow logic, and 
> that is quite possibly the one that triggers the "30% off" behaviour).

yeah, i'll generalize it, but our internal getnstimeofday() used on most 
architectures is using __get_realtime_clock_ns(), and the patch you 
attached already adds the second-overflow logic to it.

there are two versions of getnstimeofday(), a TIME_INTERPOLATION one and 
a !TIME_INTERPOLATION one. TIME_INTERPOLATION is only used on ia64 at 
the moment - and that one indeed does not have the second overflow 
logic.

> Ingo, I'd suggest:
>  - ger rid of "timespec_add_ns()", or at least make it return a return 
>    value for when it overflows.
>  - make all the people who overflow into tv_sec call a "fix_up_seconds()" 
>    thing that does the xtime overflow handling.

ok, i'll do something clean.

	Ingo
