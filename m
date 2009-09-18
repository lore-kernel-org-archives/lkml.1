Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZIRPDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZIRPDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZIRPDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:03:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:63786 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZIRPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v/U40AvJyEzppe6wL+SR9YGyfbTdmjzTl6RXfn1xqSteFxqZ6j0v6WuZffR6eDgBOs
         6F3g+u5d6KwkTjMod1uJIaOSe2XR8KVDYpMv9ryxhnvnXe3xtxa+brwe/JSPqAyKkun6
         RTFPXtKTa+nKEbPir9fKXxH5L+5XdKFa4oGaM=
Date: Fri, 18 Sep 2009 17:03:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3][RESEND] function-graph: use ftrace_graph_funcs
	directly
Message-ID: <20090918150337.GA5200@nowhere>
References: <4AB32364.7020602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB32364.7020602@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 02:06:28PM +0800, Li Zefan wrote:
> No need to store ftrace_graph_funcs in file->private.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
> 
> The first 2 patches were sent 2 month ago..
> 
> ---
>  kernel/trace/ftrace.c |   23 ++++-------------------
>  1 files changed, 4 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index cc615f8..c71e91b 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2414,11 +2414,9 @@ unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
>  static void *
>  __g_next(struct seq_file *m, loff_t *pos)
>  {
> -	unsigned long *array = m->private;
> -
>  	if (*pos >= ftrace_graph_count)
>  		return NULL;
> -	return &array[*pos];
> +	return &ftrace_graph_funcs[*pos];
>  }
>  
>  static void *
> @@ -2482,16 +2480,10 @@ ftrace_graph_open(struct inode *inode, struct file *file)
>  		ftrace_graph_count = 0;
>  		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
>  	}
> +	mutex_unlock(&graph_lock);
>  
> -	if (file->f_mode & FMODE_READ) {
> +	if (file->f_mode & FMODE_READ)
>  		ret = seq_open(file, &ftrace_graph_seq_ops);
> -		if (!ret) {
> -			struct seq_file *m = file->private_data;
> -			m->private = ftrace_graph_funcs;
> -		}
> -	} else
> -		file->private_data = ftrace_graph_funcs;
> -	mutex_unlock(&graph_lock);
>  
>  	return ret;
>  }
> @@ -2560,7 +2552,6 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
>  	struct trace_parser parser;
> -	unsigned long *array;
>  	size_t read = 0;
>  	ssize_t ret;
>  
> @@ -2574,12 +2565,6 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		goto out;
>  	}
>  
> -	if (file->f_mode & FMODE_READ) {
> -		struct seq_file *m = file->private_data;
> -		array = m->private;
> -	} else
> -		array = file->private_data;
> -
>  	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
>  		ret = -ENOMEM;
>  		goto out;
> @@ -2591,7 +2576,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		parser.buffer[parser.idx] = 0;
>  
>  		/* we allow only one expression at a time */
> -		ret = ftrace_set_func(array, &ftrace_graph_count,
> +		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
>  					parser.buffer);
>  		if (ret)
>  			goto out;
> -- 
> 1.6.3
> 

