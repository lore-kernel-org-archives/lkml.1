Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZF3Tcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZF3Tcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZF3Tcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:32:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZF3Tcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:32:35 -0400
Date: Tue, 30 Jun 2009 21:32:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: bts & perf_counters
Message-ID: <20090630193229.GD20567@elte.hu>
References: <928CFBE8E7CB0040959E56B4EA41A77EBBD00DC5@irsmsx504.ger.corp.intel.com> <928CFBE8E7CB0040959E56B4EA41A77EBE2DB8EB@irsmsx504.ger.corp.intel.com> <20090624133645.GE6224@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EBE2DB9B9@irsmsx504.ger.corp.intel.com> <20090624153229.GA24346@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EBE2DC3D9@irsmsx504.ger.corp.intel.com> <20090626122948.GC10850@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EBE519869@irsmsx504.ger.corp.intel.com> <20090629202002.GF31577@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77EBE519AE5@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBE519AE5@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> > How does 'interval' get mixed with BTS?
> 
> We could view BTS as event-based sampling with interval=1. The 
> sample we collect is the <from, to> address pair of an executed 
> branch and the sampling interval is 1, i.e. we store a sample for 
> every branch. Wouldn't this be how BTS integrates into 
> perf_counters?

Yeah, this is how i view it too.

> One of the big advantages that comes with using the perf_counter 
> framework is that you could mix branch tracing with other forms of 
> profiling and sampling.

Correct.

> >> Would it be possible for a user to profile the same task twice? 
> >> He could then use different buffers for different sampling 
> >> intervals.
> >
> > It's possibe to open multiple counters to the same task, yes.
> 
> That's good. And users could mmap every counter they open in order 
> to get multiple perf event streams?

Yes.

> OK. The existing implementation reconfigured DS area to have the 
> h/w already collect the trace into the correct buffer. The only 
> copying that is ever needed is to copy it into user-space while 
> translating the arch-specific format into an arch-independent 
> format.
> 
> This is obviously only possible for a single user. Copying the 
> data is definitely more flexible if we expect multiple users of 
> that data with different-sized buffers.

Yeah. [ That decoupling is nice as it also allows multiplexing - 
there's nothing that prevents from two independent monitor tasks 
from sampling the same task. (beyond the inevitable runtime overhead 
that is inherent in BTS anyway.) ]

> > If a task schedules out then it will have its DS area drained 
> > already to the mmap buffer - i.e. it's all properly 
> > synchronized.
> 
> When is that draining done? Somewhere in schedule()? Wouldn't that 
> be quite expensive for a few pages of BTS buffer?

Well, it is an open question how frequently we want to move 
information from the DS area into the mmap pages.

The most direct approach would be to 'flush' the DS from two places: 
the threshold IRQ handler plus from the context switch code if the 
BTS counter gets deactivated. In the latter case BTS activities have 
to stop anyway, so the DS can be flushed to the mmap pages.

Or is your mental model for getting the BTS records from the DS to 
the mmap pages significantly different?

I think we should shoot for the simplest approach initially - we can 
do other, more sophisticated streaming modes later as well - they 
will not differ in functionality, only in performance.

> Hmmm, I'll see what I can do. Please don't expect a minimally 
> working prototype to be bug-free from the beginning.

Sure, i dont.

> I see identifying the beginning of the stream as well as random 
> accesses into the stream as bigger open points.
> 
> Maybe we could add a mode where records are zero-extended to a 
> fixed size. This would leave the choice to the user: compact 
> format or random access.

I agree that streaming is a problem because the debugger does not 
want to poll() really - such an output mode and a 'ignore data_tail 
and overwrite old entries' ring-buffer modus operandi should be 
added.

The latter would be useful for tracepoints too for example, so such 
a 'flight recorder' or 'history buffer' mode is not limited to BTS.

So feel free to add something that meets your constant-size records 
needs - and we'll make sure it fits well into the rest of 
perfcounters.

So based on your suggestion we'd have two streaming models:

 - 'no information loss' output model where user-space poll()s and 
   tries hard not to lose events (this is what profilers and 
   reliable tracers do)

 - 'history ring-buffer' model - this is useful for debuggers and is 
   useful for certain modes of tracing as well. (crash-tracing for 
   example)

	Ingo
