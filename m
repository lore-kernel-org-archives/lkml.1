Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZD2MYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZD2MYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZD2MYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:24:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZD2MYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:24:37 -0400
Date: Wed, 29 Apr 2009 08:24:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Function graph tracer hang
In-Reply-To: <20090429104006.GE2373@elte.hu>
Message-ID: <alpine.DEB.2.00.0904290818450.8066@gandalf.stny.rr.com>
References: <20090417144055.857407604@goodmis.org> <20090417151135.GG23493@elte.hu> <20090417151303.GA18267@elte.hu> <20090428111223.GA20526@elte.hu> <20090428203244.GE7337@nowhere> <alpine.DEB.2.00.0904281645020.8066@gandalf.stny.rr.com>
 <20090429104006.GE2373@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Tue, 28 Apr 2009, Frederic Weisbecker wrote:
> > 
> > > 
> > > Note that the branch profiler does that:
> > > 
> > > ______f.miss_hit[______r]++;
> > > 
> > > Which is a read + write on the cacheline.
> > > If each "if" are profiled in the timer interrupt, we can
> > > have the cachelines doing a ping-pong of dirtifying since the above
> > > variable is shared.
> > > 
> > > Then the timer interrupt becomes slower. The function graph tracer itself makes
> > > it slower.
> > > Moreover it is traced itself. So not only the "if" in code are traced, but also
> > > each "if" processed by the function graph tracer on function calls and returns.
> > > 
> > > Which means a fair amount of cacheline dirtifying.
> > > 
> > > Then if the timer interrupt is slowed, and we have a lot of them (1000 Hz),
> > > the system spends all of its time inside it.
> > > 
> > > At least we need the branch tracing to be done per cpu, I guess.
> > 
> > This can be done by basically reimplementing what percpu does. 
> > This is because the data is saved off in its own section at every 
> > if statement. We could copy that section per cpu and add code to 
> > the incrementors to add only to their own CPU buffers.
> 
> Why not just make these variables regular percpu constructs?

Because it is a special section. The variables are embedded into the "if" 
statement. We would need to add it to both the percpu section as well as 
its own section.

One section for the per cpu data, the other to print out the data. We use 
the section to gather all the if statements. Hmm, maybe we can simply make 
the linker script put the if section within the percpu section?

> 
> > This is low in my priority of things to do, but I'll at least add 
> > it to my "to do" list.
> 
> I think we should mark the branch tracer as CONFIG_BROKEN - there's 
> been too many problems with it. Thoughts?

You mean the branch profiler? I've been using it without any issues. The 
issues usually come when we have it combined with other tracers on 
large(?) SMP boxes. I don't hit the cacheline bouncing hang on my 4 cores.

-- Steve

