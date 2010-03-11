Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0CKIfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:35:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0CKIff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:35:35 -0500
Subject: Re: [PATCH] perf_events: improve task_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, robert.richter@amd.com, davem@davemloft.net,
       perfmon2-devel@lists.sf.net
In-Reply-To: <1268288765-5326-1-git-send-email-eranian@google.com>
References: <1268288765-5326-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Mar 2010 09:35:16 +0100
Message-ID: <1268296516.5279.912.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 22:26 -0800, eranian@google.com wrote:
> This patch is an optimization in perf_event_task_sched_in() to avoid scheduling
> the events twice in a row. Without it, the perf_disable()/perf_enable() pair
> is invoked twice, thereby pinned events counts while scheduling flexible events
> and we go throuh hw_perf_enable() twice. By encapsulating, the whole sequence
> into perf_disable()/perf_enable() we ensure, hw_perf_enable() is going to be
> invoked only once because of the refcount protection.

Agreed, this makes perfect sense.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Signed-off-by: Stephane Eranian <eranian@google.com>
> --
>  perf_event.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -1382,6 +1382,8 @@ void perf_event_task_sched_in(struct task_struct *task)
>  	if (cpuctx->task_ctx == ctx)
>  		return;
>  
> +	perf_disable();
> +
>  	/*
>  	 * We want to keep the following priority order:
>  	 * cpu pinned (that don't need to move), task pinned,
> @@ -1394,6 +1396,8 @@ void perf_event_task_sched_in(struct task_struct *task)
>  	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
>  
>  	cpuctx->task_ctx = ctx;
> +
> +	perf_enable();
>  }
>  
>  #define MAX_INTERRUPTS (~0ULL)

