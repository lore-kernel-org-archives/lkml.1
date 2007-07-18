Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbXGRHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbXGRHyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXGRHyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:54:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbXGRHyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:54:36 -0400
Date: Wed, 18 Jul 2007 09:54:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] CFS scheduler, -v19
Message-ID: <20070718075417.GA7895@elte.hu>
References: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com> <1184738344.4178.18.camel@raven.themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184738344.4178.18.camel@raven.themaw.net>
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


* Ian Kent <raven@themaw.net> wrote:

> > > ah! It passes in a low-res time source into a high-res time 
> > > interface (pthread_cond_timedwait()). Could you change the 
> > > time(NULL) + 1 to time(NULL) + 2, or change it to:
> > >
> > > 	gettimeofday(&wait, NULL);
> > > 	wait.tv_sec++;
> > >
> > > does this solve the spinning?
> 
> Yes, adding in the offset within the current second appears to resolve 
> the issue. Thanks Ingo.
> 
> > > i'm wondering how widespread this is. If automount is the only app 
> > > doing this then _maybe_ we could get away with it by changing 
> > > automount?
> 
> I don't think the change is unreasonable since I wasn't using an 
> accurate time in the condition wait, so that's a coding mistake on my 
> part which I will fix.

thanks Ian for taking care of this and for fixing it!

Linus, Thomas, what do you think, should we keep the time.c change? 
Automount is one app affected so far, and it's a borderline case: the 
increased (30%) CPU usage is annoying, but it does not prevent the 
system from working per se, and an upgrade to a fixed/enhanced automount 
version resolves it.

The temptation of using a really (and trivially) scalable low-resolution 
time-source (which is _easily_ vsyscall-able, on any platform) for DBMS 
use is really large, to me at least. Should i perhaps add a boot/config 
option that enables/disables this optimization, to allow distros finer
grained control about this? And we've also got to wait whether there's
any other app affected.

	Ingo
