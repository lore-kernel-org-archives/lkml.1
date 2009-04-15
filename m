Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZDOJp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZDOJp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZDOJpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:45:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbZDOJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:45:46 -0400
Date: Wed, 15 Apr 2009 11:44:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 5/4] ftrace, workqueuetrace: display work name
Message-ID: <20090415094433.GA32116@elte.hu>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415141250.AC46.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > About event tracing, we want to have something that let us 
> > identifying the events individually. For the works it can be 
> > either the function embedeed in the work, or the work itself. 
> > But do we need both? Since it's rare that a function can be 
> > embedeed in more than two works, I guess we only need one of 
> > those informations. Which one is the more efficient to identify 
> > a work? That can be discussed actually.
> 
> OK. I think function name is enough. I'll drop this patch.

I think function name is what we generally use - and maybe that fits 
better into the function tracer concepts as well.

The 'work' (worklet) itself can often be non-symbolic: some 
dynamically allocated object embedded in another dynamically 
allocated object.

It might make sense to trace it (non-symbolically - just as a 
pointer value) - because to the work flow itself we can see what got 
started and where, and where it got finished, by looking at the work 
object itself.

In other words: the work function is the 'actor' or method, the 
worklet is the 'object'. They are two separate entities and tracing 
_both_ makes sense - as long as it's pervasive enough to understand 
the full life cycle of a worklet:

   worklet initialization (optional)
   queueing
   start of execution
   completion
   destruction/cancellation (optional)

It does not make sense to just trace bits of the life cycle.

Once we have these events instrumented, we can use them to build 
various derived metrics: average latency of queueing, average 
execution time, ratio of execution versus cancellation, etc. etc. We 
can build histograms that summarize informaton, or we can expose the 
full raw and uncut trace history as well.

All of that builds on a complete capture of the essentials of a 
subsystem.

> And also function name has another benefit. symbol name is module 
> unload safe. then we don't need to care module unloading.
> 
> In the other hand, work_struct variable is often static variable. 
> it mean the variable name is often very short.

That is true - but often a worklet is dynamic and then we'll have no 
symbol name to work with at all.

	Ingo
