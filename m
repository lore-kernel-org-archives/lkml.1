Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZDBBQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZDBBQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZDBBQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:16:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41967 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZDBBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:16:31 -0400
Date: Wed, 1 Apr 2009 21:12:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>
Cc: linux-tip-commits@vger.kernel.org, stable@kernel.org
Subject: Re: [tip:tracing/syscalls] tracing/core: fix early free of cpumasks
Message-ID: <20090402011232.GA32066@goodmis.org>
References: <1237164303-11476-1-git-send-email-fweisbec@gmail.com> <tip-2fc1dfbe17e7705c55b7a99da995fa565e26f151@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2fc1dfbe17e7705c55b7a99da995fa565e26f151@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This never made it into 2.6.29, nor do I see it yet in mainline.

This can cause unpredictable results with ftrace. We are freeing a cpu mask
that will be later used.

This is definitely stable material.

Thanks to Johannes Berg for patiently bisecting his branch with a merge of my
branch to locate the patch that was missing from mainline.

He was seeing empty traces, but in reality, the changing of these masks might
have more dire consequences.

-- Steve

On Mon, Mar 16, 2009 at 08:19:33AM +0000, Frederic Weisbecker wrote:
> Commit-ID:  2fc1dfbe17e7705c55b7a99da995fa565e26f151
> Gitweb:     http://git.kernel.org/tip/2fc1dfbe17e7705c55b7a99da995fa565e26f151
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Mon, 16 Mar 2009 01:45:03 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 16 Mar 2009 09:13:18 +0100
> 
> tracing/core: fix early free of cpumasks
> 
> Impact: fix crashes when tracing cpumasks
> 
> While ring-buffer allocation, the cpumasks are allocated too,
> including the tracing cpumask and the per-cpu file mask handler.
> But these cpumasks are freed accidentally just after.
> Fix it.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <1237164303-11476-1-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/trace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index c0cf946..ae32d3b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4125,7 +4125,8 @@ __init static int tracer_alloc_buffers(void)
>  				       &trace_panic_notifier);
>  
>  	register_die_notifier(&trace_die_notifier);
> -	ret = 0;
> +
> +	return 0;
>  
>  out_free_cpumask:
>  	free_cpumask_var(tracing_reader_cpumask);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
