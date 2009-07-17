Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbZGQFis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbZGQFis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbZGQFis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:38:48 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:50120 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbZGQFir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A8GcMBdiT/CbfoVPARhUd9uYAcjOk/vrZ0U/KNwMa3GfwBcVFgeSJJ8r8/6zgjGsg8
         k5spE7KlfO7ZC2XPSY6H9cA96meIQcVnNWoAIUhiSXUJ/6VIQ5aDbiq9IGgvCimJO08A
         IB8OFyEW2hg4hgkIas+r2AUkVqDbx3xTJabxw=
Date: Fri, 17 Jul 2009 01:38:40 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function: cleanup for function tracer
Message-ID: <20090717053839.GF4977@nowhere>
References: <4A5EC5E7.6080307@cn.fujitsu.com> <4A5EC6D4.5040007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5EC6D4.5040007@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 02:21:08PM +0800, Xiao Guangrong wrote:
> We can use %pf input format instead of kallsyms_lookup()
> and %s input format
> 
> Thanks for Li Zefan's offline review.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>


Queuing these two patches for .32

Thanks!

Frederic.



> ---
>  kernel/trace/ftrace.c          |   17 +++--------------
>  kernel/trace/trace_functions.c |    4 +---
>  2 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 4521c77..8f7d28e 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1438,18 +1438,13 @@ static int t_hash_show(struct seq_file *m, void *v)
>  {
>  	struct ftrace_func_probe *rec;
>  	struct hlist_node *hnd = v;
> -	char str[KSYM_SYMBOL_LEN];
>  
>  	rec = hlist_entry(hnd, struct ftrace_func_probe, node);
>  
>  	if (rec->ops->print)
>  		return rec->ops->print(m, rec->ip, rec->ops, rec->data);
>  
> -	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> -	seq_printf(m, "%s:", str);
> -
> -	kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
> -	seq_printf(m, "%s", str);
> +	seq_printf(m, "%pf:%pf", (void *)rec->ip, (void *)rec->ops->func);
>  
>  	if (rec->data)
>  		seq_printf(m, ":%p", rec->data);
> @@ -1547,7 +1542,6 @@ static int t_show(struct seq_file *m, void *v)
>  {
>  	struct ftrace_iterator *iter = m->private;
>  	struct dyn_ftrace *rec = v;
> -	char str[KSYM_SYMBOL_LEN];
>  
>  	if (iter->flags & FTRACE_ITER_HASH)
>  		return t_hash_show(m, v);
> @@ -1560,9 +1554,7 @@ static int t_show(struct seq_file *m, void *v)
>  	if (!rec)
>  		return 0;
>  
> -	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> -
> -	seq_printf(m, "%s\n", str);
> +	seq_printf(m, "%pf\n", (void *)rec->ip);
>  
>  	return 0;
>  }
> @@ -2543,7 +2535,6 @@ static void g_stop(struct seq_file *m, void *p)
>  static int g_show(struct seq_file *m, void *v)
>  {
>  	unsigned long *ptr = v;
> -	char str[KSYM_SYMBOL_LEN];
>  
>  	if (!ptr)
>  		return 0;
> @@ -2553,9 +2544,7 @@ static int g_show(struct seq_file *m, void *v)
>  		return 0;
>  	}
>  
> -	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> -
> -	seq_printf(m, "%s\n", str);
> +	seq_printf(m, "%pf\n", v);
>  
>  	return 0;
>  }
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 7402144..b53dc99 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -288,11 +288,9 @@ static int
>  ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
>  			 struct ftrace_probe_ops *ops, void *data)
>  {
> -	char str[KSYM_SYMBOL_LEN];
>  	long count = (long)data;
>  
> -	kallsyms_lookup(ip, NULL, NULL, NULL, str);
> -	seq_printf(m, "%s:", str);
> +	seq_printf(m, "%pf:", (void *)ip);
>  
>  	if (ops == &traceon_probe_ops)
>  		seq_printf(m, "traceon");
> -- 
> 1.6.1.2
> 

