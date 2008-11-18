Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYKROVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYKROVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYKROVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:21:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYKROVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:21:39 -0500
Date: Tue, 18 Nov 2008 09:21:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <20081117084923.GD28786@elte.hu>
Message-ID: <alpine.DEB.1.10.0811180918480.15003@gandalf.stny.rr.com>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Ingo Molnar wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: help to find the better depth of trace
> > 
> > We decided to arbitrary define the depth of function return trace as 
> > "20". Perhaps this is not enough. To help finding an optimal depth, 
> > we measure now the overrun: the number of functions that have been 
> > missed for the current thread. By default this is not displayed, we 
> > have to do set a particular flag on the return tracer: echo overrun 
> > > /debug/tracing/trace_options And the overrun will be printed on 
> > the right.
> > 
> > As the trace shows below, the current 20 depth is not enough.
> > 
> > update_wall_time+0x37f/0x8c0 -> update_xtime_cache (345 ns) (Overruns: 2838)
> > update_wall_time+0x384/0x8c0 -> clocksource_get_next (1141 ns) (Overruns: 2838)
> > do_timer+0x23/0x100 -> update_wall_time (3882 ns) (Overruns: 2838)
> 
> hm, interesting. Have you tried to figure out what a practical depth 
> limit would be?
> 
> With lockdep we made the experience that function call stacks can be 
> very deep - if we count IRQ contexts too it can be up to 100 in the 
> extreme cases. (but at that stage kernel stack limits start hitting 
> us)
> 
> I'd say 50 would be needed.

I was just looking at the stack tracer, and it pretty much gives us the 
answer ;-)  I'm hitting on max traces around 55, but some of those are asm 
calls. We could do 50 or 60?  We probably want to make sure that the two 
do not come close to hitting. That is, the bottom of the stack to 
overwrite the saved return addresses.

-- Steve
