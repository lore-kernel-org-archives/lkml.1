Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0CIDy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:54:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab0CIDyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:54:23 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=l-3ljm5jsgfLu-SywfYA:9 a=UzwnKz7mnkYZpleVHqVrDEejLuQA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <4B95C1FC.9030307@cn.fujitsu.com>
References: <4B94936B.8030409@cn.fujitsu.com>
	 <4B949E43.2010906@cn.fujitsu.com>
	 <1268060596.10871.1805.camel@gandalf.stny.rr.com>
	 <1268060858.10871.1807.camel@gandalf.stny.rr.com>
	 <4B95C1FC.9030307@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 22:54:20 -0500
Message-ID: <1268106860.10871.1867.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 11:35 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:
> > On Mon, 2010-03-08 at 10:03 -0500, Steven Rostedt wrote:
> > 
> >>> ringbuffer resizing and reseting will increase the ->record_disabled
> >>> and then wait until a rcu_shced grace period passes.
> >>>
> >>> Contrarily, testing ->record_disabled should be at the same
> >>> preempt disabled critical region as writing into ringbuffer, otherwise
> >>> it will leave a window break ringbuffer resizing or reseting.
> >> So the resizing and the resetting need a synchronize_sched() after the
> >> disabling of the buffers, right?
> > 
> > Looking at the code, the synchronize_sched() is already done in
> > ring_buffer_resize, and the caller (trace.c:tracing_reset() ) also
> > disables the ring buffer and calls synchronize_sched().
> > 
> > With that, what other window is still opened (after this fix)?
> > 
> 
> This window is still opened: (RCU vs IDLE vs Tracing)
> 
> synchronize_sched() does not protect preempt_disable()/enable() for
> idle process. But tracing(function_graph, function) introduce more
> preempt_disable()/enable() for idle process. It brings windows.

It most definitely should. If it does not, then we have major problems.
>From the comment above synchronize_sched(void):

/**
 * synchronize_sched - wait until an rcu-sched grace period has elapsed.
 *
 * Control will return to the caller some time after a full rcu-sched
 * grace period has elapsed, in other words after all currently executing
 * rcu-sched read-side critical sections have completed.   These read-side
 * critical sections are delimited by rcu_read_lock_sched() and
 * rcu_read_unlock_sched(), and may be nested.  Note that preempt_disable(),
 * local_irq_disable(), and so on may be used in place of
 * rcu_read_lock_sched().

I do not see how idle can be ignored here.

> 
> I bet that this bug is not come from this window.
> (I added some strict code to RCU and did stress test,
> bug was still occurred.)
> 

What exactly were you doing when this happened? Was this from Li's test?

-- Steve


