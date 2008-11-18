Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYKROs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYKROs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYKROsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:48:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYKROsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:48:50 -0500
Date: Tue, 18 Nov 2008 15:48:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118144838.GB30358@elte.hu>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Mon, 17 Nov 2008, Ingo Molnar wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Impact: help to find the better depth of trace
> > > 
> > > We decided to arbitrary define the depth of function return trace as 
> > > "20". Perhaps this is not enough. To help finding an optimal depth, 
> > > we measure now the overrun: the number of functions that have been 
> > > missed for the current thread. By default this is not displayed, we 
> > > have to do set a particular flag on the return tracer: echo overrun 
> > > > /debug/tracing/trace_options And the overrun will be printed on 
> > > the right.
> > > 
> > > As the trace shows below, the current 20 depth is not enough.
> > > 
> > > update_wall_time+0x37f/0x8c0 -> update_xtime_cache (345 ns) (Overruns: 2838)
> > > update_wall_time+0x384/0x8c0 -> clocksource_get_next (1141 ns) (Overruns: 2838)
> > > do_timer+0x23/0x100 -> update_wall_time (3882 ns) (Overruns: 2838)
> > 
> > hm, interesting. Have you tried to figure out what a practical depth 
> > limit would be?
> > 
> > With lockdep we made the experience that function call stacks can be 
> > very deep - if we count IRQ contexts too it can be up to 100 in the 
> > extreme cases. (but at that stage kernel stack limits start hitting 
> > us)
> > 
> > I'd say 50 would be needed.
> 
> I was just looking at the stack tracer, and it pretty much gives us 
> the answer ;-) I'm hitting on max traces around 55, but some of 
> those are asm calls. We could do 50 or 60?  We probably want to make 
> sure that the two do not come close to hitting. That is, the bottom 
> of the stack to overwrite the saved return addresses.

does the stack tracer properly nest across IRQ entry boundaries 
already on x86? We used to have problems in that area.

	Ingo
