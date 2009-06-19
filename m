Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZFSKAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZFSKAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 06:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZFSKAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 06:00:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:63532 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbZFSKAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 06:00:45 -0400
Message-ID: <4A3B5CD7.3050601@windriver.com>
Date: Fri, 19 Jun 2009 17:39:35 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] tracing_bprintk: don't increment @pos in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com> <4A3B3445.2050005@cn.fujitsu.com>
In-Reply-To: <4A3B3445.2050005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2009 10:00:35.0496 (UTC) FILETIME=[CA4B5280:01C9F0C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Li Zefan wrote:
> It's wrong to increment @pos in t_start(), otherwise we'll lose
> some entries when reading printk_formats, if the output is large
> than PAGE_SIZE.
> 
> [ Impact: fix missing entries when reading printk_formats ]
> 
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_printk.c |   26 ++++++--------------------
>  1 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 9bece96..7b62781 100644
> --- a/kernel/trace/trace_printk.c
> +++ b/kernel/trace/trace_printk.c
> @@ -155,25 +155,19 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
>  EXPORT_SYMBOL_GPL(__ftrace_vprintk);
>  
>  static void *
> -t_next(struct seq_file *m, void *v, loff_t *pos)
> +t_start(struct seq_file *m, loff_t *pos)
>  {
> -	const char **fmt = m->private;
> -	const char **next = fmt;
> -
> -	(*pos)++;
> +	const char **fmt = __start___trace_bprintk_fmt + *pos;
>  
>  	if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
>  		return NULL;
> -
> -	next = fmt;
> -	m->private = ++next;
> -
>  	return fmt;
>  }
>  
> -static void *t_start(struct seq_file *m, loff_t *pos)
> +static void *t_next(struct seq_file *m, void * v, loff_t *pos)
>  {
> -	return t_next(m, NULL, pos);
> +	(*pos)++;
> +	return t_start(m, pos);
>  }
>  
I prefer to .start to call .next, so I rewrite it to following:


@@ -157,17 +157,15 @@ EXPORT_SYMBOL_GPL(__ftrace_vprintk);
  static void *
  t_next(struct seq_file *m, void *v, loff_t *pos)
  {
-       const char **fmt = m->private;
-       const char **next = fmt;
+       const char **fmt;

-       (*pos)++;
+       if (v)
+               (*pos)++;
+       fmt = __start___trace_bprintk_fmt + *pos;

         if ((unsigned long)fmt >= (unsigned long)__stop___trace_bprintk_fmt)
                 return NULL;

-       next = fmt;
-       m->private = ++next;
-
         return fmt;
  }

but I have not tested it, if you have no objection, then:

Signed-off-by: walimis <walimisdev@gmail.com>

Liming Wang

>  static int t_show(struct seq_file *m, void *v)
> @@ -224,15 +218,7 @@ static const struct seq_operations show_format_seq_ops = {
>  static int
>  ftrace_formats_open(struct inode *inode, struct file *file)
>  {
> -	int ret;
> -
> -	ret = seq_open(file, &show_format_seq_ops);
> -	if (!ret) {
> -		struct seq_file *m = file->private_data;
> -
> -		m->private = __start___trace_bprintk_fmt;
> -	}
> -	return ret;
> +	return seq_open(file, &show_format_seq_ops);
>  }
>  
>  static const struct file_operations ftrace_formats_fops = {

