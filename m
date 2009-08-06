Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbZHFJm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbZHFJm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHFJm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:42:58 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:43243 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHFJm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:42:57 -0400
X-SourceIP: 213.93.53.227
Subject: Re: malloc() tracing in perf?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, acme <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       fche <fche@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A7AA008.80309@cs.helsinki.fi>
References: <4A7A8ADD.4080208@cs.helsinki.fi>
	 <1249546610.32113.35.camel@twins> <4A7A9F7F.7080405@cs.helsinki.fi>
	 <4A7AA008.80309@cs.helsinki.fi>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 11:42:40 +0200
Message-Id: <1249551760.32113.83.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 12:19 +0300, Pekka Enberg wrote:
> Pekka Enberg wrote:
> > Hi Peter,
> > 
> > On Thu, 2009-08-06 at 10:48 +0300, Pekka Enberg wrote:
> >>> Hi,
> >>>
> >>> It's me again :-).
> >>>
> >>> I have a little user-space application that is pretty memory hungry 
> >>> and I want to understand why. I started to google around for a memory 
> >>> profiler or a malloc() tracer but didn't seem to find anything really 
> >>> useful.
> >>>
> >>> But then it hit me, why can't I have kmemtrace + perf but for 
> >>> user-space? Something like the "Malloc Trace" shown here:
> >>>
> >>> http://developer.apple.com/documentation/developertools/conceptual/SharkUserGuide/OtherProfilingandTracingTechniques/OtherProfilingandTracingTechniques.html#//apple_ref/doc/uid/TP40005233-CH6-SW17 
> >>>
> >>>
> >>> Does this sound like something that could/should be part of "perf"? 
> >>> How would all this work anyway? Can we intercept malloc() and free() 
> >>> somehow? Where would the data be pushed? Am I just going perf-crazy 
> >>> and trying to turn it into a swiss army knife because it's so easy to 
> >>> use?-)
> > 
> > Peter Zijlstra wrote:
> >> OK, you just trod into a wasp's nest :-)
> >>
> >> That sounds like uprobes, the equivalent of kprobes but for userspace.
> >>
> >> I seem to have heard people are working on such a thing, but I can't
> >> seem to find a single LKML post with 'uprobe' in the subject in the past
> >> two years or something (except for MTUprobe) -- so I guess its not
> >> really going anywhere any fast.
> > 
> > [snip]
> > 
> > Right. Are dynamic tracepoints what we want for malloc() and free() 
> > interception, though? I guess we can just do generic "userspace function 
> > called" events and record the passed parameters. Then "perf memreport" 
> > can just go find all the malloc() and free() calls and construct a 
> > memory profile out of it?
> > 
> > That said, I'd also be interested in wiring my userspace VM garbage 
> > collector to emit similar alloc and free events as well (because perf 
> > already has a JIT symbol map) which makes me think we want generic 
> > "userspace allocated memory" events.

Right, there is the distinction between static and dynamic tracepoints,
and I'm not sure how that'll work out. Most people who've looked at the
subject matter are on CC, so I'm hoping someone will expand.

That said, we could simply LD_PRELOAD malloc and free (new and delete)
like any other memory debugger out there already does, that's not rocket
science (in fact, I've done so on many an occasion).

I remember mpatrol being a hackable code base, but I just looked it up
and its LGPL-v3 so I'm not sure we should be borrowing code from there.
Maybe there is another such creature out there we can borrow code from.

I've got similar ideas for your JIT stuff, you now open-code the tmp
file writing, ideally I'd like to push that into a library and have you
link against something with weak stubs and let perf LD_PRELOAD real code
which will do whatever is needed. That'd rid you of having to know about
where and what to write.

Anyway, malloc/free are easy, but like you say, you might be interested
in other functions which aren't as easy.

