Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZCYWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZCYWCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZCYWB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:01:57 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52086 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZCYWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tRC8ctYA5WCb3cPJDzktTU6O9xKPXpbjpJwwdfGeuDQLrz/22GQBN1A7Kqi1wvz/9q
         MZmP+v0pNw0V/bsk2ebkV8N/d0Ki/ztigADfgPj/gk8l93X0trDNhmf8MwUy94aIZzbP
         NufFZ0s4v2hPF1Ogbe2AuD/iSxJ5wfv/0t6xQ=
Date: Wed, 25 Mar 2009 23:01:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing: add handler to trace_stat
Message-ID: <20090325220149.GK5932@nowhere>
References: <alpine.DEB.2.00.0903242329350.22830@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903242329350.22830@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:30:33PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (1):
>       tracing: add handler to trace_stat
> 
> ----
>  kernel/trace/trace_branch.c    |    4 ++--
>  kernel/trace/trace_stat.c      |    2 +-
>  kernel/trace/trace_stat.h      |    2 +-
>  kernel/trace/trace_workqueue.c |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> ---------------------------
> commit 425480081e936d8725f0d44b8829d699bf088c6b
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Mar 24 13:38:36 2009 -0400
> 
>     tracing: add handler to trace_stat
>     
>     Currently, if a trace_stat user wants a handle to some private data,
>     the trace_stat infrastructure does not supply a way to do that.
>     
>     This patch passes the trace_stat structure to the start function of
>     the trace_stat code.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index ad8c22e..e6e3291 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -263,7 +263,7 @@ static int branch_stat_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static void *annotated_branch_stat_start(void)
> +static void *annotated_branch_stat_start(struct tracer_stat *trace)
>  {
>  	return __start_annotated_branch_profile;
>  }
> @@ -338,7 +338,7 @@ static int all_branch_stat_headers(struct seq_file *m)
>  	return 0;
>  }
>  
> -static void *all_branch_stat_start(void)
> +static void *all_branch_stat_start(struct tracer_stat *trace)
>  {
>  	return __start_branch_profile;
>  }
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index f71b85b..f8f48d8 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -85,7 +85,7 @@ static int stat_seq_init(struct tracer_stat_session *session)
>  	if (!ts->stat_cmp)
>  		ts->stat_cmp = dummy_cmp;
>  
> -	stat = ts->stat_start();
> +	stat = ts->stat_start(ts);
>  	if (!stat)
>  		goto exit;
>  
> diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
> index 202274c..f3546a2 100644
> --- a/kernel/trace/trace_stat.h
> +++ b/kernel/trace/trace_stat.h
> @@ -12,7 +12,7 @@ struct tracer_stat {
>  	/* The name of your stat file */
>  	const char		*name;
>  	/* Iteration over statistic entries */
> -	void			*(*stat_start)(void);
> +	void			*(*stat_start)(struct tracer_stat *trace);



In that case, shoudn't we pass another thing than the struct tracer_stat?
Because nothing really private can be stored in it. Moreover, most of the
time the handler is dedicated to this tracer_stat so it is able to have
an access to it.

May be we could add a void *private inside struct trace_stat and then pass
it to stat_start() ?

Thanks,
Frederic.


>  	void			*(*stat_next)(void *prev, int idx);
>  	/* Compare two entries for stats sorting */
>  	int			(*stat_cmp)(void *p1, void *p2);
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 9ab035b..ee533c2 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -152,7 +152,7 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
>  	return ret;
>  }
>  
> -static void *workqueue_stat_start(void)
> +static void *workqueue_stat_start(struct tracer_stat *trace)
>  {
>  	int cpu;
>  	void *ret = NULL;
> 

