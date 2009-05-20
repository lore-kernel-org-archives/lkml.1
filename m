Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZETAdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZETAdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZETAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:33:15 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:65445 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbZETAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:33:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAG/rEkpMQW1W/2dsb2JhbACBT81phAIF
Date: Tue, 19 May 2009 20:33:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
Message-ID: <20090520003314.GA8790@Krystal>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal> <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:31:22 up 80 days, 20:57,  3 users,  load average: 0.44, 0.56,
	0.52
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> [ added Christoph ]
> 
> On Tue, 19 May 2009, Mathieu Desnoyers wrote:
> 
> > * Jason Baron (jbaron@redhat.com) wrote:
> > > hi,
> > > 
> > > After disassembling some of the tracepoints, I've noticed that arguments that
> > > are passed as macros or that perform  dereferences, evaluate prior to the
> > > tracepoint on/off check. This means that we are needlessly impacting the 
> > > off case.
> > > 
> > > I am proposing to fix this by adding a macro that first checks for on/off and
> > > then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> > > move from:
> > > 
> > > trace_block_bio_complete(md->queue, bio);
> > > 
> > > to:
> > > 
> > > tracepoint_call(block_bio_complete,  md->queue, bio);
> > > 
> > 
> > I knew this limitation in the first place, but decided it was not worth
> > uglifying the tracepoint call site for it.
> > 
> > The expected use is to pass a pointer or a value as tracepoint argument
> > and dereference it in the callback attached to it.
> > 
> > Is there any _real_ added value for going through this API change pain ?
> > 
> 
> I agree with Mathieu that I don't think we want to "uglify" the callers. 
> But I also agree with Jason that we must not add any overhead to the "off" 
> state when we can avoid it.
> 
> If it comes down to the two, I would lean towards the "uglify" if it shows 
> performance benefits in the "off" case.
> 

Given the tradeoff is taste vs overhead, what do you think of the
following proposal ?

trace(block_bio_complete, md->queue, bio);

?

I'm thinking that it may just be the "tracepoint_call" name that's a bit
too verbose for its own good.

Mathieu

> Perhaps I'll try to see if I can fool CPP to getting both worlds. But this 
> will be tricky :-/
> 
> When are we going to get our own C pre-processor?
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
