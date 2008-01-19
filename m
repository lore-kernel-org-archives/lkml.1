Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbYASP3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbYASP3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760194AbYASP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:29:44 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:57541 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759734AbYASP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:29:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJ6lkUdMROHU/2dsb2JhbACBV5ASnB4
Date: Sat, 19 Jan 2008 10:29:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080119152939.GA21594@Krystal>
References: <20080116201713.GA14336@Krystal> <Pine.LNX.4.58.0801171440360.28350@gandalf.stny.rr.com> <20080117203740.GA24397@redhat.com> <Pine.LNX.4.58.0801171555120.28350@gandalf.stny.rr.com> <20080118222637.GA30900@Krystal> <Pine.LNX.4.58.0801181735140.13971@gandalf.stny.rr.com> <20080118231928.GA5563@Krystal> <20080119033632.GE27193@redhat.com> <Pine.LNX.4.58.0801182242440.16333@gandalf.stny.rr.com> <20080119042352.GF27193@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080119042352.GF27193@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:26:57 up 76 days, 20:32,  3 users,  load average: 0.69, 0.50,
	0.54
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> On Fri, Jan 18, 2008 at 10:55:27PM -0500, Steven Rostedt wrote:
> > [...]
> > > All this complexity is to be justified by keeping the raw prev/next
> > > pointers from being sent to a naive tracer?  It seems to me way out of
> > > proportion.
> > 
> > Damn, and I just blew away all my marker code for something like this ;-)
> 
> Sorry! :-)
> 
> > [...]
> > We have in sched.c the following marker:
> >  trace_mark(kernel_sched_scheduler, "prev %p next %p", prev, next);
> 
> Fine so far!
> 
> > Then Mathieu can add in some code somewhere (or a module, or something)
> > 	ret = marker_probe_register("kernel_sched_scheduler",
> > 				"prev %p next %p",
> > 				pretty_print_sched_switch, NULL);
> 
> > static void pretty_print_sched_switch(const struct marker *mdata,
> > 				void *private_data,
> > 				const char *format, ...)
> > {
> > 	[...]
> > 	trace_mark(kernel_pretty_print_sched_switch,
> > 		"prev_pid %d next_pid %d prev_state %ld",
> > 		prev->pid, next->pid, prev->state);
> > }
> 
> That marker_probe_register call would need to be done only when the
> embedded (k_p_p_s_s) marker is actually being used.  Otherwise we'd
> lose all the savings of a dormant sched.c marker by always calling
> into pretty_print_sched_switch(), whether or not the k_p_p_s_s marker
> was active.
> 
> In any case, if the naive tracer agrees to become educated about some
> of these markers in the form of intermediary functions like that, they
> need not insist on a second hop through marker territory anyway:
> 
>  static void pretty_print_sched_switch(const struct marker *mdata,
>  				void *private_data,
>  				const char *format, ...)
>  {
>  	[...]
>  	lttng_backend_trace(kernel_pretty_print_sched_switch,
>  		            "prev_pid %d next_pid %d prev_state %ld",
>                		    prev->pid, next->pid, prev->state);
>  }
> 

Oh! perfect then :) Since I already planned my ltt-marker-control kernel
module to connect specialized callbacks instead of the dumb one, it
shouldn't be so hard to do.

I would just have to find another way to declare the trace events (it's
currently embedded in the markers), but it's not a showstopper. I'll try
this.

Thanks to you both for the good proposals,

Mathieu

> 
> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
