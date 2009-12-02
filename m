Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZLBSTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZLBSTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZLBSTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:19:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZLBSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:19:42 -0500
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20091202180633.GF9710@Krystal>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 13:19:47 -0500
Message-Id: <1259777987.12870.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 13:06 -0500, Mathieu Desnoyers wrote:
> *
> Hrm. I wonder if having DEFINE_EVENT_CLASS is really worth having,
> considering that it really just does 2 things at once and may be
> confusing.

We keep it because that's what TRACE_EVENT currently is. It would suck
to have to replace every TRACE_EVENT there is now with a
DECLARE_EVENT_CLASS and DEFINE_EVENT. Although this would push
developers into using classes.

> 
> I would have thought amongst the lines of the following as main API
> (note: "SKETCH" is only a proposal. The idea is to do _not_ use
> declare/define, as it's really something _different_ than what people
> are expecting!)
> 
> SKETCH_EVENT_CLASS()
> 
> SKETCH_EVENT()
> 
> Which would use only DECLARE, or both DECLARE and DEFINE depending if
> CREATE_TRACE_POINTS is set. I see the DECLARE/DEFINE more as the
> "low-level" macros that are actually selected by CREATE_TRACE_POINTS:
> 
> DECLARE_EVENT_CLASS : only performs event class declarations (macros,
> inlines...)
> 
> DECLARE_EVENT : only performs event instance declarations (macros,
> inlines, ...). Depends on the DECLARE_EVENT_CLASS().
> 
> DEFINE_EVENT_CLASS : create instances of template functions.
> 
> DEFINE_EVENT : create event tracepoint functions. Depends on
> DEFINE_EVENT_CLASS().
> 
> This way, it should make digging into the generation system internals
> headhache-free. ;) I think we should really avoid re-using terms people
> are familiar with for things that have a semantic intrincially different
> than what people come to expect.

Egad No! It would make it a living nightmare. The internals reuse the
define macro, and there's no intermediate. By changing the
DECLARE_EVENT_CLASS to another name (SKETCH_EVENT_CLASS) we would have
to add something like this:

#define SKETCH_EVENT_CLASS(name, proto, args, tstruct, print) \
	DECLARE_EVENT_CLASS(name, PARAMS(proto), PARAMS(args),\
		PARAMS(tstruct), PARAMS(print))

We don't have a intermediate or "low level" macro in use here. Whatever
we give to the user is what we use.


I think the kernel developers are smart enough to figure out that these
macros are not a typical DECLARE/DEFINE that is elsewhere. But I think
using the DECLARE/DEFINE names will give them a better idea of what is
happening than to make up something completely new.

-- Steve

