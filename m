Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZESWhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZESWhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 18:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZESWg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 18:36:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34207 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbZESWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 18:36:56 -0400
Date: Tue, 19 May 2009 18:36:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
In-Reply-To: <20090519211704.GA3325@Krystal>
Message-ID: <alpine.DEB.2.00.0905191826031.7816@gandalf.stny.rr.com>
References: <cover.1242763826.git.jbaron@redhat.com> <20090519211704.GA3325@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Christoph ]

On Tue, 19 May 2009, Mathieu Desnoyers wrote:

> * Jason Baron (jbaron@redhat.com) wrote:
> > hi,
> > 
> > After disassembling some of the tracepoints, I've noticed that arguments that
> > are passed as macros or that perform  dereferences, evaluate prior to the
> > tracepoint on/off check. This means that we are needlessly impacting the 
> > off case.
> > 
> > I am proposing to fix this by adding a macro that first checks for on/off and
> > then calls 'trace_##name', preserving type checking. Thus, callsites have to 
> > move from:
> > 
> > trace_block_bio_complete(md->queue, bio);
> > 
> > to:
> > 
> > tracepoint_call(block_bio_complete,  md->queue, bio);
> > 
> 
> I knew this limitation in the first place, but decided it was not worth
> uglifying the tracepoint call site for it.
> 
> The expected use is to pass a pointer or a value as tracepoint argument
> and dereference it in the callback attached to it.
> 
> Is there any _real_ added value for going through this API change pain ?
> 

I agree with Mathieu that I don't think we want to "uglify" the callers. 
But I also agree with Jason that we must not add any overhead to the "off" 
state when we can avoid it.

If it comes down to the two, I would lean towards the "uglify" if it shows 
performance benefits in the "off" case.

Perhaps I'll try to see if I can fool CPP to getting both worlds. But this 
will be tricky :-/

When are we going to get our own C pre-processor?

-- Steve

