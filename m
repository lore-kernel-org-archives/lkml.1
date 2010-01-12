Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621Ab0ALDjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0ALDjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363Ab0ALDjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:39:36 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:34518 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab0ALDjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZSbPVkupJAaqZliYblW2ZBRsBZcheO6VYk67aVIVomwGPT0zMweTpJ3hnk5ZUXP69b
         bgQf9WotIaR1BFK/c+R9km5P6GE1IBaoOnvbMtfO1Gzh8UYXDI8sncQ6qqtnMu1wBilf
         29kOEDz3TCOmpUGCvaNX7OMevhR5SY5jZz/wc=
Date: Tue, 12 Jan 2010 04:39:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 14/26] trace: Convert various locks to raw_spinlock
Message-ID: <20100112033931.GF5243@nowhere>
References: <1263245216-14754-6-git-send-email-jkacur@redhat.com> <1263245216-14754-7-git-send-email-jkacur@redhat.com> <1263245216-14754-8-git-send-email-jkacur@redhat.com> <1263245216-14754-9-git-send-email-jkacur@redhat.com> <1263245216-14754-10-git-send-email-jkacur@redhat.com> <1263245216-14754-11-git-send-email-jkacur@redhat.com> <1263245216-14754-12-git-send-email-jkacur@redhat.com> <1263245216-14754-13-git-send-email-jkacur@redhat.com> <1263245216-14754-14-git-send-email-jkacur@redhat.com> <1263245216-14754-15-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263245216-14754-15-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 10:26:44PM +0100, John Kacur wrote:
> Convert locks that cannot sleep in preempt-rt to raw_spinlocks.
> 
> See also: 87654a70523a8c5baadcbbc07d80cbae8f912837
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  kernel/trace/ring_buffer.c   |   52 +++++++++++++++++++++---------------------
>  kernel/trace/trace.c         |   10 ++++----
>  kernel/trace/trace_irqsoff.c |    6 ++--
>  3 files changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 2326b04..ffaddc5 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -422,7 +422,7 @@ int ring_buffer_print_page_header(struct trace_seq *s)
>  struct ring_buffer_per_cpu {
>  	int				cpu;
>  	struct ring_buffer		*buffer;
> -	spinlock_t			reader_lock;	/* serialize readers */
> +	raw_spinlock_t			reader_lock;	/* serialize readers */



Why this one? This is a reader lock, not taken in any tracing fast path
places. Why should it never sleep in rt, it's taken by a reader of the ring
buffer, which doesn't seem to me involved in any critical work.

I may be wrong though, better wait for Steve to correct me
if needed.

In any case, the changelog needs more details about the individual
purpose of this patch.


> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0df1b0f..0c6bbcb 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -258,7 +258,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
>  	TRACE_ITER_GRAPH_TIME;
>  
>  static int trace_stop_count;
> -static DEFINE_SPINLOCK(tracing_start_lock);
> +static DEFINE_RAW_SPINLOCK(tracing_start_lock);


Same here. I don't understand why this should never sleep in -rt.
This is not a critical lock. It is taken in rare and not critical
places, mostly in reader places when we open/release a trace
file and also in tracing selftests.



> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 2974bc7..60ba58e 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -23,7 +23,7 @@ static int				tracer_enabled __read_mostly;
>  
>  static DEFINE_PER_CPU(int, tracing_cpu);
>  
> -static DEFINE_SPINLOCK(max_trace_lock);
> +static DEFINE_RAW_SPINLOCK(max_trace_lock);


But there yeah, it does seem necessary as it is involved
in irqsoff tracing fastpath.

This needs a comment though.

Thanks.

