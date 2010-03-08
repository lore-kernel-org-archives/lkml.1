Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0CHPDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:03:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64267 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0CHPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:03:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=drjUTJznMZEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=omOdbC7AAAAA:8 a=jLi6EhibbEP4c3Lg2VkA:9 a=8MJZsihnVcqJWlBz1rYA:7 a=AxWqq8iKe2n763JNzxO8HEKuyc0A:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] WARNING: at kernel/trace/ring_buffer.c:3420
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B949E43.2010906@cn.fujitsu.com>
References: <4B94936B.8030409@cn.fujitsu.com>
	 <4B949E43.2010906@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 10:03:16 -0500
Message-ID: <1268060596.10871.1805.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 14:50 +0800, Lai Jiangshan wrote:
> Li Zefan wrote:
> > While running a ftrace test, a kernel warning showed up. The bug is not so
> > easy to reproduce, normally it takes 30 mins to 2 hours.
> > 
> > After revering 3c05d7482777f15e71bb4cb1ba78dee2800dfec6, I ran the test
> > for 15 hours, and the bug seems disapeared.
> > 
> 
> This bug exhausted us, we found a issue: a tiny window which is
> one of causes of this bug. This patch is to close this tiny window.
> (bug is not fixed)
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> ringbuffer resizing and reseting will increase the ->record_disabled
> and then wait until a rcu_shced grace period passes.
> 
> Contrarily, testing ->record_disabled should be at the same
> preempt disabled critical region as writing into ringbuffer, otherwise
> it will leave a window break ringbuffer resizing or reseting.

So the resizing and the resetting need a synchronize_sched() after the
disabling of the buffers, right?

-- Steve

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 8c1b2d2..54191d6 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2232,12 +2232,12 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
>  	if (ring_buffer_flags != RB_BUFFERS_ON)
>  		return NULL;
>  
> -	if (atomic_read(&buffer->record_disabled))
> -		return NULL;
> -
>  	/* If we are tracing schedule, we don't want to recurse */
>  	resched = ftrace_preempt_disable();
>  
> +	if (atomic_read(&buffer->record_disabled))
> +		goto out_nocheck;
> +
>  	if (trace_recursive_lock())
>  		goto out_nocheck;
>  
> @@ -2469,11 +2469,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
>  	if (ring_buffer_flags != RB_BUFFERS_ON)
>  		return -EBUSY;
>  
> -	if (atomic_read(&buffer->record_disabled))
> -		return -EBUSY;
> -
>  	resched = ftrace_preempt_disable();
>  
> +	if (atomic_read(&buffer->record_disabled))
> +		goto out;
> +
>  	cpu = raw_smp_processor_id();
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> 
> 


