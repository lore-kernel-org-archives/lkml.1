Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbYKGUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbYKGUSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYKGUS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:18:29 -0500
Received: from relais.videotron.ca ([24.201.245.36]:16981 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYKGUS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:18:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 15:18:22 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081107165112.GC22134@Krystal>
Message-id: <alpine.LFD.2.00.0811071513180.13034@xanadu.home>
References: <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
 <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca>
 <20081106220530.5b0e3a96.akpm@linux-foundation.org>
 <25298.1226055815@redhat.com> <20081107165112.GC22134@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:

> * David Howells (dhowells@redhat.com) wrote:
> > Nicolas Pitre <nico@cam.org> wrote:
> > 
> > > > I mean, the darned thing is called from sched_clock(), which can be
> > > > concurrently called on separate CPUs and which can be called from
> > > > interrupt context (with an arbitrary nesting level!) while it was running
> > > > in process context.
> > > 
> > > Yes!  And this is so on *purpose*.  Please take some time to read the 
> > > comment that goes along with it, and if you're still not convinced then 
> > > look for those explanation emails I've already posted.
> > 
> > I agree with Nicolas on this.  It's abominably clever, but I think he's right.
> > 
> > The one place I remain unconvinced is over the issue of preemption of a process
> > that is in the middle of cnt32_to_63(), where if the preempted process is
> > asleep for long enough, I think it can wind time backwards when it resumes, but
> > that's not a problem for the one place I want to use it (sched_clock()) because
> > that is (almost) always called with preemption disabled in one way or another.
> > 
> > The one place it isn't is a debugging case that I'm not too worried about.
> > 
> 
> I am also concerned about the non-preemption off case.
> 
> Then I think the function should document that it must be called with
> preempt disabled.

I explained several times already why I disagree.  Preemption is not a 
problem unless you're preempted away for long enough, or IOW if your 
counter is too fast.

And no, ^Z on a process doesn't create preemption. This is a signal that 
gets acted upon far away from the middle of cnt32_to_63().


Nicolas
