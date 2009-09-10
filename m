Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZIJUnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZIJUnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZIJUnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:43:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:43:31 -0400
Subject: Re: [PATCHv2 3/3] tracing - buf iterator support for
 set_graph_function set_ftrace_filter set_ftrace_notrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1252113181-3325-4-git-send-email-jolsa@redhat.com>
References: <1252113181-3325-1-git-send-email-jolsa@redhat.com>
	 <1252113181-3325-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 16:43:25 -0400
Message-Id: <1252615405.18996.34.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 03:13 +0200, jolsa@redhat.com wrote:
> Updated 'set_graph_function', 'set_ftrace_filter', 'set_ftrace_notrace' write methods
> to use the 'trace_get_user' function.
> 
> Removed FTRACE_ITER_CONT flag, since it's not needed after this change.
> 
> Fixed minor in set_graph_function display - g_show function.
> 

This patch seems fine as long as it gets updated with the same comments
of the other patches.

-- Steve

> wbr,
> jirka
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 8c804e2..04bffba 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1323,11 +1323,10 @@ static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
>  
>  enum {
>  	FTRACE_ITER_FILTER	= (1 << 0),
> -	FTRACE_ITER_CONT	= (1 << 1),
> -	FTRACE_ITER_NOTRACE	= (1 << 2),
> -	FTRACE_ITER_FAILURES	= (1 << 3),
> -	FTRACE_ITER_PRINTALL	= (1 << 4),
> -	FTRACE_ITER_HASH	= (1 << 5),
> +	FTRACE_ITER_NOTRACE	= (1 << 1),
> +	FTRACE_ITER_FAILURES	= (1 << 2),
> +	FTRACE_ITER_PRINTALL	= (1 << 3),
> +	FTRACE_ITER_HASH	= (1 << 4),
>  };
>  
>  #define FTRACE_BUFF_MAX (KSYM_SYMBOL_LEN+4) /* room for wildcards */
> @@ -1337,8 +1336,7 @@ struct ftrace_iterator {
>  	int			hidx;
>  	int			idx;
>  	unsigned		flags;
> -	unsigned char		buffer[FTRACE_BUFF_MAX+1];
> -	unsigned		buffer_idx;
> +	struct trace_biter	biter;
>  };
>  
>  static void *
> @@ -1604,6 +1602,11 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
>  	if (!iter)
>  		return -ENOMEM;
>  
> +	if (trace_biter_alloc(&iter->biter, FTRACE_BUFF_MAX)) {
> +		kfree(iter);
> +		return -ENOMEM;
> +	}
> +
>  	mutex_lock(&ftrace_regex_lock);
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC))
> @@ -2196,9 +2199,8 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos, int enable)
>  {
>  	struct ftrace_iterator *iter;
> -	char ch;
> -	size_t read = 0;
> -	ssize_t ret;
> +	struct trace_biter *biter;
> +	ssize_t ret, read;
>  
>  	if (!cnt || cnt < 0)
>  		return 0;
> @@ -2211,72 +2213,23 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
>  	} else
>  		iter = file->private_data;
>  
> -	if (!*ppos) {
> -		iter->flags &= ~FTRACE_ITER_CONT;
> -		iter->buffer_idx = 0;
> -	}
> -
> -	ret = get_user(ch, ubuf++);
> -	if (ret)
> -		goto out;
> -	read++;
> -	cnt--;
> +	biter = &iter->biter;
> +	read = trace_get_user(biter, ubuf, cnt, ppos);
>  
> -	/*
> -	 * If the parser haven't finished with the last write,
> -	 * continue reading the user input without skipping spaces.
> -	 */
> -	if (!(iter->flags & FTRACE_ITER_CONT)) {
> -		/* skip white space */
> -		while (cnt && isspace(ch)) {
> -			ret = get_user(ch, ubuf++);
> -			if (ret)
> -				goto out;
> -			read++;
> -			cnt--;
> -		}
> -
> -		/* only spaces were written */
> -		if (isspace(ch)) {
> -			*ppos += read;
> -			ret = read;
> -			goto out;
> -		}
> -
> -		iter->buffer_idx = 0;
> -	}
> -
> -	while (cnt && !isspace(ch)) {
> -		if (iter->buffer_idx < FTRACE_BUFF_MAX)
> -			iter->buffer[iter->buffer_idx++] = ch;
> -		else {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -		ret = get_user(ch, ubuf++);
> +	if (TRACE_BITER_LOADED(biter) &&
> +	    !TRACE_BITER_CONT(biter)) {
> +		ret = ftrace_process_regex(biter->buffer,
> +					   biter->idx, enable);
>  		if (ret)
>  			goto out;
> -		read++;
> -		cnt--;
> -	}
>  
> -	if (isspace(ch)) {
> -		iter->buffer[iter->buffer_idx] = 0;
> -		ret = ftrace_process_regex(iter->buffer,
> -					   iter->buffer_idx, enable);
> -		if (ret)
> -			goto out;
> -		iter->buffer_idx = 0;
> -	} else {
> -		iter->flags |= FTRACE_ITER_CONT;
> -		iter->buffer[iter->buffer_idx++] = ch;
> +		TRACE_BITER_CLEAR(biter);
>  	}
>  
> -	*ppos += read;
>  	ret = read;
> - out:
> -	mutex_unlock(&ftrace_regex_lock);
>  
> +	mutex_unlock(&ftrace_regex_lock);
> +out:
>  	return ret;
>  }
>  
> @@ -2381,6 +2334,7 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
>  {
>  	struct seq_file *m = (struct seq_file *)file->private_data;
>  	struct ftrace_iterator *iter;
> +	struct trace_biter *biter;
>  
>  	mutex_lock(&ftrace_regex_lock);
>  	if (file->f_mode & FMODE_READ) {
> @@ -2390,9 +2344,10 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
>  	} else
>  		iter = file->private_data;
>  
> -	if (iter->buffer_idx) {
> -		iter->buffer[iter->buffer_idx] = 0;
> -		ftrace_match_records(iter->buffer, iter->buffer_idx, enable);
> +	biter = &iter->biter;
> +	if (TRACE_BITER_LOADED(biter)) {
> +		biter->buffer[biter->idx] = 0;
> +		ftrace_match_records(biter->buffer, biter->idx, enable);
>  	}
>  
>  	mutex_lock(&ftrace_lock);
> @@ -2400,7 +2355,9 @@ ftrace_regex_release(struct inode *inode, struct file *file, int enable)
>  		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
>  	mutex_unlock(&ftrace_lock);
>  
> +	trace_biter_free(biter);
>  	kfree(iter);
> +
>  	mutex_unlock(&ftrace_regex_lock);
>  	return 0;
>  }
> @@ -2499,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
>  		return 0;
>  	}
>  
> -	seq_printf(m, "%pf\n", v);
> +	seq_printf(m, "%p\n", (void*) *ptr);
>  
>  	return 0;
>  }
> @@ -2602,12 +2559,10 @@ static ssize_t
>  ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
> -	unsigned char buffer[FTRACE_BUFF_MAX+1];
> +	struct trace_biter biter;
>  	unsigned long *array;
>  	size_t read = 0;
>  	ssize_t ret;
> -	int index = 0;
> -	char ch;
>  
>  	if (!cnt || cnt < 0)
>  		return 0;
> @@ -2625,51 +2580,27 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  	} else
>  		array = file->private_data;
>  
> -	ret = get_user(ch, ubuf++);
> -	if (ret)
> +	if (trace_biter_alloc(&biter, FTRACE_BUFF_MAX)) {
> +		ret = -ENOMEM;
>  		goto out;
> -	read++;
> -	cnt--;
> -
> -	/* skip white space */
> -	while (cnt && isspace(ch)) {
> -		ret = get_user(ch, ubuf++);
> -		if (ret)
> -			goto out;
> -		read++;
> -		cnt--;
>  	}
>  
> -	if (isspace(ch)) {
> -		*ppos += read;
> -		ret = read;
> -		goto out;
> -	}
> +	read = trace_get_user(&biter, ubuf, cnt, ppos);
> +
> +	if (TRACE_BITER_LOADED((&biter))) {
> +		biter.buffer[biter.idx] = 0;
> +
> +		/* we allow only one expression at a time */
> +		ret = ftrace_set_func(array, &ftrace_graph_count,
> +					biter.buffer);
>  
> -	while (cnt && !isspace(ch)) {
> -		if (index < FTRACE_BUFF_MAX)
> -			buffer[index++] = ch;
> -		else {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -		ret = get_user(ch, ubuf++);
>  		if (ret)
>  			goto out;
> -		read++;
> -		cnt--;
>  	}
> -	buffer[index] = 0;
> -
> -	/* we allow only one expression at a time */
> -	ret = ftrace_set_func(array, &ftrace_graph_count, buffer);
> -	if (ret)
> -		goto out;
> -
> -	file->f_pos += read;
>  
>  	ret = read;
>   out:
> +	trace_biter_free(&biter);
>  	mutex_unlock(&graph_lock);
>  
>  	return ret;

