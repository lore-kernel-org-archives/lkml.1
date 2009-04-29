Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZD2Kk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZD2Kk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZD2KkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:40:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZD2KkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:40:11 -0400
Date: Wed, 29 Apr 2009 12:40:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG: Function graph tracer hang
Message-ID: <20090429104006.GE2373@elte.hu>
References: <20090417144055.857407604@goodmis.org> <20090417151135.GG23493@elte.hu> <20090417151303.GA18267@elte.hu> <20090428111223.GA20526@elte.hu> <20090428203244.GE7337@nowhere> <alpine.DEB.2.00.0904281645020.8066@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904281645020.8066@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 28 Apr 2009, Frederic Weisbecker wrote:
> 
> > 
> > Note that the branch profiler does that:
> > 
> > ______f.miss_hit[______r]++;
> > 
> > Which is a read + write on the cacheline.
> > If each "if" are profiled in the timer interrupt, we can
> > have the cachelines doing a ping-pong of dirtifying since the above
> > variable is shared.
> > 
> > Then the timer interrupt becomes slower. The function graph tracer itself makes
> > it slower.
> > Moreover it is traced itself. So not only the "if" in code are traced, but also
> > each "if" processed by the function graph tracer on function calls and returns.
> > 
> > Which means a fair amount of cacheline dirtifying.
> > 
> > Then if the timer interrupt is slowed, and we have a lot of them (1000 Hz),
> > the system spends all of its time inside it.
> > 
> > At least we need the branch tracing to be done per cpu, I guess.
> 
> This can be done by basically reimplementing what percpu does. 
> This is because the data is saved off in its own section at every 
> if statement. We could copy that section per cpu and add code to 
> the incrementors to add only to their own CPU buffers.

Why not just make these variables regular percpu constructs?

> This is low in my priority of things to do, but I'll at least add 
> it to my "to do" list.

I think we should mark the branch tracer as CONFIG_BROKEN - there's 
been too many problems with it. Thoughts?

	Ingo
