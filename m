Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZKQL3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZKQL3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZKQL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:29:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:59564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZKQL3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:29:16 -0500
Subject: Re: [PATCH 3/7 v6] perf/core: Add a callback to perf events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1257694141-5670-4-git-send-email-fweisbec@gmail.com>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com>
	 <1257694141-5670-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 12:28:53 +0100
Message-ID: <1258457333.7816.186.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> A simple callback in a perf event can be used for multiple purposes.
> For example it is useful for triggered based events like hardware
> breakpoints that need a callback to dispatch a triggered breakpoint
> event.
> 
> v2: Simplify a bit the callback attribution as suggested by Paul
>     Mackerras

Yuck! So we add an opaque callback without semantics nor usage.

> ---
>  include/linux/perf_event.h |    7 ++++++-
>  kernel/perf_event.c        |   14 ++++++++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index fa151d4..8d54e6d 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -544,6 +544,8 @@ struct perf_pending_entry {
>  	void (*func)(struct perf_pending_entry *);
>  };
>  
> +typedef void (*perf_callback_t)(struct perf_event *, void *);
> +
>  /**
>   * struct perf_event - performance event kernel representation:
>   */
> @@ -639,6 +641,8 @@ struct perf_event {
>  	struct event_filter		*filter;
>  #endif
>  
> +	perf_callback_t			callback;
> +
>  #endif /* CONFIG_PERF_EVENTS */
>  };
>  
> @@ -748,7 +752,8 @@ extern int perf_event_release_kernel(struct perf_event *event);
>  extern struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr,
>  				int cpu,
> -				pid_t pid);
> +				pid_t pid,
> +				perf_callback_t callback);
>  extern u64 perf_event_read_value(struct perf_event *event);
>  
>  struct perf_sample_data {
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 02d4ff0..5087125 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4293,6 +4293,7 @@ perf_event_alloc(struct perf_event_attr *attr,
>  		   struct perf_event_context *ctx,
>  		   struct perf_event *group_leader,
>  		   struct perf_event *parent_event,
> +		   perf_callback_t callback,
>  		   gfp_t gfpflags)
>  {
>  	const struct pmu *pmu;
> @@ -4335,6 +4336,11 @@ perf_event_alloc(struct perf_event_attr *attr,
>  
>  	event->state		= PERF_EVENT_STATE_INACTIVE;
>  
> +	if (!callback && parent_event)
> +		callback = parent_event->callback;
> +	
> +	event->callback	= callback;
> +
>  	if (attr->disabled)
>  		event->state = PERF_EVENT_STATE_OFF;
>  
> @@ -4611,7 +4617,7 @@ SYSCALL_DEFINE5(perf_event_open,
>  	}
>  
>  	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
> -				     NULL, GFP_KERNEL);
> +				     NULL, NULL, GFP_KERNEL);
>  	err = PTR_ERR(event);
>  	if (IS_ERR(event))
>  		goto err_put_context;
> @@ -4668,7 +4674,7 @@ err_put_context:
>   */
>  struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
> -				 pid_t pid)
> +				 pid_t pid, perf_callback_t callback)
>  {
>  	struct perf_event *event;
>  	struct perf_event_context *ctx;
> @@ -4683,7 +4689,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
>  		return NULL ;
>  
>  	event = perf_event_alloc(attr, cpu, ctx, NULL,
> -				     NULL, GFP_KERNEL);
> +				     NULL, callback, GFP_KERNEL);
>  	err = PTR_ERR(event);
>  	if (IS_ERR(event))
>  		goto err_put_context;
> @@ -4736,7 +4742,7 @@ inherit_event(struct perf_event *parent_event,
>  	child_event = perf_event_alloc(&parent_event->attr,
>  					   parent_event->cpu, child_ctx,
>  					   group_leader, parent_event,
> -					   GFP_KERNEL);
> +					   NULL, GFP_KERNEL);
>  	if (IS_ERR(child_event))
>  		return child_event;
>  	get_ctx(child_ctx);


