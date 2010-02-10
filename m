Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0BJDtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:49:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJDtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:49:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=BAHfPmN_V-kA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=FUG6NJzH6TSREZMhclcA:9 a=gcvMsA19nWlVPNNssRkA:7 a=NMNou1Bl-0T4JUXWohISII0AlNYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: Allow to remove a single function from
 function graph filter
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B71072B.1030405@cn.fujitsu.com>
References: <4B71072B.1030405@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 09 Feb 2010 22:49:13 -0500
Message-ID: <1265773753.24386.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 14:56 +0800, Li Zefan wrote:
> I don't see why we can only clear all functions from the filter.
> 
> After patching:
> 
>   # echo sys_open > set_graph_function
>   # echo sys_close >> set_graph_function
>   # cat set_graph_function
>   sys_open
>   sys_close
>   # echo '!sys_close' >> set_graph_function
>   # cat set_graph_function
>   sys_open
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/ftrace.c |   51 +++++++++++++++++++++++++++++-------------------
>  kernel/trace/trace.h  |    3 +-
>  2 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 1e6640f..4ec779d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2426,6 +2426,7 @@ static const struct file_operations ftrace_notrace_fops = {
>  static DEFINE_MUTEX(graph_lock);
>  
>  int ftrace_graph_count;
> +int ftrace_graph_filter_enabled;
>  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
>  
>  static void *
> @@ -2448,7 +2449,7 @@ static void *g_start(struct seq_file *m, loff_t *pos)
>  	mutex_lock(&graph_lock);
>  
>  	/* Nothing, tell g_show to print all functions are enabled */
> -	if (!ftrace_graph_count && !*pos)
> +	if (!ftrace_graph_filter_enabled && !*pos)
>  		return (void *)1;
>  
>  	return __g_next(m, pos);
> @@ -2494,6 +2495,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
>  	mutex_lock(&graph_lock);
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC)) {
> +		ftrace_graph_filter_enabled = 0;
>  		ftrace_graph_count = 0;
>  		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
>  	}
> @@ -2519,7 +2521,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
>  	struct dyn_ftrace *rec;
>  	struct ftrace_page *pg;
>  	int search_len;
> -	int found = 0;
> +	int fail = 1;
>  	int type, not;
>  	char *search;
>  	bool exists;
> @@ -2530,37 +2532,51 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
>  
>  	/* decode regex */
>  	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
> -	if (not)
> -		return -EINVAL;
> +	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
> +		return -EBUSY;
>  
>  	search_len = strlen(search);
>  
>  	mutex_lock(&ftrace_lock);
>  	do_for_each_ftrace_rec(pg, rec) {
>  
> -		if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
> -			break;
> -
>  		if (rec->flags & (FTRACE_FL_FAILED | FTRACE_FL_FREE))
>  			continue;
>  
>  		if (ftrace_match_record(rec, search, search_len, type)) {
> -			/* ensure it is not already in the array */
> +			/* if it is in the array */
>  			exists = false;
> -			for (i = 0; i < *idx; i++)
> +			for (i = 0; i < *idx; i++) {
>  				if (array[i] == rec->ip) {
>  					exists = true;
>  					break;
>  				}
> -			if (!exists)
> -				array[(*idx)++] = rec->ip;
> -			found = 1;
> +			}
> +
> +			if (!not) {
> +				if (!exists) {
> +					array[(*idx)++] = rec->ip;
> +					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
> +						goto out;

The fail = 0 needs to be first. I just tested this and on the 32'cd
function added, it gives a failed message but still adds the function.

-- Steve

> +				}
> +				fail = 0;
> +			} else {
> +				if (exists) {
> +					array[i] = array[--(*idx)];
> +					array[*idx] = 0;
> +					fail = 0;
> +				}
> +			}
>  		}
>  	} while_for_each_ftrace_rec();
> -
> +out:
>  	mutex_unlock(&ftrace_lock);
>  
> -	return found ? 0 : -EINVAL;
> +	if (fail)
> +		return -EINVAL;
> +
> +	ftrace_graph_filter_enabled = 1;
> +	return 0;
>  }
>  
>  static ssize_t
> @@ -2570,16 +2586,11 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  	struct trace_parser parser;
>  	ssize_t read, ret;
>  
> -	if (!cnt || cnt < 0)
> +	if (!cnt)
>  		return 0;
>  
>  	mutex_lock(&graph_lock);
>  
> -	if (ftrace_graph_count >= FTRACE_GRAPH_MAX_FUNCS) {
> -		ret = -EBUSY;
> -		goto out_unlock;
> -	}
> -
>  	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
>  		ret = -ENOMEM;
>  		goto out_unlock;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9a69b9c..d2929ca 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -499,6 +499,7 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  /* TODO: make this variable */
>  #define FTRACE_GRAPH_MAX_FUNCS		32
> +extern int ftrace_graph_filter_enabled;
>  extern int ftrace_graph_count;
>  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
>  
> @@ -506,7 +507,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
>  {
>  	int i;
>  
> -	if (!ftrace_graph_count)
> +	if (!ftrace_graph_filter_enabled)
>  		return 1;
>  
>  	for (i = 0; i < ftrace_graph_count; i++) {


