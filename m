Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0CIDfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:35:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63702 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab0CIDfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:35:01 -0500
Message-ID: <4B95C1FC.9030307@cn.fujitsu.com>
Date: Tue, 09 Mar 2010 11:35:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
References: <4B94936B.8030409@cn.fujitsu.com>	 <4B949E43.2010906@cn.fujitsu.com>	 <1268060596.10871.1805.camel@gandalf.stny.rr.com> <1268060858.10871.1807.camel@gandalf.stny.rr.com>
In-Reply-To: <1268060858.10871.1807.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2010-03-08 at 10:03 -0500, Steven Rostedt wrote:
> 
>>> ringbuffer resizing and reseting will increase the ->record_disabled
>>> and then wait until a rcu_shced grace period passes.
>>>
>>> Contrarily, testing ->record_disabled should be at the same
>>> preempt disabled critical region as writing into ringbuffer, otherwise
>>> it will leave a window break ringbuffer resizing or reseting.
>> So the resizing and the resetting need a synchronize_sched() after the
>> disabling of the buffers, right?
> 
> Looking at the code, the synchronize_sched() is already done in
> ring_buffer_resize, and the caller (trace.c:tracing_reset() ) also
> disables the ring buffer and calls synchronize_sched().
> 
> With that, what other window is still opened (after this fix)?
> 

This window is still opened: (RCU vs IDLE vs Tracing)

synchronize_sched() does not protect preempt_disable()/enable() for
idle process. But tracing(function_graph, function) introduce more
preempt_disable()/enable() for idle process. It brings windows.

I bet that this bug is not come from this window.
(I added some strict code to RCU and did stress test,
bug was still occurred.)

