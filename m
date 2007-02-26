Return-Path: <linux-kernel-owner+w=401wt.eu-S1161396AbXBZXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396AbXBZXOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161397AbXBZXOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:14:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14812 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161396AbXBZXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:14:19 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       mingo@elte.hu
In-Reply-To: <20070226221423.GA2286@Krystal>
References: <20061124215904.GI25048@Krystal>
	 <1164475747.5196.5.camel@localhost.localdomain>
	 <20061126170542.GA30771@Krystal>
	 <1164561427.16871.14.camel@localhost.localdomain>
	 <20061126231833.GA22241@Krystal>
	 <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 15:12:01 -0800
Message-Id: <1172531521.5517.138.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 17:14 -0500, Mathieu Desnoyers wrote:


> For kernel and user space tracing, those small jumps are very annoying :
> it can show, in a trace, that a fork() appears on a CPU after the first
> schedule() of the thread on the other CPU : scheduling causality relationship
> can become very hard to follow. This is only a sample case. Inaccuracy and
> periodical modification of the clock time (non monotonic) can cause important
> inaccuracy in performance tests, even on UP systems. A monotonic clock,
> accessible from anywhere in kernel space (including NMI handler) and
> from user space is very useful for performance analysis and, more
> generally, for timestamping data in per cpu buffers so it can be later
> reordered correctly.

What about adding a layer below do_gettimeofday() which just scheds the
adjustment process? That might be reasonable .. The NMI, and userspace
cases aren't very compelling right now, at least I'm not convinced a
whole new timing interface is needed ..

The latency tracing system in the -rt branch modifies the gettimeofday
facilities , I'm not sure of the correctness of it but it gets called
from anyplace in the kernel including NMI's . 

Here's the function,

cycle_t notrace get_monotonic_cycles(void)
{
        cycle_t cycle_now, cycle_delta;

        /* read clocksource: */
        cycle_now = clocksource_read(clock);

        /* calculate the delta since the last update_wall_time: */
        cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;

        return clock->cycle_last + cycle_delta;
}

That looks safe. When converting this to nanoseconds you would still get
the time adjustments but it would be all at once instead of in little
increments ..

Daniel

