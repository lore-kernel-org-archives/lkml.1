Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYKGLEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYKGLEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbYKGLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:04:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60470 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbYKGLEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:04:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
References: <alpine.LFD.2.00.0811070256450.13034@xanadu.home> <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca> <20081106220530.5b0e3a96.akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Date: Fri, 07 Nov 2008 11:03:35 +0000
Message-ID: <25298.1226055815@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> > I mean, the darned thing is called from sched_clock(), which can be
> > concurrently called on separate CPUs and which can be called from
> > interrupt context (with an arbitrary nesting level!) while it was running
> > in process context.
> 
> Yes!  And this is so on *purpose*.  Please take some time to read the 
> comment that goes along with it, and if you're still not convinced then 
> look for those explanation emails I've already posted.

I agree with Nicolas on this.  It's abominably clever, but I think he's right.

The one place I remain unconvinced is over the issue of preemption of a process
that is in the middle of cnt32_to_63(), where if the preempted process is
asleep for long enough, I think it can wind time backwards when it resumes, but
that's not a problem for the one place I want to use it (sched_clock()) because
that is (almost) always called with preemption disabled in one way or another.

The one place it isn't is a debugging case that I'm not too worried about.

> > /*
> >  * Caller must provide locking to protect *caller_state
> >  */
> 
> NO!  This is meant to be LOCK FREE!

Absolutely.

David
