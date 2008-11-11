Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYKKDSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYKKDSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYKKDSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:18:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYKKDSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:18:22 -0500
Date: Mon, 10 Nov 2008 22:18:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: disable tracing on resize
In-Reply-To: <20081111030517.017566077@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811102216240.10298@gandalf.stny.rr.com>
References: <20081111025808.946638585@goodmis.org> <20081111030517.017566077@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka,

I forgot to add you to the Cc list. Could you test this patch to see if it 
fixes the bug you reported. It fixed a bug I was able to reproduce, but I 
was never able to reproduce the exact same bug you have seen.

-- Steve


On Mon, 10 Nov 2008, Steven Rostedt wrote:

> Impact: fix for bug on resize
> 
> This patch addresses the bug found here:
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=11996
> 
> When ftrace converted to the new unified trace buffer, the resizing of
> the buffer was not protected as much as it was originally. If tracing
> is performed while the resize occurs, then the buffer can be corrupted.
> 
> This patch disables all ftrace buffer modifications before a resize
> takes place.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 9f3b478..abfa810 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2676,7 +2676,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  {
>  	unsigned long val;
>  	char buf[64];
> -	int ret;
> +	int ret, cpu;
>  	struct trace_array *tr = filp->private_data;
>  
>  	if (cnt >= sizeof(buf))
> @@ -2704,6 +2704,14 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  		goto out;
>  	}
>  
> +	/* disable all cpu buffers */
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_inc(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_inc(&max_tr.data[cpu]->disabled);
> +	}
> +
>  	if (val != global_trace.entries) {
>  		ret = ring_buffer_resize(global_trace.buffer, val);
>  		if (ret < 0) {
> @@ -2735,6 +2743,13 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>  	if (tracing_disabled)
>  		cnt = -ENOMEM;
>   out:
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_dec(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_dec(&max_tr.data[cpu]->disabled);
> +	}
> +
>  	max_tr.entries = global_trace.entries;
>  	mutex_unlock(&trace_types_lock);
>  
> -- 
> 1.5.6.5
> 
> -- 
> 
> 
