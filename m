Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZLBRLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZLBRLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZLBRLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:11:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZLBRLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:11:23 -0500
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
In-Reply-To: <20091202162715.GB9710@Krystal>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
	 <1259761934.12870.12.camel@gandalf.stny.rr.com>
	 <20091202140128.GA2611@elte.hu>
	 <1259764109.12870.37.camel@gandalf.stny.rr.com>
	 <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 12:11:27 -0500
Message-Id: <1259773888.12870.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 11:27 -0500, Mathieu Desnoyers wrote:

> A few questions about the semantic:
> 
> Is "declare" here always only used as a declaration ? (e.g. only in
> headers, never impacted by CREATE_TRACE_POINT ?)

Well yes it is impacted by CREATE_TRACE_POINT, but so is DECLARE_TRACE
for that matter ;-)

The difference is that DECLARE_EVENT_CLASS will at most (with
CREATE_TRACE_POINT) only create the functions that can be used by other
events. It does not create an event itself. That is, it's not much
different than making a "static inline function" except that function
will not be static nor will it be inline ;-)

> 
> Is "define" here always mapping to a definition ? (e.g. to be used in a
> C file to define the class or event handling stub)

The DEFINE_* will create something that can be hooked to the trace
points in other C files.


> 
> I feel that your DEFINE_EVENT_CLASS might actually be doing a bit more
> than just "defining", it would actually also perform the declaration.
> Same goes for "DEFINE_EVENT". So can you tell us a bit more about that
> is the context of templates ?


Well, the macros used by these are totally off the wall anyway :-) So
any name we come up with will not match what the rest of the kernel does
regardless. But we need to give something that is close.

I'm liking more the:

DECLARE_EVENT_CLASS, DEFINE_EVENT, DEFINE_EVENT_CLASS, because I think
that comes the closest to other semantics in the kernel. That is (once
again)

DECLARE_EVENT_CLASS - makes only the class. It does create helper
functions, but if there's no DEFINE_EVENT that uses them, then they are
just wasting space.

The DEFINE_EVENT will create the trace points in the C file that has
CREATE_TRACE_POINTS defined. But it requires the helper functions
created by a previous DECLARE_EVENT_CLASS.

DEFINE_EVENT_CLASS will do both create a EVENT_CLASS template, as well
as a EVENT that uses the class. The name of the class is a separate
namespace as the event. Here both the class and the event have the same
name, but other events can use this class by referencing the name.

DEFINE_EVENT_CLASS(x, ...);

DEFINE_EVENT(x, y, ...);

The DEFINE_EVENT_CLASS will create a class x and an event x, then the
DEFINE_EVENT will create another event y that uses the same class x.


Actually, with the above, we may not need to have DECLARE_EVENT_CLASS()
at all, because why declare a class if you don't have an event to use
it?  But then again, you may not want the name of the class also a name
of an event.

-- Steve


