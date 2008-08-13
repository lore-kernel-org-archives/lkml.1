Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYHMRxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYHMRxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYHMRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:52:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60042 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbYHMRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:52:49 -0400
Date: Wed, 13 Aug 2008 19:52:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: invalidate caches before going into suspend
Message-ID: <20080813175232.GA1127@elte.hu>
References: <200808131141.18003.mark.langsdorf@amd.com> <200808131209.57534.mark.langsdorf@amd.com> <alpine.LFD.1.10.0808131011050.3462@nehalem.linux-foundation.org> <200808131230.07581.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131230.07581.mark.langsdorf@amd.com>
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


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> On Wednesday 13 August 2008, Linus Torvalds wrote:
> > 
> > On Wed, 13 Aug 2008, Mark Langsdorf wrote:
> > > 
> > > I don't think it's necessary.  I can submit a delta patch later if you
> > > think it's really necessary.
> > 
> > Why not at least move it to after the local_irq_disable()?
> > 
> > That local_irq_disable() will do tons of writes if you have 
> > lockdep enabled, it calls trace_hardirqs_off() etc. Maybe they don't end 
> > up ever mattering, but wouldn't it make much more sense to just move the 
> > wbinvd down to just before the
> > 
> > 	while (1)
> > 		halt();
> > 
> > which is also likely to make sure that the compiler won't do anything at 
> > all because everything is dead at that point with no function calls etc 
> > happening.
> 
> I don't think we realized that local_irq_disable() did all that and so 
> we only tested the submitted patch.  I've resubmitted the unified 
> patch after applying your suggestion.  Thanks.

Thanks, this looks much better. Please create a wbinvd_halt() variant 
a'la safe_halt() and please also add comments why that is needed.

That way no instrumentation or other detail can ever get into that code 
sequence. (full-blown debug labs with hw tracing facilities are really 
an exception :-)

Note that the original bug was introduced with the original hotplug CPU 
support, more than 3 years ago, via commit 76e4f660d9 - and the CLI was 
inserted in the wrong place via commit 1fa744e6e, 2.5 years ago.

That gives a ballpark figure about the time it takes for CPU cache 
corruption bugs to be found. So if we find a bug that matches such 
patterns we absolutely want to overdo every single related detail there 
- we really dont want to wait another 3 years if another bug creeps in 
there sometime in the future.

( Even if you redo this patch it's still all v2.6.27-worthy material in 
  my opinion, obviously. It's a cool fix and it must have been 
  absolutely hard to debug it. )

	Ingo
