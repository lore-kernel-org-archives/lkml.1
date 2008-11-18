Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYKRQbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYKRQbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYKRQbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:31:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYKRQa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:30:59 -0500
Date: Tue, 18 Nov 2008 17:30:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081118163037.GD8088@elte.hu>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu> <20081118044403.GA32759@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118044403.GA32759@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Markers identify the name (and therefore numeric ID) to attach to an 
> "event" and the data types to export into trace buffers for this 
> specific event type. These data types are fully expressed in a 
> marker format-string table recorded in a "metadata" channel. The 
> size of the various basic types and the endianness is recorded in 
> the buffer header. Therefore, the binary trace buffers are 
> self-described.
> 
> Data is exported through binary trace buffers out of kernel-space, 
> either by writing directly to disk, sending data over the network, 
> crash dump extraction, etc.

Streaming gigabytes of data is really mostly only done when we know 
_nothing_ useful about a failure mode and are _forced_ into logging 
gobs and gobs of data at great expense.

And thus in reality this is a rather uninteresting usecase.

We do recognize and support it as it's a valid "last line of defense" 
for system and application failure analysis, but we should also put it 
all into proper perspective: it's the rare and abnormal exception, not 
the design target.

Note that we support this mode of tracing today already: we can 
already stream binary data via the ftrace channel - the ring buffer 
gives the infrastructure for that. Just do:

  # echo bin > /debug/tracing/trace_options

... and you'll get the trace data streamed to user-space in an 
efficient, raw, binary data format!

This works here and today - and if you'd like it to become more 
efficient within the ftrace framework, we are all for it. (It's 
obviously not the default mode of output, because humans prefer ASCII 
and scriptable output formats by a _wide_ margin.)

Almost by definition anything opaque and binary-only that goes from 
the kernel to user-space has fundamental limitations: it just doesnt 
actively interact with the kernel for us to be able to form a useful 
and flexible filter of information around it.

The _real_ solution to tracing in 99% of the cases is to intelligently 
limit information - it's not like the user will read and parse 
gigabytes of data ...

Look at the myriads of rather useful ftrace plugins we have already 
and that sprung out of nothing. Compare it to the _10 years_ of 
inaction that more static tracing concepts created. Those plugins work 
and spread because it all lives and breathes within the kernel, and 
almost none of that could be achieved via the 'stream binary data to 
user-space' model you are concentrating on.

So in the conceptual space i can see little use for markers in the 
kernel that are not tracepoints (i.e. not actively used by a real 
tracer). We had markers in the scheduler initially, then we moved to 
tracepoints - and tracepoints are much nicer.

[ And you wrote both markers and tracepoints, so it's not like i risk
  degenerating this discussion into a flamewar by advocating one of 
  your solutions over the other one ;-) ]

... and in that sense i'd love to see lttng become a "super ftrace 
plugin", and be merged upstream ASAP.

We could even split it up into multiple bits as its merged: for 
example syscall tracing would be a nice touch that a couple of other 
plugins would adapt as well. But every tracepoint should have some 
active role and active connection to a tracer.

And we'd keep all those tracepoints open for external kprobes use as 
well - for the dynamic tracers, as a low-cost courtesy. (no long-term 
API guarantees though.)

Hm?

	Ingo
