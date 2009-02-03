Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZBCFBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZBCFBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbZBCFBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:01:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZBCFBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:01:45 -0500
Date: Mon, 2 Feb 2009 21:00:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] trace: fix default boot up tracer
Message-Id: <20090202210042.fdd589ff.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902022327080.2192@gandalf.stny.rr.com>
References: <20090203023830.440860800@goodmis.org>
	<20090203024358.332574797@goodmis.org>
	<20090202195021.83bd0b80.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902022302060.2192@gandalf.stny.rr.com>
	<20090202202041.6256a566.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902022327080.2192@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 23:33:52 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2 Feb 2009, Andrew Morton wrote:
> > > 
> > > The lock_kernel addition was added when the BKL became a spinlock again. 
> > > The selftests needed to be able to sleep, and this caused issues.
> > 
> > Sleeping inside lock_kernel() is quite OK.  Confused.
> 
> I did not explain that quite well. I need to focus on the emails 
> that I write, and not do it half concentrating on code that I'm
> also writing :-/
> 
> The preempt tracer expects preemption enabled when the self test is 
> executed. Because the self test for preempt tracer is basically:
> 
> start_trace();
> preempt_disable();
> udelay(x);
> preempt_enable();
> stop_trace();
> 
> make sure we have a delay.
> 
> This failed, because lock_kernel now disables preemption. So that 
> preempt_disable() never triggers the trace, and the test sees that nothing 
> was recorded. This causes a failure to be flagged, and we disable the 
> preempt tracer.

OK.

It might be a bit cleaner to run all the selftests later, after
start_kernel() has done unlock_kernel().  That would make it even
harder to support modular tracers in the future though.

Perhaps the preempt tracer could itself do

	if (kernel_locked()) {
		kernel_was_locked = true;
		unlock_kernel();
	}
	...
