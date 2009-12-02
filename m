Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZLBTTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZLBTTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZLBTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:19:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZLBTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:19:33 -0500
Subject: Re: trace/events: DECLARE vs DEFINE semantic
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091202190135.GA23316@Krystal>
References: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
	 <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 14:19:38 -0500
Message-Id: <1259781578.12870.78.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 14:01 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2009-12-02 at 13:06 -0500, Mathieu Desnoyers wrote:
> > > *
> > > Hrm. I wonder if having DEFINE_EVENT_CLASS is really worth having,
> > > considering that it really just does 2 things at once and may be
> > > confusing.
> > 
> > We keep it because that's what TRACE_EVENT currently is. It would suck
> > to have to replace every TRACE_EVENT there is now with a
> > DECLARE_EVENT_CLASS and DEFINE_EVENT. Although this would push
> > developers into using classes.
> 
> I agree that keeping something for backward compatibility is good, but
> what I dislike the most is the similarity between the
> DECLARE_EVENT_CLASS and DEFINE_EVENT_CLASS which have completely
> unrelated semantics. This is really misleading.

Not really, they are almost identical. But one creates an event with the
class, whereas the other does not. I find this quite convenient.

> > 
> > Egad No! It would make it a living nightmare. The internals reuse the
> > define macro, and there's no intermediate. By changing the
> > DECLARE_EVENT_CLASS to another name (SKETCH_EVENT_CLASS) we would have
> > to add something like this:
> > 
> > #define SKETCH_EVENT_CLASS(name, proto, args, tstruct, print) \
> > 	DECLARE_EVENT_CLASS(name, PARAMS(proto), PARAMS(args),\
> > 		PARAMS(tstruct), PARAMS(print))
> > 
> > We don't have a intermediate or "low level" macro in use here. Whatever
> > we give to the user is what we use.
> > 
> 
> Maybe we should consider having one. e.g.:
> 
> #ifdef CREATE_TRACE_POINTS
> 
> SKETCH_EVENT_CLASS maps to DEFINE_EVENT_CLASS
> 
> #else
> 
> SKETCH_EVENT_CLASS maps to DECLARE_EVENT_CLASS
> 
> #endif

And what? Make another level of needless abstraction? That's sure to not
confuse people.

> 
> > 
> > I think the kernel developers are smart enough to figure out that these
> > macros are not a typical DECLARE/DEFINE that is elsewhere. But I think
> > using the DECLARE/DEFINE names will give them a better idea of what is
> > happening than to make up something completely new.
> 
> In my opinion, re-using a well-known keyword (e.g. DECLARE/DEFINE) but
> applying a different semantic to what is generally agreed upon is a
> recipe for confusing developers and users, who will skip the review of
> some pieces of code assuming they already know what "DECLARE" and
> "DEFINE" stands for.
> 
> I argue here that the content of trace/events/ headers are _not_ per se
> declarations nor definitions, and hence they should not confuse people
> by using inappropriately well-known keywords. They are actually more
> evolved macros that can be turned in either a declaration or definition,
> depending if CREATE_TRACE_POINTS is declared.

And I argue that the semantics here are not too far off to what those
are. Yes, these macros behave differently if CREATE_TRACE_POINTS is
declared or not, but I argue that the average (and below average) kernel
developer is smart enough to understand this difference.


> 
> When I created the markers/tracepoints, Andrew Morton explained to me
> the importance of distinguishing DECLARE vs DEFINE macros. I would
> really like to hear his point of view on the current question.

I would like to hear Andrew's comments too, as well as anyone else.
Randy Dunlap seemed to already approve of these naming conventions, and
he's a pretty picky person too.

Randy, do you agree that the use of DECLARE/DEFINE here is fine, or do
you think that we should come up with a better naming. I do not want to
add any needless abstraction layer for the sake of naming. These macros
are confusing enough without that.

Or do you (or anyone else) have a better name?


-- Steve


