Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYAWSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYAWSsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYAWSsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:48:43 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:62765 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYAWSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:48:42 -0500
Date: Wed, 23 Jan 2008 13:48:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
In-Reply-To: <20080123182533.GF18698@redhat.com>
Message-ID: <Pine.LNX.4.58.0801231344090.9982@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org>
 <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org>
 <20080123172712.GE18698@redhat.com> <1201111103.6341.73.camel@lappy>
 <20080123182533.GF18698@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jan 2008, Frank Ch. Eigler wrote:
> >
> > Also, the things the latency tracer and latecytop measure are quite
> > different. the latency tracer measures how long a non-schedulable
> > section is, latencytop measures how a task was scheduled away.
>
> The commonality I imagine is not in what sorts of reports they create,
> or where they complete the formatting for and end-user.  It is solely
> whether the kernel-side instrumentation sites can be represented by
> individual markers, so that these particular tools as well as future
> ones don't need to keep inserting custom code in similar or even the
> same places.

So basically just having the marker implementation there to let all
tracers access to irqs enabled/disabled.

One problem is that the hooks are alse in entry.S, so the tracing ends up
being architecture dependent. One solution is to have a "generic" hook for
trace_hardirqs_on/off (kind of like what I did here) and add a marker
inside that. The hooks in entry.S can call the generic function and have
the marker call the registered probes, be that lockdep, latencytap or
latency-trace.

Have the generic hook only be compiled in when one of the tracers or
lockdep is configured on and they select it.

-- Steve

