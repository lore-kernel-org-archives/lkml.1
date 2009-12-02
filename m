Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZLBTBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZLBTBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZLBTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:01:32 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:54543 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbZLBTBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:01:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAF5CFktGGNlG/2dsb2JhbACBTtYvhDEE
Date: Wed, 2 Dec 2009 14:01:35 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: trace/events: DECLARE vs DEFINE semantic
Message-ID: <20091202190135.GA23316@Krystal>
References: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org> <1259761934.12870.12.camel@gandalf.stny.rr.com> <20091202140128.GA2611@elte.hu> <1259764109.12870.37.camel@gandalf.stny.rr.com> <20091202144334.GA30359@elte.hu> <1259765735.12870.42.camel@gandalf.stny.rr.com> <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1259777987.12870.70.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:43:45 up  9:34,  4 users,  load average: 0.87, 0.57, 0.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2009-12-02 at 13:06 -0500, Mathieu Desnoyers wrote:
> > *
> > Hrm. I wonder if having DEFINE_EVENT_CLASS is really worth having,
> > considering that it really just does 2 things at once and may be
> > confusing.
> 
> We keep it because that's what TRACE_EVENT currently is. It would suck
> to have to replace every TRACE_EVENT there is now with a
> DECLARE_EVENT_CLASS and DEFINE_EVENT. Although this would push
> developers into using classes.

I agree that keeping something for backward compatibility is good, but
what I dislike the most is the similarity between the
DECLARE_EVENT_CLASS and DEFINE_EVENT_CLASS which have completely
unrelated semantics. This is really misleading.

> 
> > 
> > I would have thought amongst the lines of the following as main API
> > (note: "SKETCH" is only a proposal. The idea is to do _not_ use
> > declare/define, as it's really something _different_ than what people
> > are expecting!)
> > 
> > SKETCH_EVENT_CLASS()
> > 
> > SKETCH_EVENT()
> > 
> > Which would use only DECLARE, or both DECLARE and DEFINE depending if
> > CREATE_TRACE_POINTS is set. I see the DECLARE/DEFINE more as the
> > "low-level" macros that are actually selected by CREATE_TRACE_POINTS:
> > 
> > DECLARE_EVENT_CLASS : only performs event class declarations (macros,
> > inlines...)
> > 
> > DECLARE_EVENT : only performs event instance declarations (macros,
> > inlines, ...). Depends on the DECLARE_EVENT_CLASS().
> > 
> > DEFINE_EVENT_CLASS : create instances of template functions.
> > 
> > DEFINE_EVENT : create event tracepoint functions. Depends on
> > DEFINE_EVENT_CLASS().
> > 
> > This way, it should make digging into the generation system internals
> > headhache-free. ;) I think we should really avoid re-using terms people
> > are familiar with for things that have a semantic intrincially different
> > than what people come to expect.
> 
> Egad No! It would make it a living nightmare. The internals reuse the
> define macro, and there's no intermediate. By changing the
> DECLARE_EVENT_CLASS to another name (SKETCH_EVENT_CLASS) we would have
> to add something like this:
> 
> #define SKETCH_EVENT_CLASS(name, proto, args, tstruct, print) \
> 	DECLARE_EVENT_CLASS(name, PARAMS(proto), PARAMS(args),\
> 		PARAMS(tstruct), PARAMS(print))
> 
> We don't have a intermediate or "low level" macro in use here. Whatever
> we give to the user is what we use.
> 

Maybe we should consider having one. e.g.:

#ifdef CREATE_TRACE_POINTS

SKETCH_EVENT_CLASS maps to DEFINE_EVENT_CLASS

#else

SKETCH_EVENT_CLASS maps to DECLARE_EVENT_CLASS

#endif

> 
> I think the kernel developers are smart enough to figure out that these
> macros are not a typical DECLARE/DEFINE that is elsewhere. But I think
> using the DECLARE/DEFINE names will give them a better idea of what is
> happening than to make up something completely new.

In my opinion, re-using a well-known keyword (e.g. DECLARE/DEFINE) but
applying a different semantic to what is generally agreed upon is a
recipe for confusing developers and users, who will skip the review of
some pieces of code assuming they already know what "DECLARE" and
"DEFINE" stands for.

I argue here that the content of trace/events/ headers are _not_ per se
declarations nor definitions, and hence they should not confuse people
by using inappropriately well-known keywords. They are actually more
evolved macros that can be turned in either a declaration or definition,
depending if CREATE_TRACE_POINTS is declared.

When I created the markers/tracepoints, Andrew Morton explained to me
the importance of distinguishing DECLARE vs DEFINE macros. I would
really like to hear his point of view on the current question.

Thanks,

Mathieu


> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
