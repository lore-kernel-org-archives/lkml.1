Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYGPLl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYGPLl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYGPLlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:41:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYGPLlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:41:20 -0400
Date: Wed, 16 Jul 2008 07:41:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] sched_clock: stop maximum check on NO HZ
In-Reply-To: <1216206895.5232.41.camel@twins>
Message-ID: <Pine.LNX.4.58.0807160739400.31086@gandalf.stny.rr.com>
References: <20080707181649.942597764@goodmis.org>  <20080707182104.327343504@goodmis.org>
 <1216206895.5232.41.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jul 2008, Peter Zijlstra wrote:

>
> On Mon, 2008-07-07 at 14:16 -0400, Steven Rostedt wrote:
> > plain text document attachment (sched-clock-no-max-from-idle.patch)
> > Working with ftrace I would get large jumps of 11 millisecs or more with
> > the clock tracer. This killed the latencing timings of ftrace and also
> > caused the irqoff self tests to fail.
> >
> > What was happening is with NO_HZ the idle would stop the jiffy counter and
> > before the jiffy counter was updated the sched_clock would have a bad
> > delta jiffies to compare with the gtod with the maximum.
> >
> > The jiffies would stop and the last sched_tick would record the last gtod.
> > On wakeup, the sched clock update would compare the gtod + delta jiffies
> > (which would be zero) and compare it to the TSC. The TSC would have
> > correctly (with a stable TSC) moved forward several jiffies. But because the
> > jiffies has not been updated yet the clock would be prevented from moving
> > forward because it would appear that the TSC jumped too far ahead.
> >
> > The clock would then virtually stop, until the jiffies are updated. Then
> > the next sched clock update would see that the clock was very much behind
> > since the delta jiffies is now correct. This would then jump the clock
> > forward by several jiffies.
> >
> > This caused ftrace to report several milliseconds of interrupts off
> > latency at every resume from NO_HZ idle.
> >
> > This patch adds hooks into the nohz code to disable the checking of the
> > maximum clock update when nohz is in effect. It resumes the max check
> > when nohz has updated the jiffies again.
>
> IIRC we have code to move jiffies forward over no_hz periods too. So
> could this be an ordering issue, in that we should update the jiffies
> before we do this bit?
>
> Wouldn't be the first time ftrace causes ordering issues..
>
> /me goes look for where that jiffie stuff was done again.

The problem is that ftrace calls this code at every function, and even
when function_trace is not on, the irqsoff tracer will call it from
assembly. In-other-words, ftrace will use it before you even have a chance
to update the jiffies.

-- Steve

