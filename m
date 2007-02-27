Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbXB0DzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbXB0DzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 22:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXB0DzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 22:55:00 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:59984 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbXB0Dy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 22:54:59 -0500
Date: Mon, 26 Feb 2007 22:54:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       mingo@elte.hu
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227035456.GA15444@Krystal>
References: <20061126170542.GA30771@Krystal> <1164561427.16871.14.camel@localhost.localdomain> <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1172531521.5517.138.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 22:35:11 up 24 days, 17:43,  3 users,  load average: 1.23, 1.15, 1.12
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Mon, 2007-02-26 at 17:14 -0500, Mathieu Desnoyers wrote:
> 
> 
> > For kernel and user space tracing, those small jumps are very annoying :
> > it can show, in a trace, that a fork() appears on a CPU after the first
> > schedule() of the thread on the other CPU : scheduling causality relationship
> > can become very hard to follow. This is only a sample case. Inaccuracy and
> > periodical modification of the clock time (non monotonic) can cause important
> > inaccuracy in performance tests, even on UP systems. A monotonic clock,
> > accessible from anywhere in kernel space (including NMI handler) and
> > from user space is very useful for performance analysis and, more
> > generally, for timestamping data in per cpu buffers so it can be later
> > reordered correctly.
> 
> What about adding a layer below do_gettimeofday() which just scheds the
> adjustment process? That might be reasonable .. The NMI, and userspace
> cases aren't very compelling right now, at least I'm not convinced a
> whole new timing interface is needed ..
> 
> The latency tracing system in the -rt branch modifies the gettimeofday
> facilities , I'm not sure of the correctness of it but it gets called
> from anyplace in the kernel including NMI's . 
> 
> Here's the function,
> 
> cycle_t notrace get_monotonic_cycles(void)
> {
>         cycle_t cycle_now, cycle_delta;
> 
>         /* read clocksource: */
>         cycle_now = clocksource_read(clock);
> 
>         /* calculate the delta since the last update_wall_time: */
>         cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> 
>         return clock->cycle_last + cycle_delta;
> }
> 
> That looks safe. When converting this to nanoseconds you would still get
> the time adjustments but it would be all at once instead of in little
> increments ..
> 

ouch... if the clocksource used is the PIT on x86 :

static cycle_t pit_read(void)
{
        unsigned long flags;
        int count;
        u32 jifs;
        static int old_count;
        static u32 old_jifs;

        spin_lock_irqsave(&i8253_lock, flags);

If an NMI nests over the spinlock, we have a deadlock.

In addition, clock->cycle_last is a cycle_t, defined as a 64 bits on
x86. If is therefore not updated atomically by change_clocksource,
timekeeping_init, timekeeping_resume and update_wall_time. If an NMI
fires right on top of the update, especially around the 32 bits wrap
around, the time will be really fuzzy.

Mathieu

> Daniel
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
