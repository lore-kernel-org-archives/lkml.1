Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYKMOOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYKMOOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbYKMOO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:14:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYKMOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:14:27 -0500
Date: Thu, 13 Nov 2008 09:14:24 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <20081113140102.GA14258@elte.hu>
Message-ID: <alpine.DEB.1.10.0811130907380.7458@gandalf.stny.rr.com>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com> <20081113131939.GA2669@elte.hu> <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
 <20081113140102.GA14258@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Thu, 13 Nov 2008, Ingo Molnar wrote:
> > > 
> > > the obvious solution is to add this to ring_buffer_resize():
> > > 
> > > 	if (!buffer)
> > > 		return size;
> > 
> > Having a NULL buffer return a successful resize is a bit worrisome to me.
> > 
> > And looking at the code I was trying to make sure could never be called
> > if there are no max_tr users:
> > 
> > in update_max_tr
> > 
> > 	buf = tr->buffer;
> > 	tr->buffer = max_tr.buffer;
> > 	max_tr.buffer = buf;
> > 
> > Should all the ring buffer API return success on NULL pointers?
> 
> well, update_max_tr() is only used from tracers which also actually 
> allocate a max trace buffer: irqs/preemptoff, sched-wakeup.

Which is what we expect. But just the fact that there's nothing protecting
update_max_tr from being used by anything else means we really can not 
prove that those are the only three users, without reviewing the code.


> 
> So, can you tell me any way how the patch below could be broken?

I just do not see how we can say resizing a NULL pointer to a given size 
succeeds without actually resizing anything.

>From the comment above the code:

/**
 * ring_buffer_resize - resize the ring buffer
 * @buffer: the buffer to resize.
 * @size: the new size.
 *
 * The tracer is responsible for making sure that the buffer is
 * not being used while changing the size.
 * Note: We may be able to change the above requirement by using
 *  RCU synchronizations.
 *
 * Minimum size is 2 * BUF_PAGE_SIZE.
 *
 * Returns -1 on failure.
 */


To me, the correct response to !buffer is a -1, not size. And a -1 would 
make the ftrace code fail. At least it would not crash.

-- Steve


> 
> 	Ingo
> 
> ------------->
> >From ee51a1de7e3837577412be269e0100038068e691 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 13 Nov 2008 14:58:31 +0100
> Subject: [PATCH] tracing: fix mmiotrace resizing crash
> 
> Pekka reported a crash when resizing the mmiotrace tracer (if only
> mmiotrace is enabled).
> 
> This happens because in that case we do not allocate the max buffer,
> but we try to use it.
> 
> Make ring_buffer_resize() idempotent against NULL buffers.
> 
> Reported-by: Pekka Paalanen <pq@iki.fi>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/ring_buffer.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 231db20..036456c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -538,6 +538,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
>  	LIST_HEAD(pages);
>  	int i, cpu;
>  
> +	/*
> +	 * Always succeed at resizing a non-existent buffer:
> +	 */
> +	if (!buffer)
> +		return size;
> +
>  	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
>  	size *= BUF_PAGE_SIZE;
>  	buffer_size = buffer->pages * BUF_PAGE_SIZE;
> 
> 
