Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab0CKMqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:46:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607Ab0CKMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:46:17 -0500
Date: Thu, 11 Mar 2010 13:46:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
Message-ID: <20100311124608.GG31354@elte.hu>
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
 <4B8FFE55.5070008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8FFE55.5070008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> On 3/3/2010 6:30 PM, Corey Ashford wrote:
> >For your review, this patch adds support for arch-dependent symbolic
> >event names to the "perf stat" tool, and could be expanded to other
> >"perf *" commands fairly easily, I suspect.
> >
> >To support arch-dependent event names without adding arch-dependent code
> >to perf, I added a callout mechanism whereby perf will look for the
> >environment variable: PERF_ARCH_DEP_LIB, and if it exists, it will try
> >to open it as a shared object. If that succeeds, it looks for the symbol
> >"parse_arch_dep_event". If that exists, that function will be called by
> >parse_events() before all of the other event parsing functions in
> >parse-events.c. It is passed the same arguments as the other
> >parse_*_event functions, namely the event string and a pointer to an
> >event attribute structure.
> >
> >As the code existed, "perf stat" would print out the count results, but
> >for raw events (which is how arch-dependent events are supported in
> >perf_events), it would just print out a raw code. This is not
> >acceptable, especially when a symbolic name was placed on the command
> >line. So I changed the code to save away the event name that was passed
> >on the command line, rather than doing a reverse translation to an event
> >string based on the event type and config fields of the attr structure.
> >In this way, there's no need for a reverse translation function in the
> >arch-dependent library; only a event string->attr struct function is
> >needed.
> >
> >I could well be missing something, but I don't understand why reverse
> >translation is ever needed in perf, as long as the tool keeps track of
> >the original event strings.
> 
> A couple of follow-up comments on this patch:
> 
> This functionality was designed to provide a generalized interface to an 
> external event name -> attr struct library, such as libpfm4. libpfm4 has an 
> interface that nearly exactly matches parse_*_event() profiles, so it's 
> quite easy to write a small wrapper function to call libpfm4's function.
> 
> Ingo Molnar discussed adding some visibility to the arch-dependent event 
> names through some other interface, such as through /sys/devices/pmus 
> perhaps, but that discussion is a long way (as far as I know) from having 
> something usable today.  So you could think of this external library 
> approach to be a stop-gap until something better is developed.  When/if that 
> new event naming mechanism becomes available, we can easily remove this 
> external library support from perf.

I'm quite much against stop-gap measures like this - they tend to become 
tomorrow's impossible-to-remove quirk.

If you want extensible events you can already do it by providing an ftrace 
tracepoint event via TRACE_EVENT. They are easy to add and ad-hoc, and are 
supported throughout by perf.

That could be librarized further by providing an /eventfs or /proc/events 
interface to enumerate them.

Or if you want to extend the perf events namespace ABI you can send patches 
for that as well. (It's not a big issue if a particular event is currently 
only supported on Power for example - as long as you make a good effort naming 
and structuring it in a reasonably generic way.)

Thanks,

	Ingo
